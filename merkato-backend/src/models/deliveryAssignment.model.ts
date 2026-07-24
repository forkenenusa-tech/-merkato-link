import mongoose, { Document, Schema } from 'mongoose';

export interface IDeliveryAssignment extends Document {
  orderId: mongoose.Types.ObjectId;
  driverId: mongoose.Types.ObjectId;
  pickupLocation: string;
  dropLocation: string;
  status: 'assigned' | 'accepted' | 'picked' | 'delivered';
  distance: string;
  price: number;
  assignedAt: Date;
  completedAt?: Date;
}

const deliveryAssignmentSchema = new Schema<IDeliveryAssignment>({
  orderId: {
    type: Schema.Types.ObjectId,
    ref: 'Order',
    required: [true, 'Order ID is required'],
    unique: true
  },
  driverId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Driver ID is required']
  },
  pickupLocation: {
    type: String,
    required: [true, 'Pickup location is required'],
    trim: true
  },
  dropLocation: {
    type: String,
    required: [true, 'Drop location is required'],
    trim: true
  },
  status: {
    type: String,
    enum: ['assigned', 'accepted', 'picked', 'delivered'],
    default: 'assigned'
  },
  distance: {
    type: String,
    required: [true, 'Distance is required'],
    default: '5 km'
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price cannot be negative']
  },
  assignedAt: {
    type: Date,
    default: Date.now
  },
  completedAt: {
    type: Date
  }
}, {
  timestamps: true
});

// Indexes for faster queries
deliveryAssignmentSchema.index({ driverId: 1 });
deliveryAssignmentSchema.index({ status: 1 });
deliveryAssignmentSchema.index({ orderId: 1 });

export default mongoose.model<IDeliveryAssignment>('DeliveryAssignment', deliveryAssignmentSchema);