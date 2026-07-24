import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/database/default_music_loader.dart';
import '../../../../core/widgets/app_text.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
    _initializeAppData();
    _playSplashAudio();
  }

  Future<void> _playSplashAudio() async {
    try {
      await _audioPlayer.setAsset(AssetPaths.majaNahiAaRaha);
      _audioPlayer.play();
    } catch (e) {
      debugPrint("Error playing splash audio: $e");
    }
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
    _audioPlayer.dispose();
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
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AssetPaths.modiRock,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.account_circle_rounded,
                          size: 180,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const AppText.heading1(
                'Modi Player',
                color: AppColors.primary,
              ),
              const SizedBox(height: 12),
              const AppText.bodyLarge(
                'सुर में गाने सुनिए मोदी जी के साथ।',
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 32),
              Opacity(
                opacity: 0.3,
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}