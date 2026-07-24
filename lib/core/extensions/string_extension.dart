extension StringExtension on String {
  /// Kisi bhi string ka pehla letter capital karne ke liye.
  /// Example: "patriotic" -> "Patriotic"
  String capitalizeFirst() {
    if (trim().isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  /// Search feature ke liye bohot zaroori!
  /// Yeh check karega ki ek string dusre ko contain karti hai ya nahi, bina case ki fikar kiye.
  /// Example: "Modi".containsIgnoreCase("modi") -> true
  bool containsIgnoreCase(String query) {
    if (trim().isEmpty || query.trim().isEmpty) return false;
    return toLowerCase().contains(query.toLowerCase());
  }

  /// Agar gaane ka naam bohot bada ho toh logic level pe usko cut karne ke liye (Optional use)
  String truncate({int maxLength = 30}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}