import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/music_model.dart';
import '../constants/asset_paths.dart';
import '../constants/hive_boxes.dart';
import '../constants/music_category.dart';

class DefaultMusicLoader {
  DefaultMusicLoader._();

  static Future<void> loadDefaultData() async {
    final box = Hive.box<MusicModel>(HiveBoxes.musicBox);

    // clear the box to remove old dummy data
    await box.clear();

    final defaultSongs = [
      MusicModel(
        id: '1',
        title: 'Maja Nahi Aa Raha',
        artist: 'Narendra Modi',
        album: 'Speeches',
        category: MusicCategory.speech.displayName,
        coverImage: AssetPaths.modiRock,
        audioPath: AssetPaths.majaNahiAaRaha,
        duration: 5, // Just a placeholder, audio service will get actual duration
      ),
    ];

    for (var song in defaultSongs) {
      await box.put(song.id, song);
    }
  }
}
