extension DurationExtension on Duration {
  /// Yeh function Duration ko "MM:SS" ya "HH:MM:SS" format mein convert karta hai.
  /// Music player ke seek bar aur track time ke liye yeh bohot kaam aayega.
  String toFormattedString() {
    // Single digit ko double digit banane ke liye helper (e.g., 5 sec -> "05")
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));

    // Agar gaana 1 ghante se lamba hai (Speeches ke case mein ho sakta hai)
    if (inHours > 0) {
      return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      // Normal gaano ke liye MM:SS
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}