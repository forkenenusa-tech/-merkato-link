# Merkato Link Complete Deployment Guide

This guide will help you deploy ALL components of the Merkato Link platform to free hosting services.

## 🎯 Deployment Overview

**Backend**: Render.com ✅ (Already deployed: https://merkato-link.onrender.com)
**Frontends**: Vercel.com (Admin, Staff, Seller, Driver)
**Mobile App**: Flutter (Local testing + App Store deployment)

## 📋 Prerequisites
- GitHub account with repository: https://github.com/forkenenusa-tech/-merkato-link.git
- MongoDB Atlas account (free tier) ✅ (Already configured)
- Render.com account (free tier) ✅ (Already deployed)
- Vercel account (free tier)

## 🚀 Frontend Deployments (Vercel)

### Step 1: Deploy Admin Panel
1. Go to [Vercel](https://vercel.com) and create a free account
2. Click "Add New Project"
3. Import GitHub repository: `forkenenusa-tech/-merkato-link`
4. Configure:
   - **Project Name**: `merkato-admin`
   - **Root Directory**: `merkato-admin`
   - **Framework Preset**: Vite
5. Add Environment Variables:
   - `VITE_API_URL`: `https://merkato-link.onrender.com`
6. Click "Deploy"
7. Save the deployed URL (e.g., `https://merkato-admin.vercel.app`)

### Step 2: Deploy Staff Panel
1. In Vercel, click "Add New Project"
2. Import same GitHub repository
3. Configure:
   - **Project Name**: `merkato-staff`
   - **Root Directory**: `merkato-staff`
   - **Framework Preset**: Vite
4. Add Environment Variables:
   - `VITE_API_URL`: `https://merkato-link.onrender.com`
5. Click "Deploy"
6. Save the deployed URL (e.g., `https://merkato-staff.vercel.app`)

### Step 3: Deploy Seller Panel
1. In Vercel, click "Add New Project"
2. Import same GitHub repository
3. Configure:
   - **Project Name**: `merkato-seller`
   - **Root Directory**: `merkato-seller`
   - **Framework Preset**: Vite
4. Add Environment Variables:
   - `VITE_API_URL`: `https://merkato-link.onrender.com`
5. Click "Deploy"
6. Save the deployed URL (e.g., `https://merkato-seller.vercel.app`)

### Step 4: Deploy Driver Panel
1. In Vercel, click "Add New Project"
2. Import same GitHub repository
3. Configure:
   - **Project Name**: `merkato-driver`
   - **Root Directory**: `merkato-driver`
   - **Framework Preset**: Vite
4. Add Environment Variables:
   - `VITE_API_URL`: `https://merkato-link.onrender.com`
5. Click "Deploy"
6. Save the deployed URL (e.g., `https://merkato-driver.vercel.app`)

## 📱 Mobile App Configuration

### Current Status
- ✅ Backend URL configured to: `https://merkato-link.onrender.com`
- ✅ Logo asset fixed (logo.jpg)
- ✅ Ready for testing

### Test Mobile App
```bash
cd merkato-mobile
flutter run -d chrome
```

### Build for Production
For web deployment:
```bash
cd merkato-mobile
flutter build web
```

For mobile app stores:
- **Android**: Build APK and upload to Google Play Store
- **iOS**: Build IPA and upload to Apple App Store

## 🔗 Integration Testing

### 1. Test Backend API
```bash
curl https://merkato-link.onrender.com/api/health
```

### 2. Test Admin Panel
- Open admin URL in browser
- Register/login as admin
- Test dashboard, user management, analytics

### 3. Test Staff Panel
- Open staff URL in browser
- Register/login as staff
- Test order management, inventory

### 4. Test Seller Panel
- Open seller URL in browser
- Register/login as seller
- Test product management, order management, analytics

### 5. Test Driver Panel
- Open driver URL in browser
- Register/login as driver
- Test order delivery, location tracking

### 6. Test Mobile App
- Run mobile app
- Register as customer
- Test shopping, cart, checkout, order tracking
- Register as seller
- Test seller dashboard integration

## 🎯 Role-Based Functionality

### Admin Role
- User management (create, edit, delete users)
- Role assignment (admin, staff, seller, driver, customer)
- Platform analytics and reports
- System configuration

### Staff Role
- Order management and fulfillment
- Inventory management
- Customer support
- Store operations

### Seller Role
- Product management (add, edit, delete products)
- Order management (view, update order status)
- Sales analytics and reports
- Store dashboard

### Driver Role
- Order delivery management
- Location tracking
- Delivery status updates
- Earnings tracking

### Customer Role (Mobile App)
- Browse products and categories
- Shopping cart management
- Checkout and payment
- Order tracking
- Wishlist management

## 📊 Environment Variables Summary

### Backend (Render.com) ✅
- `MONGO_URI`: MongoDB Atlas connection string
- `JWT_SECRET`: Random secret key
- `NODE_ENV`: `production`
- `CLIENT_URL`: `*`

### Frontends (Vercel)
- `VITE_API_URL`: `https://merkato-link.onrender.com`

### Mobile App
- `API_URL`: `https://merkato-link.onrender.com`

## 🔧 Troubleshooting

### Backend Issues
- Check Render logs: https://dashboard.render.com
- Verify MongoDB Atlas connection
- Ensure IP whitelist includes 0.0.0.0/0

### Frontend Issues
- Check Vercel deployment logs
- Verify VITE_API_URL is correct
- Clear browser cache
- Check console for errors

### Mobile App Issues
- Verify API_URL in .env file
- Check network connectivity
- Test API endpoints with curl
- Check Flutter logs

## 💡 Free Tier Limitations

### Render.com
- Free tier: 750 hours/month
- Sleeps after 15 minutes of inactivity
- Cold starts may take 30-60 seconds

### Vercel
- Free tier: 100GB bandwidth/month
- Unlimited deployments
- Automatic SSL certificates
- Fast CDN

### MongoDB Atlas
- Free tier: 512MB storage
- Shared RAM
- Good for development/testing

## ✅ Deployment Checklist

- [x] Backend deployed to Render.com
- [x] MongoDB Atlas configured
- [x] Mobile app configured with backend URL
- [x] Logo asset fixed
- [ ] Admin panel deployed to Vercel
- [ ] Staff panel deployed to Vercel
- [ ] Seller panel deployed to Vercel
- [ ] Driver panel deployed to Vercel
- [ ] All components tested and integrated
- [ ] Role-based functionality verified

## 🎉 After Deployment

1. **Test all user flows** for each role
2. **Monitor performance** on all platforms
3. **Set up error tracking** (Sentry, LogRocket)
4. **Configure analytics** (Google Analytics)
5. **Set up backup strategy** for database
6. **Document API endpoints** for developers
7. **Create user guides** for each role
