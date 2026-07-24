import 'package:audio_session/audio_session.dart';
import 'logger_service.dart';

class AudioSessionService {
  // Private constructor
  AudioSessionService._();

  /// Configures the audio session for a music player application.
  /// Handles audio interruptions like phone calls, alarms, or other media apps playing.
  static Future<void> init() async {
    try {
      final session = await AudioSession.instance;

      // Configuring the session specifically for music playback
      await session.configure(const AudioSessionConfiguration.music());

      LoggerService.info('Audio session configured successfully.', tag: 'AudioSessionService');
    } catch (e, stackTrace) {
      LoggerService.error('Failed to configure audio session.', e, stackTrace);
    }
  }
}