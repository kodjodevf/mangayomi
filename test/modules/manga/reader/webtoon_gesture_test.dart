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

  group('a drag over a webtoon page', () {
    late int panUpdates;
    late int listDrags;

    // The webtoon list's vertical drag, competing with the page's pan the
    // way SuperListView does in the reader.
    Future<void> pumpPage(WidgetTester tester, {required bool zoomed}) async {
      panUpdates = 0;
      listDrags = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              VerticalDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                    VerticalDragGestureRecognizer
                  >(() => VerticalDragGestureRecognizer(), (instance) {
                    instance.onUpdate = (_) => listDrags++;
                  }),
            },
            child: RawGestureDetector(
              behavior: HitTestBehavior.opaque,
              gestures: <Type, GestureRecognizerFactory>{
                WebtoonScaleGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                      WebtoonScaleGestureRecognizer
                    >(() => WebtoonScaleGestureRecognizer(), (instance) {
                      instance.canPanCallback = () => zoomed;
                      instance.onUpdate = (_) => panUpdates++;
                    }),
              },
              child: const SizedBox.expand(),
            ),
          ),
        ),
      );
    }

    Future<void> diagonalDrag(WidgetTester tester) async {
      final gesture = await tester.startGesture(const Offset(200, 300));
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(6, 8));
        await tester.pump();
      }
      await gesture.up();
    }

    testWidgets('pans a zoomed page instead of scrolling the list', (
      tester,
    ) async {
      // Without claiming the drag early, the list's smaller slop won every
      // vertical or diagonal drag and the zoomed page could not move
      // sideways (#1021).
      await pumpPage(tester, zoomed: true);
      await diagonalDrag(tester);

      expect(panUpdates, greaterThan(0));
      expect(listDrags, 0);
    });

    testWidgets('scrolls the list when the page is not zoomed', (tester) async {
      await pumpPage(tester, zoomed: false);
      await diagonalDrag(tester);

      expect(listDrags, greaterThan(0));
      expect(panUpdates, 0);
    });
  });
}
