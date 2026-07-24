import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteGuard {
  RouteGuard._();

  static String? guard(BuildContext context, GoRouterState state) {
    // Yahan future mein aap onboarding ya auth ki condition laga sakte hain.
    // Abhi ke liye hum null return kar rahe hain jiska matlab hai "continue normal routing".
    return null;
  }
}