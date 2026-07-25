import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/database/hive_initializer.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Supabase first
  await Supabase.initialize(
    url: 'https://fxpgyrstmtlmtjvtjtql.supabase.co',
    anonKey: 'sb_publishable_UqH2Hl1-CWLqXYCYUeMPHg_NYxJdyRJ',
  );

  // Lock orientation to portrait for a consistent UI experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set transparent status bar for a clean, modern aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive and register adapters before running the app
  await HiveInitializer.init();

  // Run the app wrapped in ProviderScope for Riverpod state management
  runApp(
    const ProviderScope(
      child: ModiMusicApp(),
    ),
  );
}
