import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/utils/player_focus.dart';

void main() {
  testWidgets('restores player focus before a focused control is removed', (
    tester,
  ) async {
    final playerFocusNode = FocusNode();
    final controlFocusNode = FocusNode();
    addTearDown(playerFocusNode.dispose);
    addTearDown(controlFocusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Focus(
          focusNode: playerFocusNode,
          child: Focus(focusNode: controlFocusNode, child: const SizedBox()),
        ),
      ),
    );
    controlFocusNode.requestFocus();
    await tester.pump();

    expect(controlFocusNode.hasPrimaryFocus, isTrue);
    expect(playerFocusNode.hasFocus, isTrue);

    restorePlayerFocusBeforeUnmount(playerFocusNode);
    await tester.pump();

    expect(playerFocusNode.hasPrimaryFocus, isTrue);
  });

  testWidgets('does not steal focus from outside the player', (tester) async {
    final playerFocusNode = FocusNode();
    final externalFocusNode = FocusNode();
    addTearDown(playerFocusNode.dispose);
    addTearDown(externalFocusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Focus(focusNode: playerFocusNode, child: const SizedBox()),
            Focus(focusNode: externalFocusNode, child: const SizedBox()),
          ],
        ),
      ),
    );
    externalFocusNode.requestFocus();
    await tester.pump();

    restorePlayerFocusBeforeUnmount(playerFocusNode);
    await tester.pump();

    expect(externalFocusNode.hasPrimaryFocus, isTrue);
    expect(playerFocusNode.hasFocus, isFalse);
  });
}
