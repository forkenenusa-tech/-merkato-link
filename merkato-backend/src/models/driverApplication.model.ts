import mongoose, { Document, Schema } from 'mongoose';

export interface IDriverApplication extends Document {
  userId: mongoose.Types.ObjectId;
  licenseNumber: string;
  vehicleType: 'motorcycle' | 'car' | 'van' | 'truck';
  plateNumber: string;
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