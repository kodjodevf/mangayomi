import 'dart:ui' as ui;

/// Manages calculations and coordinate transformations between the following spaces:
/// - View (v): real pixels on the screen
/// - Source (s): logical coordinates in the image (oriented/rotated)
/// - File (f): raw physical coordinates in the original image file
class CoordinateTransformer {
  final double scale;
  final ui.Offset vTranslate;
  final int rotation; // 0, 90, 180, 270
  final int sWidth; // Physical width of the original file
  final int sHeight; // Physical height of the original file

  CoordinateTransformer({
    required this.scale,
    required this.vTranslate,
    required this.rotation,
    required this.sWidth,
    required this.sHeight,
  });

  /// Converts a view (screen) coordinate to logical source (rotated image) coordinates
  ui.Offset viewToSource(ui.Offset vCoord) {
    final double sx = (vCoord.dx - vTranslate.dx) / scale;
    final double sy = (vCoord.dy - vTranslate.dy) / scale;
    return ui.Offset(sx, sy);
  }

  /// Public alias of viewToSource for the controller API
  ui.Offset vCoordToSCoord(ui.Offset vCoord) => viewToSource(vCoord);

  /// Converts a logical source (rotated image) coordinate to view (screen) coordinates
  ui.Offset sourceToView(ui.Offset sCoord) {
    final double vx = (sCoord.dx * scale) + vTranslate.dx;
    final double vy = (sCoord.dy * scale) + vTranslate.dy;
    return ui.Offset(vx, vy);
  }

  /// Public alias of sourceToView for the controller API
  ui.Offset sCoordToVCoord(ui.Offset sCoord) => sourceToView(sCoord);

  /// Converts a logical source rectangle to a display rectangle on the screen
  ui.Rect sourceToViewRect(ui.Rect sRect) {
    final ui.Offset topLeft = sourceToView(sRect.topLeft);
    final ui.Offset bottomRight = sourceToView(sRect.bottomRight);
    return ui.Rect.fromPoints(topLeft, bottomRight);
  }

  /// Converts a source coordinate rectangle (oriented) to raw physical coordinates in the original file
  ui.Rect fileSRect(ui.Rect sRect) {
    switch (rotation) {
      case 90:
        return ui.Rect.fromLTRB(
          sRect.top,
          sHeight - sRect.right,
          sRect.bottom,
          sHeight - sRect.left,
        );
      case 180:
        return ui.Rect.fromLTRB(
          sWidth - sRect.right,
          sHeight - sRect.bottom,
          sWidth - sRect.left,
          sHeight - sRect.top,
        );
      case 270:
        return ui.Rect.fromLTRB(
          sWidth - sRect.bottom,
          sRect.left,
          sWidth - sRect.top,
          sRect.right,
        );
      case 0:
      default:
        return sRect;
    }
  }

  /// Effective width of the source, taking rotation into account
  int get effectiveSWidth {
    return (rotation == 90 || rotation == 270) ? sHeight : sWidth;
  }

  /// Effective height of the source, taking rotation into account
  int get effectiveSHeight {
    return (rotation == 90 || rotation == 270) ? sWidth : sHeight;
  }
}
