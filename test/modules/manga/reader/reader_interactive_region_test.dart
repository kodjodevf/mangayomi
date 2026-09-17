import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';

void main() {
  testWidgets(
    'ReaderInteractiveHitTestBlocker yields hit-test to ReaderInteractiveRegion',
    (WidgetTester tester) async {
      bool buttonPressed = false;
      bool overlayTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                // Underneath content with retry button
                Center(
                  child: ReaderInteractiveRegion(
                    child: ElevatedButton(
                      onPressed: () {
                        buttonPressed = true;
                      },
                      child: const Text('Retry'),
                    ),
                  ),
                ),
                // Overlaid gesture handler
                Positioned.fill(
                  child: ReaderInteractiveHitTestBlocker(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        overlayTapped = true;
                      },
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Tap on the Retry button
      await tester.tap(find.text('Retry'));
      await tester.pump();

      // The retry button should have been hit, NOT the overlay
      expect(buttonPressed, isTrue);
      expect(overlayTapped, isFalse);

      // Tap on the top-left corner (outside the Retry button)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // The overlay should now be hit
      expect(overlayTapped, isTrue);
    },
  );
}
