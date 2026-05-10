import 'dart:async';
import 'dart:io';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:path/path.dart' as path;

class AppLogger {
  static File? _logFile;
  static IOSink? _sink;
  static bool _initialized = false;
  static bool _busy = false;

  /// Initialize the logger
  static Future<void> init() async {
    if (_initialized || _busy) return;
    _busy = true;
    try {
      final enabled = (await isar.settings.get(227))?.enableLogs ?? false;
      if (!enabled) return;
      final storage = StorageProvider();
      final directory = await storage.getDefaultDirectory();
      _logFile = File(path.join(directory!.path, 'logs.txt'));

      if (await _logFile!.exists() && await _logFile!.length() > 100 * 1024) {
        await _logFile!.delete();
      }

      if (!await _logFile!.exists()) {
        await _logFile!.create(recursive: true);
      }

      _sink = _logFile!.openWrite(mode: FileMode.append);
      _initialized = true;

      log('\n\nLogger initialized\n\n');
    } finally {
      _busy = false;
    }
  }

  static void log(String message, {LogLevel logLevel = LogLevel.info}) {
    if (!_initialized || _sink == null) return;

    final now = DateTime.now();
    final timestamp =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().padLeft(4, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final logMessage = '[$timestamp][${logLevel.toString()}] $message';
    _sink!.writeln(logMessage);
  }

  static Future<void> dispose() async {
    if (!_initialized || _busy) return;
    _busy = true;
    try {
      await _sink?.flush();
      await _sink?.close();
      _sink = null;
      _logFile = null;
      _initialized = false;
    } finally {
      _busy = false;
    }
  }
}

enum LogLevel {
  debug,
  info,
  warning,
  error;

  @override
  String toString() {
    switch (this) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
    }
  }
}
