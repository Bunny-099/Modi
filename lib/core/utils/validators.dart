class AppValidators {
  // Private constructor to prevent instantiation
  AppValidators._();

  /// Validates if a standard text input (like a search query) is empty
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  /// Validates playlist name creation.
  /// Ensures it's not empty and not too long.
  static String? validatePlaylistName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Playlist name cannot be empty';
    }
    if (value.trim().length > 30) {
      return 'Playlist name cannot exceed 30 characters';
    }
    return null;
  }
}