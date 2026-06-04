import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
