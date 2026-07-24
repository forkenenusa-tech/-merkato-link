import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import dotenv from 'dotenv';
import User from './models/user.model';
import Product from './models/product.model';
import Order from './models/order.model';
import DeliveryAssignment from './models/deliveryAssignment.model';
import SellerApplication from './models/sellerApplication.model';
import DriverApplication from './models/driverApplication.model';

dotenv.config();

const seedData = async () => {
  try {
    // Connect to MongoDB
    await mongoose.connect(process.env.MONGO_URI!);
    console.log('✅ Connected to MongoDB for seeding');

    // Clear existing data
    await User.deleteMany({});
    await Product.deleteMany({});
    await Order.deleteMany({});
    await DeliveryAssignment.deleteMany({});
    await SellerApplication.deleteMany({});
    await DriverApplication.deleteMany({});
    console.log('🗑️  Cleared existing data');

    // Hash password function
    const hashPassword = async (password: string) => {
      const salt = await bcrypt.genSalt(10);
      return await bcrypt.hash(password, salt);
    };

    // Create users
    const admin = await User.create({
      name: 'Admin User',
      email: 'admin@test.com',
      password: await hashPassword('password123'),
      phone: '+251911234567',
      role: 'admin',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Admin+User&background=009A49&color=fff'
    });

    const seller = await User.create({
      name: 'Seller Test',
      email: 'seller@test.com',
      password: await hashPassword('password123'),
      phone: '+251922334455',
      role: 'seller',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Seller+Test&background=009A49&color=fff'
    });

    const staff = await User.create({
      name: 'Staff User',
      email: 'staff@test.com',
      password: await hashPassword('password123'),
      phone: '+251933445566',
      role: 'staff',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Staff+User&background=009A49&color=fff'
    });

    const driver = await User.create({
      name: 'Driver Test',
      email: 'driver@test.com',
      password: await hashPassword('password123'),
      phone: '+251944556677',
      role: 'driver',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Driver+Test&background=009A49&color=fff'
    });

    const customer = await User.create({
      name: 'Customer Test',
      email: 'customer@test.com',
      password: await hashPassword('password123'),
      phone: '+251955667788',
      role: 'customer',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Customer+Test&background=009A49&color=fff'
    });

    console.log('👥 Created 5 users');

    // Create sample products
    const products = await Product.create([
      {
        sellerId: seller._id,
        name: 'Ethiopian Coffee Beans',
        category: 'food',
        description: 'Fresh Ethiopian coffee beans from Yirgacheffe region',
        price: 350,
        discount: 10,
        stock: 100,
        images: [
          'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=400&h=300&fit=crop',
          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w-400&h=300&fit=crop'
        ],
        rating: 4.8
      },
      {
        sellerId: seller._id,
        name: 'Handwoven Scarf',
        category: 'clothing',
        description: 'Traditional Ethiopian handwoven scarf with colorful patterns',
        price: 850,
        discount: 15,
        stock: 50,
        images: [
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400&h=300&fit=crop'
        ],
        rating: 4.5
      },
      {
        sellerId: seller._id,
        name: 'Ethiopian Spice Mix',
        category: 'food',
        description: 'Authentic Ethiopian spice blend for traditional dishes',
        price: 280,
        discount: 5,
        stock: 200,
        images: [
          'https://images.unsplash.com/photo-1534938665420-4193effeacc4?w=400&h=300&fit=crop'
        ],
        rating: 4.7
      },
      {
        sellerId: seller._id,
        name: 'Traditional Coffee Pot',
        category: 'home',
        description: 'Authentic Ethiopian jebena coffee pot for traditional coffee ceremony',
        price: 1200,
        discount: 20,
        stock: 30,
        images: [
          'https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w=400&h=300&fit=crop'
        ],
        rating: 4.9
      },
      {
        sellerId: seller._id,
        name: 'Ethiopian Cross Necklace',
        category: 'other',
        description: 'Silver Ethiopian cross necklace with traditional design',
        price: 650,
        discount: 0,
        stock: 25,
        images: [
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=400&h=300&fit=crop'
        ],
        rating: 4.6
      }
    ]);

    console.log('📦 Created 5 sample products');

    // Create sample orders
    const order1 = await Order.create({
      customerId: customer._id,
      sellerId: seller._id,
      products: [
        {
          productId: products[0]._id,
          quantity: 2,
          price: products[0].price,
          name: products[0].name
        },
        {
          productId: products[2]._id,
          quantity: 1,
          price: products[2].price,
          name: products[2].name
        }
      ],
      total: (products[0].price * 2 * 0.9) + (products[2].price * 0.95), // Apply discounts
      status: 'delivered',
      deliveryAddress: 'Bole Road, Addis Ababa',
      driverId: driver._id,
      paymentStatus: 'completed',
      paymentMethod: 'card'
    });

    const order2 = await Order.create({
      customerId: customer._id,
      sellerId: seller._id,
      products: [
        {
          productId: products[1]._id,
          quantity: 1,
          price: products[1].price,
          name: products[1].name
        }
      ],
      total: products[1].price * 0.85, // Apply 15% discount
      status: 'ontheway',
      deliveryAddress: 'Kirkos Subcity, Addis Ababa',
      driverId: driver._id,
      paymentStatus: 'completed',
      paymentMethod: 'cash'
    });

    console.log('📦 Created 2 sample orders');

    // Create delivery assignments
    await DeliveryAssignment.create([
      {
        orderId: order1._id,
        driverId: driver._id,
        pickupLocation: 'Seller Warehouse, Bole',
        dropLocation: 'Bole Road, Addis Ababa',
        status: 'delivered',
        distance: '8 km',
        price: 50,
        assignedAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7 days ago
        completedAt: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000) // 6 days ago
      },
      {
        orderId: order2._id,
        driverId: driver._id,
        pickupLocation: 'Seller Store, Piazza',
        dropLocation: 'Kirkos Subcity, Addis Ababa',
        status: 'accepted',
        distance: '5 km',
        price: 40,
        assignedAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000) // 1 day ago
      }
    ]);

    console.log('🚚 Created 2 delivery assignments');

    // Create pending applications
    await SellerApplication.create({
      userId: customer._id, // Customer applying to be seller
      businessName: 'New Ethiopian Crafts',
      businessLicense: 'https://example.com/license.jpg',
      status: 'pending',
      submittedAt: new Date(Date.now() - 3 * 24 * 60 * 60 * 1000) // 3 days ago
    });

    // Create another user for driver application
    const driverApplicant = await User.create({
      name: 'Driver Applicant',
      email: 'applicant@test.com',
      password: await hashPassword('password123'),
      phone: '+251966778899',
      role: 'customer',
      isVerified: true,
      isActive: true,
      profileImage: 'https://ui-avatars.com/api/?name=Driver+Applicant&background=009A49&color=fff'
    });

    await DriverApplication.create({
      userId: driverApplicant._id,
      licenseNumber: 'ET123456',
      vehicleType: 'motorcycle',
      plateNumber: 'AA1234',
      status: 'pending',
      submittedAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000) // 2 days ago
    });

    console.log('📝 Created pending applications');

    console.log('✅ Seeding completed successfully!');
    console.log('\n📋 Default Credentials:');
    console.log('Admin: admin@test.com / password123');
    console.log('Seller: seller@test.com / password123');
    console.log('Staff: staff@test.com / password123');
    console.log('Driver: driver@test.com / password123');
    console.log('Customer: customer@test.com / password123');
    console.log('Applicant: applicant@test.com / password123');

    process.exit(0);
  } catch (error) {
    console.error('❌ Seeding error:', error);
    process.exit(1);
  }
};

seedData();