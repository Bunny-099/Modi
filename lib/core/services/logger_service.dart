import 'dart:developer' as developer;

class LoggerService {
  LoggerService._();

  static void info(String message, {String tag = 'SWARA_INFO'}) {
    developer.log(message, name: tag);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'SWARA_ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}