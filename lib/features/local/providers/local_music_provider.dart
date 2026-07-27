import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../shared/models/music_model.dart';

final localMusicProvider = StateNotifierProvider<LocalMusicNotifier, AsyncValue<List<MusicModel>>>((ref) {
  return LocalMusicNotifier();
});

class LocalMusicNotifier extends StateNotifier<AsyncValue<List<MusicModel>>> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  LocalMusicNotifier() : super(const AsyncValue.loading()) {
    fetchLocalSongs();
  }

  Future<void> fetchLocalSongs() async {
    state = const AsyncValue.loading();
    try {
      // Permission check
      final status = await Permission.audio.request();
      
      if (status.isGranted) {
        final List<SongModel> songs = await _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        );

        final List<MusicModel> musicList = songs.map((song) => MusicModel(
          id: song.id.toString(),
          title: song.title,
          artist: song.artist ?? 'Unknown',
          album: song.album ?? 'Unknown',
          category: 'Local',
          coverImage: '', // Will handle artwork separately or via placeholder
          audioPath: song.uri ?? '',
          duration: (song.duration ?? 0) ~/ 1000,
        )).toList();

        state = AsyncValue.data(musicList);
      } else {
        state = AsyncValue.error('Permission denied', StackTrace.current);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
