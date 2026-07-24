@echo off
echo 🚀 Merkato Link - Start All Applications
echo ========================================
echo.
echo 📝 IMPORTANT: First update your MongoDB password in:
echo    merkato-backend\.env
echo.
echo Replace: YOUR_ACTUAL_PASSWORD
echo With: your actual MongoDB Atlas password
echo.
pause

echo.
echo 🔧 Starting Backend API...
start cmd /k "cd merkato-backend && npm run dev"
timeout /t 5

echo.
echo 🖥️ Starting Admin Dashboard...
start cmd /k "cd merkato-admin && npm run dev"
timeout /t 5

echo.
echo 📊 Starting Seller Dashboard...
start cmd /k "cd merkato-seller && npm install && npm run dev"
timeout /t 2

echo.
echo 👥 Starting Staff Dashboard...
start cmd /k "cd merkato-staff && npm install && npm run dev"
timeout /t 2

echo.
echo 🚚 Starting Driver Dashboard...
start cmd /k "cd merkato-driver && npm install && npm run dev"
timeout /t 2

echo.
echo ✅ All applications starting...
echo.
echo 📍 URLs:
echo    Backend API: http://localhost:5001
echo    Admin Dashboard: http://localhost:3000
echo    Seller Dashboard: http://localhost:3001
echo    Staff Dashboard: http://localhost:3002
echo    Driver Dashboard: http://localhost:3003
echo.
echo 🔐 Default Credentials (after seeding):
echo    Admin: admin@test.com / password123
echo    Seller: seller@test.com / password123
echo    Staff: staff@test.com / password123
echo    Driver: driver@test.com / password123
echo    Customer: customer@test.com / password123
echo.
pause