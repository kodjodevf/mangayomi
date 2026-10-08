import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/unified_settings_sheet.dart';

void main() {
  testWidgets('keeps the mobile top bar below the safe inset', (tester) async {
    const size = Size(320, 568);
    const insets = EdgeInsets.only(top: 44, bottom: 34);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        insets: insets,
        child: const Align(
          alignment: Alignment.topCenter,
          child: MobilePlayerTopSafeArea(
            isDesktop: false,
            child: SizedBox(
              key: ValueKey('top-bar-content'),
              width: 320,
              height: 48,
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getTopLeft(find.byKey(const ValueKey('top-bar-content'))).dy,
      insets.top,
    );
  });

  testWidgets('keeps the locked-player control safe and center-left', (
    tester,
  ) async {
    const size = Size(320, 568);
    const insets = EdgeInsets.only(top: 44, bottom: 34);
    await _setSurfaceSize(tester, size);

    var pressed = false;
    await tester.pumpWidget(
      _testApp(
        size: size,
        insets: insets,
        child: Stack(
          children: [
            Positioned.fill(
              child: MobilePlayerUnlockControl(
                tooltip: 'Unlock',
                onPressed: () => pressed = true,
              ),
            ),
          ],
        ),
      ),
    );

    final button = find.byKey(const ValueKey('mobile-player-unlock-button'));
    final rect = tester.getRect(button);
    expect(rect.width, greaterThanOrEqualTo(48));
    expect(rect.height, greaterThanOrEqualTo(48));
    expect(rect.left, 16);
    expect(rect.center.dy, closeTo(289, 1));

    await tester.tapAt(Offset(rect.center.dx, 20));
    expect(pressed, isFalse);
    await tester.tap(button);
    expect(pressed, isTrue);
  });

  testWidgets('uses two scroll-safe tiers on a narrow portrait screen', (
    tester,
  ) async {
    const size = Size(320, 568);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        textScaler: const TextScaler.linear(2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MobilePlayerBottomControlsLayout(
            lockButton: const SizedBox(
              key: ValueKey('lock-control'),
              width: 48,
              height: 48,
            ),
            seekButton: const SizedBox(
              width: 140,
              height: 44,
              child: Text('+85 seconds'),
            ),
            chapterButton: const SizedBox(
              width: 240,
              height: 44,
              child: Text('A very long chapter marker that must remain usable'),
            ),
            shortcutButtons: const SizedBox(
              key: ValueKey('shortcut-controls'),
              width: 420,
              height: 44,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-bottom-controls-compact')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-bottom-controls-wide')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);

    final primary = tester.getRect(
      find.byKey(const ValueKey('mobile-player-primary-controls')),
    );
    final shortcuts = tester.getRect(
      find.byKey(const ValueKey('mobile-player-shortcuts-scroll')),
    );
    expect(primary.left, greaterThanOrEqualTo(12));
    expect(primary.right, lessThanOrEqualTo(size.width - 12));
    expect(primary.bottom, lessThanOrEqualTo(shortcuts.top));
    expect(shortcuts.right, lessThanOrEqualTo(size.width - 12));
  });

  testWidgets('keeps one row in landscape', (tester) async {
    const size = Size(568, 320);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MobilePlayerBottomControlsLayout(
            lockButton: const SizedBox(
              key: ValueKey('lock-control'),
              width: 48,
              height: 48,
            ),
            seekButton: const SizedBox(width: 120, height: 44),
            chapterButton: const SizedBox(width: 100, height: 44),
            shortcutButtons: const SizedBox(
              key: ValueKey('shortcut-controls'),
              width: 240,
              height: 44,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-bottom-controls-wide')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-bottom-controls-compact')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getCenter(find.byKey(const ValueKey('lock-control'))).dy,
      closeTo(
        tester.getCenter(find.byKey(const ValueKey('shortcut-controls'))).dy,
        1,
      ),
    );
  });

  testWidgets('compact shortcut pills retain a 44 point tap target', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PlayerPillButton(
              isCompact: true,
              icon: Icons.speed,
              label: '1.0x',
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    final button = find.byType(PlayerPillButton);
    expect(tester.getSize(button).height, greaterThanOrEqualTo(44));
    expect(tester.getSize(button).width, greaterThanOrEqualTo(44));
  });
}

Widget _testApp({
  required Size size,
  required Widget child,
  EdgeInsets insets = EdgeInsets.zero,
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        padding: insets,
        viewPadding: insets,
        textScaler: textScaler,
      ),
      child: Scaffold(body: child),
    ),
  );
}

Future<void> _setSurfaceSize(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}
