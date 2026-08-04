import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/music_model.dart';

class PlayerState {
  final MusicModel? currentSong;
  final List<MusicModel> playlist;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final LoopMode loopMode;
  final bool isShuffleEnabled;

  PlayerState({
    this.currentSong,
    this.playlist = const [],
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.loopMode = LoopMode.off,
    this.isShuffleEnabled = false,
  });

  PlayerState copyWith({
    MusicModel? currentSong,
    List<MusicModel>? playlist,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    LoopMode? loopMode,
    bool? isShuffleEnabled,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      playlist: playlist ?? this.playlist,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      loopMode: loopMode ?? this.loopMode,
      isShuffleEnabled: isShuffleEnabled ?? this.isShuffleEnabled,
    );
  }
}

class PlayerNotifier extends StateNotifier<PlayerState> {
  final Ref ref;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _playingSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _loopModeSubscription;
  StreamSubscription? _shuffleModeSubscription;

  PlayerNotifier(this.ref) : super(PlayerState()) {
    final audioService = ref.read(audioPlayerServiceProvider);

    _positionSubscription = audioService.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _durationSubscription = audioService.durationStream.listen((dur) {
      if (dur != null) {
        state = state.copyWith(duration: dur);
      }
    });

    _playingSubscription = audioService.playingStream.listen((playing) {
      state = state.copyWith(isPlaying: playing);
    });

    _loopModeSubscription = audioService.loopModeStream.listen((loopMode) {
      state = state.copyWith(loopMode: loopMode);
    });

    _shuffleModeSubscription = audioService.shuffleModeEnabledStream.listen((enabled) {
      state = state.copyWith(isShuffleEnabled: enabled);
    });

    _playerStateSubscription = audioService.playerStateStream.listen((audioState) {
      if (audioState.processingState == ProcessingState.completed) {
        skipToNext();
      }
    });
  }

  Future<void> playSong(MusicModel song, {List<MusicModel>? playlist}) async {
    final audioService = ref.read(audioPlayerServiceProvider);

    if (state.currentSong?.id == song.id) {
      if (state.isPlaying) {
        await audioService.pause();
      } else {
        await audioService.play();
      }
      return;
    }

    state = state.copyWith(
      currentSong: song,
      playlist: playlist,
      position: Duration.zero,
      duration: Duration.zero,
    );
    
    try {
      await audioService.loadAudio(song.audioPath);
      await audioService.play();
      
      // Update last played in Hive if it's not a local song (or handle local songs differently)
      if (song.category != 'Local') {
        song.lastPlayed = DateTime.now();
        song.playCount++;
        await song.save();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> skipToNext() async {
    if (state.playlist.isEmpty || state.currentSong == null) return;

    final currentIndex = state.playlist.indexWhere((s) => s.id == state.currentSong!.id);
    if (currentIndex != -1 && currentIndex < state.playlist.length - 1) {
      await playSong(state.playlist[currentIndex + 1], playlist: state.playlist);
    } else {
      // End of playlist - stop or loop
      final audioService = ref.read(audioPlayerServiceProvider);
      await audioService.pause();
      await audioService.seek(Duration.zero);
    }
  }

  Future<void> skipToPrevious() async {
    if (state.playlist.isEmpty || state.currentSong == null) return;

    final currentIndex = state.playlist.indexWhere((s) => s.id == state.currentSong!.id);
    if (currentIndex > 0) {
      await playSong(state.playlist[currentIndex - 1], playlist: state.playlist);
    } else {
      // Start of playlist - just seek to beginning
      await seek(Duration.zero);
    }
  }

  Future<void> togglePlayPause() async {
    final audioService = ref.read(audioPlayerServiceProvider);
    if (state.isPlaying) {
      await audioService.pause();
    } else {
      await audioService.play();
    }
  }

  Future<void> seek(Duration position) async {
    final audioService = ref.read(audioPlayerServiceProvider);
    await audioService.seek(position);
  }

  Future<void> toggleRepeatMode() async {
    final audioService = ref.read(audioPlayerServiceProvider);
    final currentMode = state.loopMode;
    LoopMode nextMode;
    
    switch (currentMode) {
      case LoopMode.off:
        nextMode = LoopMode.all;
        break;
      case LoopMode.all:
        nextMode = LoopMode.one;
        break;
      case LoopMode.one:
        nextMode = LoopMode.off;
        break;
    }
    
    await audioService.setLoopMode(nextMode);
  }

  Future<void> toggleShuffle() async {
    final audioService = ref.read(audioPlayerServiceProvider);
    await audioService.setShuffleModeEnabled(!state.isShuffleEnabled);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playingSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _loopModeSubscription?.cancel();
    _shuffleModeSubscription?.cancel();
    super.dispose();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerState>((ref) {
  return PlayerNotifier(ref);
});
