// ignore_for_file: avoid_print

import 'dart:developer' as dev;

/// Central logger for Aidoku extension execution.
class AidokuLogger {
  /// Whether logging to stdout / debug print is enabled.
  static bool enabled = false;

  /// Optional custom log listener.
  static void Function(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  })?
  customLogger;

  /// Log a detailed info/trace message.
  static void log(String tag, String message) {
    if (!enabled && customLogger == null) return;

    final formatted = '[Aidoku:$tag] $message';
    if (enabled) {
      print(formatted);
    }
    customLogger?.call(tag, message);
  }

  /// Log a debug message with detailed variable tracking.
  static void debug(String tag, String message) {
    log(tag, message);
  }

  /// Log a warning or error message.
  static void error(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final errSuffix = error != null ? ' | Error: $error' : '';
    final formatted = '[Aidoku:$tag:ERROR] $message$errSuffix';
    if (enabled) {
      print(formatted);
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
    dev.log(message, name: 'Aidoku:$tag', error: error, stackTrace: stackTrace);
    customLogger?.call(tag, message, error: error, stackTrace: stackTrace);
  }
}
