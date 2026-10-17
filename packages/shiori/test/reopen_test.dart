import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

void main() {
  for (final kind in ['choice', 'multi', 'prompt']) {
    testWidgets('$kind opens again after Escape dismissed it', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: buildShioriTheme(
            brightness: Brightness.light,
            colors: FlexColor.schemesList[2].light,
            tintSurfaces: false,
            blendLevel: 10,
            density: ShioriDensity.desktop,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => switch (kind) {
                  'choice' => showShioriChoice<int>(
                    context,
                    title: 'T',
                    selected: 1,
                    options: const [ShioriChoice(1, 'a'), ShioriChoice(2, 'b')],
                  ),
                  'multi' => showShioriMultiChoice<int>(
                    context,
                    title: 'T',
                    options: const [ShioriChoice(1, 'a'), ShioriChoice(2, 'b')],
                  ),
                  _ => showShioriPrompt(
                    context,
                    title: 'T',
                    confirmLabel: 'OK',
                    initialValue: 'x',
                  ),
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        expect(find.text('T'), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('T'), findsNothing);
      }
    });
  }
}
