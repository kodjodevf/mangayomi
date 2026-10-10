import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Lists the keys the reader and the player already handle, so they can be
/// found without reading the code.
///
/// The bindings live in `ReaderKeyboardHandler` (reader), the desktop
/// controls (player on desktop) and `_wrapWithPlayerShortcuts` (player
/// everywhere else); keep this list in step with them.
class KeyboardShortcutsScreen extends StatelessWidget {
  const KeyboardShortcutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reader = [
      (['↓', '→'], l10n.shortcut_next_page),
      (['↑', '←'], l10n.shortcut_previous_page),
      (['N', 'Page Down', 'Right Shift'], l10n.next(l10n.chapter)),
      (['P', 'Page Up', 'Left Shift'], l10n.previous(l10n.chapter)),
      (['M'], l10n.shortcut_toggle_menu),
      (['F11'], l10n.fullscreen),
      (['Esc', 'Backspace'], l10n.shortcut_close_reader),
    ];
    final player = isDesktop
        ? [
            (['Space'], l10n.shortcut_play_pause),
            (['←'], l10n.shortcut_seek_back(5)),
            (['→'], l10n.shortcut_seek_forward(5)),
            (['J'], l10n.shortcut_seek_back(10)),
            (['L'], l10n.shortcut_seek_forward(10)),
            (['↑'], l10n.shortcut_volume_up),
            (['↓'], l10n.shortcut_volume_down),
            (['M'], l10n.shortcut_mute),
            (['Enter', 'S'], l10n.shortcut_skip_intro),
            (['N', '⏭'], l10n.next(l10n.episode)),
            (['P', '⏮'], l10n.previous(l10n.episode)),
            (['F'], l10n.fullscreen),
            (['Esc'], l10n.shortcut_exit_fullscreen),
            (['Ctrl + 0…6'], l10n.shortcut_anime4k),
          ]
        : [
            (['Space', '⏯'], l10n.shortcut_play_pause),
            (['J', '⏪'], l10n.shortcut_seek_back(10)),
            (['L', '⏩'], l10n.shortcut_seek_forward(10)),
            (['⏭'], l10n.next(l10n.episode)),
            (['⏮'], l10n.previous(l10n.episode)),
            (['↑ ↓ ← →', 'OK'], l10n.shortcut_show_controls),
          ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.keyboard_shortcuts)),
      body: ListView(
        padding: tvPageInsets,
        children: [
          _header(context, l10n.reader),
          for (final (keys, action) in reader) _row(context, keys, action),
          _header(context, l10n.player),
          for (final (keys, action) in player) _row(context, keys, action),
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

  Widget _row(BuildContext context, List<String> keys, String action) =>
      ListTile(
        // A remote can only scroll by moving focus, so rows take focus on TV.
        onTap: isTv ? () {} : null,
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
}
