import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../player/providers/player_provider.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../shared/models/music_model.dart';
import '../../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayed = ref.watch(recentlyPlayedProvider);
    final allSongsAsync = ref.watch(allSongsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(allSongsProvider.future),
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // --- SaaS-Style Minimal Header ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.caption('OVERVIEW', color: AppColors.textSecondary),
                          const SizedBox(height: 4),
                          const AppText.heading('Library Dashboard', color: AppColors.textPrimary),
                        ],
                      ),
                      // Sleek Search Button (Dashboard action style)
                      InkWell(
                        onTap: () => context.pushNamed(RouteNames.search),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Row(
                            children: [
                              const Icon(AppIcons.search, size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              AppText.caption('Search...', color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 1. HERO SPOTLIGHT BANNER (SaaS Feature Card) ---
              allSongsAsync.when(
                data: (allSongs) {
                  if (allSongs.isEmpty) return const SliverToBoxAdapter(child: SizedBox());
                  final featuredSong = allSongs.first;
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: _buildHeroBanner(context, ref, featuredSong, allSongs),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(child: SizedBox()),
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
              ),

              // --- 2. RECENTLY PLAYED (Compact SaaS Module Cards) ---
              if (recentlyPlayed.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText.subtitle('Quick Access'),
                        AppText.caption('${recentlyPlayed.length} items', color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 64,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: recentlyPlayed.length,
                      itemBuilder: (context, index) {
                        return _buildQuickAccessCard(
                          context,
                          recentlyPlayed[index],
                          ref,
                          recentlyPlayed,
                        );
                      },
                    ),
                  ),
                ),
              ],

              // --- 3. TRENDING (SaaS Table / Ranked Row View) ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText.subtitle('Trending Tracks'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const AppText.caption('LIVE', color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),

              allSongsAsync.when(
                data: (allSongs) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final song = allSongs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                        child: _buildSizedTableRow(
                          context,
                          song,
                          index + 1,
                          ref,
                          allSongs,
                        ),
                      );
                    },
                    childCount: allSongs.length,
                  ),
                ),
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  ),
                ),
                error: (err, _) => SliverToBoxAdapter(
                  child: AppErrorWidget(
                    message: err.toString(),
                    onRetry: () => ref.refresh(allSongsProvider),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget: Hero Banner (Featured Song) ---
  Widget _buildHeroBanner(
      BuildContext context,
      WidgetRef ref,
      MusicModel song,
      List<MusicModel> playlist,
      ) {
    return GestureDetector(
      onTap: () {
        ref.read(playerProvider.notifier).playSong(song, playlist: playlist);
        context.pushNamed(RouteNames.player);
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.surface,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          image: song.coverImage.isNotEmpty
              ? DecorationImage(
            image: song.coverImage.startsWith('http')
                ? NetworkImage(song.coverImage) as ImageProvider
                : AssetImage(song.coverImage),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.65),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const AppText.caption('FEATURED TRACK', color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.heading(song.title, color: Colors.white),
                      const SizedBox(height: 4),
                      AppText.caption(song.artist, color: Colors.white70),
                    ],
                  ),
                ),
                Container(
                  height: 44,
                  width: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 28),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: Compact Quick Access Pill Card ---
  Widget _buildQuickAccessCard(
      BuildContext context,
      MusicModel song,
      WidgetRef ref,
      List<MusicModel> playlist,
      ) {
    return GestureDetector(
      onTap: () {
        ref.read(playerProvider.notifier).playSong(song, playlist: playlist);
        context.pushNamed(RouteNames.player);
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: song.coverImage.isNotEmpty
                  ? Image(
                image: song.coverImage.startsWith('http')
                    ? NetworkImage(song.coverImage) as ImageProvider
                    : AssetImage(song.coverImage),
                width: 46,
                height: 46,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 46,
                height: 46,
                color: AppColors.primary.withOpacity(0.1),
                child: const Icon(Icons.music_note, color: AppColors.primary, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText.body(song.title, maxLines: 1),
                  const SizedBox(height: 2),
                  AppText.caption(song.artist, color: AppColors.textSecondary, maxLines: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget: High-Density Table Row (SaaS Style) ---
  Widget _buildSizedTableRow(
      BuildContext context,
      MusicModel song,
      int rank,
      WidgetRef ref,
      List<MusicModel> playlist,
      ) {
    final isTopThree = rank <= 3;

    return InkWell(
      onTap: () {
        ref.read(playerProvider.notifier).playSong(song, playlist: playlist);
        context.pushNamed(RouteNames.player);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Row(
          children: [
            // Index Number
            SizedBox(
              width: 28,
              child: AppText.caption(
                rank < 10 ? '0$rank' : '$rank',
                color: isTopThree ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            // Cover Image Small
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: song.coverImage.isNotEmpty
                  ? Image(
                image: song.coverImage.startsWith('http')
                    ? NetworkImage(song.coverImage) as ImageProvider
                    : AssetImage(song.coverImage),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 40,
                height: 40,
                color: AppColors.surface,
                child: const Icon(Icons.music_note, color: AppColors.textSecondary, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.body(song.title, maxLines: 1),
                  const SizedBox(height: 2),
                  AppText.caption(song.artist, color: AppColors.textSecondary, maxLines: 1),
                ],
              ),
            ),
            // Play Icon Minimal
            Icon(
              Icons.play_circle_outline_rounded,
              color: AppColors.textSecondary.withOpacity(0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}