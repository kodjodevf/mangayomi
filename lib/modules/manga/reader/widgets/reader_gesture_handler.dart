import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Manages gesture detection zones and tap handling for the reader.
///
/// The reader screen is divided into zones:
///
/// For horizontal reading (LTR):
/// ```
/// ┌─────────────────────────┐
/// │     TOP (prev page)     │
/// ├───────┬───────┬─────────┤
/// │ LEFT  │CENTER │  RIGHT  │
/// │(prev) │ (UI)  │ (next)  │
/// ├───────┴───────┴─────────┤
/// │   BOTTOM (next page)    │
/// └─────────────────────────┘
/// ```
///
/// For RTL mode, LEFT and RIGHT actions are reversed.
class ReaderGestureHandler extends StatelessWidget {
  /// Whether tap zones are enabled for navigation
  final bool usePageTapZones;

  /// Whether the reader is in RTL mode
  final bool isRTL;

  /// Whether there's an image loading error
  final bool hasImageError;

  /// Whether the reader is in continuous scroll mode
  final bool isContinuousMode;

  /// Callback when UI should be toggled
  final VoidCallback onToggleUI;

  /// Callback to go to previous page
  final VoidCallback onPreviousPage;

  /// Callback to go to next page
  final VoidCallback onNextPage;

  /// Callback for double-tap to zoom (with position)
  final void Function(Offset position)? onDoubleTapDown;

  /// Callback for double-tap gesture complete
  final VoidCallback? onDoubleTap;

  /// Callback for secondary tap (right-click on desktop)
  final void Function(Offset position)? onSecondaryTapDown;

  /// Callback for secondary tap complete
  final VoidCallback? onSecondaryTap;

  const ReaderGestureHandler({
    super.key,
    required this.usePageTapZones,
    required this.isRTL,
    required this.hasImageError,
    required this.isContinuousMode,
    required this.onToggleUI,
    required this.onPreviousPage,
    required this.onNextPage,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Horizontal zones (left, center, right)
        _buildHorizontalZones(context),

        // Vertical zones (top, center, bottom)
        _buildVerticalZones(context),
      ],
    );
  }

  Widget _buildHorizontalZones(BuildContext context) {
    return Row(
      children: [
        // Left zone
        Expanded(
          flex: 2,
          child: _ZoneGestureDetector(
            onTap: () {
              if (usePageTapZones) {
                isRTL ? onNextPage() : onPreviousPage();
              } else {
                onToggleUI();
              }
            },
            onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
            onDoubleTap: isContinuousMode ? onDoubleTap : null,
            onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
            onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
          ),
        ),

        // Center zone
        Expanded(
          flex: 2,
          child: hasImageError
              ? SizedBox(width: context.width(1), height: context.height(0.7))
              : _ZoneGestureDetector(
                  onTap: onToggleUI,
                  onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
                  onDoubleTap: isContinuousMode ? onDoubleTap : null,
                  onSecondaryTapDown: isContinuousMode
                      ? onSecondaryTapDown
                      : null,
                  onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
                ),
        ),

        // Right zone
        Expanded(
          flex: 2,
          child: _ZoneGestureDetector(
            onTap: () {
              if (usePageTapZones) {
                isRTL ? onPreviousPage() : onNextPage();
              } else {
                onToggleUI();
              }
            },
            onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
            onDoubleTap: isContinuousMode ? onDoubleTap : null,
            onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
            onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalZones(BuildContext context) {
    return Column(
      children: [
        // Top zone
        Expanded(
          flex: 2,
          child: _ZoneGestureDetector(
            onTap: () {
              if (hasImageError) {
                onToggleUI();
              } else if (usePageTapZones) {
                onPreviousPage();
              } else {
                onToggleUI();
              }
            },
            onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
            onDoubleTap: isContinuousMode ? onDoubleTap : null,
            onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
            onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
          ),
        ),

        // Center zone (transparent, handled by horizontal zones)
        const Expanded(flex: 5, child: SizedBox.shrink()),

        // Bottom zone
        Expanded(
          flex: 2,
          child: _ZoneGestureDetector(
            onTap: () {
              if (hasImageError) {
                onToggleUI();
              } else if (usePageTapZones) {
                onNextPage();
              } else {
                onToggleUI();
              }
            },
            onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
            onDoubleTap: isContinuousMode ? onDoubleTap : null,
            onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
            onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
          ),
        ),
      ],
    );
  }
}

/// Individual gesture detector for a zone.
class _ZoneGestureDetector extends StatelessWidget {
  final VoidCallback onTap;
  final void Function(Offset position)? onDoubleTapDown;
  final VoidCallback? onDoubleTap;
  final void Function(Offset position)? onSecondaryTapDown;
  final VoidCallback? onSecondaryTap;

  const _ZoneGestureDetector({
    required this.onTap,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onDoubleTapDown: onDoubleTapDown != null
          ? (details) => onDoubleTapDown!(details.globalPosition)
          : null,
      onDoubleTap: onDoubleTap,
      onSecondaryTapDown: onSecondaryTapDown != null
          ? (details) => onSecondaryTapDown!(details.globalPosition)
          : null,
      onSecondaryTap: onSecondaryTap,
    );
  }
}
