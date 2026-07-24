import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'app_radius.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      // Material 3 use karenge modern look ke liye
      useMaterial3: true,

      // Brand Colors
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardBackground,
        error: AppColors.error,
      ),

      // Global Font Family
      fontFamily: AppTextStyle.fontFamily,

      // AppBar Theme (Flat, no elevation)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0, // Scroll karne pe shadow na aaye
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyle.heading2,
        centerTitle: false,
      ),

      // Card Theme (Base structure, shadows hum custom container se denge ya yahan set karenge)
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0, // Elevation 0 kyunki hum AppShadow use karenge custom widgets mein
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
        margin: EdgeInsets.zero,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
    );
  }
}