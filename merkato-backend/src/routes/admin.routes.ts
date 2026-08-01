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
      { email: { $regex: search, $options: 'i' } },
      { phone: { $regex: search, $options: 'i' } }
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

// @desc    Update user status (suspend/activate, change role)
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
  
  if (role && ['customer', 'seller', 'driver', 'admin'].includes(role)) {
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
    .populate('customerId', 'name email phone')
    .populate('sellerId', 'name email')
    .populate('driverId', 'name phone')
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

// @desc    Get all applications (seller & driver)
// @route   GET /api/admin/applications
// @access  Private/Admin
router.get('/applications', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { type = 'all', status = 'pending', page = 1, limit = 20 } = req.query;
  
  let sellerApps: any[] = [];
  let driverApps: any[] = [];
  let sellerTotal = 0;
  let driverTotal = 0;
  
  // Get seller applications
  if (type === 'all' || type === 'seller') {
    let sellerQuery: any = {};
    if (status !== 'all') {
      sellerQuery.status = status;
    }
    
    const pageNum = parseInt(page as string);
    const limitNum = parseInt(limit as string);
    const skip = (pageNum - 1) * limitNum;
    
    sellerApps = await SellerApplication.find(sellerQuery)
      .populate('userId', 'name email phone')
      .populate('reviewedBy', 'name email')
      .sort({ submittedAt: -1 })
      .skip(skip)
      .limit(limitNum);
    
    sellerTotal = await SellerApplication.countDocuments(sellerQuery);
  }
  
  // Get driver applications
  if (type === 'all' || type === 'driver') {
    let driverQuery: any = {};
    if (status !== 'all') {
      driverQuery.status = status;
    }
    
    const pageNum = parseInt(page as string);
    const limitNum = parseInt(limit as string);
    const skip = (pageNum - 1) * limitNum;
    
    driverApps = await DriverApplication.find(driverQuery)
      .populate('userId', 'name email phone')
      .populate('reviewedBy', 'name email')
      .sort({ submittedAt: -1 })
      .skip(skip)
      .limit(limitNum);
    
    driverTotal = await DriverApplication.countDocuments(driverQuery);
  }
  
  res.json({
    sellerApplications: sellerApps,
    driverApplications: driverApps,
    sellerTotal,
    driverTotal,
    stats: {
      pendingSellers: await SellerApplication.countDocuments({ status: 'pending' }),
      pendingDrivers: await DriverApplication.countDocuments({ status: 'pending' }),
      totalApplications: sellerTotal + driverTotal
    }
  });
}));

// @desc    Verify/approve/reject application
// @route   PUT /api/admin/verify/:id
// @access  Private/Admin
router.put('/verify/:id', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { status, type, notes } = req.body;
  
  if (!['approved', 'rejected'].includes(status)) {
    res.status(400).json({ message: 'Invalid status' });
    return;
  }
  
  if (!['seller', 'driver'].includes(type)) {
    res.status(400).json({ message: 'Invalid application type' });
    return;
  }
  
  let application;
  let user = null;
  
  if (type === 'seller') {
    application = await SellerApplication.findById(req.params.id)
      .populate('userId');
    
    if (!application) {
      res.status(404).json({ message: 'Seller application not found' });
      return;
    }
    
    user = await User.findById(application.userId._id);
    if (!user) {
      res.status(404).json({ message: 'User not found' });
      return;
    }
    
    // Update application
    application.status = status;
    application.reviewedAt = new Date();
    application.reviewedBy = req.user._id;
    if (notes) application.notes = notes;
    await application.save();
    
    // If approved, update user role
    if (status === 'approved') {
      user.role = 'seller';
      user.isVerified = true;
      await user.save();
    }
  } else if (type === 'driver') {
    application = await DriverApplication.findById(req.params.id)
      .populate('userId');
    
    if (!application) {
      res.status(404).json({ message: 'Driver application not found' });
      return;
    }
    
    user = await User.findById(application.userId._id);
    if (!user) {
      res.status(404).json({ message: 'User not found' });
      return;
    }
    
    // Update application
    application.status = status;
    application.reviewedAt = new Date();
    application.reviewedBy = req.user._id;
    if (notes) application.notes = notes;
    await application.save();
    
    // If approved, update user role
    if (status === 'approved') {
      user.role = 'driver';
      user.isVerified = true;
      await user.save();
    }
  }
  
  // At this point, user should be defined
  res.json({
    message: `Application ${status}`,
    application,
    user: {
      _id: user!._id,
      name: user!.name,
      email: user!.email,
      role: user!.role,
      isVerified: user!.isVerified
    }
  });
}));

// @desc    Get all products
// @route   GET /api/admin/products
// @access  Private/Admin
router.get('/products', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { status, category, sellerId, search, page = 1, limit = 20 } = req.query;
  
  let query: any = {};
  
  if (status && status !== 'all') {
    query.status = status;
  }
  
  if (category && category !== 'all') {
    query.category = category;
  }
  
  if (sellerId && sellerId !== 'all') {
    query.sellerId = sellerId;
  }
  
  if (search) {
    query.$or = [
      { name: { $regex: search, $options: 'i' } },
      { description: { $regex: search, $options: 'i' } }
    ];
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const products = await Product.find(query)
    .populate('sellerId', 'name email phone')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limitNum);
  
  const total = await Product.countDocuments(query);
  
  res.json({
    products,
    page: pageNum,
    pages: Math.ceil(total / limitNum),
    total
  });
}));

// @desc    Get all orders
// @route   GET /api/admin/orders
// @access  Private/Admin
router.get('/orders', protect, authorize('admin'), asyncHandler(async (req: any, res) => {
  const { status, sellerId, driverId, customerId, dateFrom, dateTo, page = 1, limit = 20 } = req.query;
  
  let query: any = {};
  
  if (status && status !== 'all') {
    query.status = status;
  }
  
  if (sellerId && sellerId !== 'all') {
    query.sellerId = sellerId;
  }
  
  if (driverId && driverId !== 'all') {
    query.driverId = driverId;
  }
  
  if (customerId && customerId !== 'all') {
    query.customerId = customerId;
  }
  
  // Date range filter
  if (dateFrom || dateTo) {
    query.createdAt = {};
    if (dateFrom) {
      query.createdAt.$gte = new Date(dateFrom as string);
    }
    if (dateTo) {
      const endDate = new Date(dateTo as string);
      endDate.setHours(23, 59, 59, 999);
      query.createdAt.$lte = endDate;
    }
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const orders = await Order.find(query)
    .populate('customerId', 'name email phone')
    .populate('sellerId', 'name email phone')
    .populate('driverId', 'name phone')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limitNum);
  
  const total = await Order.countDocuments(query);
  
  // Calculate order statistics
  const orderStats = await Order.aggregate([
    {
      $group: {
        _id: '$status',
        count: { $sum: 1 },
        totalAmount: { $sum: '$total' }
      }
    }
  ]);
  
  res.json({
    orders,
    page: pageNum,
    pages: Math.ceil(total / limitNum),
    total,
    stats: orderStats
  });
}));

// @desc    Create admin user (for initial setup)
// @route   POST /api/admin/create-admin
// @access  Public (only for initial setup)
router.post('/create-admin', asyncHandler(async (req, res) => {
  const { name, email, password, phone } = req.body;
  
  // Check if admin already exists
  const adminExists = await User.findOne({ email, role: 'admin' });
  if (adminExists) {
    res.status(400).json({ message: 'Admin already exists' });
    return;
  }
  
  // Import bcrypt
  const bcrypt = await import('bcryptjs');
  
  // Hash password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  
  // Create admin user
  const admin = await User.create({
    name,
    email,
    password: hashedPassword,
    phone,
    role: 'admin',
    isVerified: true,
    isActive: true
  });
  
  // Import jwt
  const jwt = await import('jsonwebtoken');
  
  // Create token
  const token = jwt.sign(
    { id: admin._id },
    process.env.JWT_SECRET!,
    { expiresIn: '30d' }
  );
  
  res.status(201).json({
    message: 'Admin created successfully',
    user: {
      _id: admin._id,
      name: admin.name,
      email: admin.email,
      role: admin.role,
      isVerified: admin.isVerified
    },
    token
  });
}));

export default router;