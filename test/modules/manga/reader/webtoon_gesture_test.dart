import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';

void main() {
  test('WebtoonScaleGestureRecognizer converts accepted to rejected when unzoomed with < 2 pointers', () {
    var canPan = false;
    final recognizer = WebtoonScaleGestureRecognizer(
      canPanCallback: () => canPan,
    );

    // Unzoomed, 0 or 1 pointers -> should reject
    expect(
      recognizer.resolveDisposition(GestureDisposition.accepted),
      GestureDisposition.rejected,
    );

    // Zoomed (canPan = true) -> should accept
    canPan = true;
    expect(
      recognizer.resolveDisposition(GestureDisposition.accepted),
      GestureDisposition.accepted,
    );

    // Already rejected -> remains rejected
    expect(
      recognizer.resolveDisposition(GestureDisposition.rejected),
      GestureDisposition.rejected,
    );
  });

  testWidgets(
    'zoomed webtoon leaves small pointer jitter available to double tap',
    (tester) async {
      var doubleTapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RawGestureDetector(
              behavior: HitTestBehavior.opaque,
              gestures: <Type, GestureRecognizerFactory>{
                WebtoonScaleGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                      WebtoonScaleGestureRecognizer
                    >(() => WebtoonScaleGestureRecognizer(), (instance) {
                      instance.canPanCallback = () => true;
                      instance.onStart = (_) {};
                    }),
                DoubleTapGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                      DoubleTapGestureRecognizer
                    >(() => DoubleTapGestureRecognizer(), (instance) {
                      instance.onDoubleTap = () => doubleTapCount++;
                    }),
              },
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );

      Future<void> jitteryTap() async {
        final gesture = await tester.startGesture(const Offset(200, 200));
        await gesture.moveBy(const Offset(1, 0));
        await gesture.up();
      }

      await jitteryTap();
      await tester.pump(const Duration(milliseconds: 40));
      await jitteryTap();
      await tester.pump();

      expect(doubleTapCount, 1);
      await tester.pump(kDoubleTapTimeout);
    },
  );
}
