import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/anime/widgets/mobile_player_controls_layout.dart';
import 'package:mangayomi/modules/anime/widgets/tv_player_pills.dart';
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

  testWidgets('keeps title and actions in one compact portrait row', (
    tester,
  ) async {
    const size = Size(320, 568);
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
              child: Text(
                'A long title that must truncate before the actions',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            wideActions: SizedBox(
              key: ValueKey('wide-top-actions'),
              width: 160,
              height: 48,
            ),
            portraitActions: SizedBox(
              key: ValueKey('portrait-top-actions'),
              width: 196,
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
    final portrait = tester.getRect(
      find.byKey(const ValueKey('mobile-player-top-controls-portrait')),
    );
    final back = tester.getRect(find.byKey(const ValueKey('portrait-back')));
    final title = tester.getRect(find.byKey(const ValueKey('portrait-title')));
    final actions = tester.getRect(
      find.byKey(const ValueKey('portrait-top-actions')),
    );
    expect(title.left, greaterThanOrEqualTo(back.right));
    expect(title.center.dy, closeTo(back.center.dy, 1));
    expect(actions.left, greaterThanOrEqualTo(title.right));
    expect(actions.center.dy, closeTo(title.center.dy, 1));
    expect(actions.right, lessThanOrEqualTo(portrait.right));
    expect(title.width, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('centers compact primary controls on the full player surface', (
    tester,
  ) async {
    const size = Size(320, 568);
    const insets = EdgeInsets.only(left: 5, right: 7, bottom: 34);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        insets: insets,
        child: const MobilePlayerControlsOverlayLayout(
          compactPortrait: true,
          safeInsets: insets,
          topControls: SizedBox(
            key: ValueKey('asymmetric-top-controls'),
            height: 112,
          ),
          primaryControls: Center(
            child: SizedBox(
              key: ValueKey('centered-primary-controls'),
              width: 120,
              height: 56,
            ),
          ),
          bottomControls: SizedBox(
            key: ValueKey('asymmetric-bottom-controls'),
            height: 72,
          ),
        ),
      ),
    );

    final primary = tester.getRect(
      find.byKey(const ValueKey('centered-primary-controls')),
    );
    final top = tester.getRect(
      find.byKey(const ValueKey('asymmetric-top-controls')),
    );
    final bottom = tester.getRect(
      find.byKey(const ValueKey('asymmetric-bottom-controls')),
    );
    expect(primary.center.dx, closeTo(size.width / 2, 0.1));
    expect(primary.center.dy, closeTo(size.height / 2, 0.1));
    expect(top.left, insets.left);
    expect(top.right, size.width - insets.right);
    expect(bottom.left, insets.left);
    expect(bottom.right, size.width - insets.right);
    expect(bottom.bottom, size.height - insets.bottom);
    expect(tester.takeException(), isNull);
  });

  testWidgets('centers landscape controls between the title and seek rows', (
    tester,
  ) async {
    const size = Size(568, 320);
    const insets = EdgeInsets.only(left: 47, right: 21, bottom: 9);
    await _setSurfaceSize(tester, size);

    await tester.pumpWidget(
      _testApp(
        size: size,
        insets: insets,
        child: const MobilePlayerControlsOverlayLayout(
          compactPortrait: false,
          safeInsets: insets,
          topControls: SizedBox(
            key: ValueKey('wide-overlay-top'),
            width: double.infinity,
            height: 48,
          ),
          primaryControls: Center(
            child: SizedBox(
              key: ValueKey('wide-overlay-primary'),
              width: 120,
              height: 56,
            ),
          ),
          bottomControls: SizedBox(
            key: ValueKey('wide-overlay-bottom'),
            width: double.infinity,
            height: 72,
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('mobile-player-controls-overlay-wide')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('mobile-player-controls-overlay-portrait')),
      findsNothing,
    );
    final top = tester.getRect(find.byKey(const ValueKey('wide-overlay-top')));
    final primary = tester.getRect(
      find.byKey(const ValueKey('wide-overlay-primary')),
    );
    final bottom = tester.getRect(
      find.byKey(const ValueKey('wide-overlay-bottom')),
    );
    expect(top.left, insets.left);
    expect(top.right, size.width - insets.right);
    expect(primary.center.dx, closeTo(size.width / 2, 0.1));
    expect(primary.center.dy, closeTo((top.bottom + bottom.top) / 2, 0.1));
    expect(primary.center.dy, lessThan(size.height / 2));
    expect(bottom.left, insets.left);
    expect(bottom.right, size.width - insets.right);
    expect(bottom.bottom, size.height - insets.bottom);
    expect(tester.takeException(), isNull);
  });

  test('keeps episode navigation buttons free of a resting tint', () {
    final style = mobilePlayerEpisodeNavigationButtonStyle();

    expect(style.backgroundColor?.resolve({}), Colors.transparent);
    expect(
      style.backgroundColor?.resolve({WidgetState.disabled}),
      Colors.transparent,
    );
    expect(style.foregroundColor?.resolve({}), Colors.white);
    expect(
      style.foregroundColor?.resolve({WidgetState.disabled}),
      Colors.white.withValues(alpha: 0.35),
    );
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
    expect(tester.getCenter(lock).dx, lessThan(row.center.dx));
    expect(tester.getCenter(seek).dx, greaterThan(row.center.dx));
    expect(
      tester.getRect(seek).right,
      lessThanOrEqualTo(tester.getRect(shortcuts).left),
    );
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
    final row = tester.getRect(
      find.byKey(const ValueKey('mobile-player-compact-controls-row')),
    );
    expect(tester.getCenter(lock).dx, lessThan(row.center.dx));
    expect(tester.getCenter(seek).dx, greaterThan(row.center.dx));
    expect(
      tester.getRect(seek).right,
      lessThanOrEqualTo(tester.getRect(fullscreen).left),
    );
    expect(
      tester.getRect(fullscreen).right,
      lessThanOrEqualTo(size.width - 12),
    );
    expect(find.byKey(const ValueKey('hidden-small-chapter')), findsNothing);
  });

  testWidgets(
    'uses one icon size for portrait actions without changing autoplay',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MobilePlayerPortraitActionTheme(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      key: const ValueKey('episode-action'),
                      onPressed: () {},
                      icon: const Icon(Icons.format_list_numbered_outlined),
                    ),
                    IconButton(
                      key: const ValueKey('caption-action'),
                      onPressed: () {},
                      icon: const Icon(Icons.closed_caption_outlined),
                    ),
                    IconButton(
                      key: const ValueKey('settings-action'),
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined),
                    ),
                    const AutoplaySwitch(
                      key: ValueKey('portrait-autoplay'),
                      on: true,
                      accent: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      for (final icon in <IconData>[
        Icons.format_list_numbered_outlined,
        Icons.closed_caption_outlined,
        Icons.settings_outlined,
      ]) {
        expect(
          tester.getSize(find.byIcon(icon)),
          const Size.square(mobilePlayerPortraitControlIconSize),
        );
      }
      for (final key in <String>[
        'episode-action',
        'caption-action',
        'settings-action',
      ]) {
        expect(
          tester.getSize(find.byKey(ValueKey(key))),
          const Size.square(48),
        );
      }
      expect(
        tester.getSize(find.byKey(const ValueKey('portrait-autoplay'))),
        const Size(52, 28),
      );
    },
  );

  testWidgets(
    'compact seek control shows the duration and keeps both actions',
    (tester) async {
      final semantics = tester.ensureSemantics();
      var taps = 0;
      var longPresses = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MobilePlayerCompactSeekControl(
                tooltip: '+85 seconds',
                seconds: 85,
                onPressed: () => taps++,
                onLongPress: () => longPresses++,
              ),
            ),
          ),
        ),
      );

      final control = find.byType(MobilePlayerCompactSeekControl);
      expect(tester.getSize(control), const Size.square(48));
      expect(find.text('85'), findsOneWidget);
      expect(find.byIcon(Icons.rotate_right_outlined), findsOneWidget);
      expect(
        tester.getSize(find.byIcon(Icons.rotate_right_outlined)),
        const Size.square(mobilePlayerPortraitControlIconSize),
      );
      expect(
        tester.widget<Tooltip>(find.byType(Tooltip)).message,
        '+85 seconds',
      );
      final semanticControl = find.bySemanticsLabel('+85 seconds');
      expect(semanticControl, findsOneWidget);
      final semanticsData = tester
          .getSemantics(semanticControl)
          .getSemanticsData();
      expect(semanticsData.hasAction(SemanticsAction.tap), isTrue);
      expect(semanticsData.hasAction(SemanticsAction.longPress), isTrue);

      await tester.tap(control);
      await tester.pump();
      expect(taps, 1);

      await tester.longPress(control);
      await tester.pump();
      expect(longPresses, 1);
      semantics.dispose();
    },
  );

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
