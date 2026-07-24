# 🛒 Merkato Link - Ethiopian Multi-Vendor Marketplace

**A complete role-based marketplace ecosystem with MongoDB Atlas persistence and deployment-ready configuration.**

## 🎯 Features Overview

✅ **5 Complete Applications:**
1. **Flutter Customer App** - Android/iOS mobile shopping
2. **React Admin Dashboard** - Full system management
3. **React Seller Dashboard** - Store management & analytics
4. **React Staff Dashboard** - Application verification
5. **React Driver Dashboard** - Delivery management & tracking

✅ **Full CRUD Operations** with MongoDB Atlas persistence
✅ **JWT Authentication** with role-based access control
✅ **Real Database Connectivity** (no in-memory arrays)
✅ **Deployment Ready** for free hosting platforms
✅ **Responsive Design** across all platforms
✅ **Complete API Documentation**

## 🚀 Quick Start

### Option 1: One-click Setup (Windows)
```bash
setup.bat
```

### Option 2: Manual Setup
```bash
# 1. Backend Setup
cd merkato-backend
npm install
cp .env.example .env
# Edit .env with your MongoDB Atlas URI
npm run dev

# 2. Seed Database
npm run seed

# 3. Start Admin Dashboard
cd ../merkato-admin
npm install
npm run dev

# 4. Start Flutter App
cd ../merkato-mobile
flutter pub get
flutter run
```

## 🌐 MongoDB Atlas Setup

1. **Create Free Cluster:** https://www.mongodb.com/cloud/atlas
2. **Get Connection String:** 
   ```
   mongodb+srv://<username>:<password>@cluster0.mongodb.net/merkato
   ```
3. **Update `.env` file:**
   ```env
   MONGO_URI=your_connection_string_here
   JWT_SECRET=your_secret_key
   PORT=5000
   CLIENT_URL=*
   ```

## 📱 Application URLs (Development)

- **Backend API:** http://localhost:5000
- **Admin Dashboard:** http://localhost:3000
- **Seller Dashboard:** http://localhost:3001 (after setup)
- **Staff Dashboard:** http://localhost:3002 (after setup)
- **Driver Dashboard:** http://localhost:3003 (after setup)
- **Flutter App:** Run on device/emulator

## 👥 Default Credentials

After seeding:
- **Admin:** admin@test.com / password123
- **Seller:** seller@test.com / password123  
- **Staff:** staff@test.com / password123
- **Driver:** driver@test.com / password123
- **Customer:** customer@test.com / password123

## 🏗️ Technology Stack

| Component | Technology |
|-----------|------------|
| **Backend** | Node.js, Express, TypeScript, Mongoose |
| **Database** | MongoDB Atlas (free tier) |
| **Mobile** | Flutter, Riverpod, Dio, Google Maps |
| **Web Dashboards** | React, Vite, TypeScript, Tailwind CSS |
| **Authentication** | JWT, bcrypt, role-based middleware |
| **Deployment** | Render, Vercel, Docker |

## 📊 Database Collections

1. **`users`** - All users with roles (customer, seller, staff, admin, driver)
2. **`products`** - Seller products with images and pricing
3. **`orders`** - Customer orders with delivery tracking
4. **`deliveryassignments`** - Driver delivery assignments
5. **`sellerapplications`** - Seller registration requests
6. **`driverapplications`** - Driver registration requests

## 🔧 API Documentation

Complete API documentation available in:
- `MERKATO_LINK_API_POSTMAN.json` - Postman collection
- Check `PROJECT_STRUCTURE.md` for endpoint details
- Health check: `GET /api/health`

## 🚢 Deployment

### Backend (Render/Railway)
```yaml
# Already configured in render.yaml
# Just push to GitHub and connect
```

### React Dashboards (Vercel)
```bash
# Each dashboard has vercel.json
# Connect GitHub repo to Vercel
```

### Flutter App
```bash
# Android APK
flutter build apk --release

# iOS (Mac only)
flutter build ios --release
```

## 📁 Project Structure

See `PROJECT_STRUCTURE.md` for complete directory breakdown.

## 🎨 UI Design

- **Primary Color:** #009A49 (Green)
- **Secondary Color:** #FFD700 (Gold) 
- **Accent Color:** #E63946 (Red)
- **Glassmorphism Effects** on cards
- **Mobile-First** responsive design
- **Smooth Animations** & transitions

## 🔐 Security Features

- **JWT Authentication** for all protected routes
- **Password Hashing** with bcrypt
- **Role-based Access Control** (RBAC)
- **Input Validation** on all endpoints
- **CORS Configuration** for cross-origin requests
- **Environment Variables** for sensitive data

## 🧪 Testing

### Backend API Testing
```bash
cd merkato-backend
# Use Postman collection for manual testing
```

### Flutter Testing
```bash
cd merkato-mobile
flutter test
```

## 📈 Future Enhancements

1. **Real-time Updates** with WebSockets
2. **Payment Integration** (Stripe/PayPal)
3. **Push Notifications** for order updates
4. **Advanced Analytics Dashboard**
5. **Multi-language Support** (Amharic)
6. **Image Optimization** with Cloudinary
7. **Comprehensive Test Suite**

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

Distributed under MIT License. See `LICENSE` for more information.

## 🙏 Acknowledgments

- Ethiopian marketplace inspiration
- MongoDB Atlas for free database hosting
- All open-source libraries used in this project

## 📞 Support

For issues and questions:
1. Check `PROJECT_STRUCTURE.md` for documentation
2. Review API endpoints in Postman collection
3. Test with default credentials first

---

**🚀 Ready to launch your Ethiopian marketplace!**

## Project Structure

- `/merkato-backend` - Node.js + Express + TypeScript backend
- `/merkato-mobile` - Flutter Customer App (Android/iOS)
- `/merkato-admin` - React Admin Dashboard
- `/merkato-seller` - React Seller Dashboard  
- `/merkato-staff` - React Staff Dashboard
- `/merkato-driver` - React Driver Dashboard

## Tech Stack

- **Backend**: Node.js + Express + TypeScript + Mongoose + JWT + bcrypt
- **Database**: MongoDB Atlas (free tier)
- **Mobile**: Flutter + Riverpod + Dio + google_maps_flutter
- **Web Dashboards**: React + Vite + TypeScript + Tailwind + shadcn/ui

## Features

- **Customer App**: Browse products, add to cart, checkout, track orders
- **Admin Dashboard**: User management, product oversight, application verification
- **Seller Dashboard**: Product CRUD, order management, store analytics
- **Staff Dashboard**: Application verification, order monitoring
- **Driver Dashboard**: Delivery management, earnings tracking, route visualization

## Setup Instructions

### 1. Backend Setup
```bash
cd merkato-backend
npm install
cp .env.example .env
# Update MONGO_URI with your MongoDB Atlas connection string
npm run dev
```

### 2. MongoDB Setup
1. Create a free MongoDB Atlas cluster at https://www.mongodb.com/cloud/atlas
2. Get your connection string
3. Add database user with read/write permissions
4. Update `.env` with your connection string

### 3. Seed Data
```bash
cd merkato-backend
npm run seed
```

### 4. Mobile App Setup
```bash
cd merkato-mobile
flutter pub get
flutter run
```

### 5. Web Dashboards Setup
Each dashboard follows the same pattern:
```bash
cd merkato-admin  # or merkato-seller, merkato-staff, merkato-driver
npm install
npm run dev
```

## Environment Variables

### Backend (.env)
```
MONGO_URI=mongodb+srv://username:password@cluster.mongodb.net/merkato
JWT_SECRET=your_jwt_secret_here
PORT=5000
CLIENT_URL=*
```

### Web Dashboards (.env)
```
VITE_API_URL=http://localhost:5000
```

## Default Credentials

After seeding:
- Admin: admin@test.com / password123
- Seller: seller@test.com / password123  
- Staff: staff@test.com / password123
- Driver: driver@test.com / password123
- Customer: customer@test.com / password123

## API Documentation

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product (seller only)
- `PUT /api/products/:id` - Update product (seller only)
- `DELETE /api/products/:id` - Delete product (seller only)

### Orders
- `POST /api/orders` - Place order (customer only)
- `GET /api/orders/:id` - Get order details

### Seller
- `GET /api/seller/orders` - Get seller's orders
- `POST /api/seller/apply` - Apply as seller

### Driver
- `GET /api/driver/deliveries` - Get driver's deliveries
- `GET /api/driver/stats` - Get driver statistics
- `PUT /api/driver/delivery/:id/status` - Update delivery status
- `POST /api/driver/accept/:id` - Accept delivery

### Staff
- `GET /api/staff/applications` - Get pending applications
- `PUT /api/staff/verify/:id` - Approve/reject application

### Admin
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/:id` - Update user status

## Deployment

### Backend (Render/Railway)
1. Push to GitHub
2. Connect repository to Render/Railway
3. Add environment variables
4. Deploy

### Web Dashboards (Vercel/Netlify)
1. Push each dashboard separately
2. Connect to Vercel/Netlify
3. Set `VITE_API_URL` to backend URL
4. Deploy

### Flutter App
```bash
flutter build apk --release
flutter build ios --release
```

## Database Schema

- **User**: Customers, Sellers, Staff, Admins, Drivers
- **Product**: Seller products with images, price, stock
- **Order**: Customer orders with delivery tracking
- **DeliveryAssignment**: Driver delivery assignments
- **SellerApplication**: Seller registration requests
- **DriverApplication**: Driver registration requests

## UI Styling

- Primary Color: #009A49 (Green)
- Secondary Color: #FFD700 (Gold)
- Accent Color: #E63946 (Red)
- Glassmorphism effects on cards
- Fully responsive design
- Mobile-first approach

## Notes

- Maps use static coordinates (9.03, 38.74) for Addis Ababa
- Payments are mocked for demo purposes
- All data persists in MongoDB Atlas
- JWT authentication protects all routes
- Role-based access control for all dashboards