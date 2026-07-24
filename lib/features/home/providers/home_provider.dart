import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../shared/models/music_model.dart';
import '../../../../core/constants/hive_boxes.dart';

// Provider for all songs from the database
final allSongsProvider = Provider<List<MusicModel>>((ref) {
  // Currently returning asset-based songs for development
  return [
    MusicModel(
      id: '1',
      title: 'Dope Shop',
      artist: 'Modi Ji',
      album: 'Modi Rock',
      category: 'Trending',
      coverImage: 'assets/images/modi_rock.jpeg',
      audioPath: 'assets/audio/dope_shop.mp3',
      duration: 180,
    ),
    MusicModel(
      id: '2',
      title: 'Maja Nahi Aa Raha',
      artist: 'Modi Ji',
      album: 'Modi Rock',
      category: 'Trending',
      coverImage: 'assets/images/modi_rock.jpeg',
      audioPath: 'assets/audio/maja_nahi_aa_raha.mp3',
      duration: 60,
    ),
    MusicModel(
      id: '3',
      title: 'Saiyaara',
      artist: 'Modi Ji',
      album: 'Modi Rock',
      category: 'Trending',
      coverImage: 'assets/images/modi_rock.jpeg',
      audioPath: 'assets/audio/Saiyaara.mp3',
      duration: 210,
    ),
    MusicModel(
      id: '4',
      title: 'Teri Meri Prem Kahani',
      artist: 'Modi Ji',
      album: 'Modi Rock',
      category: 'Trending',
      coverImage: 'assets/images/modi_rock.jpeg',
      audioPath: 'assets/audio/teri_meri_prem_kahani.mp3',
      duration: 240,
    ),
  ];
});

// Provider for recently played songs
final recentlyPlayedProvider = Provider<List<MusicModel>>((ref) {
  // We can still try to read from Hive for recently played if needed, 
  // but for now, let's keep it simple or use a subset of all songs if Hive is empty
  try {
    final box = Hive.box<MusicModel>(HiveBoxes.musicBox);
    final recentlyPlayed = box.values
        .where((song) => song.lastPlayed != null)
        .toList()
      ..sort((a, b) => b.lastPlayed!.compareTo(a.lastPlayed!));
    
    return recentlyPlayed.take(5).toList();
  } catch (e) {
    return [];
  }
});
