import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget providing horizontal tap zones for reader navigation.
class HorizontalTapZones extends StatelessWidget {
  /// Callback for left region tap.
  final VoidCallback onLeftTap;

  /// Callback for center region tap.
  final VoidCallback onCenterTap;

  /// Callback for right region tap.
  final VoidCallback onRightTap;

  /// Callback for double-tap with position.
  final void Function(Offset position)? onDoubleTap;

  /// Whether to show overlay for failed images.
  final bool showFailedOverlay;

  /// Widget to show when image failed to load.
  final Widget? failedWidget;

  const HorizontalTapZones({
    super.key,
    required this.onLeftTap,
    required this.onCenterTap,
    required this.onRightTap,
    this.onDoubleTap,
    this.showFailedOverlay = false,
    this.failedWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left region (2 flex)
        Expanded(
          flex: 2,
          child: _TapZone(onTap: onLeftTap, onDoubleTap: onDoubleTap),
        ),
        // Center region (2 flex)
        Expanded(
          flex: 2,
          child: showFailedOverlay && failedWidget != null
              ? failedWidget!
              : _TapZone(onTap: onCenterTap, onDoubleTap: onDoubleTap),
        ),
        // Right region (2 flex)
        Expanded(
          flex: 2,
          child: _TapZone(onTap: onRightTap, onDoubleTap: onDoubleTap),
        ),
      ],
    );
  }
}

/// Widget providing vertical tap zones for reader navigation.
class VerticalTapZones extends StatelessWidget {
  /// Callback for top region tap.
  final VoidCallback onTopTap;

  /// Callback for center region tap.
  final VoidCallback onCenterTap;

  /// Callback for bottom region tap.
  final VoidCallback onBottomTap;

  /// Callback for double-tap with position.
  final void Function(Offset position)? onDoubleTap;

  const VerticalTapZones({
    super.key,
    required this.onTopTap,
    required this.onCenterTap,
    required this.onBottomTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top region (2 flex)
        Expanded(
          flex: 2,
          child: _TapZone(onTap: onTopTap, onDoubleTap: onDoubleTap),
        ),
        // Center region (5 flex) - larger for viewing
        const Expanded(flex: 5, child: SizedBox.shrink()),
        // Bottom region (2 flex)
        Expanded(
          flex: 2,
          child: _TapZone(onTap: onBottomTap, onDoubleTap: onDoubleTap),
        ),
      ],
    );
  }
}

class _TapZone extends StatelessWidget {
  final VoidCallback onTap;
  final void Function(Offset position)? onDoubleTap;

  const _TapZone({required this.onTap, this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onDoubleTapDown: onDoubleTap != null
          ? (details) => onDoubleTap!(details.globalPosition)
          : null,
      onDoubleTap: onDoubleTap != null ? () {} : null,
      onSecondaryTapDown: onDoubleTap != null
          ? (details) => onDoubleTap!(details.globalPosition)
          : null,
      onSecondaryTap: onDoubleTap != null ? () {} : null,
    );
  }
}

/// Handler for keyboard shortcuts in the reader.
class ReaderKeyboardHandler {
  final VoidCallback? onEscape;
  final VoidCallback? onFullScreen;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onNextChapter;
  final VoidCallback? onPreviousChapter;

  const ReaderKeyboardHandler({
    this.onEscape,
    this.onFullScreen,
    this.onPreviousPage,
    this.onNextPage,
    this.onNextChapter,
    this.onPreviousChapter,
  });

  /// Handles a key event and returns true if it was handled.
  bool handleKeyEvent(KeyEvent event, {bool isReverseHorizontal = false}) {
    if (event is! KeyDownEvent) return false;
    switch (event.logicalKey) {
      case LogicalKeyboardKey.f11:
        onFullScreen?.call();
        return true;

      case LogicalKeyboardKey.escape:
      case LogicalKeyboardKey.backspace:
        onEscape?.call();
        return true;

      case LogicalKeyboardKey.arrowUp:
        onPreviousPage?.call();
        return true;

      case LogicalKeyboardKey.arrowDown:
        onNextPage?.call();
        return true;

      case LogicalKeyboardKey.arrowLeft:
        if (isReverseHorizontal) {
          onNextPage?.call();
        } else {
          onPreviousPage?.call();
        }
        return true;

      case LogicalKeyboardKey.arrowRight:
        if (isReverseHorizontal) {
          onPreviousPage?.call();
        } else {
          onNextPage?.call();
        }
        return true;

      case LogicalKeyboardKey.keyN:
      case LogicalKeyboardKey.pageDown:
      case LogicalKeyboardKey.shiftRight:
        onNextChapter?.call();
        return true;

      case LogicalKeyboardKey.keyP:
      case LogicalKeyboardKey.pageUp:
      case LogicalKeyboardKey.shiftLeft:
        onPreviousChapter?.call();
        return true;

      default:
        return false;
    }
  }

  /// Creates a KeyboardListener widget with this handler.
  Widget wrapWithKeyboardListener({
    required Widget child,
    bool isReverseHorizontal = false,
    FocusNode? focusNode,
  }) {
    return KeyboardListener(
      autofocus: true,
      focusNode: focusNode ?? FocusNode(),
      onKeyEvent: (event) =>
          handleKeyEvent(event, isReverseHorizontal: isReverseHorizontal),
      child: child,
    );
  }
}
