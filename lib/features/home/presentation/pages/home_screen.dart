import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
                      return _buildRecentlyPlayedCard(context, recentlyPlayed[index]);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // All Songs Section
              const AppText.subtitle('All Songs'),
              const SizedBox(height: 16),

              if (allSongs.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: AppText.body('No songs found in library.'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true, // Isko true karna zaroori hai SingleChildScrollView ke andar
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: allSongs.length,
                  itemBuilder: (context, index) {
                    return _buildSongTile(context, allSongs[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for Recently Played Horizontal Cards
  Widget _buildRecentlyPlayedCard(BuildContext context, MusicModel song) {
    return GestureDetector(
      onTap: () {
        // TODO: Play song and navigate to player screen
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
                image: song.coverUrl != null
                    ? DecorationImage(
                  image: NetworkImage(song.coverUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: song.coverUrl == null
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

  // Widget for All Songs Vertical List Items
  Widget _buildSongTile(BuildContext context, MusicModel song) {
    return ListTile(
      contentPadding: const EdgeInsets.only(bottom: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          image: song.coverUrl != null
              ? DecorationImage(
            image: NetworkImage(song.coverUrl!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: song.coverUrl == null
            ? const Icon(Icons.music_note_rounded, color: AppColors.primary)
            : null,
      ),
      title: AppText.body(song.title, maxLines: 1),
      subtitle: AppText.caption(song.artist ?? 'Unknown Artist', maxLines: 1),
      trailing: IconButton(
        icon: const Icon(AppIcons.play, color: AppColors.primary),
        onPressed: () {
          // TODO: Play song
          context.pushNamed(RouteNames.player);
        },
      ),
      onTap: () {
        // TODO: Play song and navigate to player screen
        context.pushNamed(RouteNames.player);
      },
    );
  }
}