import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/main_view/nav_shrink.dart';

void main() {
  group('NavShrink', () {
    test('rests until the scroll down is sustained', () {
      final shrink = NavShrink();
      expect(shrink.update(NavShrink.downTrigger - 1), isFalse);
      expect(shrink.shrunk, isFalse);
      expect(shrink.update(1), isTrue);
      expect(shrink.shrunk, isTrue);
    });

    test('a nudge either way leaves it alone', () {
      final shrink = NavShrink();
      for (var i = 0; i < 20; i++) {
        shrink.update(i.isEven ? 12 : -12);
      }
      expect(shrink.shrunk, isFalse);
    });

    test('changing direction starts the run over', () {
      final shrink = NavShrink();
      shrink.update(NavShrink.downTrigger - 5);
      shrink.update(-1); // direction flip discards the run so far
      expect(shrink.update(5), isFalse);
      expect(shrink.shrunk, isFalse);
    });

    test('comes back on a shorter scroll up than it took to shrink', () {
      final shrink = NavShrink();
      shrink.update(NavShrink.downTrigger);
      expect(shrink.shrunk, isTrue);

      expect(shrink.update(-(NavShrink.upRelease - 1)), isFalse);
      expect(shrink.shrunk, isTrue);
      expect(shrink.update(-1), isTrue);
      expect(shrink.shrunk, isFalse);

      expect(
        NavShrink.upRelease,
        lessThan(NavShrink.downTrigger),
        reason: 'reaching for the bar should beat hiding it',
      );
    });

    test('does not re-report a state it is already in', () {
      final shrink = NavShrink();
      shrink.update(NavShrink.downTrigger);
      expect(shrink.update(NavShrink.downTrigger * 3), isFalse);
      expect(shrink.shrunk, isTrue);
    });

    test('reset only reports when it had something to undo', () {
      final shrink = NavShrink();
      expect(shrink.reset(), isFalse);
      shrink.update(NavShrink.downTrigger);
      expect(shrink.reset(), isTrue);
      expect(shrink.shrunk, isFalse);
    });

    test('reset also clears a part-built run', () {
      final shrink = NavShrink();
      shrink.update(NavShrink.downTrigger - 1);
      shrink.reset();
      expect(shrink.update(1), isFalse);
      expect(shrink.shrunk, isFalse);
    });

    test('a zero delta is not a direction', () {
      final shrink = NavShrink();
      shrink.update(NavShrink.downTrigger - 1);
      expect(shrink.update(0), isFalse);
      expect(shrink.update(1), isTrue, reason: 'the run should have survived');
    });
  });
}
