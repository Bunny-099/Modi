class AppConstants {
  AppConstants._();

  // --- Timings & Durations ---
  // SRD mein splash duration 3 seconds diya gaya hai
  static const Duration splashDuration = Duration(seconds: 3);

  // App ki smooth animations ke liye standard durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500); // Hero animations ke liye badhiya rahega

  // --- UI Measurements ---
  // Mini player ki fixed height taaki list ke last item par scroll overlap na ho
  static const double miniPlayerHeight = 72.0;

  // Agar future mein bottom nav bar add karna ho
  static const double bottomNavBarHeight = 80.0;

  // Tablet ya bade screens par UI ko constrain karne ke liye (optional but good practice)
  static const double maxScreenWidth = 600.0;

  // --- System/App Defaults ---
  static const double offlineCacheLimit = 100.0; // In MBs (Just an example)
}