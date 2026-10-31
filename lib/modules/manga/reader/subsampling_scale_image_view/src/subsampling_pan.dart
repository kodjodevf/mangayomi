part of 'subsampling_scale_image_view.dart';

/// Moving a zoomed image a screen at a time, as the page keys and tap
/// zones do before the page turns.
extension SubsamplingPan on SubsamplingScaleImageViewController {
  /// Checks if the image can be panned to the left.
  bool canPanLeft() {
    final s = _state;
    if (s == null || !s._isInitialized) return false;
    final left = max(0.0, -s._vTranslate.dx);
    return left > 1.0;
  }

  /// Checks if the image can be panned to the right.
  bool canPanRight() {
    final s = _state;
    if (s == null || !s._isInitialized) return false;
    final transformer = CoordinateTransformer(
      scale: s._scale,
      vTranslate: s._vTranslate,
      rotation: s.widget.rotation,
      sWidth: s._sWidth,
      sHeight: s._sHeight,
    );
    final double imageWidth = transformer.effectiveSWidth * s._scale;
    final right = max(0.0, (imageWidth + s._vTranslate.dx) - s._viewSize.width);
    return right > 1.0;
  }

  /// Pans the image to the left by one screen width.
  void panLeft() {
    final s = _state;
    if (s == null || !s._isInitialized) return;
    final currentCenter = center;
    if (currentCenter == null) return;
    final dx = s._viewSize.width / s._scale;
    final targetCenter = ui.Offset(currentCenter.dx - dx, currentCenter.dy);
    animateScaleAndCenter(
      s._scale,
      targetCenter,
      duration: ShioriMotion.standard,
    );
  }

  /// Pans the image to the right by one screen width.
  void panRight() {
    final s = _state;
    if (s == null || !s._isInitialized) return;
    final currentCenter = center;
    if (currentCenter == null) return;
    final dx = s._viewSize.width / s._scale;
    final targetCenter = ui.Offset(currentCenter.dx + dx, currentCenter.dy);
    animateScaleAndCenter(
      s._scale,
      targetCenter,
      duration: ShioriMotion.standard,
    );
  }

  /// The image's size on screen, as the view shows it (rotation applied).
  ui.Size? _shownSize() {
    final s = _state;
    if (s == null || !s._isInitialized) return null;
    final transformer = CoordinateTransformer(
      scale: s._scale,
      vTranslate: s._vTranslate,
      rotation: s.widget.rotation,
      sWidth: s._sWidth,
      sHeight: s._sHeight,
    );
    return ui.Size(
      transformer.effectiveSWidth * s._scale,
      transformer.effectiveSHeight * s._scale,
    );
  }

  /// Checks if the image can be panned up.
  bool canPanUp() {
    final s = _state;
    if (s == null || !s._isInitialized) return false;
    return -s._vTranslate.dy > 1.0;
  }

  /// Checks if the image can be panned down.
  bool canPanDown() {
    final s = _state;
    final shown = _shownSize();
    if (s == null || shown == null) return false;
    return shown.height + s._vTranslate.dy - s._viewSize.height > 1.0;
  }

  /// Pans to the next row of the page, or the row above ([rowPanTarget]),
  /// so a page taller than the screen is read row by row.
  void panToRow({required bool down, required bool rightToLeft}) {
    final s = _state;
    final shown = _shownSize();
    if (s == null || shown == null) return;
    animateScaleAndTranslation(
      s._scale,
      rowPanTarget(
        translation: s._vTranslate,
        shown: shown,
        view: s._viewSize,
        down: down,
        rightToLeft: rightToLeft,
      ),
      duration: ShioriMotion.standard,
    );
  }
}
