import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/platform_utils.dart';

void main() {
  // Detection never runs here (initIsTv is Android only and no engine is up),
  // so the baseline is always the off-TV layout.
  tearDown(() => debugIsTvOverride = null);

  group('isTv', () {
    test('follows detection by default, which is false off a TV', () {
      expect(isTv, isFalse);
    });

    test('override forces the TV layout on', () {
      debugIsTvOverride = true;
      expect(isTv, isTrue);
    });

    test('override forces the TV layout off', () {
      debugIsTvOverride = false;
      expect(isTv, isFalse);
    });

    test('clearing the override goes back to detection', () {
      debugIsTvOverride = true;
      expect(isTv, isTrue);
      debugIsTvOverride = null;
      expect(isTv, isFalse);
    });
  });

  group('tvPageInsets', () {
    test('is zero off TV, so phone and desktop layouts are unchanged', () {
      expect(tvPageInsets, EdgeInsets.zero);
    });

    test('adds horizontal room for panel overscan on TV', () {
      debugIsTvOverride = true;
      expect(tvPageInsets, const EdgeInsets.symmetric(horizontal: 16));
    });
  });
}
