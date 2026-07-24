@echo off
echo 🚀 Merkato Link Setup Script
echo =============================

REM Check Node.js version
echo 📦 Checking Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js 18+
    pause
    exit /b 1
)

for /f "tokens=2 delims=v" %%i in ('node --version') do set NODE_VERSION=%%i
for /f "tokens=1 delims=." %%i in ("%NODE_VERSION%") do set NODE_MAJOR=%%i

if %NODE_MAJOR% LSS 18 (
    echo ❌ Node.js version must be 18 or higher. Current: %NODE_VERSION%
    pause
    exit /b 1
)
echo ✅ Node.js %NODE_VERSION%

REM Check Flutter
echo 📱 Checking Flutter...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Flutter is not installed. Mobile app setup will be skipped.
    set FLUTTER_INSTALLED=false
) else (
    echo ✅ Flutter installed
    set FLUTTER_INSTALLED=true
)

REM Install backend dependencies
echo 📦 Setting up Backend...
cd merkato-backend
call npm install
cd ..

REM Create .env files from examples
echo ⚙️  Creating environment files...
copy merkato-backend\.env.example merkato-backend\.env >nul 2>&1

echo 📝 Please update the following files with your configuration:
echo    - merkato-backend\.env ^(Add your MongoDB Atlas URI^)
echo    - merkato-mobile\.env ^(Set API_URL to backend URL^)

echo.
echo ✅ Setup complete!
echo.
echo To start the backend:
echo    cd merkato-backend ^&^& npm run dev
echo.
echo To start admin dashboard:
echo    cd merkato-admin ^&^& npm run dev
echo.
echo To start seller dashboard:
echo    cd merkato-seller ^&^& npm run dev
echo.
echo To start staff dashboard:
echo    cd merkato-staff ^&^& npm run dev
echo.
echo To start driver dashboard:
echo    cd merkato-driver ^&^& npm run dev
echo.
if "%FLUTTER_INSTALLED%"=="true" (
    echo To start Flutter app:
    echo    cd merkato-mobile ^&^& flutter run
)

pause