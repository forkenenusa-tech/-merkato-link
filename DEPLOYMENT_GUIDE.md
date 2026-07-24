# Merkato Link Deployment Guide

This guide will help you deploy all components of the Merkato Link platform to free hosting services.

## Prerequisites
- GitHub account with repository: https://github.com/forkenenusa-tech/-merkato-link.git
- MongoDB Atlas account (free tier)
- Render.com account (free tier)
- Vercel account (free tier)

## 1. Backend Deployment (Render.com)

### Step 1: Set up MongoDB Atlas
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account
3. Create a new cluster (free M0 tier)
4. Create database user with username/password
5. Network Access → Add IP Address → 0.0.0.0/0 (allow all IPs)
6. Get connection string: `mongodb+srv://username:password@cluster.mongodb.net/merkato`

### Step 2: Deploy Backend to Render
1. Go to [Render.com](https://render.com)
2. Create a free account
3. Click "New +" → "Web Service"
4. Connect GitHub repository: `forkenenusa-tech/-merkato-link`
5. Configure:
   - **Name**: merkato-backend
   - **Root Directory**: `merkato-backend`
   - **Build Command**: `npm install && npm run build`
   - **Start Command**: `npm start`
6. Add Environment Variables:
   - `MONGO_URI`: Your MongoDB Atlas connection string
   - `JWT_SECRET`: Generate a random secret (use: https://www.random.org/strings/)
   - `NODE_ENV`: `production`
   - `CLIENT_URL`: `*`
   - `PORT`: `5000`
7. Click "Deploy Web Service"

### Step 3: Get Backend URL
After deployment, Render will provide a URL like:
```
https://merkato-backend.onrender.com
```

## 2. Frontend Deployments (Vercel)

### Admin Panel Deployment
1. Go to [Vercel](https://vercel.com)
2. Create a free account
3. Click "Add New Project"
4. Import GitHub repository: `forkenenusa-tech/-merkato-link`
5. Configure:
   - **Root Directory**: `merkato-admin`
   - **Framework Preset**: Vite
6. Add Environment Variables:
   - `VITE_API_URL`: Your Render backend URL
7. Click "Deploy"

### Staff Panel Deployment
1. In Vercel, click "Add New Project"
2. Import same GitHub repository
3. Configure:
   - **Root Directory**: `merkato-staff`
   - **Framework Preset**: Vite
4. Add Environment Variables:
   - `VITE_API_URL`: Your Render backend URL
5. Click "Deploy"

### Seller Panel Deployment
1. In Vercel, click "Add New Project"
2. Import same GitHub repository
3. Configure:
   - **Root Directory**: `merkato-seller`
   - **Framework Preset**: Vite
4. Add Environment Variables:
   - `VITE_API_URL`: Your Render backend URL
5. Click "Deploy"

## 3. Mobile App Configuration

### Update API URL
1. Edit `merkato-mobile/lib/services/api_service.dart`
2. Change the baseUrl from `http://127.0.0.1:5001` to your Render backend URL:
```dart
baseUrl: dotenv.env['API_URL'] ?? 'https://merkato-backend.onrender.com',
```

3. Update `merkato-mobile/.env`:
```
API_URL=https://merkato-backend.onrender.com
```

### Build and Deploy Mobile App
For web deployment:
```bash
cd merkato-mobile
flutter build web
```

For mobile deployment, you'll need to:
- Android: Upload APK to Google Play Store
- iOS: Upload IPA to Apple App Store

## 4. Testing Integration

### Test Backend
```bash
curl https://merkato-backend.onrender.com/api/health
```

### Test Frontend
- Admin: Open your Vercel admin URL
- Staff: Open your Vercel staff URL  
- Seller: Open your Vercel seller URL

### Test Mobile App
1. Run mobile app with new API URL
2. Test registration/login
3. Test customer features
4. Test seller features

## 5. Environment Variables Summary

### Backend (Render.com)
- `MONGO_URI`: MongoDB Atlas connection string
- `JWT_SECRET`: Random secret key
- `NODE_ENV`: `production`
- `CLIENT_URL`: `*`
- `PORT`: `5000`

### Frontends (Vercel)
- `VITE_API_URL`: Render backend URL

### Mobile App
- `API_URL`: Render backend URL

## 6. Troubleshooting

### Backend Issues
- Check Render logs for errors
- Verify MongoDB Atlas connection
- Ensure IP whitelist includes 0.0.0.0/0

### Frontend Issues
- Check Vercel deployment logs
- Verify VITE_API_URL is correct
- Clear browser cache

### Mobile App Issues
- Verify API_URL in .env file
- Check network connectivity
- Test API endpoints with curl

## 7. Free Tier Limitations

### Render.com
- Free tier: 750 hours/month
- Sleeps after 15 minutes of inactivity
- Cold starts may take 30-60 seconds

### Vercel
- Free tier: 100GB bandwidth/month
- Unlimited deployments
- Automatic SSL certificates

### MongoDB Atlas
- Free tier: 512MB storage
- Shared RAM
- Good for development/testing

## 8. Next Steps

After deployment:
1. Test all user flows
2. Monitor performance
3. Set up error tracking
4. Configure analytics
5. Set up backup strategy
