import 'dart:developer' as developer;

/// Severity levels for [AppLogger].
enum LogLevel { debug, info, warning, error }

/// Minimal structured logger. Deliberately dependency-free.
///
/// Privacy: callers must pass already-redacted values. [redactId] is provided
/// so BLE MAC addresses / device identifiers never reach normal logs in full.
/// See documentation/mobile-app/PRIVACY-NOTES.md.
class AppLogger {
  const AppLogger(this.tag);

  final String tag;

  static LogLevel minLevel = LogLevel.debug;

  void debug(String message, {Object? data}) =>
      _log(LogLevel.debug, message, data: data);
  void info(String message, {Object? data}) =>
      _log(LogLevel.info, message, data: data);
  void warning(String message, {Object? data}) =>
      _log(LogLevel.warning, message, data: data);
  void error(String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.error, message, error: error, stackTrace: stackTrace);

  void _log(
    LogLevel level,
    String message, {
    Object? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;
    final suffix = data == null ? '' : ' | $data';
    developer.log(
      '$message$suffix',
      name: 'ShadeShifter/$tag',
      level: _levelValue(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  int _levelValue(LogLevel level) => switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      };

  /// Redacts an identifier to `AB••••EF` form for logs/diagnostics.
  static String redactId(String id) {
    final clean = id.replaceAll(':', '');
    if (clean.length <= 4) return '••';
    return '${clean.substring(0, 2)}••••${clean.substring(clean.length - 2)}';
  }
}
