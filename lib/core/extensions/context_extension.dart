import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  // --- Theme Extensions ---
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  // --- Screen Size / MediaQuery Extensions ---
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;

  // Width aur Height direct nikalne ke liye
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  // Safe area padding (Notch aur bottom bar se bachne ke liye)
  EdgeInsets get padding => mediaQuery.padding;

  // Keyboard open hai ya nahi check karne ke liye (Search screen pe kaam aayega)
  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
}