// Yeh enum app mein har jagah category filter karne ke kaam aayega
enum MusicCategory {
  all,          // Default, library mein sab dikhane ke liye
  patriotic,
  speech,
  bhajan,
  motivational,
  favorite,     // SRD ke hisaab se Future scope hai
}

// UI mein category ka naam dikhane ke liye extension
extension MusicCategoryExtension on MusicCategory {
  String get displayName {
    switch (this) {
      case MusicCategory.all:
        return 'All Tracks';
      case MusicCategory.patriotic:
        return 'Patriotic';
      case MusicCategory.speech:
        return 'Speeches';
      case MusicCategory.bhajan:
        return 'Bhajans';
      case MusicCategory.motivational:
        return 'Motivational';
      case MusicCategory.favorite:
        return 'Favorites';
    }
  }
}