import 'package:hive/hive.dart';

// Yeh file Hive generator banayega command run karne ke baad
part 'music_model.g.dart';

@HiveType(typeId: 0) // Hive database ke liye unique ID
class MusicModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  final String album;

  @HiveField(4)
  final String category; // E.g., 'Patriotic', 'Speech' (enum ki displayName se match karenge)

  @HiveField(5)
  final String coverImage; // Asset path for cover image

  @HiveField(6)
  final String audioPath; // Asset path for the mp3 file

  @HiveField(7)
  final int duration; // Duration in seconds

  @HiveField(8)
  bool isFavorite; // Future scope ke liye, but database design abhi se proper

  @HiveField(9)
  int playCount; // Most played/recently played logic ke liye

  @HiveField(10)
  DateTime? lastPlayed; // Recently played items sort karne ke liye

  String? get coverUrl => coverImage;

  MusicModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.category,
    required this.coverImage,
    required this.audioPath,
    required this.duration,
    this.isFavorite = false,
    this.playCount = 0,
    this.lastPlayed,
  });

  // Riverpod ke sath immutable state update karne ke liye bohot kaam aayega
  MusicModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? category,
    String? coverImage,
    String? audioPath,
    int? duration,
    bool? isFavorite,
    int? playCount,
    DateTime? lastPlayed,
  }) {
    return MusicModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      category: category ?? this.category,
      coverImage: coverImage ?? this.coverImage,
      audioPath: audioPath ?? this.audioPath,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }
}