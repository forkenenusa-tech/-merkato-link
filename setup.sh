#!/bin/bash

echo "🚀 Merkato Link Setup Script"
echo "============================="

# Check Node.js version
echo "📦 Checking Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version must be 18 or higher. Current: $(node -v)"
    exit 1
fi
echo "✅ Node.js $(node -v)"

# Check Flutter
echo "📱 Checking Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter is not installed. Mobile app setup will be skipped."
    FLUTTER_INSTALLED=false
else
    echo "✅ Flutter installed"
    FLUTTER_INSTALLED=true
fi

# Install backend dependencies
echo "📦 Setting up Backend..."
cd merkato-backend
npm install
cd ..

# Create .env files from examples
echo "⚙️  Creating environment files..."
cp merkato-backend/.env.example merkato-backend/.env 2>/dev/null || true

echo "📝 Please update the following files with your configuration:"
echo "   - merkato-backend/.env (Add your MongoDB Atlas URI)"
echo "   - merkato-mobile/.env (Set API_URL to backend URL)"

# Seed database
echo "🌱 Seeding database..."
cd merkato-backend
echo "Note: Update MONGO_URI in .env file before seeding"
echo "To seed after updating: cd merkato-backend && npm run seed"
cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the backend:"
echo "   cd merkato-backend && npm run dev"
echo ""
echo "To start admin dashboard:"
echo "   cd merkato-admin && npm run dev"
echo ""
echo "To start seller dashboard:"
echo "   cd merkato-seller && npm run dev"
echo ""
echo "To start staff dashboard:"
echo "   cd merkato-staff && npm run dev"
echo ""
echo "To start driver dashboard:"
echo "   cd merkato-driver && npm run dev"
echo ""
if [ "$FLUTTER_INSTALLED" = true ]; then
    echo "To start Flutter app:"
    echo "   cd merkato-mobile && flutter run"
fi