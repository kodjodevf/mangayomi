import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Navigation layout variants matching Mihon.
///
///  0 = Default  – current three-column + top/bottom zones
///  1 = L-shaped – top-left = prev, bottom-right = next, rest = UI
///  2 = Kindle   – top = UI, bottom split left = prev / right = next
///  3 = Edge     – thin side strips for prev/next, rest = UI
///  4 = Right & Left – simple two-zone left = prev / right = next
///  5 = Disabled – full screen = toggle UI
///
/// For horizontal reading (LTR), the default layout is:
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

  /// Navigation layout index (0-5), see class docs.
  final int navigationLayout;

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
    this.navigationLayout = 0,
    this.onDoubleTapDown,
    this.onDoubleTap,
    this.onSecondaryTapDown,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return switch (navigationLayout) {
      1 => _buildLShaped(context),
      2 => _buildKindle(context),
      3 => _buildEdge(context),
      4 => _buildRightAndLeft(context),
      5 => _buildDisabled(context),
      _ => _buildDefault(context),
    };
  }

  // ── helpers ──

  VoidCallback _prev() => isRTL ? onNextPage : onPreviousPage;
  VoidCallback _next() => isRTL ? onPreviousPage : onNextPage;

  _ZoneGestureDetector _zone(VoidCallback onTap) => _ZoneGestureDetector(
    onTap: usePageTapZones ? onTap : onToggleUI,
    onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
    onDoubleTap: isContinuousMode ? onDoubleTap : null,
    onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
    onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
  );

  _ZoneGestureDetector _uiZone() => _ZoneGestureDetector(
    onTap: onToggleUI,
    onDoubleTapDown: isContinuousMode ? onDoubleTapDown : null,
    onDoubleTap: isContinuousMode ? onDoubleTap : null,
    onSecondaryTapDown: isContinuousMode ? onSecondaryTapDown : null,
    onSecondaryTap: isContinuousMode ? onSecondaryTap : null,
  );

  // ── Layout 0: Default (original 3-col + top/bottom) ──

  Widget _buildDefault(BuildContext context) {
    return Stack(
      children: [
        _buildDefaultHorizontalZones(context),
        _buildDefaultVerticalZones(context),
      ],
    );
  }

  Widget _buildDefaultHorizontalZones(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: _zone(_prev())),
        Expanded(
          flex: 2,
          child: hasImageError
              ? SizedBox(width: context.width(1), height: context.height(0.7))
              : _uiZone(),
        ),
        Expanded(flex: 2, child: _zone(_next())),
      ],
    );
  }

  Widget _buildDefaultVerticalZones(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _zone(hasImageError ? onToggleUI : onPreviousPage),
        ),
        const Expanded(flex: 5, child: SizedBox.shrink()),
        Expanded(
          flex: 2,
          child: _zone(hasImageError ? onToggleUI : onNextPage),
        ),
      ],
    );
  }

  // ── Layout 1: L-shaped ──
  // ┌───────┬───────────────┐
  // │ PREV  │               │
  // ├───────┘               │
  // │          UI           │
  // │               ┌───────┤
  // │               │ NEXT  │
  // └───────────────┴───────┘

  Widget _buildLShaped(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 1, child: _zone(_prev())),
              Expanded(flex: 2, child: _uiZone()),
            ],
          ),
        ),
        Expanded(flex: 2, child: _uiZone()),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(flex: 2, child: _uiZone()),
              Expanded(flex: 1, child: _zone(_next())),
            ],
          ),
        ),
      ],
    );
  }

  // ── Layout 2: Kindle ──
  // ┌───────────────────────┐
  // │       UI (toggle)     │
  // ├───────────┬───────────┤
  // │   PREV    │   NEXT    │
  // └───────────┴───────────┘

  Widget _buildKindle(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 1, child: _uiZone()),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(child: _zone(_prev())),
              Expanded(child: _zone(_next())),
            ],
          ),
        ),
      ],
    );
  }

  // ── Layout 3: Edge ──
  // ┌──┬──────────────┬──┐
  // │P │              │N │
  // │R │     UI       │E │
  // │E │   (toggle)   │X │
  // │V │              │T │
  // └──┴──────────────┴──┘

  Widget _buildEdge(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: _zone(_prev())),
        Expanded(flex: 5, child: _uiZone()),
        Expanded(flex: 1, child: _zone(_next())),
      ],
    );
  }

  // ── Layout 4: Right and Left ──
  // ┌───────────┬───────────┐
  // │           │           │
  // │   PREV    │   NEXT    │
  // │           │           │
  // └───────────┴───────────┘

  Widget _buildRightAndLeft(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _zone(_prev())),
        Expanded(child: _zone(_next())),
      ],
    );
  }

  // ── Layout 5: Disabled ──

  Widget _buildDisabled(BuildContext context) {
    return SizedBox.expand(child: _uiZone());
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
