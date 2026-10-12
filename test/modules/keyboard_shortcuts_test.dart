import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/shortcuts.dart';

void main() {
  test('nothing saved means every default', () {
    expect(resolveShortcuts(null), defaultShortcuts);
  });

  test('a saved key replaces the default of that action only', () {
    final keyB = LogicalKeyboardKey.keyB.keyId;
    final shortcuts = resolveShortcuts(['previousEpisode=c+$keyB']);
    expect(shortcuts[ShortcutAction.previousEpisode], [
      const KeyCombo(LogicalKeyboardKey.keyB, control: true),
    ]);
    expect(
      shortcuts[ShortcutAction.nextEpisode],
      defaultShortcuts[ShortcutAction.nextEpisode],
    );
  });

  test('a backup with junk in it does not break the defaults', () {
    final shortcuts = resolveShortcuts([
      'gone=1',
      'no equals sign',
      'mute=not-a-number',
      'a=b=c',
    ]);
    expect(
      shortcuts[ShortcutAction.mute],
      defaultShortcuts[ShortcutAction.mute],
    );
    expect(
      shortcuts[ShortcutAction.nextPage],
      defaultShortcuts[ShortcutAction.nextPage],
    );
  });

  test(
    'the same key finds a different action in the reader and the player',
    () {
      final shortcuts = resolveShortcuts(null);
      expect(
        shortcutFor(
          shortcuts,
          const KeyCombo(LogicalKeyboardKey.keyM),
          ShortcutAction.values.where((a) => a.isReader),
        ),
        ShortcutAction.toggleMenu,
      );
      expect(
        shortcutFor(
          shortcuts,
          const KeyCombo(LogicalKeyboardKey.keyM),
          ShortcutAction.values.where((a) => !a.isReader),
        ),
        ShortcutAction.mute,
      );
    },
  );

  test('a combination saves and loads with its modifiers', () {
    const combo = KeyCombo(LogicalKeyboardKey.keyB, control: true, shift: true);
    expect(KeyCombo.decode(combo.encode()), combo);
    expect(
      KeyCombo.decode(LogicalKeyboardKey.keyB.keyId.toString()),
      const KeyCombo(LogicalKeyboardKey.keyB),
    );
    expect(combo, isNot(const KeyCombo(LogicalKeyboardKey.keyB)));
  });
}
