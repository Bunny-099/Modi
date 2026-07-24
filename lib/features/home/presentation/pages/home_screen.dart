import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../player/providers/player_provider.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../shared/models/music_model.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Providers se data watch kar rahe hain
    final recentlyPlayed = ref.watch(recentlyPlayedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const AppText.heading('Modi Ji ', color: AppColors.primary),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.search, color: AppColors.textPrimary),
            onPressed: () => context.pushNamed(RouteNames.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Agar recently played list khali nahi hai, tabhi yeh section dikhega
              if (recentlyPlayed.isNotEmpty) ...[
                const AppText.subtitle('Recently Played'),
                const SizedBox(height: 16),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: recentlyPlayed.length,
                    itemBuilder: (context, index) {
                      return _buildRecentlyPlayedCard(context, recentlyPlayed[index], ref);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Recently Played Horizontal Cards
  Widget _buildRecentlyPlayedCard(BuildContext context, MusicModel song, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(playerProvider.notifier).playSong(song);
        context.pushNamed(RouteNames.player);
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                image: song.coverImage.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(song.coverImage),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: song.coverImage.isEmpty
                  ? const Icon(Icons.music_note_rounded, size: 40, color: AppColors.primary)
                  : null,
            ),
            const SizedBox(height: 8),
            AppText.body(
              song.title,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
