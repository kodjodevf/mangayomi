import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

/// Saves and restores desktop window size and position across sessions.
class WindowGeometry {
  static const _fileName = 'window_geometry.json';

  static Future<File> get _file async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Restore saved window geometry, if available.
  static Future<void> restore() async {
    try {
      final file = await _file;
      if (!await file.exists()) return;
      final json = jsonDecode(await file.readAsString());
      final width = (json['width'] as num?)?.toDouble();
      final height = (json['height'] as num?)?.toDouble();
      final x = (json['x'] as num?)?.toDouble();
      final y = (json['y'] as num?)?.toDouble();
      final isMaximized = json['isMaximized'] as bool? ?? false;

      if (width != null && height != null && width > 100 && height > 100) {
        await windowManager.setSize(Size(width, height));
      }
      if (x != null && y != null) {
        await windowManager.setPosition(Offset(x, y));
      }
      if (isMaximized) {
        await windowManager.maximize();
      }
    } catch (_) {
      // Ignore errors from corrupted or missing file
    }
  }

  /// Save current window geometry to disk.
  static Future<void> save() async {
    try {
      final isMaximized = await windowManager.isMaximized();
      final size = await windowManager.getSize();
      final position = await windowManager.getPosition();
      final json = jsonEncode({
        'width': size.width,
        'height': size.height,
        'x': position.dx,
        'y': position.dy,
        'isMaximized': isMaximized,
      });
      final file = await _file;
      await file.writeAsString(json);
    } catch (_) {
      // Ignore write errors
    }
  }
}
