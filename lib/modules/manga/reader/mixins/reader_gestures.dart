import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
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
/// [zoom] (the novel reader) the zoom keys are left out. The keys are the
/// user's [bindings].
List<(ReaderShortcut, List<String>)> readerShortcutKeys({
  bool isReverseHorizontal = false,
  bool zoom = true,
  KeyBindings bindings = defaultKeyBindings,
}) {
  List<String> keys(ReaderShortcut shortcut) => [
    for (final label in keyLabels(bindings[shortcut]!))
      isReverseHorizontal ? _swapArrows(label) : label,
  ];
  return [
    for (final shortcut in ReaderShortcut.values)
      if (shortcut == ReaderShortcut.showShortcuts)
        (shortcut, ['?', 'F1'])
      else if (zoom || !_zoomShortcuts.contains(shortcut))
        (shortcut, keys(shortcut)),
  ];
}

const _zoomShortcuts = {
  ReaderShortcut.zoomIn,
  ReaderShortcut.zoomOut,
  ReaderShortcut.zoomReset,
};

String _swapArrows(String label) => switch (label) {
  '←' => '→',
  '→' => '←',
  _ => label,
};

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
/// Every key but ? and F1 comes from the user's [bindings].
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
  final KeyBindings bindings;

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
    this.bindings = defaultKeyBindings,
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
    var key = event.logicalKey;
    if (key == LogicalKeyboardKey.question ||
        key == LogicalKeyboardKey.slash ||
        key == LogicalKeyboardKey.f1) {
      return _run(onShowShortcuts);
    }
    // Right to left, the horizontal arrows turn the other way.
    if (isReverseHorizontal) {
      key = switch (key) {
        LogicalKeyboardKey.arrowLeft => LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.arrowRight => LogicalKeyboardKey.arrowLeft,
        _ => key,
      };
    }
    // The keys exactly as held first (⇧ Space turns back), then the key on
    // its own, so a stray modifier (⇧ + on most layouts) still works.
    final shortcut =
        shortcutFor(
          bindings,
          KeyCombo.pressed(key),
          sameKindAs: ReaderShortcut.leave,
        ) ??
        shortcutFor(bindings, KeyCombo(key), sameKindAs: ReaderShortcut.leave);
    return _run(switch (shortcut) {
      ReaderShortcut.previousPage => onPreviousPage,
      ReaderShortcut.nextPage => onNextPage,
      ReaderShortcut.previousChapter => onPreviousChapter,
      ReaderShortcut.nextChapter => onNextChapter,
      ReaderShortcut.toggleBars => onToggleUI,
      ReaderShortcut.fullScreen => onFullScreen,
      ReaderShortcut.zoomIn => onZoomIn,
      ReaderShortcut.zoomOut => onZoomOut,
      ReaderShortcut.zoomReset => onZoomReset,
      ReaderShortcut.leave => onEscape,
      _ => null,
    });
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
  KeyBindings bindings = defaultKeyBindings,
}) {
  final l10n = context.l10n;
  return showKeyboardShortcuts(context, [
    for (final (shortcut, keys) in readerShortcutKeys(
      isReverseHorizontal: isReverseHorizontal,
      zoom: zoom,
      bindings: bindings,
    ))
      (readerShortcutLabel(shortcut, l10n), keys),
  ]);
}
