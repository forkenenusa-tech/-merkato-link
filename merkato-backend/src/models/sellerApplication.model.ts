import mongoose, { Document, Schema } from 'mongoose';

export interface ISellerApplication extends Document {
  userId: mongoose.Types.ObjectId;
  businessName: string;
  businessLicense: string;
  taxId?: string;
  businessAddress?: string;
  businessPhone?: string;
  businessEmail?: string;
  yearsInBusiness?: number;
  businessLicenseImage?: string;
  taxCertificateImage?: string;
  businessRegistrationImage?: string;
  idFrontImage?: string;
  idBackImage?: string;
  businessPremisesImage?: string;
  status: 'pending' | 'approved' | 'rejected';
  submittedAt: Date;
  reviewedAt?: Date;
  reviewedBy?: mongoose.Types.ObjectId;
  notes?: string;
}

const sellerApplicationSchema = new Schema<ISellerApplication>({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User ID is required'],
    unique: true
  },
  businessName: {
    type: String,
    required: [true, 'Business name is required'],
    trim: true
  },
  businessLicense: {
    type: String,
    required: [true, 'Business license is required']
  },
  taxId: {
    type: String,
    default: ''
  },
  businessAddress: {
    type: String,
    default: ''
  },
  businessPhone: {
    type: String,
    default: ''
  },
  businessEmail: {
    type: String,
    default: ''
  },
  yearsInBusiness: {
    type: Number,
    default: 0
  },
  businessLicenseImage: {
    type: String,
    default: ''
  },
  taxCertificateImage: {
    type: String,
    default: ''
  },
  businessRegistrationImage: {
    type: String,
    default: ''
  },
  idFrontImage: {
    type: String,
    default: ''
  },
  idBackImage: {
    type: String,
    default: ''
  },
  businessPremisesImage: {
    type: String,
    default: ''
  },
  status: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'pending'
  },
  submittedAt: {
    type: Date,
    default: Date.now
  },
  reviewedAt: {
    type: Date
  },
  reviewedBy: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  notes: {
    type: String,
    trim: true
  }
});

// Indexes for faster queries
sellerApplicationSchema.index({ userId: 1 });
sellerApplicationSchema.index({ status: 1 });
sellerApplicationSchema.index({ submittedAt: -1 });

export default mongoose.model<ISellerApplication>('SellerApplication', sellerApplicationSchema);