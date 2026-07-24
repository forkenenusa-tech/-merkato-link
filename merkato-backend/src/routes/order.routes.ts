import express from 'express';
import asyncHandler from 'express-async-handler';
import Order from '../models/order.model';
import Product from '../models/product.model';
import DeliveryAssignment from '../models/deliveryAssignment.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Create new order
// @route   POST /api/orders
// @access  Private/Customer
router.post('/', protect, authorize('customer'), asyncHandler(async (req: any, res) => {
  const { products, deliveryAddress, paymentMethod } = req.body;
  
  if (!products || products.length === 0) {
    res.status(400).json({ message: 'No order items' });
    return;
  }
  
  // Validate products and get seller ID from first product
  const productIds = products.map((item: any) => item.productId);
  const dbProducts = await Product.find({ _id: { $in: productIds } });
  
  if (dbProducts.length !== products.length) {
    res.status(400).json({ message: 'One or more products not found' });
    return;
  }
  
  // All products should be from the same seller
  const sellerId = dbProducts[0].sellerId;
  const allSameSeller = dbProducts.every((product) => 
    product.sellerId.toString() === sellerId.toString()
  );
  
  if (!allSameSeller) {
    res.status(400).json({ message: 'All products must be from the same seller' });
    return;
  }
  
  // Calculate total
  let total = 0;
  const orderItems = products.map((item: any) => {
    const product = dbProducts.find(p => p._id.toString() === item.productId);
    if (!product) {
      throw new Error('Product not found');
    }
    
    const itemTotal = product.price * item.quantity;
    total += itemTotal;
    
    return {
      productId: product._id,
      quantity: item.quantity,
      price: product.price,
      name: product.name
    };
  });
  
  // Create order
  const order = await Order.create({
    customerId: req.user._id,
    sellerId,
    products: orderItems,
    total,
    deliveryAddress,
    paymentMethod: paymentMethod || 'cash',
    status: 'pending'
  });
  
  // Create delivery assignment (assign to any available driver)
  // For demo, we'll assign to the first driver we find
  const deliveryAssignment = await DeliveryAssignment.create({
    orderId: order._id,
    driverId: null, // Will be assigned by staff/admin
    pickupLocation: 'Seller Location, Addis Ababa',
    dropLocation: deliveryAddress,
    status: 'assigned',
    distance: '5 km',
    price: 50 // Fixed delivery fee for demo
  });
  
  // Populate order with details
  const populatedOrder = await Order.findById(order._id)
    .populate('customerId', 'name email phone')
    .populate('sellerId', 'name email phone')
    .populate('products.productId', 'name images');
  
  res.status(201).json({
    order: populatedOrder,
    deliveryAssignment
  });
}));

// @desc    Get order by ID
// @route   GET /api/orders/:id
// @access  Private
router.get('/:id', protect, asyncHandler(async (req: any, res) => {
  const order = await Order.findById(req.params.id)
    .populate('customerId', 'name email phone')
    .populate('sellerId', 'name email phone')
    .populate('driverId', 'name phone')
    .populate('products.productId', 'name images price');
  
  if (!order) {
    res.status(404).json({ message: 'Order not found' });
    return;
  }
  
  // Check authorization
  const isCustomer = order.customerId._id.toString() === req.user._id.toString();
  const isSeller = order.sellerId._id.toString() === req.user._id.toString();
  const isDriver = order.driverId && order.driverId._id.toString() === req.user._id.toString();
  const isStaffOrAdmin = ['staff', 'admin'].includes(req.user.role);
  
  if (!isCustomer && !isSeller && !isDriver && !isStaffOrAdmin) {
    res.status(403).json({ message: 'Not authorized to view this order' });
    return;
  }
  
  // Get delivery assignment if exists
  const deliveryAssignment = await DeliveryAssignment.findOne({ orderId: order._id });
  
  res.json({
    order,
    deliveryAssignment: deliveryAssignment || null
  });
}));

export default router;