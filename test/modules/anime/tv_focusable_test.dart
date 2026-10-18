import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_focusable.dart';

void main() {
  testWidgets('a focused button reads its icon on the accent', (tester) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: TvFocusable(
            accent: const Color(0xFFFFEB3B),
            focusNode: focus,
            onPressed: () {},
            child: const Icon(Icons.replay),
          ),
        ),
      ),
    );
    Color iconColor() =>
        IconTheme.of(tester.element(find.byIcon(Icons.replay))).color!;

    expect(iconColor(), Colors.white);
    focus.requestFocus();
    await tester.pumpAndSettle();
    // White on yellow was unreadable; the light accent takes black.
    expect(iconColor(), const Color(0xFF000000));
  });
}
