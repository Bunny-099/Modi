import 'package:flutter/material.dart';

class AppColors {
  // Private constructor
  AppColors._();

  // Brand Colors (As per SRD)
  static const Color primary = Color(0xFF7B61FF);
  static const Color secondary = Color(0xFFA78BFA);
  static const Color accent = Color(0xFF8B5CF6);

  // Backgrounds
  static const Color background = Color(0xFFFAFAFC);
  static const Color cardBackground = Colors.white;
  static const Color surface = cardBackground;

  // Typography
  static const Color textPrimary = Color(0xFF1D1D1D);
  static const Color textSecondary = Color(0xFF8C8C8C);

  // UI Elements & Shadows
  static const Color divider = Color(0xFFEEEEEE);
  // Very soft shadow color for cards
  static const Color shadowColor = Color(0x0D000000);

  // Status Colors (Optional but good to have)
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
}