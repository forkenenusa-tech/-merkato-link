# Merkato Link - Complete Project Structure

## 📁 Root Structure
```
merkato_link/
├── README.md                    # Main project documentation
├── setup.sh                     # Linux/macOS setup script
├── setup.bat                    # Windows setup script
├── PROJECT_STRUCTURE.md         # This file
│
├── merkato-backend/             # Node.js + Express Backend
├── merkato-mobile/              # Flutter Customer App
├── merkato-admin/               # React Admin Dashboard
├── merkato-seller/              # React Seller Dashboard
├── merkato-staff/               # React Staff Dashboard
└── merkato-driver/              # React Driver Dashboard
```

## 🔧 Backend (merkato-backend/)
```
merkato-backend/
├── package.json                 # Dependencies and scripts
├── tsconfig.json                # TypeScript configuration
├── Dockerfile                   # Container configuration
├── render.yaml                  # Render deployment config
├── .env.example                 # Environment variables template
├── .env                         # Environment variables (created by user)
│
├── src/
│   ├── index.ts                 # Main application entry
│   ├── seed.ts                  # Database seeder script
│   │
│   ├── models/                  # Mongoose models
│   │   ├── user.model.ts        # User model
│   │   ├── product.model.ts     # Product model
│   │   ├── order.model.ts       # Order model
│   │   ├── deliveryAssignment.model.ts
│   │   ├── sellerApplication.model.ts
│   │   └── driverApplication.model.ts
│   │
│   ├── middleware/              # Express middleware
│   │   └── auth.middleware.ts   # JWT authentication
│   │
│   └── routes/                  # API routes
│       ├── auth.routes.ts       # Authentication routes
│       ├── product.routes.ts    # Product routes
│       ├── order.routes.ts      # Order routes
│       ├── seller.routes.ts     # Seller routes
│       ├── driver.routes.ts     # Driver routes
│       ├── staff.routes.ts      # Staff routes
│       └── admin.routes.ts      # Admin routes
│
└── dist/                        # Compiled JavaScript (generated)
```

## 📱 Flutter Mobile App (merkato-mobile/)
```
merkato-mobile/
├── pubspec.yaml                 # Flutter dependencies
├── .env                         # API configuration
├── README.md                    # Flutter app documentation
│
├── lib/
│   ├── main.dart                # App entry point
│   │
│   ├── screens/                 # App screens
│   │   ├── splash_screen.dart   # Splash screen
│   │   ├── home_screen.dart     # Main home screen
│   │   └── auth/                # Authentication screens
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   │
│   ├── widgets/                 # Reusable widgets
│   │   └── product_grid.dart    # Product grid widget
│   │
│   ├── services/                # API services
│   │   └── api_service.dart     # API client
│   │
│   ├── providers/               # Riverpod providers
│   ├── models/                  # Data models
│   └── utils/                   # Utilities
│
├── assets/                      # Images, fonts, etc.
└── android/, ios/, web/         # Platform-specific files
```

## 🖥️ React Dashboards (All 4 have similar structure)

### Admin Dashboard (merkato-admin/)
```
merkato-admin/
├── package.json                 # Dependencies
├── vite.config.ts              # Vite configuration
├── tsconfig.json               # TypeScript config
├── vercel.json                 # Vercel deployment
├── tailwind.config.js          # Tailwind CSS config
├── index.html                  # HTML entry point
│
├── src/
│   ├── main.tsx                # React entry point
│   ├── App.tsx                 # Main App component
│   ├── index.css               # Global styles
│   │
│   ├── components/             # Reusable components
│   │   ├── Layout.tsx          # Dashboard layout
│   │   └── StatCard.tsx        # Statistics card
│   │
│   ├── pages/                  # Page components
│   │   ├── Dashboard.tsx       # Dashboard page
│   │   ├── Login.tsx          # Login page
│   │   ├── Products.tsx       # Products page
│   │   ├── Users.tsx          # Users page
│   │   └── Verification.tsx   # Verification page
│   │
│   └── services/              # API services
│       └── api.ts             # API client
│
└── public/                    # Static assets
```

### Seller Dashboard (merkato-seller/)
Similar to admin but with:
- Products CRUD
- Order management
- Store analytics

### Staff Dashboard (merkato-staff/)
Similar to admin but with:
- Application verification
- Order monitoring

### Driver Dashboard (merkato-driver/)
Similar to admin but with:
- Delivery management
- Map integration
- Earnings tracking

## 🗄️ Database Schema

### Collections:
1. **User** - All users (customers, sellers, staff, admins, drivers)
2. **Product** - Seller products with images and pricing
3. **Order** - Customer orders with delivery tracking
4. **DeliveryAssignment** - Driver delivery assignments
5. **SellerApplication** - Seller registration requests
6. **DriverApplication** - Driver registration requests

## 🔐 API Endpoints

### Public:
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product

### Customer (JWT protected):
- `POST /api/orders` - Place order
- `GET /api/orders/:id` - Get order details

### Seller (JWT protected):
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product
- `GET /api/seller/orders` - Get seller's orders
- `POST /api/seller/apply` - Apply as seller

### Driver (JWT protected):
- `GET /api/driver/deliveries` - Get driver's deliveries
- `GET /api/driver/stats` - Get driver statistics
- `PUT /api/driver/delivery/:id/status` - Update delivery status
- `POST /api/driver/accept/:id` - Accept delivery

### Staff (JWT protected):
- `GET /api/staff/applications` - Get pending applications
- `PUT /api/staff/verify/:id` - Approve/reject application

### Admin (JWT protected):
- `GET /api/admin/users` - Get all users
- `PUT /api/admin/users/:id` - Update user status
- `GET /api/admin/stats` - Get dashboard statistics

## 🌈 UI Design System

### Colors:
- Primary: `#009A49` (Green)
- Secondary: `#FFD700` (Gold)
- Accent: `#E63946` (Red)
- Background: `#F9FAFB` (Gray 50)

### Typography:
- Font Family: Poppins (Flutter), Inter (React)
- Headings: Bold, clear hierarchy
- Body: Readable, appropriate contrast

### Components:
- Glassmorphism cards
- Skeleton loaders
- Smooth transitions
- Responsive design
- Mobile-first approach

## 🚀 Deployment

### Backend:
- **Render**: Use `render.yaml` for easy deployment
- **Railway**: Push to GitHub and connect
- **Docker**: Build and deploy anywhere

### React Dashboards:
- **Vercel**: Each dashboard as separate project
- **Netlify**: Connect GitHub repositories
- **Static Hosting**: Build and upload `dist/` folder

### Flutter App:
- **Android**: Build APK or App Bundle
- **iOS**: Build through Xcode
- **Web**: Deploy as PWA

## 📊 Default Data (Seed)

### Users:
- Admin: `admin@test.com` / `password123`
- Seller: `seller@test.com` / `password123`
- Staff: `staff@test.com` / `password123`
- Driver: `driver@test.com` / `password123`
- Customer: `customer@test.com` / `password123`

### Sample Data:
- 5 Ethiopian products with images
- 2 sample orders
- 2 delivery assignments
- Pending applications

## 🔧 Development Commands

### Backend:
```bash
cd merkato-backend
npm install          # Install dependencies
npm run dev         # Start development server
npm run build       # Build TypeScript
npm run seed        # Seed database
```

### React Dashboards:
```bash
cd merkato-admin    # or seller/staff/driver
npm install
npm run dev         # Start dev server on port 3000
npm run build       # Build for production
```

### Flutter:
```bash
cd merkato-mobile
flutter pub get     # Install dependencies
flutter run         # Run on connected device
flutter build apk   # Build Android APK
```

## 🛡️ Security Features

1. **JWT Authentication** - Token-based auth for all protected routes
2. **Password Hashing** - bcrypt for secure password storage
3. **Role-based Access Control** - Different permissions per role
4. **Input Validation** - Request validation on all endpoints
5. **CORS Configuration** - Configured for web and mobile clients
6. **Environment Variables** - Sensitive data stored in .env files

## 📈 Future Enhancements

1. **Real-time Updates** - WebSocket for live order tracking
2. **Payment Integration** - Stripe/PayPal integration
3. **Push Notifications** - Mobile push for order updates
4. **Analytics Dashboard** - Advanced business insights
5. **Multi-language Support** - Amharic and other languages
6. **Advanced Search** - Elasticsearch integration
7. **Image Optimization** - Cloudinary for image hosting
8. **Testing Suite** - Comprehensive unit and integration tests

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Follow code style guidelines
4. Write tests for new features
5. Submit pull request

## 📄 License

MIT License - See LICENSE file for details