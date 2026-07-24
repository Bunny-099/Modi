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
    final allSongs = ref.watch(allSongsProvider);

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
              // Recently Played section
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
                      return _buildSongCard(context, recentlyPlayed[index], ref);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Trending Section (Showing all songs for now)
              const AppText.subtitle('Trending'),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: allSongs.length,
                itemBuilder: (context, index) {
                  return _buildSongCard(context, allSongs[index], ref, isGrid: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Song Card (Used in both Horizontal and Grid)
  Widget _buildSongCard(BuildContext context, MusicModel song, WidgetRef ref, {bool isGrid = false}) {
    return GestureDetector(
      onTap: () {
        ref.read(playerProvider.notifier).playSong(song);
        context.pushNamed(RouteNames.player);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: isGrid ? double.infinity : 120,
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
          ),
          const SizedBox(height: 8),
          AppText.body(
            song.title,
            maxLines: 1,
          ),
          AppText.caption(
            song.artist,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
