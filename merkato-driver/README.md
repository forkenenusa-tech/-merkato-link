# 🚚 Merkato Link - Driver Dashboard

## 📋 Overview
A beautiful, modern dashboard for delivery drivers to manage their deliveries, track earnings, and update their status in real-time.

## 🎨 UI Design Features
- **Theme:** Orange/Amber gradient theme
- **Glassmorphism effects** on cards and components
- **Responsive design** for mobile and desktop
- **Animated transitions** and hover states
- **Clean typography** with Inter font
- **Real-time status indicators**
- **Interactive map integration** (placeholder)

## 🚀 Features

### **Dashboard**
- Real-time delivery statistics
- Earnings overview
- Active delivery tracking
- Performance metrics
- Quick action buttons

### **Active Deliveries**
- Delivery details and customer info
- Pickup & dropoff locations
- Navigation assistance
- Status updates
- Contact customer functionality

### **Delivery History**
- Past delivery records
- Earnings breakdown
- Customer ratings
- Performance analytics
- Export functionality

### **Profile Management**
- Driver information
- Vehicle details
- License verification
- Account settings
- Notification preferences

## 🛠️ Technical Stack
- **Frontend:** React + TypeScript + Vite
- **Styling:** Tailwind CSS
- **Icons:** Lucide React
- **Charts:** Recharts
- **Maps:** Leaflet + React Leaflet (placeholder)
- **HTTP Client:** Axios
- **Routing:** React Router DOM

## 📦 Installation

### **1. Install Dependencies**
```bash
npm install
```

### **2. Run Development Server**
```bash
npm run dev
```

### **3. Build for Production**
```bash
npm run build
```

### **4. Preview Production Build**
```bash
npm run preview
```

## 🔧 Configuration

### **Environment Variables**
Create a `.env` file in the root directory:
```env
VITE_API_URL=http://localhost:5001/api
```

### **Port Configuration**
Default port: **3003**
Modify in `vite.config.ts`:
```typescript
server: {
  port: 3003,
}
```

## 🔗 API Integration

The dashboard connects to the Merkato Link backend API. All API endpoints are defined in `src/services/api.ts`.

### **Authentication**
```typescript
// Login
driverAPI.login({ email: 'driver@test.com', password: 'password123' })

// Get profile
driverAPI.getProfile()
```

### **Deliveries**
```typescript
// Get active deliveries
driverAPI.getActiveDeliveries()

// Update delivery status
driverAPI.updateDeliveryStatus('DEL-001', 'delivered')
```

### **Earnings**
```typescript
// Get earnings by period
driverAPI.getEarnings('weekly')

// Get driver stats
driverAPI.getStats()
```

## 📱 Pages

### **1. Dashboard (`/`)**
Main dashboard with overview statistics and quick actions.

### **2. Active Deliveries (`/deliveries`)**
Manage current deliveries with navigation and status updates.

### **3. Delivery History (`/history`)**
View past deliveries and earnings history.

### **4. Profile (`/profile`)**
Manage driver profile and account settings.

### **5. Login (`/login`)**
Driver authentication page.

## 🎯 Demo Credentials
```
Email: driver@test.com
Password: password123
```

## 🚀 Running the Complete System

### **Required Services:**
1. **Backend API:** Running on port 5001
2. **MongoDB Atlas:** Connected via backend

### **Start Order:**
1. Start backend server
2. Start driver dashboard
3. Open http://localhost:3003

## 📄 Project Structure
```
merkato-driver/
├── src/
│   ├── components/     # Reusable components
│   ├── pages/         # Page components
│   ├── services/      # API services
│   ├── App.tsx        # Main app component
│   ├── main.tsx       # Entry point
│   └── index.css      # Global styles
├── public/            # Static assets
├── index.html         # HTML template
├── vite.config.ts     # Vite configuration
├── tailwind.config.js # Tailwind configuration
├── tsconfig.json      # TypeScript configuration
└── package.json       # Dependencies
```

## 🎨 Customization

### **Theming**
Modify colors in `tailwind.config.js`:
```javascript
colors: {
  primary: '#FF6B35',
  secondary: '#FFA726',
  accent: '#43A047',
}
```

### **Components**
All components use Tailwind CSS utility classes for easy customization.

## 🔍 Development Notes

### **State Management**
- Uses React hooks for local state
- API calls via Axios with interceptors
- Token-based authentication

### **Responsive Design**
- Mobile-first approach
- Breakpoints: sm (640px), md (768px), lg (1024px), xl (1280px)
- Flexible grid layouts

### **Performance**
- Code splitting via React Router
- Lazy loading for components
- Optimized bundle size with Vite

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## 📄 License
Proprietary - Merkato Link Marketplace System

## 🆘 Support
For issues and questions, contact the development team.

---

**Built with ❤️ for Ethiopian Marketplace Delivery Partners**