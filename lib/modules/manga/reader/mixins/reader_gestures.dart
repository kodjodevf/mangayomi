import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/widgets/keyboard_shortcuts_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// What a reader shortcut does.
enum ReaderShortcut {
  previousPage,
  nextPage,
  previousChapter,
  nextChapter,
  toggleBars,
  fullScreen,
  zoomIn,
  zoomOut,
  zoomReset,
  leave,
  showShortcuts,
}

/// The keys of each shortcut, as shown to the reader, in the order the
/// list of shortcuts shows them. [isReverseHorizontal] swaps the arrows
/// that turn the page, as the pages themselves are swapped; without
/// [zoom] (the novel reader) the zoom keys are left out.
List<(ReaderShortcut, List<String>)> readerShortcutKeys({
  bool isReverseHorizontal = false,
  bool zoom = true,
}) => [
  (
    ReaderShortcut.previousPage,
    [isReverseHorizontal ? '→' : '←', '↑', '⇧ Space'],
  ),
  (ReaderShortcut.nextPage, [isReverseHorizontal ? '←' : '→', '↓', 'Space']),
  (ReaderShortcut.previousChapter, ['P', 'Page ↑']),
  (ReaderShortcut.nextChapter, ['N', 'Page ↓']),
  (ReaderShortcut.toggleBars, ['M']),
  (ReaderShortcut.fullScreen, ['F', 'F11']),
  if (zoom) ...[
    (ReaderShortcut.zoomIn, ['+']),
    (ReaderShortcut.zoomOut, ['−']),
    (ReaderShortcut.zoomReset, ['0']),
  ],
  (ReaderShortcut.leave, ['Esc', '⌫']),
  (ReaderShortcut.showShortcuts, ['?', 'F1']),
];

/// What [shortcut] does, in the reader's language.
String readerShortcutLabel(ReaderShortcut shortcut, AppLocalizations l10n) =>
    switch (shortcut) {
      ReaderShortcut.previousPage => l10n.shortcut_previous_page,
      ReaderShortcut.nextPage => l10n.shortcut_next_page,
      ReaderShortcut.previousChapter => l10n.previous_chapter,
      ReaderShortcut.nextChapter => l10n.next_chapter,
      ReaderShortcut.toggleBars => l10n.shortcut_toggle_bars,
      ReaderShortcut.fullScreen => l10n.fullscreen,
      ReaderShortcut.zoomIn => l10n.shortcut_zoom_in,
      ReaderShortcut.zoomOut => l10n.shortcut_zoom_out,
      ReaderShortcut.zoomReset => l10n.shortcut_zoom_reset,
      ReaderShortcut.leave => l10n.shortcut_leave,
      ReaderShortcut.showShortcuts => l10n.shortcut_show,
    };

/// Handler for keyboard shortcuts in the reader.
///
/// Shift on its own used to change chapter, so touching it by mistake, or
/// before another key, left the chapter; chapters are N, P and the page
/// keys now. Space turns the page, M shows the bars, F goes full screen,
/// +, − and 0 zoom, and ? or F1 lists them all ([readerShortcutKeys]).
class ReaderKeyboardHandler {
  final VoidCallback? onEscape;
  final VoidCallback? onFullScreen;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onNextChapter;
  final VoidCallback? onPreviousChapter;
  final VoidCallback? onToggleUI;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;
  final VoidCallback? onZoomReset;
  final VoidCallback? onShowShortcuts;

  const ReaderKeyboardHandler({
    this.onEscape,
    this.onFullScreen,
    this.onPreviousPage,
    this.onNextPage,
    this.onNextChapter,
    this.onPreviousChapter,
    this.onToggleUI,
    this.onZoomIn,
    this.onZoomOut,
    this.onZoomReset,
    this.onShowShortcuts,
  });

  /// Runs [action] when it is set; the key counts as handled only then.
  bool _run(VoidCallback? action) {
    if (action == null) return false;
    action();
    return true;
  }

  /// Handles a key event and returns true if it was handled.
  bool handleKeyEvent(KeyEvent event, {bool isReverseHorizontal = false}) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    if (key == LogicalKeyboardKey.f11 || key == LogicalKeyboardKey.keyF) {
      return _run(onFullScreen);
    }
    if (key == LogicalKeyboardKey.escape ||
        key == LogicalKeyboardKey.backspace) {
      return _run(onEscape);
    }
    if (key == LogicalKeyboardKey.arrowUp) return _run(onPreviousPage);
    if (key == LogicalKeyboardKey.arrowDown) return _run(onNextPage);
    if (key == LogicalKeyboardKey.arrowLeft) {
      return _run(isReverseHorizontal ? onNextPage : onPreviousPage);
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      return _run(isReverseHorizontal ? onPreviousPage : onNextPage);
    }
    if (key == LogicalKeyboardKey.space) {
      return _run(shift ? onPreviousPage : onNextPage);
    }
    if (key == LogicalKeyboardKey.keyN || key == LogicalKeyboardKey.pageDown) {
      return _run(onNextChapter);
    }
    if (key == LogicalKeyboardKey.keyP || key == LogicalKeyboardKey.pageUp) {
      return _run(onPreviousChapter);
    }
    if (key == LogicalKeyboardKey.keyM) return _run(onToggleUI);
    if (key == LogicalKeyboardKey.equal ||
        key == LogicalKeyboardKey.add ||
        key == LogicalKeyboardKey.numpadAdd) {
      return _run(onZoomIn);
    }
    if (key == LogicalKeyboardKey.minus ||
        key == LogicalKeyboardKey.numpadSubtract) {
      return _run(onZoomOut);
    }
    if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
      return _run(onZoomReset);
    }
    if (key == LogicalKeyboardKey.question ||
        key == LogicalKeyboardKey.slash ||
        key == LogicalKeyboardKey.f1) {
      return _run(onShowShortcuts);
    }
    return false;
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

/// Lists the reader's keyboard shortcuts in a dialog.
Future<void> showReaderShortcuts(
  BuildContext context, {
  bool isReverseHorizontal = false,
  bool zoom = true,
}) {
  final l10n = context.l10n;
  return showKeyboardShortcuts(context, [
    for (final (shortcut, keys) in readerShortcutKeys(
      isReverseHorizontal: isReverseHorizontal,
      zoom: zoom,
    ))
      (readerShortcutLabel(shortcut, l10n), keys),
  ]);
}
