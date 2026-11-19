import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

/// The size and place of the desktop window when it is neither maximized nor
/// fullscreen, and whether it was maximized.
@immutable
class WindowGeometry {
  const WindowGeometry({
    required this.size,
    this.position,
    this.isMaximized = false,
  });

  final Size size;
  final Offset? position;
  final bool isMaximized;

  /// Smaller than this, the window was not sized by anyone on purpose.
  static const minimumSide = 100.0;

  /// Null when [json] holds no usable size.
  static WindowGeometry? fromJson(Object? json) {
    if (json is! Map) return null;
    final width = json['width'];
    final height = json['height'];
    if (width is! num || height is! num) return null;
    if (width < minimumSide || height < minimumSide) return null;
    final x = json['x'];
    final y = json['y'];
    return WindowGeometry(
      size: Size(width.toDouble(), height.toDouble()),
      position: x is num && y is num
          ? Offset(x.toDouble(), y.toDouble())
          : null,
      isMaximized: json['isMaximized'] == true,
    );
  }

  Map<String, Object?> toJson() => {
    'width': size.width,
    'height': size.height,
    'x': position?.dx,
    'y': position?.dy,
    'isMaximized': isMaximized,
  };

  /// Whether [size] fills one of [screens] (logical sizes) whole. That is
  /// a fullscreen window's size, saved by versions that did not tell the two
  /// apart: given back to a fresh window, a tiling compositor takes it for
  /// fullscreen.
  bool coversAScreen(Iterable<Size> screens) => screens.any(
    (screen) => size.width >= screen.width && size.height >= screen.height,
  );

  @override
  bool operator ==(Object other) =>
      other is WindowGeometry &&
      other.size == size &&
      other.position == position &&
      other.isMaximized == isMaximized;

  @override
  int get hashCode => Object.hash(size, position, isMaximized);

  @override
  String toString() => 'WindowGeometry(${toJson()})';
}

/// Remembers the desktop window's [WindowGeometry] across launches.
///
/// Only the window's own size is kept: the screen a fullscreen reader or
/// player fills, or a maximized window's, would come back as the window's
/// size on the next launch.
class WindowGeometryStore {
  WindowGeometryStore._();

  static const _fileName = 'window_geometry.json';

  /// How long the window must stay still before it is saved. Linux reports
  /// each step of a resize or a move, many a second.
  static const settleDelay = Duration(milliseconds: 500);

  static Timer? _pending;

  @visibleForTesting
  static Future<File> Function() file = () async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  };

  /// The logical size of each screen.
  @visibleForTesting
  static Iterable<Size> Function() screens = () => PlatformDispatcher
      .instance
      .displays
      .map((display) => display.size / display.devicePixelRatio);

  /// What was saved last, or null when nothing usable was.
  static Future<WindowGeometry?> read() async {
    final saved = await file();
    if (!await saved.exists()) return null;
    try {
      return WindowGeometry.fromJson(jsonDecode(await saved.readAsString()));
    } on FormatException catch (error, stack) {
      // Cut short by a kill while an older version wrote it in place: the
      // window opens at its default size and the next save writes a good one.
      recordError(
        error,
        stack: stack,
        source: 'window_geometry',
        level: LogLevel.warning,
      );
      return null;
    }
  }

  /// Gives the window the size it had when it was last saved.
  static Future<void> restore() async {
    try {
      final geometry = await read();
      if (geometry == null) return;
      if (geometry.coversAScreen(screens())) {
        // A maximized window's size, or a fullscreen one's saved by an older
        // version: the window keeps its default size and saves its own once
        // moved or resized.
        if (geometry.isMaximized) await windowManager.maximize();
        return;
      }
      await windowManager.setSize(geometry.size);
      final position = geometry.position;
      if (position != null) await windowManager.setPosition(position);
      if (geometry.isMaximized) await windowManager.maximize();
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'window_geometry');
    }
  }

  /// Saves the window once it has stayed still for [settleDelay].
  static void scheduleSave() {
    _pending?.cancel();
    _pending = Timer(settleDelay, () => unawaited(save()));
  }

  /// Saves the window now, in place of any save [scheduleSave] has pending.
  static Future<void> save() async {
    _pending?.cancel();
    _pending = null;
    try {
      // Neither size is the window's own; what was saved before stands.
      if (await windowManager.isFullScreen()) return;
      if (await windowManager.isMinimized()) return;
      final bounds = await windowManager.getBounds();
      var geometry = WindowGeometry(
        size: bounds.size,
        position: bounds.topLeft,
      );
      if (await windowManager.isMaximized()) {
        // The size to come back to once unmaximized is the one from before.
        // Without one, the maximized size covers the screen and [restore]
        // maximizes the window without sizing it.
        final previous = await read();
        geometry = WindowGeometry(
          size: previous?.size ?? geometry.size,
          position: previous?.position ?? geometry.position,
          isMaximized: true,
        );
      }
      await _write(geometry);
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'window_geometry');
    }
  }

  /// Through a file beside it, renamed over it once written: a kill midway
  /// leaves the last good one in place.
  static Future<void> _write(WindowGeometry geometry) async {
    final saved = await file();
    await saved.parent.create(recursive: true);
    final next = File('${saved.path}.tmp');
    await next.writeAsString(jsonEncode(geometry.toJson()), flush: true);
    await next.rename(saved.path);
  }
}
