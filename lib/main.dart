import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';
import 'core/database/hive_initializer.dart';
import 'core/services/logger_service.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await _initializeAppAndRun();
}

Future<void> _initializeAppAndRun() async {
  try {
    // 1. Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );

    // 2. Lock orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 3. Set transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // 4. Initialize Hive
    await HiveInitializer.init();

    // 5. Set up global error handlers for non-Flutter errors
    PlatformDispatcher.instance.onError = (error, stack) {
      LoggerService.error('Global Platform Error', error, stack);
      return true;
    };

    // 6. Run the app
    runApp(
      const ProviderScope(
        child: ModiMusicApp(),
      ),
    );
  } catch (e, stack) {
    LoggerService.error('Critical Initialization Error', e, stack);
    // Even if initialization fails, we try to run a basic error app
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: $e'),
        ),
      ),
    ));
  }
}
