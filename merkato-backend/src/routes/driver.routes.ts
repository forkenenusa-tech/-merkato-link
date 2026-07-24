import express from 'express';
import asyncHandler from 'express-async-handler';
import DeliveryAssignment from '../models/deliveryAssignment.model';
import Order from '../models/order.model';
import DriverApplication from '../models/driverApplication.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Get driver's deliveries
// @route   GET /api/driver/deliveries
// @access  Private/Driver
router.get('/deliveries', protect, authorize('driver'), asyncHandler(async (req: any, res) => {
  const { status, page = 1, limit = 20 } = req.query;
  
  let query: any = { driverId: req.user._id };
  
  if (status && status !== 'all') {
    query.status = status;
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const deliveries = await DeliveryAssignment.find(query)
    .populate({
      path: 'orderId',
      populate: [
        { path: 'customerId', select: 'name phone' },
        { path: 'sellerId', select: 'name phone' }
      ]
    })
    .sort({ assignedAt: -1 })
    .skip(skip)
    .limit(limitNum);
  
  const total = await DeliveryAssignment.countDocuments(query);
  
  res.json({
    deliveries,
    page: pageNum,
    pages: Math.ceil(total / limitNum),
    total
  });
}));

// @desc    Get driver statistics
// @route   GET /api/driver/stats
// @access  Private/Driver
router.get('/stats', protect, authorize('driver'), asyncHandler(async (req: any, res) => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const tomorrow = new Date(today);
  tomorrow.setDate(tomorrow.getDate() + 1);
  
  // Today's deliveries
  const todaysDeliveries = await DeliveryAssignment.countDocuments({
    driverId: req.user._id,
    status: 'delivered',
    completedAt: { $gte: today, $lt: tomorrow }
  });
  
  // Weekly earnings (last 7 days)
  const oneWeekAgo = new Date();
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);
  
  const weeklyEarningsResult = await DeliveryAssignment.aggregate([
    {
      $match: {
        driverId: req.user._id,
        status: 'delivered',
        completedAt: { $gte: oneWeekAgo }
      }
    },
    {
      $group: {
        _id: null,
        totalEarnings: { $sum: '$price' }
      }
    }
  ]);
  
  const weeklyEarnings = weeklyEarningsResult.length > 0 ? weeklyEarningsResult[0].totalEarnings : 0;
  
  // Total completed deliveries
  const totalDeliveries = await DeliveryAssignment.countDocuments({
    driverId: req.user._id,
    status: 'delivered'
  });
  
  // Average rating (mock for now)
  const averageRating = 4.5;
  
  res.json({
    todaysDeliveries,
    weeklyEarnings,
    totalDeliveries,
    averageRating,
    onlineStatus: true // Mock online status
  });
}));

// @desc    Update delivery status
// @route   PUT /api/driver/delivery/:id/status
// @access  Private/Driver
router.put('/delivery/:id/status', protect, authorize('driver'), asyncHandler(async (req: any, res) => {
  const { status } = req.body;
  const validStatuses = ['accepted', 'picked', 'delivered'];
  
  if (!validStatuses.includes(status)) {
    res.status(400).json({ message: 'Invalid status' });
    return;
  }
  
  const delivery = await DeliveryAssignment.findById(req.params.id);
  
  if (!delivery) {
    res.status(404).json({ message: 'Delivery not found' });
    return;
  }
  
  // Check if delivery belongs to this driver
  if (delivery.driverId.toString() !== req.user._id.toString()) {
    res.status(403).json({ message: 'Not authorized to update this delivery' });
    return;
  }
  
  // Update status
  delivery.status = status;
  
  // If delivered, set completedAt
  if (status === 'delivered') {
    delivery.completedAt = new Date();
    
    // Also update the order status
    await Order.findByIdAndUpdate(delivery.orderId, { 
      status: 'delivered',
      driverId: req.user._id 
    });
  }
  
  await delivery.save();
  
  const populatedDelivery = await DeliveryAssignment.findById(delivery._id)
    .populate({
      path: 'orderId',
      populate: [
        { path: 'customerId', select: 'name phone' },
        { path: 'sellerId', select: 'name phone' }
      ]
    });
  
  res.json({
    message: 'Delivery status updated',
    delivery: populatedDelivery
  });
}));

// @desc    Accept a delivery assignment
// @route   POST /api/driver/accept/:id
// @access  Private/Driver
router.post('/accept/:id', protect, authorize('driver'), asyncHandler(async (req: any, res) => {
  const delivery = await DeliveryAssignment.findById(req.params.id);
  
  if (!delivery) {
    res.status(404).json({ message: 'Delivery not found' });
    return;
  }
  
  // Check if delivery is already assigned to someone
  if (delivery.driverId && delivery.driverId.toString() !== req.user._id.toString()) {
    res.status(400).json({ message: 'Delivery already assigned to another driver' });
    return;
  }
  
  // Assign to this driver
  delivery.driverId = req.user._id;
  delivery.status = 'accepted';
  await delivery.save();
  
  // Also update the order
  await Order.findByIdAndUpdate(delivery.orderId, { 
    driverId: req.user._id,
    status: 'ontheway' 
  });
  
  const populatedDelivery = await DeliveryAssignment.findById(delivery._id)
    .populate({
      path: 'orderId',
      populate: [
        { path: 'customerId', select: 'name phone' },
        { path: 'sellerId', select: 'name phone' }
      ]
    });
  
  res.json({
    message: 'Delivery accepted successfully',
    delivery: populatedDelivery
  });
}));

export default router;