import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadow {
  AppShadow._();

  // SRD requirement: Very Soft, Almost Flat shadow for main cards
  static List<BoxShadow> get softCardShadow => [
    BoxShadow(
      color: AppColors.shadowColor,
      offset: const Offset(0, 4), // Halki si neeche ki taraf shadow
      blurRadius: 16, // Wide aur soft blur
      spreadRadius: 0, // Spread 0 rakhna h taaki flat lage
    ),
  ];

  // Mini player ya bottom sheets ke liye floating shadow (halki upward shadow)
  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: AppColors.shadowColor.withOpacity(0.08), // Thodi si dark float effect ke liye
      offset: const Offset(0, -4), // Upar ki taraf shadow
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // Image ya artwork ke piche dene ke liye soft glow effect
  static List<BoxShadow> get artworkShadow => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.15), // Primary color ki soft tint
      offset: const Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -4, // Tighter shadow
    ),
  ];
}