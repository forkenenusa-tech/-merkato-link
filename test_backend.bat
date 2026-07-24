@echo off
echo Testing backend server connection...
echo.

echo 1. Testing localhost:5001...
curl -s -o nul -w "%%{http_code}" http://localhost:5001/api/health
if errorlevel 1 (
  echo ❌ Cannot connect to localhost:5001
) else (
  echo ✓ Backend is running on localhost:5001
)

echo.
echo 2. Testing 192.168.1.9:5001 (your computer IP)...
curl -s -o nul -w "%%{http_code}" http://192.168.1.9:5001/api/health
if errorlevel 1 (
  echo ❌ Cannot connect to 192.168.1.9:5001
  echo   This means your mobile app won't be able to connect either
  echo   Make sure your Windows Firewall allows connections on port 5001
) else (
  echo ✓ Backend is accessible at 192.168.1.9:5001
)

echo.
echo Note: If you see ❌ for both, your backend server might not be running.
echo Run in merkato-backend directory: npm run dev