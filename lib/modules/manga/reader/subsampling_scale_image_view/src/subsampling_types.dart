import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'coordinate_transformer.dart';

// ─── Load State ───────────────────────────────────────────────────────────────

/// Image loading state, identical to extended_image.
enum LoadState {
  /// The image is currently loading (downloading, resolving, etc.)
  loading,

  /// The image is fully loaded and ready to be displayed
  completed,

  /// Loading failed
  failed,
}

/// Represents the current state of the widget, passed to the [loadStateChanged] callback.
/// Identical interface to ExtendedImageState from extended_image.
class SubsamplingImageState {
  const SubsamplingImageState({
    required this.loadState,
    this.loadingProgress,
    required this._reLoadCallback,
  });

  /// Current loading state.
  final LoadState loadState;

  /// Loading progress (available during [LoadState.loading]).
  /// Contains the bytes received and the expected total size.
  final ImageChunkEvent? loadingProgress;

  final VoidCallback _reLoadCallback;

  /// Reloads the image from the start (useful after a failure).
  void reLoadImage() => _reLoadCallback();
}

// ─── Enums ────────────────────────────────────────────────────────────────────

/// Mode for fitting the initial minimum scale of the image.
enum ScaleType {
  /// Fits the entire image to be visible (default behavior)
  centerInside,

  /// Fits to fill the view, cropping the edges
  centerCrop,

  /// Fits to the width of the view
  fitWidth,

  /// Fits to the height of the view
  fitHeight,

  /// Displays the image at its original size (1:1 pixels)
  originalSize,

  /// fitWidth if portrait, fitHeight if landscape
  smartFit,

  /// Uses the manually provided [SubsamplingScaleImageView.minScale] value
  custom,
}

/// Mode for limiting pan to the edges of the image.
enum PanLimit {
  /// The image cannot go entirely off-screen (default behavior)
  inside,

  /// The image can go entirely off-screen
  outside,

  /// The center of the image cannot go off-screen
  center,
}

// ─── Scale & Pan Helpers ──────────────────────────────────────────────────────

ScaleType resolveEffectiveScaleType(BoxFit? fit, ScaleType minimumScaleType) {
  if (fit != null) {
    switch (fit) {
      case BoxFit.contain:
        return ScaleType.centerInside;
      case BoxFit.cover:
        return ScaleType.centerCrop;
      case BoxFit.fitWidth:
        return ScaleType.fitWidth;
      case BoxFit.fitHeight:
        return ScaleType.fitHeight;
      case BoxFit.none:
        return ScaleType.originalSize;
      case BoxFit.fill:
        return ScaleType.centerCrop;
      case BoxFit.scaleDown:
        return ScaleType.centerInside;
    }
  }
  return minimumScaleType;
}

double calculateMinScaleForType({
  required double effWidth,
  required double effHeight,
  required ui.Size viewSize,
  required ScaleType effectiveScaleType,
  required double? customMinScale,
}) {
  final double scaleX = viewSize.width / effWidth;
  final double scaleY = viewSize.height / effHeight;

  switch (effectiveScaleType) {
    case ScaleType.centerInside:
      return min(scaleX, scaleY);
    case ScaleType.centerCrop:
      return max(scaleX, scaleY);
    case ScaleType.fitWidth:
      return scaleX;
    case ScaleType.fitHeight:
      return scaleY;
    case ScaleType.originalSize:
      return 1.0;
    case ScaleType.smartFit:
      return effHeight > effWidth ? scaleX : scaleY;
    case ScaleType.custom:
      return customMinScale ?? min(scaleX, scaleY);
  }
}

ui.Offset clampPanTranslation({
  required ui.Offset translate,
  required double scale,
  required int rotation,
  required int sWidth,
  required int sHeight,
  required ui.Size viewSize,
  required PanLimit panLimit,
}) {
  final transformer = CoordinateTransformer(
    scale: scale,
    vTranslate: translate,
    rotation: rotation,
    sWidth: sWidth,
    sHeight: sHeight,
  );

  final double imageWidth = transformer.effectiveSWidth * scale;
  final double imageHeight = transformer.effectiveSHeight * scale;

  double tx = translate.dx;
  double ty = translate.dy;

  switch (panLimit) {
    case PanLimit.inside:
      if (imageWidth <= viewSize.width) {
        tx = (viewSize.width - imageWidth) / 2;
      } else {
        tx = max(viewSize.width - imageWidth, min(0.0, tx));
      }
      if (imageHeight <= viewSize.height) {
        ty = (viewSize.height - imageHeight) / 2;
      } else {
        ty = max(viewSize.height - imageHeight, min(0.0, ty));
      }
      break;
    case PanLimit.outside:
      break;
    case PanLimit.center:
      tx = max(tx, viewSize.width / 2 - imageWidth);
      ty = max(ty, viewSize.height / 2 - imageHeight);
      tx = min(tx, viewSize.width / 2);
      ty = min(ty, viewSize.height / 2);
      break;
  }

  return ui.Offset(tx, ty);
}
