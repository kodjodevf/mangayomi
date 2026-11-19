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

  group('isWaylandSession', () {
    test('a Wayland display with no backend asked for is Wayland', () {
      expect(isWaylandSession({'WAYLAND_DISPLAY': 'wayland-1'}), isTrue);
      expect(
        isWaylandSession({'WAYLAND_DISPLAY': 'wayland-1', 'GDK_BACKEND': ''}),
        isTrue,
      );
    });

    test('X11 asked for first is not, Wayland display or not', () {
      expect(
        isWaylandSession({
          'WAYLAND_DISPLAY': 'wayland-1',
          'GDK_BACKEND': 'x11',
        }),
        isFalse,
      );
      expect(
        isWaylandSession({
          'WAYLAND_DISPLAY': 'wayland-1',
          'GDK_BACKEND': 'x11,wayland',
        }),
        isFalse,
      );
    });

    test('Wayland asked for first is, when there is a display', () {
      expect(
        isWaylandSession({
          'WAYLAND_DISPLAY': 'wayland-1',
          'GDK_BACKEND': ' wayland , x11',
        }),
        isTrue,
      );
      expect(
        isWaylandSession({'WAYLAND_DISPLAY': 'wayland-1', 'GDK_BACKEND': '*'}),
        isTrue,
      );
    });

    test('without a Wayland display GDK falls back to X11', () {
      expect(isWaylandSession({'DISPLAY': ':0'}), isFalse);
      expect(isWaylandSession({'GDK_BACKEND': 'wayland,x11'}), isFalse);
      expect(isWaylandSession({'WAYLAND_DISPLAY': ''}), isFalse);
    });
  });
}
