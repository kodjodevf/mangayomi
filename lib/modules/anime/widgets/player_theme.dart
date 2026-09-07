import 'package:flutter/material.dart';

/// Shared visual language for the anime player chrome (mobile + desktop).
///
/// Values mirror the "Table de montage" design pitch: a warm glass overlay,
/// a single amber accent for selection/progress, and a red kept strictly for
/// semantic skip/countdown cues so it never competes with the accent.
class PlayerTheme {
  PlayerTheme._();

  static const accent = Color(0xFFE8A33D);
  static const accentInk = Color(0xFF1B1305);
  static const semantic = Color(0xFFFF5C5C);

  static const ink = Color(0xFFF4ECDF);

  static const glassStrong = Color(0xDC120F0A);
  static const glassSoft = Color(0x59120F0A);

  static const trackBuffer = Color(0x38F4ECDF);
  static const trackIdle = Color(0x1AF4ECDF);

  static const chipBackdrop = Color(0x24FFFFFF);
  static const chipBackdropHover = Color(0x33FFFFFF);

  static const timecode = TextStyle(
    height: 1.0,
    fontSize: 12.0,
    color: Colors.white,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Dynamic colors derived from the ambient theme.
  static Color accentOf(BuildContext context) => Theme.of(context).primaryColor;
  static Color onAccentOf(BuildContext context) =>
      Theme.of(context).colorScheme.onPrimary;
  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).colorScheme.surface;
  static Color onSurfaceOf(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;
}
