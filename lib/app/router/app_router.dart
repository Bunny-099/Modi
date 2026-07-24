import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/asset_paths.dart';
import '../../core/database/default_music_loader.dart';
import '../../core/widgets/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();
    _initializeAppData();
  }

  Future<void> _initializeAppData() async {
    await DefaultMusicLoader.loadDefaultData();
    await Future.delayed(AppConstants.splashDuration);

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetPaths.appLogo,
                width: 150,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.music_note_rounded,
                    size: 120,
                    color: AppColors.primary,
                  );
                },
              ),
              const SizedBox(height: 24),
              const AppText.heading1(
                'Swara',
                color: AppColors.primary,
              ),
              const SizedBox(height: 8),
              const AppText.bodyLarge(
                'Your Offline Music Companion',
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}