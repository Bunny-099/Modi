import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../player/providers/player_provider.dart';
import '../../providers/local_music_provider.dart';

class LocalScreen extends ConsumerWidget {
  const LocalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localSongsAsync = ref.watch(localMusicProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const AppText.heading('Local Music', color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            onPressed: () => ref.read(localMusicProvider.notifier).fetchLocalSongs(),
          ),
        ],
      ),
      body: localSongsAsync.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center(
              child: AppText.body('No local songs found.', color: AppColors.textSecondary),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: QueryArtworkWidget(
                  id: int.parse(song.id),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.music_note_rounded, color: AppColors.primary),
                  ),
                ),
                title: AppText.body(song.title, maxLines: 1),
                subtitle: AppText.caption(song.artist, maxLines: 1),
                onTap: () {
                  ref.read(playerProvider.notifier).playSong(song);
                  context.pushNamed(RouteNames.player);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.body('Error: $err', color: Colors.red),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(localMusicProvider.notifier).fetchLocalSongs(),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
