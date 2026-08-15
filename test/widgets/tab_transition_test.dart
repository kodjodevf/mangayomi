import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/main_view/providers/swipe_tabs_provider.dart';
import 'package:mangayomi/modules/main_view/tab_transition.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  group('slideBetween', () {
    test('a tab to the right comes in from the right', () {
      expect(slideBetween(0, 1), 1);
      expect(slideBetween(2, 6), 1);
    });

    test('a tab to the left comes in from the left', () {
      expect(slideBetween(1, 0), -1);
      expect(slideBetween(6, 2), -1);
    });

    test('the tab already open does not slide', () {
      expect(slideBetween(3, 3), 0);
    });

    test('direction is the side, not the distance', () {
      // Neighbours and opposite ends read the same: the page comes from one
      // side or the other, it does not travel further for being further away.
      expect(slideBetween(0, 1), slideBetween(0, 7));
      expect(slideBetween(7, 6), slideBetween(7, 0));
    });
  });

  group('tabSlide', () {
    tearDown(() => setTabSlide(0));

    test('holds what was last recorded', () {
      setTabSlide(1);
      expect(tabSlide, 1);
      setTabSlide(-1);
      expect(tabSlide, -1);
    });

    test('zero means the page arrives with no transition', () {
      setTabSlide(-1);
      setTabSlide(0);
      expect(tabSlide, 0);
    });
  });

  group('swipeBetweenTabsSupported', () {
    tearDown(() => debugIsTvOverride = null);

    test('never on a TV, which has no touchscreen to swipe', () {
      debugIsTvOverride = true;
      expect(swipeBetweenTabsSupported, isFalse);
    });

    test('never on desktop, where the pointer is a mouse', () {
      debugIsTvOverride = false;
      expect(
        swipeBetweenTabsSupported,
        !isDesktop,
        reason: 'the test host is a desktop, so this must be off here',
      );
    });

    test('follows TV detection landing after the first read', () {
      debugIsTvOverride = false;
      final before = swipeBetweenTabsSupported;
      debugIsTvOverride = true;
      expect(swipeBetweenTabsSupported, isFalse);
      expect(before, !isDesktop);
    });
  });
}
