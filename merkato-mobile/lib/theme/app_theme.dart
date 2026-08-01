import 'package:flutter/material.dart';

class AppColors {
  static const primaryGreen = Color(0xFF004D33);
  static const accentGreen = Color(0xFF009A49);
  static const lightGreen = Color(0xFFE8F5EE);
  static const gold = Color(0xFFF4A900);
  static const goldLight = Color(0xFFFFF8E7);
  static const errorRed = Color(0xFFE63946);
  static const successGreen = Color(0xFF4CAF50);
  static const warningYellow = Color(0xFFFFC107);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF757575);
  static const borderGrey = Color(0xFFE0E0E0);
  static const background = Color(0xFFF5F5F5);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryGreen,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        primary: AppColors.primaryGreen,
        secondary: AppColors.gold,
        error: AppColors.errorRed,
      ),
      fontFamily: 'Poppins',
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
