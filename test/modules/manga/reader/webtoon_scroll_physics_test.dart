import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/utils/webtoon_scroll_physics.dart';

void main() {
  final strip = FixedScrollMetrics(
    minScrollExtent: 0,
    maxScrollExtent: 100000,
    pixels: 50000,
    viewportDimension: 800,
    axisDirection: AxisDirection.down,
    devicePixelRatio: 3,
  );

  /// Where a released strip comes to rest, and when.
  (double, double) rest(Simulation sim) {
    var t = 0.0;
    while (!sim.isDone(t) && t < 10) {
      t += 1 / 120;
    }
    return (sim.x(t), t);
  }

  group('a released strip', () {
    test('on iOS glides as far and as long as an iOS list', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final released = const WebtoonScrollPhysics().createBallisticSimulation(
        strip,
        1000,
      )!;
      final ios = const BouncingScrollPhysics().createBallisticSimulation(
        strip,
        1000,
      )!;

      final (releasedX, releasedT) = rest(released);
      final (iosX, iosT) = rest(ios);
      expect(releasedX, closeTo(iosX, 1));
      expect(releasedT, closeTo(iosT, 0.05));
      // Android's fling stops this one in under half a second.
      expect(releasedT, greaterThan(2));
    });

    test('on iOS glides away from the end it starts at', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      // A strip at its very top, sent down the chapter.
      final top = strip.copyWith(pixels: 0);
      final glide = const WebtoonScrollPhysics().createBallisticSimulation(
        top,
        1000,
      )!;

      expect(glide.isDone(0), isFalse);
      expect(glide.x(0.5), greaterThan(0));
    });

    test('on Android keeps Android\'s fling', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);

      final released = const WebtoonScrollPhysics().createBallisticSimulation(
        strip,
        1000,
      )!;
      final android = const ClampingScrollPhysics().createBallisticSimulation(
        strip,
        1000,
      )!;

      for (final t in [0.0, 0.1, 0.3, 0.5]) {
        expect(released.x(t), android.x(t));
      }
      expect(rest(released), rest(android));
    });
  });

  group('a strip flung on iOS', () {
    late ScrollController controller;
    late List<double> positions;

    Future<void> pumpStrip(WidgetTester tester) async {
      controller = ScrollController();
      addTearDown(controller.dispose);
      positions = [];
      controller.addListener(() => positions.add(controller.offset));
      await tester.pumpWidget(
        MaterialApp(
          home: ListView.builder(
            controller: controller,
            physics: const WebtoonScrollPhysics(),
            itemCount: 20,
            itemExtent: 600,
            itemBuilder: (_, i) => Text('$i'),
          ),
        ),
      );
    }

    testWidgets('keeps gliding after a gentle flick', (tester) async {
      await pumpStrip(tester);
      await tester.fling(find.byType(ListView), const Offset(0, -150), 1000);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));
      final at800 = controller.offset;
      await tester.pump(const Duration(milliseconds: 400));

      // Still moving most of a second after the finger left.
      expect(controller.offset, greaterThan(at800));
      await tester.pumpAndSettle();
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('stops at the end without bouncing past it', (tester) async {
      await pumpStrip(tester);
      final max = controller.position.maxScrollExtent;
      controller.jumpTo(max - 900);
      positions.clear();

      await tester.fling(find.byType(ListView), const Offset(0, -200), 4000);
      await tester.pumpAndSettle();

      expect(controller.offset, max);
      expect(positions.every((p) => p <= max), isTrue);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('stops at the top without bouncing past it', (tester) async {
      await pumpStrip(tester);
      controller.jumpTo(900);
      positions.clear();

      await tester.fling(find.byType(ListView), const Offset(0, 200), 4000);
      await tester.pumpAndSettle();

      expect(controller.offset, 0);
      expect(positions.every((p) => p >= 0), isTrue);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('glides on when a zoomed page hands it a fling', (
      tester,
    ) async {
      await pumpStrip(tester);

      glideStrip(controller, 2000);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      final at300 = controller.offset;
      await tester.pump(const Duration(milliseconds: 300));

      expect(at300, greaterThan(0));
      expect(controller.offset, greaterThan(at300));
      await tester.pumpAndSettle();
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });

  group('a zoomed page flung along the strip', () {
    test('hands the fling to the strip once it runs past the page edge', () {
      // At the page's top edge, finger moving up: the strip scrolls down.
      expect(
        stripFlingVelocity(offset: -200, maxOffset: 200, velocity: -2000),
        2000,
      );
      // Room for 100 px, a fling of 400 px: runs past the edge.
      expect(
        stripFlingVelocity(offset: 100, maxOffset: 200, velocity: 2000),
        -2000,
      );
    });

    test('keeps a fling the page can absorb', () {
      expect(stripFlingVelocity(offset: 0, maxOffset: 300, velocity: -1000), 0);
    });

    test('keeps a fling away from the edge it sits on', () {
      // At the top edge, moving down into the page's own room.
      expect(
        stripFlingVelocity(offset: -200, maxOffset: 200, velocity: 1500),
        0,
      );
    });
  });
}
