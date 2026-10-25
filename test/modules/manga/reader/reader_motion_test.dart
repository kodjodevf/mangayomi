import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_motion.dart';

void main() {
  group('a page settles', () {
    test('turned by a tap: 100 ms a page plus 100 ms', () {
      expect(
        ReaderMotion.settle(distance: 1080, extent: 1080),
        const Duration(milliseconds: 200),
      );
    });

    test('released fast: as quick as the finger was', () {
      final fast = ReaderMotion.settle(
        distance: 540,
        extent: 1080,
        velocity: 6000,
      );
      final slow = ReaderMotion.settle(
        distance: 540,
        extent: 1080,
        velocity: 2000,
      );
      expect(fast, const Duration(milliseconds: 360));
      expect(slow, ReaderMotion.maxSettle);
    });

    test('the direction of the speed does not matter', () {
      expect(
        ReaderMotion.settle(distance: -540, extent: 1080, velocity: -6000),
        ReaderMotion.settle(distance: 540, extent: 1080, velocity: 6000),
      );
    });

    test('already in place: no motion', () {
      expect(
        ReaderMotion.settle(distance: 0, extent: 1080, velocity: 3000),
        Duration.zero,
      );
    });
  });

  test('a strip scrolls three quarters of a screen in 525 ms', () {
    expect(
      ReaderMotion.scroll(distance: 1800, extent: 2400),
      const Duration(milliseconds: 525),
    );
  });

  group('a double-tap zoom', () {
    test('normal, fast and none', () {
      expect(ReaderMotion.doubleTapZoom(1).inMilliseconds, 500);
      expect(ReaderMotion.doubleTapZoom(2).inMilliseconds, 250);
      expect(ReaderMotion.doubleTapZoom(0).inMilliseconds, 1);
    });

    test('on a strip, quicker unless none', () {
      expect(ReaderMotion.stripDoubleTapZoom(1).inMilliseconds, 200);
      expect(ReaderMotion.stripDoubleTapZoom(2).inMilliseconds, 200);
      expect(ReaderMotion.stripDoubleTapZoom(0).inMilliseconds, 1);
    });
  });

  test('a fling leaves at the speed of the finger', () {
    // Decelerating from a slope of 2, over the travel and time given.
    const velocity = 3000.0;
    final travel = velocity * ReaderMotion.flingTravel;
    final seconds = ReaderMotion.flingDuration.inMicroseconds / 1e6;
    const dt = 1e-4;
    final start = Curves.decelerate.transform(dt) / dt * travel / seconds;
    expect(start, closeTo(velocity, velocity * 0.01));
  });

  test('the quintic curve lands softly', () {
    const curve = ReaderMotion.quinticOut;
    expect(curve.transform(0), 0);
    expect(curve.transform(1), 1);
    expect(curve.transform(0.5), closeTo(0.96875, 1e-9));
  });
}
