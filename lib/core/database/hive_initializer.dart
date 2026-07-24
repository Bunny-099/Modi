import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/music_model.dart';
import '../constants/hive_boxes.dart';

class HiveInitializer {
  HiveInitializer._();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MusicModelAdapter());

    await Hive.openBox<MusicModel>(HiveBoxes.musicBox);
    await Hive.openBox(HiveBoxes.preferencesBox);
    await Hive.openBox(HiveBoxes.playbackBox);
  }
}