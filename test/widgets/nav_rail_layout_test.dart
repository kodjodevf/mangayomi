import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

void main() {
  testWidgets('a phone in landscape is still a phone', (tester) async {
    late bool rail;
    Future<void> pumpAt(Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              rail = context.prefersNavRail;
              return const SizedBox();
            },
          ),
        ),
      );
    }

    addTearDown(tester.view.reset);

    await pumpAt(const Size(390, 844));
    expect(rail, isFalse, reason: 'portrait phone');

    // Over 600 wide, but the short side gives it away.
    await pumpAt(const Size(844, 390));
    expect(rail, isFalse, reason: 'the same phone, rotated');

    await pumpAt(const Size(1024, 768));
    expect(rail, isTrue, reason: 'a tablet in either orientation');

    await pumpAt(const Size(768, 1024));
    expect(rail, isTrue);
  });
}
