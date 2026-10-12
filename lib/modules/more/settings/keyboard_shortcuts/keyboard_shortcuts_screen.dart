import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Lists the keys the reader and the player already handle, so they can be
/// found without reading the code.
///
/// The bindings live in `ReaderKeyboardHandler` (reader), the desktop
/// controls (player on desktop) and `_wrapWithPlayerShortcuts` (player
/// everywhere else); keep these lists in step with them.
class KeyboardShortcutsScreen extends StatelessWidget {
  const KeyboardShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.keyboard_shortcuts)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          _header(context, l10n.reader),
          ...readerShortcutRows(context),
          _header(context, l10n.player),
          ...playerShortcutRows(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: context.primaryColor,
      ),
    ),
  );
}

/// Whether there is likely a keyboard or a remote to press these keys with.
/// Phones and tablets are left out of the in-reader and in-player lists.
bool get hasShortcutKeys => isDesktop || isTv;

List<Widget> readerShortcutRows(BuildContext context) {
  final l10n = context.l10n;
  return [
    _row(context, ['↓', '→'], l10n.shortcut_next_page),
    _row(context, ['↑', '←'], l10n.shortcut_previous_page),
    _row(context, ['N', 'Page Down', 'Right Shift'], l10n.next(l10n.chapter)),
    _row(context, ['P', 'Page Up', 'Left Shift'], l10n.previous(l10n.chapter)),
    _row(context, ['M'], l10n.shortcut_toggle_menu),
    _row(context, ['F11'], l10n.fullscreen),
    _row(context, ['Esc', 'Backspace'], l10n.shortcut_close_reader),
  ];
}

List<Widget> playerShortcutRows(BuildContext context) {
  final l10n = context.l10n;
  if (!isDesktop) {
    return [
      _row(context, ['Space', '⏯'], l10n.shortcut_play_pause),
      _row(context, ['J', '⏪'], l10n.shortcut_seek_back(10)),
      _row(context, ['L', '⏩'], l10n.shortcut_seek_forward(10)),
      _row(context, ['⏭'], l10n.next(l10n.episode)),
      _row(context, ['⏮'], l10n.previous(l10n.episode)),
      _row(context, ['↑ ↓ ← →', 'OK'], l10n.shortcut_show_controls),
    ];
  }
  return [
    _row(context, ['Space'], l10n.shortcut_play_pause),
    _row(context, ['←'], l10n.shortcut_seek_back(5)),
    _row(context, ['→'], l10n.shortcut_seek_forward(5)),
    _row(context, ['J'], l10n.shortcut_seek_back(10)),
    _row(context, ['L'], l10n.shortcut_seek_forward(10)),
    _row(context, ['↑'], l10n.shortcut_volume_up),
    _row(context, ['↓'], l10n.shortcut_volume_down),
    _row(context, ['M'], l10n.shortcut_mute),
    _row(context, ['Enter', 'S'], l10n.shortcut_skip_intro),
    _row(context, ['N', '⏭'], l10n.next(l10n.episode)),
    _row(context, ['P', '⏮'], l10n.previous(l10n.episode)),
    _row(context, ['F'], l10n.fullscreen),
    _row(context, ['Esc'], l10n.shortcut_exit_fullscreen),
    _row(context, ['Ctrl + 0…6'], l10n.shortcut_anime4k),
  ];
}

Widget _row(BuildContext context, List<String> keys, String action) => ListTile(
  // A remote can only scroll by moving focus, so rows take focus on TV.
  onTap: isTv ? () {} : null,
  // The player's settings menu strips the padding and dims the text of
  // plain tiles, so set both here.
  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  textColor: Theme.of(context).colorScheme.onSurface,
  title: Text(action),
  trailing: Wrap(
    spacing: 6,
    children: [
      for (final key in keys)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            key,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
        ),
    ],
  ),
);
