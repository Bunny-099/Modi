import 'dart:async';
import 'dart:ui';

/// A utility class for debouncing actions, primarily used in Search fields
/// to prevent excessive database queries while the user is typing.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  /// Cancels the previous timer and starts a new one.
  /// The [action] will only be executed if no new calls are made within the [milliseconds] duration.
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Always call dispose when the widget using the Debouncer is disposed
  /// to prevent memory leaks.
  void dispose() {
    _timer?.cancel();
  }
}