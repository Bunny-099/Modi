import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/music_model.dart';

class AppHiveAdapters {
  AppHiveAdapters._();

  static void register() {
    // TypeId 0 MusicModel ke liye hai
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MusicModelAdapter());
    }
  }
}