import 'package:flutter/widgets.dart';
import '../core/database/hive_initializer.dart';
import '../core/database/default_music_loader.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveInitializer.init();
    await DefaultMusicLoader.loadDefaultData();
  }
}