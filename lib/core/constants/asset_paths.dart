class AssetPaths {
  AssetPaths._();

  // --- Base Paths ---
  static const String _imagesBase = 'assets/images/';
  static const String _logoBase = 'assets/logo/';
  static const String _iconsBase = 'assets/icons/';
  static const String _audioBase = 'assets/audio/';

  // --- Logos ---
  // Assuming you have a logo.png in assets/logo/
  static const String appLogo = '${_logoBase}logo.png';

  // --- Intro / Splash ---
  // As per SRD: Narendra Modi folded hands image and welcome audio
  static const String splashImage = '${_imagesBase}intro/welcome_image.png';
  static const String modiRock = '${_imagesBase}modi_rock.jpeg';
  static const String donationQR = '${_imagesBase}qr.png';
  static const String majaNahiAaRaha = '${_audioBase}maja_nahi_aa_raha.mp3';

  // --- Placeholders & Defaults ---
  // Agar kisi gaane ka cover na mile toh ye show karenge
  static const String defaultAlbumArt = '${_imagesBase}albums/default_album.png';
  static const String defaultArtistImage = '${_imagesBase}artist/default_artist.png';

  // --- Audio Directories (For Local Loading if needed) ---
  static const String songsDir = '${_audioBase}songs/';
  static const String speechDir = '${_audioBase}speech/';
}