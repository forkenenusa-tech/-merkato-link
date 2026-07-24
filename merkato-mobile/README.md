# Merkato Link - Flutter Mobile App

Merkato Link customer mobile application for Android and iOS.

## Features
- User registration and authentication
- Browse products by category
- Add to cart and checkout
- Order tracking with static maps
- User profile management

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (>= 3.0.0)
- Android Studio or VS Code with Flutter extension
- Physical device or emulator

### 2. Installation
```bash
flutter pub get
```

### 3. Configuration
Update the `.env` file with your backend API URL:
```env
API_URL=http://localhost:5000
# or
API_URL=https://your-backend-url.herokuapp.com
```

### 4. Run the App
```bash
# For Android
flutter run

# For iOS (Mac only)
flutter run -d iPhone
```

### 5. Build Release
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (Mac only)
flutter build ios --release
```

## Project Structure
```
lib/
├── main.dart          # App entry point
├── screens/           # All screen widgets
│   ├── auth/          # Authentication screens
│   └── home_screen.dart
├── widgets/           # Reusable widgets
├── services/          # API services
├── providers/         # Riverpod providers
└── models/            # Data models
```

## Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `google_maps_flutter`: Maps integration
- `cached_network_image`: Image caching
- `shared_preferences`: Local storage
- `carousel_slider`: Image carousel

## Development Notes
- Uses Riverpod for state management
- Follows Material Design guidelines
- Responsive layout for all screen sizes
- Dark mode support available
- Internationalization ready

## Testing
```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

## Deployment
1. Update version in `pubspec.yaml`
2. Generate app icons
3. Configure signing keys
4. Build release versions
5. Submit to app stores

## Demo Credentials
- Email: customer@test.com
- Password: password123