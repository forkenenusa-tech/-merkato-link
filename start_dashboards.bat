@echo off
echo 🚀 Starting All Merkato Link Dashboards
echo ======================================
echo.
echo 📍 Starting on ports:
echo   3000 - Admin Dashboard (Already running)
echo   3001 - Seller Dashboard
echo   3002 - Staff Dashboard  
echo   3003 - Driver Dashboard
echo.
echo ⏳ Installing dependencies and starting...
echo.

echo 🏪 Starting Seller Dashboard...
start cmd /k "cd merkato-seller && npm install && npm run dev"
timeout /t 10

echo 👥 Starting Staff Dashboard...
start cmd /k "cd merkato-staff && npm install && npm run dev"
timeout /t 10

echo 🚚 Starting Driver Dashboard...
start cmd /k "cd merkato-driver && npm install && npm run dev"
timeout /t 10

echo.
echo ✅ All dashboards starting...
echo.
echo 📍 Access URLs:
echo   Admin:    http://localhost:3000
echo   Seller:   http://localhost:3001
echo   Staff:    http://localhost:3002
echo   Driver:   http://localhost:3003
echo   Backend:  http://localhost:5001
echo.
echo 🔐 Demo Credentials:
echo   Admin: admin@test.com / password123
echo   Seller: seller@test.com / password123
echo   Staff: staff@test.com / password123
echo   Driver: driver@test.com / password123
echo.
echo 🎨 Features:
echo   • Beautiful modern UI
echo   • Responsive design
echo   • Glassmorphism effects
echo   • Gradient backgrounds
echo   • Interactive components
echo.
pause