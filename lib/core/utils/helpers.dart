import 'package:flutter/material.dart';

class AppHelpers {
  // Private constructor to prevent instantiation
  AppHelpers._();

  /// Hides the on-screen keyboard safely.
  /// Call this when the user taps outside a text field (e.g., in Search).
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Shows a clean, floating Snackbar for quick messages.
  /// Set [isError] to true if you want to show a red error message.
  static void showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    // Hide any currently showing snackbar before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}