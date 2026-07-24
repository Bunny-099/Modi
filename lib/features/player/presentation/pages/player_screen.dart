import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/widgets/app_text.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Aage chal kar hum yahan Riverpod se audio player ka state watch karenge
    // Jaise current song, playing status, aur duration.

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          // Back aane ke liye down arrow, jo ek bottom sheet wali feel deta hai
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary, size: 32),
          onPressed: () => context.pop(),
        ),
        title: const AppText.subtitle('Now Playing', color: AppColors.textSecondary),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Show bottom sheet for options (Like add to playlist)
            },
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
              ),
              child: const Center(
                // Dummy Icon jab tak gaane ki image na aaye
                child: Icon(Icons.music_note_rounded, size: 80, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 40),

            // 2. Song Info (Title, Artist & Favorite Button)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      AppText.heading('Song Title Here', maxLines: 1),
                      SizedBox(height: 4),
                      AppText.body('Artist Name', color: AppColors.textSecondary, maxLines: 1),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(AppIcons.favoriteOutline, color: AppColors.primary, size: 28),
                  onPressed: () {
                    // TODO: Toggle favorite status
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Seekbar (Progress Slider)
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
                value: 0.3, // Dummy progress value (30%)
                onChanged: (value) {
                  // TODO: Seek audio
                },
              ),
            ),

            // Duration Text (e.g., 01:15 / 03:45)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                AppText.caption('01:15', color: AppColors.textSecondary),
                AppText.caption('03:45', color: AppColors.textSecondary),
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
                // Play/Pause Main Button
                Container(
                  height: 72,
                  width: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(AppIcons.play, size: 36, color: Colors.white),
                    onPressed: () {},
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