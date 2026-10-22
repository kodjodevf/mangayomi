import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/more/settings/player/providers/player_state_provider.dart';
import 'package:mangayomi/modules/widgets/keyboard_shortcuts_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// The reader's and the player's keys, each rebound in place: tap a row,
/// press the keys, and the row shows them. The fixed keys (? and F1, the
/// frame steps, Anime4K) are left out; the lists in the reader and the
/// player still show them.
class KeyboardShortcutsScreen extends ConsumerStatefulWidget {
  const KeyboardShortcutsScreen({super.key});

  @override
  ConsumerState<KeyboardShortcutsScreen> createState() =>
      _KeyboardShortcutsScreenState();
}

class _KeyboardShortcutsScreenState
    extends ConsumerState<KeyboardShortcutsScreen> {
  final _focus = FocusNode();
  Enum? _listening;
  String? _error;

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _listen(Enum? shortcut) {
    setState(() {
      _listening = shortcut;
      _error = null;
    });
    if (shortcut != null) _focus.requestFocus();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final shortcut = _listening;
    if (shortcut == null) return KeyEventResult.ignored;
    // Flutter synthesizes lock-key events (NumLock on Linux) to sync their
    // state on the first key the app sees; those were never pressed. A
    // modifier waits for the key it is held with.
    final combo = KeyCombo.pressed(event.logicalKey);
    if (event is KeyDownEvent && !event.synthesized && !combo.isModifier) {
      final taken = shortcutFor(
        ref.read(keyBindingsStateProvider),
        combo,
        sameKindAs: shortcut,
      );
      if (taken == null || taken == shortcut) {
        ref.read(keyBindingsStateProvider.notifier).set(shortcut, [combo]);
        _listen(null);
      } else {
        setState(
          () => _error = context.l10n.shortcut_key_in_use(_label(taken)),
        );
      }
    }
    // Every key is swallowed while listening, Esc included, so it can be
    // bound like any other and doesn't leave the screen.
    return KeyEventResult.handled;
  }

  String _label(Enum shortcut) => switch (shortcut) {
    final ReaderShortcut s => readerShortcutLabel(s, context.l10n),
    final PlayerShortcut s => playerShortcutLabel(
      s,
      context.l10n,
      skipIntroSeconds: ref.read(defaultSkipIntroLengthStateProvider),
    ),
    _ => shortcut.name,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bindings = ref.watch(keyBindingsStateProvider);
    Widget row(Enum shortcut) {
      final keys = bindings[shortcut]!;
      final listening = _listening == shortcut;
      return ShioriSettingRow(
        title: _label(shortcut),
        subtitle: listening ? _error ?? l10n.shortcut_press_key : null,
        onTap: () => _listen(listening ? null : shortcut),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: ShioriSpace.s4,
          children: [
            if (!listening && !isDefaultBinding(shortcut, keys))
              IconButton(
                tooltip: l10n.reset,
                icon: const Icon(Symbols.undo_rounded),
                onPressed: () =>
                    ref.read(keyBindingsStateProvider.notifier).reset(shortcut),
              ),
            if (listening)
              const KeyCap('…')
            else
              for (final key in keyLabels(keys)) KeyCap(key),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.keyboard_shortcuts),
        actions: [
          IconButton(
            tooltip: l10n.shortcut_reset_all,
            icon: const Icon(Symbols.restart_alt_rounded),
            onPressed: () {
              _listen(null);
              ref.read(keyBindingsStateProvider.notifier).resetAll();
            },
          ),
        ],
      ),
      body: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // The player's list is the longer one, so it takes the left.
            final player = _card(l10n.player, [
              for (final shortcut in PlayerShortcut.values)
                if (defaultKeyBindings.containsKey(shortcut)) row(shortcut),
            ]);
            final reader = _card(l10n.reader, [
              for (final shortcut in ReaderShortcut.values)
                if (defaultKeyBindings.containsKey(shortcut)) row(shortcut),
            ]);
            // Side by side where there is room, stacked on narrow windows so
            // the keys never run into the labels.
            return SingleChildScrollView(
              padding: tvPageInsets.add(const EdgeInsets.all(ShioriSpace.s12)),
              child: constraints.maxWidth >= 900
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: ShioriSpace.s12,
                      children: [
                        Expanded(child: player),
                        Expanded(child: reader),
                      ],
                    )
                  : Column(
                      spacing: ShioriSpace.s12,
                      children: [player, reader],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _card(String title, List<Widget> rows) {
    final tokens = context.shiori;
    return Container(
      padding: const EdgeInsets.only(bottom: ShioriSpace.s4),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tokens.color.ink1,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: ShioriSettingsGroup(title: title, children: rows),
    );
  }
}
