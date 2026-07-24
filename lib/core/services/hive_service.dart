import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/music_model.dart';
import '../constants/hive_boxes.dart';

class HiveService {
  final Box<MusicModel> _musicBox = Hive.box<MusicModel>(HiveBoxes.musicBox);

  List<MusicModel> getAllSongs() {
    return _musicBox.values.toList();
  }

  List<MusicModel> getSongsByCategory(String category) {
    return _musicBox.values.where((song) => song.category == category).toList();
  }

  List<MusicModel> getRecentlyPlayed() {
    final songs = _musicBox.values.where((song) => song.lastPlayed != null).toList();
    songs.sort((a, b) => b.lastPlayed!.compareTo(a.lastPlayed!));
    return songs.take(10).toList();
  }

  Future<void> updateSongPlayback(String id) async {
    final song = _musicBox.get(id);
    if (song != null) {
      song.playCount += 1;
      song.lastPlayed = DateTime.now();
      await song.save();
    }
  }

  Future<void> toggleFavorite(String id) async {
    final song = _musicBox.get(id);
    if (song != null) {
      song.isFavorite = !song.isFavorite;
      await song.save();
    }
  }

  List<MusicModel> searchSongs(String query) {
    final lowerQuery = query.toLowerCase();
    return _musicBox.values.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}