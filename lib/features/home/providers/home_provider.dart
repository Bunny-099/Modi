import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../shared/models/music_model.dart';
import '../../../../core/constants/hive_boxes.dart';
import '../../../../core/providers/app_provider.dart';

// Provider for all songs from Supabase
final allSongsProvider = FutureProvider<List<MusicModel>>((ref) async {
  final supabaseService = ref.watch(supabaseServiceProvider);
  return await supabaseService.fetchSongs();
});

// Provider for recently played songs
final recentlyPlayedProvider = Provider<List<MusicModel>>((ref) {
  try {
    final box = Hive.box<MusicModel>(HiveBoxes.musicBox);
    final recentlyPlayed = box.values
        .where((song) => song.lastPlayed != null)
        .toList()
      ..sort((a, b) => b.lastPlayed!.compareTo(a.lastPlayed!));
    
    return recentlyPlayed.take(5).toList();
  } catch (e) {
    return [];
  }
});
