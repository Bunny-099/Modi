import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  // SRD Specific Radii (20-24)
  static const double card = 24.0;
  static const double image = 20.0;

  // Standard Radii for other elements like buttons, chips, etc.
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;

  // Pre-defined BorderRadius objects for direct use in Widgets
  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get imageRadius => BorderRadius.circular(image);
  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get circular => BorderRadius.circular(999.0); // For perfect circles
}