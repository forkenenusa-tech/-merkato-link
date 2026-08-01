import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/screens/splash_screen.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // If .env fails to load, continue with default values
    print('Warning: Failed to load .env file: $e');
  }
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MerkatoLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      // Enhanced navigation routes
      routes: {
        // Auth routes
        '/register': (context) => const RegisterScreenEnhanced(),
        // Enhanced screens
        '/profile': (context) => const ProfileScreenEnhanced(),
        '/driver/verification': (context) => const DriverVerificationEnhanced(),
        // Customer screens
        '/customer/home': (context) => const HomeScreenEnhanced(),
        '/customer/checkout': (context) => CheckoutScreen(
          cartItems: const [],
          subtotal: 0,
          deliveryFee: 0,
          total: 0,
        ),
      },
    );
  }
}
