import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/shortcuts.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Lists the reader and player keys and, here in Settings, lets each one be
/// rebound in place: tap a row, press a key, and the row shows it. The
/// bindings themselves live in [defaultShortcuts]; the media keys and the
/// shader combinations are fixed and only listed.
class KeyboardShortcutsScreen extends ConsumerStatefulWidget {
  const KeyboardShortcutsScreen({super.key});

  @override
  ConsumerState<KeyboardShortcutsScreen> createState() =>
      _KeyboardShortcutsScreenState();
}

class _KeyboardShortcutsScreenState
    extends ConsumerState<KeyboardShortcutsScreen> {
  final _focus = FocusNode();
  ShortcutAction? _listening;
  String? _error;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _toggle(ShortcutAction action) {
    setState(() {
      _listening = _listening == action ? null : action;
      _error = null;
    });
    if (_listening != null) _focus.requestFocus();
  }

  /// A modifier pressed while listening: bound on its own if it is released
  /// before any other key, otherwise held as part of the combination.
  LogicalKeyboardKey? _pendingModifier;

  static final _lockKeys = {
    LogicalKeyboardKey.numLock,
    LogicalKeyboardKey.capsLock,
    LogicalKeyboardKey.scrollLock,
    LogicalKeyboardKey.fn,
    LogicalKeyboardKey.fnLock,
  };

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final action = _listening;
    if (action == null) return KeyEventResult.ignored;
    // Flutter synthesizes lock-key events (NumLock on Linux) to sync their
    // state on the first key the app sees; those were never pressed.
    if (event.synthesized || _lockKeys.contains(event.logicalKey)) {
      return KeyEventResult.handled;
    }
    final key = event.logicalKey;
    if (event is KeyDownEvent && KeyCombo(key).isModifier) {
      _pendingModifier = key;
    } else if (event is KeyDownEvent) {
      _pendingModifier = null;
      _bind(action, KeyCombo.pressed(key));
    } else if (event is KeyUpEvent && key == _pendingModifier) {
      _pendingModifier = null;
      _bind(action, KeyCombo(key));
    }
    // Swallow every key while listening, Esc included, so it can be bound
    // like any other and doesn't leave the screen.
    return KeyEventResult.handled;
  }

  void _bind(ShortcutAction action, KeyCombo combo) {
    final taken = shortcutFor(
      ref.read(keyboardShortcutsStateProvider),
      combo,
      ShortcutAction.values.where(
        (a) => a != action && a.isReader == action.isReader,
      ),
    );
    setState(() {
      if (taken != null) {
        _error = context.l10n.shortcut_key_in_use(
          shortcutLabel(context, taken),
        );
      } else {
        ref.read(keyboardShortcutsStateProvider.notifier).set(action, [combo]);
        _listening = null;
        _error = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final editing = ShortcutEditing(
      listening: _listening,
      error: _error,
      onTap: _toggle,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.keyboard_shortcuts),
        actions: [
          IconButton(
            tooltip: l10n.shortcut_reset_all,
            icon: const Icon(Icons.restore),
            onPressed: () {
              setState(() {
                _listening = null;
                _error = null;
              });
              ref.read(keyboardShortcutsStateProvider.notifier).resetAll();
            },
          ),
        ],
      ),
      body: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final reader = _card(
              context,
              Icons.chrome_reader_mode_outlined,
              l10n.reader,
              readerShortcutRows(context, editing: editing),
            );
            final player = _card(
              context,
              Icons.play_circle_outline,
              l10n.player,
              playerShortcutRows(context, editing: editing),
            );
            // Side by side where there is room, stacked on narrow windows so
            // the keys never run into the labels.
            return SingleChildScrollView(
              padding: tvPageInsets.add(const EdgeInsets.all(12)),
              child: constraints.maxWidth >= 900
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: reader),
                        const SizedBox(width: 12),
                        Expanded(child: player),
                      ],
                    )
                  : Column(
                      children: [reader, const SizedBox(height: 12), player],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> rows,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 16),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          ...rows,
        ],
      ),
    );
  }
}

/// What the Settings screen needs the rows to know to edit them in place.
class ShortcutEditing {
  final ShortcutAction? listening;
  final String? error;
  final ValueChanged<ShortcutAction> onTap;

  const ShortcutEditing({
    required this.listening,
    required this.error,
    required this.onTap,
  });
}

/// Whether there is likely a keyboard or a remote to press these keys with.
/// Phones and tablets are left out of the in-reader and in-player lists.
bool get hasShortcutKeys => isDesktop || isTv;

List<Widget> readerShortcutRows(
  BuildContext context, {
  ShortcutEditing? editing,
}) => [
  for (final action in ShortcutAction.values.where((a) => a.isReader))
    _ShortcutRow(action, editing: editing),
];

List<Widget> playerShortcutRows(
  BuildContext context, {
  ShortcutEditing? editing,
}) {
  final l10n = context.l10n;
  if (!isDesktop) {
    return [
      _ShortcutRow(ShortcutAction.playPause, extra: '⏯', editing: editing),
      _ShortcutRow(ShortcutAction.seekBack10, extra: '⏪', editing: editing),
      _ShortcutRow(ShortcutAction.seekForward10, extra: '⏩', editing: editing),
      _row(context, ['⏭'], l10n.next(l10n.episode), icon: Icons.skip_next),
      _row(
        context,
        ['⏮'],
        l10n.previous(l10n.episode),
        icon: Icons.skip_previous,
      ),
      _row(
        context,
        ['↑ ↓ ← →', 'OK'],
        l10n.shortcut_show_controls,
        icon: Icons.gamepad_outlined,
      ),
    ];
  }
  return [
    for (final action in ShortcutAction.values.where((a) => !a.isReader))
      _ShortcutRow(
        action,
        extra: switch (action) {
          ShortcutAction.nextEpisode => '⏭',
          ShortcutAction.previousEpisode => '⏮',
          _ => null,
        },
        editing: editing,
      ),
    _row(
      context,
      ['Ctrl + 0…6'],
      l10n.shortcut_anime4k,
      icon: Icons.auto_awesome_outlined,
    ),
  ];
}

String shortcutLabel(BuildContext context, ShortcutAction action) {
  final l10n = context.l10n;
  return switch (action) {
    ShortcutAction.nextPage => l10n.shortcut_next_page,
    ShortcutAction.previousPage => l10n.shortcut_previous_page,
    ShortcutAction.nextChapter => l10n.next(l10n.chapter),
    ShortcutAction.previousChapter => l10n.previous(l10n.chapter),
    ShortcutAction.toggleMenu => l10n.shortcut_toggle_menu,
    ShortcutAction.readerFullscreen => l10n.fullscreen,
    ShortcutAction.closeReader => l10n.shortcut_close_reader,
    ShortcutAction.playPause => l10n.shortcut_play_pause,
    ShortcutAction.seekBack5 => l10n.shortcut_seek_back(5),
    ShortcutAction.seekForward5 => l10n.shortcut_seek_forward(5),
    ShortcutAction.seekBack10 => l10n.shortcut_seek_back(10),
    ShortcutAction.seekForward10 => l10n.shortcut_seek_forward(10),
    ShortcutAction.volumeUp => l10n.shortcut_volume_up,
    ShortcutAction.volumeDown => l10n.shortcut_volume_down,
    ShortcutAction.mute => l10n.shortcut_mute,
    ShortcutAction.skipIntro => l10n.shortcut_skip_intro,
    ShortcutAction.nextEpisode => l10n.next(l10n.episode),
    ShortcutAction.previousEpisode => l10n.previous(l10n.episode),
    ShortcutAction.playerFullscreen => l10n.fullscreen,
    ShortcutAction.exitFullscreen => l10n.shortcut_exit_fullscreen,
  };
}

IconData shortcutIcon(ShortcutAction action) => switch (action) {
  ShortcutAction.nextPage => Icons.navigate_next,
  ShortcutAction.previousPage => Icons.navigate_before,
  ShortcutAction.nextChapter => Icons.fast_forward,
  ShortcutAction.previousChapter => Icons.fast_rewind,
  ShortcutAction.toggleMenu => Icons.menu,
  ShortcutAction.readerFullscreen => Icons.fullscreen,
  ShortcutAction.closeReader => Icons.close,
  ShortcutAction.playPause => Icons.play_arrow,
  ShortcutAction.seekBack5 => Icons.replay_5,
  ShortcutAction.seekForward5 => Icons.forward_5,
  ShortcutAction.seekBack10 => Icons.replay_10,
  ShortcutAction.seekForward10 => Icons.forward_10,
  ShortcutAction.volumeUp => Icons.volume_up,
  ShortcutAction.volumeDown => Icons.volume_down,
  ShortcutAction.mute => Icons.volume_off,
  ShortcutAction.skipIntro => Icons.keyboard_double_arrow_right,
  ShortcutAction.nextEpisode => Icons.skip_next,
  ShortcutAction.previousEpisode => Icons.skip_previous,
  ShortcutAction.playerFullscreen => Icons.fullscreen,
  ShortcutAction.exitFullscreen => Icons.fullscreen_exit,
};

String keyName(KeyCombo combo) => [
  if (combo.control) 'Ctrl',
  if (combo.shift) 'Shift',
  if (combo.alt) 'Alt',
  if (combo.meta) 'Meta',
  switch (combo.key) {
    LogicalKeyboardKey.arrowUp => '↑',
    LogicalKeyboardKey.arrowDown => '↓',
    LogicalKeyboardKey.arrowLeft => '←',
    LogicalKeyboardKey.arrowRight => '→',
    LogicalKeyboardKey.space => 'Space',
    LogicalKeyboardKey.escape => 'Esc',
    final key =>
      key.keyLabel.isNotEmpty ? key.keyLabel : (key.debugName ?? '?'),
  },
].join(' + ');

class _ShortcutRow extends ConsumerWidget {
  final ShortcutAction action;
  final String? extra;
  final ShortcutEditing? editing;

  const _ShortcutRow(this.action, {this.extra, this.editing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editing = this.editing;
    final keys = ref.watch(keyboardShortcutsStateProvider)[action]!;
    if (editing == null) {
      return _row(
        context,
        [...keys.map(keyName), ?extra],
        shortcutLabel(context, action),
        icon: shortcutIcon(action),
      );
    }
    final listening = editing.listening == action;
    final changed =
        !(keys.length == defaultShortcuts[action]!.length &&
            keys.every(defaultShortcuts[action]!.contains));
    return _row(
      context,
      listening
          ? ['> ${context.l10n.shortcut_press_key} <']
          : [...keys.map(keyName), ?extra],
      shortcutLabel(context, action),
      icon: shortcutIcon(action),
      highlighted: listening,
      error: listening ? editing.error : null,
      onTap: () => editing.onTap(action),
      reset: changed && !listening
          ? IconButton(
              tooltip: context.l10n.reset,
              icon: const Icon(Icons.undo, size: 20),
              onPressed: () => ref
                  .read(keyboardShortcutsStateProvider.notifier)
                  .reset(action),
            )
          : null,
    );
  }
}

Widget _row(
  BuildContext context,
  List<String> keys,
  String action, {
  IconData? icon,
  VoidCallback? onTap,
  bool highlighted = false,
  String? error,
  Widget? reset,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final chips = Wrap(
    spacing: 6,
    children: [
      for (final key in keys)
        // A filled keycap with a darker lower edge, so it reads as a key.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: highlighted
                ? colorScheme.primaryContainer
                : colorScheme.secondaryContainer,
            border: Border(
              bottom: BorderSide(
                color: highlighted
                    ? colorScheme.primary
                    : colorScheme.onSecondaryContainer.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            key,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: highlighted
                  ? colorScheme.primary
                  : colorScheme.onSecondaryContainer,
            ),
          ),
        ),
    ],
  );
  // The row being rebound is framed in the theme colour so it is clear which
  // action the key goes to, and a refused key is explained right under the
  // key chips, where the eye already is.
  return AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
    decoration: BoxDecoration(
      color: highlighted
          ? colorScheme.primaryContainer.withValues(alpha: 0.35)
          : Colors.transparent,
      border: Border.all(
        color: highlighted ? colorScheme.primary : Colors.transparent,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      // A remote can only scroll by moving focus, so rows take focus on TV.
      onTap: onTap ?? (isTv ? () {} : null),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // The player's settings menu strips the padding and dims the text of
      // plain tiles, so set both here.
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      textColor: colorScheme.onSurface,
      leading: icon == null ? null : Icon(icon),
      title: Text(action),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?reset,
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              chips,
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    error,
                    style: TextStyle(color: colorScheme.error, fontSize: 12),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
