import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../shared/models/music_model.dart';
import '../../../../core/constants/hive_boxes.dart';

// Provider for all songs from the database
final allSongsProvider = Provider<List<MusicModel>>((ref) {
  final box = Hive.box<MusicModel>(HiveBoxes.musicBox);
  return box.values.toList();
});

// Provider for recently played songs
final recentlyPlayedProvider = Provider<List<MusicModel>>((ref) {
  final allSongs = ref.watch(allSongsProvider);
  // Sort by lastPlayed and limit to 5 (most recent first)
  final recentlyPlayed = allSongs
      .where((song) => song.lastPlayed != null)
      .toList()
    ..sort((a, b) => b.lastPlayed!.compareTo(a.lastPlayed!));
  
  return recentlyPlayed.take(5).toList();
});
