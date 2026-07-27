import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../home/providers/home_provider.dart';
import '../../../player/providers/player_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSongsAsync = ref.watch(allSongsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const AppText.heading('Your Library', color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.search, color: AppColors.textPrimary),
            onPressed: () => context.pushNamed(RouteNames.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: [
                Tab(text: 'Playlists'),
                Tab(text: 'Favorites'),
                Tab(text: 'All Songs'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPlaylistsTab(),
                  _buildFavoritesTab(),
                  // 3. All Songs Tab with Async Handling
                  allSongsAsync.when(
                    data: (allSongs) => RefreshIndicator(
                      onRefresh: () => ref.refresh(allSongsProvider.future),
                      color: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      child: allSongs.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              children: const [
                                SizedBox(height: 200),
                                Center(
                                  child: AppText.body('No songs found in library.', color: AppColors.textSecondary),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: allSongs.length,
                              itemBuilder: (context, index) {
                                final song = allSongs[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(10),
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
                                        ? const Icon(Icons.music_note_rounded, color: AppColors.primary)
                                        : null,
                                  ),
                                  title: AppText.body(song.title, maxLines: 1),
                                  subtitle: AppText.caption(song.artist, maxLines: 1),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                                    onPressed: () {},
                                  ),
                                  onTap: () {
                                    ref.read(playerProvider.notifier).playSong(song);
                                    context.pushNamed(RouteNames.player);
                                  },
                                );
                              },
                            ),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (err, stack) => Center(child: AppText.body('Error: $err', color: Colors.red)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistsTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.queue_music_rounded, size: 64, color: AppColors.surface),
        const SizedBox(height: 16),
        const AppText.body('No playlists created yet.', color: AppColors.textSecondary),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Create Playlist'),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.favoriteOutline, size: 64, color: AppColors.surface),
          SizedBox(height: 16),
          AppText.body('Your favorite tracks will appear here.', color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
