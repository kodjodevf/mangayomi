import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/shortcuts.dart';

/// Handler for keyboard shortcuts in the reader.
class ReaderKeyboardHandler {
  final VoidCallback? onEscape;
  final VoidCallback? onFullScreen;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onNextChapter;
  final VoidCallback? onPreviousChapter;
  final VoidCallback? onToggleUI;
  final Map<ShortcutAction, List<KeyCombo>> shortcuts;

  const ReaderKeyboardHandler({
    this.onEscape,
    this.onFullScreen,
    this.onPreviousPage,
    this.onNextPage,
    this.onNextChapter,
    this.onPreviousChapter,
    this.onToggleUI,
    required this.shortcuts,
  });

  /// Handles a key event and returns true if it was handled.
  bool handleKeyEvent(KeyEvent event, {bool isReverseHorizontal = false}) {
    if (event is! KeyDownEvent) return false;
    var key = event.logicalKey;
    // Right-to-left reading swaps which way the horizontal arrows turn.
    if (isReverseHorizontal) {
      if (key == LogicalKeyboardKey.arrowLeft) {
        key = LogicalKeyboardKey.arrowRight;
      } else if (key == LogicalKeyboardKey.arrowRight) {
        key = LogicalKeyboardKey.arrowLeft;
      }
    }
    final callback = switch (shortcutFor(
      shortcuts,
      KeyCombo.pressed(key),
      ShortcutAction.values.where((a) => a.isReader),
    )) {
      ShortcutAction.nextPage => onNextPage,
      ShortcutAction.previousPage => onPreviousPage,
      ShortcutAction.nextChapter => onNextChapter,
      ShortcutAction.previousChapter => onPreviousChapter,
      // "M" for menu by default: the same as clicking the middle of the
      // page, for readers who scroll with the wheel and keep the mouse still.
      ShortcutAction.toggleMenu => onToggleUI,
      ShortcutAction.readerFullscreen => onFullScreen,
      ShortcutAction.closeReader => onEscape,
      _ => null,
    };
    if (callback == null) return false;
    callback();
    return true;
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
