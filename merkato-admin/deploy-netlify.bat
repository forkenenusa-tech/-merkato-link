@echo off
echo ==================================================
echo 🚀 Merkato Link Admin Portal - Netlify Deployment
echo ==================================================

REM Check if node_modules exists
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    call npm install
)

REM Build the project
echo 🔨 Building project...
call npm run build

REM Check if build succeeded
if %errorlevel% equ 0 (
    echo ✅ Build successful!
    echo.
    echo 📁 Build output is in: dist/
    echo.
    echo 📋 Next steps:
    echo 1. Go to https://app.netlify.com
    echo 2. Click 'Add new site' → 'Import an existing project'
    echo 3. Connect your GitHub repository
    echo 4. Configure:
    echo    - Base directory: merkato-admin
    echo    - Build command: npm run build
    echo    - Publish directory: dist
    echo 5. Add environment variables:
    echo    - VITE_API_URL = https://merkato-link.onrender.com
    echo    - VITE_JWT_SECRET = your-jwt-secret-key-here
    echo    - VITE_ADMIN_EMAIL = admin@merkato.link
    echo    - VITE_ADMIN_PASSWORD = admin123
    echo 6. Click 'Deploy site'
    echo.
    echo 📚 Full guide in: ../NETLIFY_DEPLOYMENT_GUIDE.md
) else (
    echo ❌ Build failed. Check the errors above.
    exit /b 1
)

pause