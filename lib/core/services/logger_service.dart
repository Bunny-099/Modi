import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LoggerService {
  LoggerService._();

  static void info(String message, {String tag = 'MODI_INFO'}) {
    developer.log(message, name: tag);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'MODI_ERROR',
      error: error,
      stackTrace: stackTrace,
    );

    if (kDebugMode && error != null) {
      debugPrint('Error: $message\nException: $error\nStackTrace: $stackTrace');
    }
  }
}
