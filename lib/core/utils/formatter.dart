class AppFormatter {
  // Private constructor to prevent instantiation
  AppFormatter._();

  /// Formats a [Duration] object into a readable string (e.g., "03:45" or "1:05:20")
  static String formatDuration(Duration duration) {
    // Helper function to ensure numbers are always two digits (e.g., 5 becomes "05")
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    // Check if the audio is an hour or longer
    if (duration.inHours > 0) {
      return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
    }

    // Default format for standard songs (minutes and seconds)
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}