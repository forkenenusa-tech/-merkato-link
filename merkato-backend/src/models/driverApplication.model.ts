import mongoose, { Document, Schema } from 'mongoose';

export interface IDriverApplication extends Document {
  userId: mongoose.Types.ObjectId;
  licenseNumber: string;
  vehicleType: 'motorcycle' | 'car' | 'van' | 'truck';
  plateNumber: string;
  vehicleModel?: string;
  vehicleColor?: string;
  yearsOfExperience?: number;
  insuranceProvider?: string;
  insuranceNumber?: string;
  licenseImage?: string;
  vehicleImage?: string;
  idFrontImage?: string;
  idBackImage?: string;
  status: 'pending' | 'approved' | 'rejected';
  submittedAt: Date;
  reviewedAt?: Date;
  reviewedBy?: mongoose.Types.ObjectId;
  notes?: string;
}

const driverApplicationSchema = new Schema<IDriverApplication>({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'User ID is required'],
    unique: true
  },
  licenseNumber: {
    type: String,
    required: [true, 'License number is required'],
    trim: true
  },
  vehicleType: {
    type: String,
    enum: ['motorcycle', 'car', 'van', 'truck'],
    required: [true, 'Vehicle type is required']
  },
  plateNumber: {
    type: String,
    required: [true, 'Plate number is required'],
    trim: true
  },
  vehicleModel: {
    type: String,
    default: ''
  },
  vehicleColor: {
    type: String,
    default: ''
  },
  yearsOfExperience: {
    type: Number,
    default: 0
  },
  insuranceProvider: {
    type: String,
    default: ''
  },
  insuranceNumber: {
    type: String,
    default: ''
  },
  licenseImage: {
    type: String,
    default: ''
  },
  vehicleImage: {
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
driverApplicationSchema.index({ userId: 1 });
driverApplicationSchema.index({ status: 1 });
driverApplicationSchema.index({ submittedAt: -1 });

export default mongoose.model<IDriverApplication>('DriverApplication', driverApplicationSchema);