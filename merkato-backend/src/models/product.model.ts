import mongoose, { Document, Schema } from 'mongoose';

export interface IProduct extends Document {
  sellerId: mongoose.Types.ObjectId;
  name: string;
  category: string;
  description: string;
  price: number;
  discount: number;
  stock: number;
  images: string[];
  rating: number;
  createdAt: Date;
  updatedAt: Date;
}

const productSchema = new Schema<IProduct>({
  sellerId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Seller ID is required']
  },
  name: {
    type: String,
    required: [true, 'Product name is required'],
    trim: true
  },
  category: {
    type: String,
    required: [true, 'Category is required'],
    enum: ['electronics', 'clothing', 'food', 'home', 'beauty', 'books', 'other']
  },
  description: {
    type: String,
    required: [true, 'Description is required'],
    trim: true
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price cannot be negative']
  },
  discount: {
    type: Number,
    default: 0,
    min: [0, 'Discount cannot be negative'],
    max: [100, 'Discount cannot exceed 100%']
  },
  stock: {
    type: Number,
    required: [true, 'Stock is required'],
    min: [0, 'Stock cannot be negative'],
    default: 0
  },
  images: [{
    type: String,
    default: []
  }],
  rating: {
    type: Number,
    default: 0,
    min: [0, 'Rating cannot be negative'],
    max: [5, 'Rating cannot exceed 5']
  }
}, {
  timestamps: true
});

// Indexes for faster queries
productSchema.index({ sellerId: 1 });
productSchema.index({ category: 1 });
productSchema.index({ name: 'text', description: 'text' });

export default mongoose.model<IProduct>('Product', productSchema);