import express from 'express';
import asyncHandler from 'express-async-handler';
import Product from '../models/product.model';
import User from '../models/user.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Get all products
// @route   GET /api/products
// @access  Public
router.get('/', asyncHandler(async (req, res) => {
  const { category, search, page = 1, limit = 20 } = req.query;
  
  let query: any = {};
  
  // Filter by category
  if (category && category !== 'all') {
    query.category = category;
  }
  
  // Search by name or description
  if (search) {
    query.$text = { $search: search as string };
  }
  
  const pageNum = parseInt(page as string);
  const limitNum = parseInt(limit as string);
  const skip = (pageNum - 1) * limitNum;
  
  const products = await Product.find(query)
    .populate('sellerId', 'name email phone profileImage')
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

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
router.get('/:id', asyncHandler(async (req, res) => {
  const product = await Product.findById(req.params.id)
    .populate('sellerId', 'name email phone profileImage');
  
  if (product) {
    res.json(product);
  } else {
    res.status(404).json({ message: 'Product not found' });
  }
}));

// @desc    Create a product
// @route   POST /api/products
// @access  Private/Seller
router.post('/', protect, authorize('seller'), asyncHandler(async (req: any, res) => {
  const { name, category, description, price, discount, stock, images } = req.body;
  
  const product = await Product.create({
    sellerId: req.user._id,
    name,
    category,
    description,
    price: parseFloat(price),
    discount: discount ? parseFloat(discount) : 0,
    stock: parseInt(stock),
    images: images || []
  });
  
  const populatedProduct = await Product.findById(product._id)
    .populate('sellerId', 'name email phone profileImage');
  
  res.status(201).json(populatedProduct);
}));

// @desc    Update a product
// @route   PUT /api/products/:id
// @access  Private/Seller
router.put('/:id', protect, authorize('seller'), asyncHandler(async (req: any, res) => {
  const product = await Product.findById(req.params.id);
  
  if (!product) {
    res.status(404).json({ message: 'Product not found' });
    return;
  }
  
  // Check if product belongs to the seller
  if (product.sellerId.toString() !== req.user._id.toString()) {
    res.status(403).json({ message: 'Not authorized to update this product' });
    return;
  }
  
  const updatedProduct = await Product.findByIdAndUpdate(
    req.params.id,
    req.body,
    { new: true, runValidators: true }
  ).populate('sellerId', 'name email phone profileImage');
  
  res.json(updatedProduct);
}));

// @desc    Delete a product
// @route   DELETE /api/products/:id
// @access  Private/Seller or Admin
router.delete('/:id', protect, authorize('seller', 'admin'), asyncHandler(async (req: any, res) => {
  const product = await Product.findById(req.params.id);
  
  if (!product) {
    res.status(404).json({ message: 'Product not found' });
    return;
  }
  
  // Check if product belongs to the seller or user is admin
  if (req.user.role !== 'admin' && product.sellerId.toString() !== req.user._id.toString()) {
    res.status(403).json({ message: 'Not authorized to delete this product' });
    return;
  }
  
  await product.deleteOne();
  res.json({ message: 'Product removed' });
}));

export default router;