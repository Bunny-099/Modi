import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../core/utils/debounce.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../shared/models/music_model.dart';
import '../../../home/providers/home_provider.dart';
import '../../../player/providers/player_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  List<MusicModel> _searchResults = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    _debouncer.run(() {
      if (query.trim().isEmpty) {
        setState(() {
          _searchResults = [];
        });
        return;
      }

      // Read the current data from allSongsProvider (which is an AsyncValue)
      final allSongsAsync = ref.read(allSongsProvider);
      
      allSongsAsync.whenData((allSongs) {
        final lowerCaseQuery = query.toLowerCase();
        setState(() {
          _searchResults = allSongs.where((song) {
            final titleMatch = song.title.toLowerCase().contains(lowerCaseQuery);
            final artistMatch = (song.artist ?? '').toLowerCase().contains(lowerCaseQuery);
            return titleMatch || artistMatch;
          }).toList();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search songs, artists...',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
                : null,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searchQuery.trim().isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.search, size: 64, color: AppColors.surface),
            SizedBox(height: 16),
            AppText.body('Find your favorite music', color: AppColors.textSecondary),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: AppText.body('No results found for "$_searchQuery"', color: AppColors.textSecondary),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final song = _searchResults[index];
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
          subtitle: AppText.caption(song.artist ?? 'Unknown Artist', maxLines: 1),
          onTap: () {
            ref.read(playerProvider.notifier).playSong(song);
            context.pushNamed(RouteNames.player);
          },
        );
      },
    );
  }
}
