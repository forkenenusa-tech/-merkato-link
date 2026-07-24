import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merkato_mobile/screens/splash_screen.dart';
import 'package:merkato_mobile/theme/app_theme.dart';

void main() async {
  // Load environment variables
  // For physical device testing (TECNO KB7j): using .env which has computer IP 192.168.1.9
  // For emulator testing: use .env.emulator file instead
  await dotenv.load(fileName: ".env");
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
    );
  }
}
