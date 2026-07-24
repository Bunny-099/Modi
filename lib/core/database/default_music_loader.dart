import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/music_model.dart';
import '../constants/asset_paths.dart';
import '../constants/hive_boxes.dart';
import '../constants/music_category.dart';

class DefaultMusicLoader {
  DefaultMusicLoader._();

  static Future<void> loadDefaultData() async {
    final box = Hive.box<MusicModel>(HiveBoxes.musicBox);

    if (box.isEmpty) {
      final defaultSongs = [
        MusicModel(
          id: '1',
          title: 'Welcome Speech',
          artist: 'Narendra Modi',
          album: 'Speeches',
          category: MusicCategory.speech.displayName,
          coverImage: AssetPaths.defaultAlbumArt,
          audioPath: AssetPaths.welcomeAudio,
          duration: 180,
        ),
        MusicModel(
          id: '2',
          title: 'Patriotic Anthem',
          artist: 'Various Artists',
          album: 'Desh Bhakti',
          category: MusicCategory.patriotic.displayName,
          coverImage: AssetPaths.defaultAlbumArt,
          audioPath: '${AssetPaths.songsDir}patriotic_1.mp3',
          duration: 210,
        ),
        MusicModel(
          id: '3',
          title: 'Morning Bhajan',
          artist: 'Traditional',
          album: 'Devotional',
          category: MusicCategory.bhajan.displayName,
          coverImage: AssetPaths.defaultAlbumArt,
          audioPath: '${AssetPaths.songsDir}bhajan_1.mp3',
          duration: 320,
        ),
      ];

      for (var song in defaultSongs) {
        await box.put(song.id, song);
      }
    }
  }
}