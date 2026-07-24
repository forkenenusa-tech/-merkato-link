import express from 'express';
import asyncHandler from 'express-async-handler';
import User from '../models/user.model';
import Product from '../models/product.model';
import Order from '../models/order.model';
import SellerApplication from '../models/sellerApplication.model';
import DriverApplication from '../models/driverApplication.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Get all users
// @route   GET /api/admin/users
// @access  Private/Admin
router.get('/users', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { role, isVerified, isActive, search, page = 1, limit = 20 } = req.query;
  
  let query: any = {};
  
  // Filter by role
  if (role && role !== 'all') {
    query.role = role;
  }
  
  // Filter by verification status
  if (isVerified !== undefined) {
    query.isVerified = isVerified === 'true';
  }
  
  // Filter by active status
  if (isActive !== undefined) {
    query.isActive = isActive === 'true';
  }
  
  // Search by name or email
  if (search) {
    query.$or = [
      { name: { $regex: search, $options: 'i' } },
      { email: { $regex: search, $options: 'i' } }
    ];
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const users = await User.find(query)
    .select('-password')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limitNum);
  
  const total = await User.countDocuments(query);
  
  // Get user counts by role
  const roleCounts = await User.aggregate([
    { $group: { _id: '$role', count: { $sum: 1 } } }
  ]);
  
  const roleCountsMap: any = {};
  roleCounts.forEach((rc: any) => {
    roleCountsMap[rc._id] = rc.count;
  });
  
  res.json({
    users,
    page: pageNum,
    pages: Math.ceil(total / limitNum),
    total,
    stats: {
      totalUsers: total,
      roleCounts: roleCountsMap,
      activeUsers: await User.countDocuments({ isActive: true }),
      verifiedUsers: await User.countDocuments({ isVerified: true })
    }
  });
}));

// @desc    Update user status (suspend/activate)
// @route   PUT /api/admin/users/:id
// @access  Private/Admin
router.put('/users/:id', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { isActive, role, isVerified } = req.body;
  
  const user = await User.findById(req.params.id).select('-password');
  
  if (!user) {
    res.status(404).json({ message: 'User not found' });
    return;
  }
  
  // Prevent modifying other admins
  if (user.role === 'admin' && req.user._id.toString() !== user._id.toString()) {
    res.status(403).json({ message: 'Cannot modify other admin accounts' });
    return;
  }
  
  // Update fields
  if (isActive !== undefined) {
    user.isActive = isActive;
  }
  
  if (role && ['customer', 'seller', 'staff', 'driver'].includes(role)) {
    user.role = role;
  }
  
  if (isVerified !== undefined) {
    user.isVerified = isVerified;
  }
  
  await user.save();
  
  res.json({
    message: 'User updated successfully',
    user
  });
}));

// @desc    Get admin dashboard statistics
// @route   GET /api/admin/stats
// @access  Private/Admin
router.get('/stats', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  // Get counts
  const totalUsers = await User.countDocuments();
  const totalProducts = await Product.countDocuments();
  const totalOrders = await Order.countDocuments();
  
  // Calculate revenue
  const revenueResult = await Order.aggregate([
    { $match: { status: 'delivered' } },
    { $group: { _id: null, total: { $sum: '$total' } } }
  ]);
  
  const totalRevenue = revenueResult.length > 0 ? revenueResult[0].total : 0;
  
  // Get pending applications
  const pendingSellerApps = await SellerApplication.countDocuments({ status: 'pending' });
  const pendingDriverApps = await DriverApplication.countDocuments({ status: 'pending' });
  
  // Get recent orders
  const recentOrders = await Order.find()
    .populate('customerId', 'name')
    .populate('sellerId', 'name')
    .sort({ createdAt: -1 })
    .limit(10);
  
  // Get user growth (last 30 days)
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
  
  const newUsers = await User.countDocuments({ createdAt: { $gte: thirtyDaysAgo } });
  
  res.json({
    stats: {
      totalUsers,
      totalProducts,
      totalOrders,
      totalRevenue,
      pendingApplications: pendingSellerApps + pendingDriverApps,
      newUsers
    },
    recentOrders,
    pendingSellerApps,
    pendingDriverApps
  });
}));

export default router;