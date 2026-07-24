import express from 'express';
import asyncHandler from 'express-async-handler';
import SellerApplication from '../models/sellerApplication.model';
import DriverApplication from '../models/driverApplication.model';
import User from '../models/user.model';
import { protect, authorize } from '../middleware/auth.middleware';

const router = express.Router();

// @desc    Get pending applications
// @route   GET /api/staff/applications
// @access  Private/Staff
router.get('/applications', protect, authorize('staff', 'admin'), asyncHandler(async (req: any, res) => {
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
      pendingDrivers: await DriverApplication.countDocuments({ status: 'pending' })
    }
  });
}));

// @desc    Verify/approve/reject application
// @route   PUT /api/staff/verify/:id
// @access  Private/Staff
router.put('/verify/:id', protect, authorize('staff', 'admin'), asyncHandler(async (req: any, res) => {
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
  
  // At this point, user should be defined (either from seller or driver branch)
  // Use non-null assertion to tell TypeScript user is not null
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

export default router;