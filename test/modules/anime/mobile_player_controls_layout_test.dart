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

  testWidgets('uses a two-row top bar on compact portrait', (tester) async {
    const size = Size(300, 568);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        textScaler: const TextScaler.linear(2),
        child: const Align(
          alignment: Alignment.topCenter,
          child: MobilePlayerTopControlsLayout(
            compactPortrait: true,
            backButton: SizedBox(
              key: ValueKey('portrait-back'),
              width: 48,
              height: 48,
            ),
            title: SizedBox(
              key: ValueKey('portrait-title'),
              height: 48,
              child: Text('A long title that still has its own row'),
            ),
            wideActions: SizedBox(
              key: ValueKey('wide-top-actions'),
              width: 160,
              height: 48,
            ),
            portraitActions: SizedBox(
              key: ValueKey('portrait-top-actions'),
              width: 260,
              height: 48,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-portrait')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-wide')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('portrait-top-actions')), findsOneWidget);
    expect(find.byKey(const ValueKey('wide-top-actions')), findsNothing);
    expect(
      find.byKey(const ValueKey('mobile-player-portrait-actions-scroll')),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('portrait-title'))).dy,
      greaterThanOrEqualTo(
        tester.getBottomLeft(find.byKey(const ValueKey('portrait-back'))).dy,
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps the original one-row top bar in landscape', (
    tester,
  ) async {
    const size = Size(568, 320);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: const Align(
          alignment: Alignment.topCenter,
          child: MobilePlayerTopControlsLayout(
            compactPortrait: false,
            backButton: SizedBox(width: 48, height: 48),
            title: SizedBox(key: ValueKey('wide-title'), height: 48),
            wideActions: SizedBox(
              key: ValueKey('wide-top-actions'),
              width: 160,
              height: 48,
            ),
            portraitActions: SizedBox(
              key: ValueKey('portrait-top-actions'),
              width: 240,
              height: 48,
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-wide')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-portrait')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('wide-top-actions')), findsOneWidget);
    expect(find.byKey(const ValueKey('portrait-top-actions')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses the caller top layout decision at the 600px breakpoint', (
    tester,
  ) async {
    const size = Size(600, 800);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: const Center(
          child: SizedBox(
            width: 580,
            child: MobilePlayerTopControlsLayout(
              compactPortrait: false,
              backButton: SizedBox(width: 48, height: 48),
              title: SizedBox(height: 48),
              wideActions: SizedBox(width: 120, height: 48),
              portraitActions: SizedBox(width: 240, height: 48),
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-wide')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-top-controls-portrait')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
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

  testWidgets('keeps only curated actions in the compact portrait footer', (
    tester,
  ) async {
    const size = Size(390, 844);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        textScaler: const TextScaler.linear(2),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MobilePlayerBottomControlsLayout(
            compactPortrait: true,
            lockButton: const SizedBox(
              key: ValueKey('lock-control'),
              width: 48,
              height: 48,
            ),
            seekButton: PlayerPillButton(
              key: const ValueKey('compact-seek-control'),
              isCompact: true,
              icon: Icons.fast_forward_rounded,
              label: '+85 seconds',
              showLabel: false,
              tooltip: '+85 seconds',
              onTap: () {},
            ),
            chapterButton: PlayerPillButton(
              key: const ValueKey('compact-chapter-control'),
              isCompact: true,
              icon: Icons.bookmark_outline,
              label: 'A very long chapter marker that must remain usable',
              showLabel: false,
              tooltip: 'A very long chapter marker that must remain usable',
              onTap: () {},
            ),
            shortcutButtons: const SizedBox(
              key: ValueKey('shortcut-controls'),
              width: 48,
              height: 48,
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

    final row = tester.getRect(
      find.byKey(const ValueKey('mobile-player-compact-controls-row')),
    );
    final lock = find.byKey(const ValueKey('lock-control'));
    final seek = find.byKey(const ValueKey('compact-seek-control'));
    final chapter = find.byKey(const ValueKey('compact-chapter-control'));
    final shortcuts = find.byKey(const ValueKey('shortcut-controls'));
    final centerY = tester.getCenter(lock).dy;

    expect(row.left, greaterThanOrEqualTo(12));
    expect(row.right, lessThanOrEqualTo(size.width - 12));
    expect(tester.getCenter(seek).dy, closeTo(centerY, 1));
    expect(tester.getCenter(shortcuts).dy, closeTo(centerY, 1));
    expect(chapter, findsNothing);
    expect(find.text('+85 seconds'), findsNothing);
    expect(
      find.text('A very long chapter marker that must remain usable'),
      findsNothing,
    );
    expect(tester.getRect(shortcuts).right, lessThanOrEqualTo(size.width - 12));
  });

  testWidgets('compact portrait footer fits a 320px screen at 2x text', (
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
            compactPortrait: true,
            lockButton: const SizedBox(
              key: ValueKey('overflow-lock-control'),
              width: 48,
              height: 48,
            ),
            seekButton: const SizedBox(
              key: ValueKey('small-seek-control'),
              width: 48,
              height: 48,
            ),
            chapterButton: const SizedBox(
              key: ValueKey('hidden-small-chapter'),
              width: 48,
              height: 48,
            ),
            shortcutButtons: const SizedBox(
              key: ValueKey('small-fullscreen-control'),
              width: 48,
              height: 48,
            ),
          ),
        ),
      ),
    );

    final lock = find.byKey(const ValueKey('overflow-lock-control'));
    final seek = find.byKey(const ValueKey('small-seek-control'));
    final fullscreen = find.byKey(const ValueKey('small-fullscreen-control'));

    expect(tester.takeException(), isNull);
    expect(tester.getRect(lock).left, greaterThanOrEqualTo(12));
    expect(tester.getRect(seek).left, greaterThan(tester.getRect(lock).right));
    expect(
      tester.getRect(fullscreen).right,
      lessThanOrEqualTo(size.width - 12),
    );
    expect(find.byKey(const ValueKey('hidden-small-chapter')), findsNothing);
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
            compactPortrait: false,
            lockButton: const SizedBox(
              key: ValueKey('lock-control'),
              width: 48,
              height: 48,
            ),
            seekButton: const SizedBox(width: 120, height: 35),
            chapterButton: const SizedBox(width: 100, height: 35),
            shortcutButtons: const SizedBox(
              key: ValueKey('shortcut-controls'),
              width: 240,
              height: 35,
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

  testWidgets('uses the caller layout decision at the 600px breakpoint', (
    tester,
  ) async {
    const size = Size(600, 800);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        child: Center(
          child: SizedBox(
            width: 580,
            child: MobilePlayerBottomControlsLayout(
              compactPortrait: false,
              lockButton: const SizedBox(width: 48, height: 48),
              seekButton: const SizedBox(width: 80, height: 35),
              chapterButton: const SizedBox(width: 80, height: 35),
              shortcutButtons: const SizedBox(width: 300, height: 35),
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
  });

  testWidgets('compact shortcut pills use the original visual sizing', (
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
    expect(tester.getSize(button).height, lessThan(44));
    expect(tester.widget<Icon>(find.byIcon(Icons.speed)).size, 14);
    expect(tester.widget<Text>(find.text('1.0x')).style?.fontSize, 11);
  });

  testWidgets('icon-only shortcut keeps its icon and tooltip', (tester) async {
    var longPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PlayerPillButton(
              isCompact: true,
              icon: Icons.speed,
              label: '1.0x',
              showLabel: false,
              tooltip: 'Playback speed',
              onTap: () {},
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.speed), findsOneWidget);
    expect(find.text('1.0x'), findsNothing);
    expect(
      tester.widget<Tooltip>(find.byType(Tooltip)).message,
      'Playback speed',
    );
    final semanticsWidgets = tester.widgetList<Semantics>(
      find.descendant(
        of: find.byType(PlayerPillButton),
        matching: find.byType(Semantics),
      ),
    );
    expect(
      semanticsWidgets.any((widget) => widget.properties.value == '1.0x'),
      isTrue,
    );
    await tester.longPress(find.byType(PlayerPillButton));
    expect(longPressed, isTrue);
  });

  test('uses icon-only controls only below the portrait breakpoint', () {
    expect(
      usesCompactPortraitPlayerControls(
        orientation: Orientation.portrait,
        width: 390,
      ),
      isTrue,
    );
    expect(
      usesCompactPortraitPlayerControls(
        orientation: Orientation.portrait,
        width: 600,
      ),
      isFalse,
    );
    expect(
      usesCompactPortraitPlayerControls(
        orientation: Orientation.landscape,
        width: 390,
      ),
      isFalse,
    );
  });

  testWidgets('settings home can run a portrait-only action', (tester) async {
    var actionCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsDrilldown(
            title: 'Settings',
            entries: [
              SettingsEntry(
                label: 'Share',
                icon: Icons.share_outlined,
                onTap: (_) => actionCalled = true,
              ),
            ],
            onClose: () {},
            initialIndex: 0,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Share'));
    await tester.pump();

    expect(actionCalled, isTrue);
    expect(find.byKey(const ValueKey('home')), findsOneWidget);
    expect(find.byKey(const ValueKey('section-0')), findsNothing);
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
