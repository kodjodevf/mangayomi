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

  group('tvHorizontalSafeInset', () {
    testWidgets('is zero away from TV layouts', (tester) async {
      late double inset;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(960, 540)),
          child: Builder(
            builder: (context) {
              inset = tvHorizontalSafeInset(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(inset, 0);
    });

    testWidgets('uses five percent with compact and large TV clamps', (
      tester,
    ) async {
      debugIsTvOverride = true;

      Future<double> insetFor(Size size) async {
        late double inset;
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(size: size),
            child: Builder(
              builder: (context) {
                inset = tvHorizontalSafeInset(context);
                return const SizedBox();
              },
            ),
          ),
        );
        return inset;
      }

      expect(await insetFor(const Size(400, 300)), 24);
      expect(await insetFor(const Size(960, 540)), 48);
      expect(await insetFor(const Size(1920, 1080)), 64);
    });
  });
}
