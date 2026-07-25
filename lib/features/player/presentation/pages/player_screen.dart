import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/widgets/app_text.dart';
import '../../providers/player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final playerNotifier = ref.read(playerProvider.notifier);
    final song = playerState.currentSong;

    if (song == null) {
      return const Scaffold(
        body: Center(child: AppText.body('No song selected')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary, size: 32),
          onPressed: () => context.pop(),
        ),
        title: const AppText.subtitle('Now Playing', color: AppColors.textSecondary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Album Art Box
            Container(
              height: MediaQuery.of(context).size.width - 48,
              width: MediaQuery.of(context).size.width - 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                image: song.coverImage.isNotEmpty
                    ? DecorationImage(
                        image: song.coverImage.startsWith('http')
                            ? NetworkImage(song.coverImage) as ImageProvider
                            : AssetImage(song.coverImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: song.coverImage.isEmpty
                  ? const Center(
                      child: Icon(Icons.music_note_rounded, size: 80, color: AppColors.primary),
                    )
                  : null,
            ),
            const SizedBox(height: 40),

            // 2. Song Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.heading(song.title, maxLines: 1),
                      const SizedBox(height: 4),
                      AppText.body(song.artist ?? 'Unknown Artist', color: AppColors.textSecondary, maxLines: 1),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    song.isFavorite ? AppIcons.favorite : AppIcons.favoriteOutline,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  onPressed: () {
                    // TODO: Toggle favorite status in Hive
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Seekbar
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.surface,
                thumbColor: AppColors.primary,
                trackHeight: 4.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
              ),
              child: Slider(
                value: playerState.position.inMilliseconds.toDouble().clamp(
                  0.0,
                  playerState.duration.inMilliseconds.toDouble(),
                ),
                max: playerState.duration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  playerNotifier.seek(Duration(milliseconds: value.toInt()));
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.caption(_formatDuration(playerState.position), color: AppColors.textSecondary),
                AppText.caption(_formatDuration(playerState.duration), color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 32),

            // 4. Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle_rounded, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(AppIcons.skipPrevious, size: 36, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
                Container(
                  height: 72,
                  width: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      playerState.isPlaying ? AppIcons.pause : AppIcons.play,
                      size: 36,
                      color: Colors.white,
                    ),
                    onPressed: () => playerNotifier.togglePlayPause(),
                  ),
                ),
                IconButton(
                  icon: const Icon(AppIcons.skipNext, size: 36, color: AppColors.textPrimary),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.repeat_rounded, color: AppColors.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
