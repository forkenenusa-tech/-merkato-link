import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import asyncHandler from 'express-async-handler';
import User from '../models/user.model';
import { protect } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Register a new user
// @route   POST /api/auth/register
// @access  Public
router.post('/register', asyncHandler(async (req, res) => {
  const { name, email, password, phone, role } = req.body;

  // Check if user exists
  const userExists = await User.findOne({ email });
  if (userExists) {
    res.status(400).json({ message: 'User already exists' });
    return;
  }

  // Hash password
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);

  // Create user
  const user = await User.create({
    name,
    email,
    password: hashedPassword,
    phone,
    role: role || 'customer'
  });

  if (user) {
    // Create token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET!,
      { expiresIn: '30d' }
    );

    res.status(201).json({
      _id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      token,
      isVerified: user.isVerified,
      profileImage: user.profileImage
    });
  } else {
    res.status(400).json({ message: 'Invalid user data' });
  }
}));

// @desc    Login user
// @route   POST /api/auth/login
// @access  Public
router.post('/login', asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  // Check for user email
  const user = await User.findOne({ email });

  if (user && (await bcrypt.compare(password, user.password))) {
    // Check if user is active
    if (!user.isActive) {
      res.status(401).json({ message: 'Account is suspended' });
      return;
    }

    // Create token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET!,
      { expiresIn: '30d' }
    );

    res.json({
      _id: user._id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      role: user.role,
      token,
      isVerified: user.isVerified,
      profileImage: user.profileImage
    });
  } else {
    res.status(401).json({ message: 'Invalid email or password' });
  }
}));

// @desc    Get current user profile
// @route   GET /api/auth/profile
// @access  Private
router.get('/profile', protect, asyncHandler(async (req: any, res) => {
  const user = await User.findById(req.user._id).select('-password');
  
  if (user) {
    res.json(user);
  } else {
    res.status(404).json({ message: 'User not found' });
  }
}));

// @desc    Update user profile
// @route   PUT /api/auth/profile
// @access  Private
router.put('/profile', protect, asyncHandler(async (req: any, res) => {
  const user = await User.findById(req.user._id);

  if (user) {
    user.name = req.body.name || user.name;
    user.email = req.body.email || user.email;
    user.phone = req.body.phone || user.phone;
    user.profileImage = req.body.profileImage !== undefined ? req.body.profileImage : user.profileImage;
    user.address = req.body.address !== undefined ? req.body.address : user.address;
    user.bio = req.body.bio !== undefined ? req.body.bio : user.bio;

    // Allow switching active role if role is valid
    if (req.body.role && ['customer', 'seller', 'driver'].includes(req.body.role)) {
      user.role = req.body.role;
    }

    if (req.body.password) {
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(req.body.password, salt);
    }

    const updatedUser = await user.save();

    res.json({
      _id: updatedUser._id,
      name: updatedUser.name,
      email: updatedUser.email,
      phone: updatedUser.phone,
      role: updatedUser.role,
      isVerified: updatedUser.isVerified,
      profileImage: updatedUser.profileImage,
      address: updatedUser.address,
      bio: updatedUser.bio,
      approvedRoles: updatedUser.approvedRoles
    });
  } else {
    res.status(404).json({ message: 'User not found' });
  }
}));

export default router;