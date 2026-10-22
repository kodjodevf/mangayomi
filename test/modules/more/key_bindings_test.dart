import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/player_shortcuts.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';

void main() {
  const ctrlB = KeyCombo(LogicalKeyboardKey.keyB, control: true);

  test('only the changed keys are saved, and read back', () {
    expect(encodeKeyBindings(defaultKeyBindings), isEmpty);
    final saved = encodeKeyBindings({
      ...defaultKeyBindings,
      PlayerShortcut.mute: [ctrlB],
    });
    expect(saved, ['player.mute=c+${LogicalKeyboardKey.keyB.keyId}']);
    final read = resolveKeyBindings([...saved, 'garbage', 'reader.nope=1']);
    expect(read[PlayerShortcut.mute], [ctrlB]);
    expect(read[ReaderShortcut.toggleBars], [
      const KeyCombo(LogicalKeyboardKey.keyM),
    ]);
  });

  testWidgets('the reader follows a rebound key', (tester) async {
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: ReaderKeyboardHandler(
          onNextChapter: () => calls.add('next chapter'),
          bindings: {
            ...defaultKeyBindings,
            ReaderShortcut.nextChapter: [ctrlB],
          },
        ).wrapWithKeyboardListener(child: const SizedBox.expand()),
      ),
    );
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyN);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    expect(calls, isEmpty);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    expect(calls, ['next chapter']);
  });

  test('the lists show the rebound keys', () {
    final bindings = {
      ...defaultKeyBindings,
      PlayerShortcut.mute: [ctrlB],
    };
    final keys = Map.fromEntries(
      playerShortcutKeys(bindings: bindings).map((e) => MapEntry(e.$1, e.$2)),
    );
    expect(keys[PlayerShortcut.mute], ['Ctrl B']);
    expect(keys[PlayerShortcut.showShortcuts], ['?', 'F1']);
    final reader = readerShortcutKeys().map((e) => e.$2).toList();
    expect(reader.first, ['←', '↑', '⇧ Space']);
  });
}
