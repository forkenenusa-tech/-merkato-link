import mongoose, { Document, Schema } from 'mongoose';

export interface IOrderItem {
  productId: mongoose.Types.ObjectId;
  quantity: number;
  price: number;
  name: string;
}

export interface IOrder extends Document {
  customerId: mongoose.Types.ObjectId;
  sellerId: mongoose.Types.ObjectId;
  products: IOrderItem[];
  total: number;
  status: 'pending' | 'accepted' | 'prepared' | 'picked' | 'ontheway' | 'delivered' | 'cancelled';
  deliveryAddress: string;
  driverId?: mongoose.Types.ObjectId;
  paymentStatus: 'pending' | 'completed' | 'failed';
  paymentMethod: string;
  createdAt: Date;
  updatedAt: Date;
}

const orderItemSchema = new Schema<IOrderItem>({
  productId: {
    type: Schema.Types.ObjectId,
    ref: 'Product',
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    min: 1
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  name: {
    type: String,
    required: true
  }
});

const orderSchema = new Schema<IOrder>({
  customerId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Customer ID is required']
  },
  sellerId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Seller ID is required']
  },
  products: [orderItemSchema],
  total: {
    type: Number,
    required: [true, 'Total amount is required'],
    min: [0, 'Total cannot be negative']
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'prepared', 'picked', 'ontheway', 'delivered', 'cancelled'],
    default: 'pending'
  },
  deliveryAddress: {
    type: String,
    required: [true, 'Delivery address is required'],
    trim: true
  },
  driverId: {
    type: Schema.Types.ObjectId,
    ref: 'User'
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed'],
    default: 'pending'
  },
  paymentMethod: {
    type: String,
    required: [true, 'Payment method is required'],
    default: 'cash'
  }
}, {
  timestamps: true
});

// Indexes for faster queries
orderSchema.index({ customerId: 1 });
orderSchema.index({ sellerId: 1 });
orderSchema.index({ driverId: 1 });
orderSchema.index({ status: 1 });
orderSchema.index({ createdAt: -1 });

export default mongoose.model<IOrder>('Order', orderSchema);