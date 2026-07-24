import express from 'express';
import asyncHandler from 'express-async-handler';
import Order from '../models/order.model';
import SellerApplication from '../models/sellerApplication.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Get seller's orders
// @route   GET /api/seller/orders
// @access  Private/Seller
router.get('/orders', protect, authorize('seller'), asyncHandler(async (req: any, res) => {
  const { status, page = 1, limit = 20 } = req.query;
  
  let query: any = { sellerId: req.user._id };
  
  if (status && status !== 'all') {
    query.status = status;
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const orders = await Order.find(query)
    .populate('customerId', 'name email phone')
    .populate('driverId', 'name phone')
    .sort({ createdAt: -1 })
    .skip(skip)
    .limit(limitNum);
  
  const total = await Order.countDocuments(query);
  
  // Calculate stats
  const totalOrders = await Order.countDocuments({ sellerId: req.user._id });
  const pendingOrders = await Order.countDocuments({ 
    sellerId: req.user._id, 
    status: 'pending' 
  });
  const completedOrders = await Order.countDocuments({ 
    sellerId: req.user._id, 
    status: 'delivered' 
  });
  
  // Calculate total revenue
  const revenueResult = await Order.aggregate([
    { $match: { sellerId: req.user._id, status: 'delivered' } },
    { $group: { _id: null, total: { $sum: '$total' } } }
  ]);
  
  const totalRevenue = revenueResult.length > 0 ? revenueResult[0].total : 0;
  
  res.json({
    orders,
    page: pageNum,
    pages: Math.ceil(total / limitNum),
    total,
    stats: {
      totalOrders,
      pendingOrders,
      completedOrders,
      totalRevenue
    }
  });
}));

// @desc    Apply to become a seller
// @route   POST /api/seller/apply
// @access  Private
router.post('/apply', protect, asyncHandler(async (req: any, res) => {
  const { businessName, businessLicense } = req.body;
  
  // Check if already a seller
  if (req.user.role === 'seller') {
    res.status(400).json({ message: 'Already a seller' });
    return;
  }
  
  // Check if already applied
  const existingApplication = await SellerApplication.findOne({ userId: req.user._id });
  if (existingApplication) {
    res.status(400).json({ 
      message: 'Application already submitted',
      status: existingApplication.status 
    });
    return;
  }
  
  // Create application
  const application = await SellerApplication.create({
    userId: req.user._id,
    businessName,
    businessLicense,
    status: 'pending'
  });
  
  res.status(201).json({
    message: 'Application submitted successfully',
    application
  });
}));

// @desc    Update order status (for seller)
// @route   PUT /api/seller/orders/:id/status
// @access  Private/Seller
router.put('/orders/:id/status', protect, authorize('seller'), asyncHandler(async (req: any, res) => {
  const { status } = req.body;
  const validStatuses = ['accepted', 'prepared', 'cancelled'];
  
  if (!validStatuses.includes(status)) {
    res.status(400).json({ message: 'Invalid status' });
    return;
  }
  
  const order = await Order.findById(req.params.id);
  
  if (!order) {
    res.status(404).json({ message: 'Order not found' });
    return;
  }
  
  // Check if order belongs to this seller
  if (order.sellerId.toString() !== req.user._id.toString()) {
    res.status(403).json({ message: 'Not authorized to update this order' });
    return;
  }
  
  // Update order status
  order.status = status;
  await order.save();
  
  const populatedOrder = await Order.findById(order._id)
    .populate('customerId', 'name email phone')
    .populate('driverId', 'name phone');
  
  res.json({
    message: 'Order status updated',
    order: populatedOrder
  });
}));

export default router;