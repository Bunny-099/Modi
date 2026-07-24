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

// ConsumerStatefulWidget isliye use kiya hai taaki TextField aur Debouncer ki state manage kar sakein
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // 500ms ka debounce delay set kiya hai
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  List<MusicModel> _searchResults = [];
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose(); // Debouncer ko dispose karna zaroori hai memory leaks rokne ke liye
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

      // Hive database se saare gaane utha kar locally filter kar rahe hain
      final allSongs = ref.read(allSongsProvider);
      final lowerCaseQuery = query.toLowerCase();

      setState(() {
        _searchResults = allSongs.where((song) {
          final titleMatch = song.title.toLowerCase().contains(lowerCaseQuery);
          final artistMatch = (song.artist ?? '').toLowerCase().contains(lowerCaseQuery);
          return titleMatch || artistMatch;
        }).toList();
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
          autofocus: true, // Screen open hote hi keyboard show hoga
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
    // 1. Initial State (Jab kuch type na kiya ho)
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

    // 2. Empty State (Jab query match na kare)
    if (_searchResults.isEmpty) {
      return Center(
        child: AppText.body('No results found for "$_searchQuery"', color: AppColors.textSecondary),
      );
    }

    // 3. Results State
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
          onTap: () {
            // TODO: Yahan par hum gaana play hone ka logic add karenge
            context.pushNamed(RouteNames.player);
          },
        );
      },
    );
  }
}