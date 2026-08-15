import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';

const _destinations = [
  NavigationDestination(
    icon: Icon(Icons.collections_bookmark_outlined),
    selectedIcon: Icon(Icons.collections_bookmark_rounded),
    label: 'Manga',
  ),
  NavigationDestination(
    icon: Icon(Icons.video_library_outlined),
    selectedIcon: Icon(Icons.video_library_rounded),
    label: 'Anime',
  ),
  NavigationDestination(
    icon: Icon(Icons.explore_outlined),
    selectedIcon: Icon(Icons.explore_rounded),
    label: 'Browse',
  ),
];

Widget _host({
  required int index,
  List<NavigationDestination> destinations = _destinations,
  ValueChanged<int>? onSelected,
}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      // Width only. Scaffold gives its bottomNavigationBar loose height, so
      // pinning one here would force the bar to fill it and mask the very
      // thing several of these tests measure.
      child: SizedBox(
        width: 360,
        child: FloatingNavBar(
          destinations: destinations,
          currentIndex: index,
          onSelected: onSelected ?? (_) {},
        ),
      ),
    ),
  ),
);

/// The painted pill. The positioned box around it spans the bar's full height
/// (the gap lives in a padding inside, so it can animate while the horizontal
/// tracking stays instant), so measuring that box would not measure the pill.
Rect _pillRect(WidgetTester tester) => tester.getRect(
  find.descendant(
    of: find.byType(AnimatedPositioned),
    matching: find.byType(AnimatedContainer),
  ),
);

Rect _barRect(WidgetTester tester) => tester.getRect(
  find.descendant(
    of: find.byType(FloatingNavBar),
    matching: find.byType(ClipRRect),
  ),
);

void main() {
  testWidgets('the highlight sits under the selected destination', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    final pill = _pillRect(tester);
    final icon = tester.getRect(find.byIcon(Icons.video_library_rounded).first);
    expect(
      pill.center.dx,
      moreOrLessEquals(icon.center.dx, epsilon: 1),
      reason: 'the pill should be centred on the icon it highlights',
    );
  });

  testWidgets('the highlight travels when the selection changes', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final before = _pillRect(tester);

    await tester.pumpWidget(_host(index: 2));
    // Halfway through the transition it must be neither where it started nor
    // where it is going, which is what distinguishes a slide from a jump.
    await tester.pump(const Duration(milliseconds: 130));
    final midway = _pillRect(tester);
    expect(midway.left, greaterThan(before.left));

    await tester.pumpAndSettle();
    final after = _pillRect(tester);
    expect(after.left, greaterThan(midway.left));

    final bar = _barRect(tester);
    expect(
      bar.right - after.right,
      moreOrLessEquals(after.top - bar.top, epsilon: 0.5),
      reason: 'the last slot keeps the same inset as every other side',
    );
  });

  List<NavigationDestination> manyTabs(int n) => [
    for (var i = 0; i < n; i++)
      NavigationDestination(
        icon: const Icon(Icons.circle_outlined),
        selectedIcon: const Icon(Icons.circle),
        label: 'Tab $i',
      ),
  ];

  testWidgets('the bar keeps full height up to five destinations', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(3)));
    await tester.pumpAndSettle();
    final three = _barRect(tester).height;

    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(5)));
    await tester.pumpAndSettle();
    expect(_barRect(tester).height, moreOrLessEquals(three, epsilon: 0.5));
  });

  testWidgets('each destination past five takes a little height', (
    tester,
  ) async {
    double heightWith(int n) => FloatingNavBar.heightFor(n);

    expect(heightWith(6), lessThan(heightWith(5)));
    expect(heightWith(7), lessThan(heightWith(6)));
    expect(heightWith(8), lessThan(heightWith(7)));
    // Even steps, so no single extra tab causes a jolt.
    expect(
      heightWith(6) - heightWith(7),
      moreOrLessEquals(heightWith(7) - heightWith(8), epsilon: 0.01),
    );

    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(5)));
    await tester.pumpAndSettle();
    final five = _barRect(tester).height;

    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(7)));
    await tester.pumpAndSettle();
    final seven = _barRect(tester).height;
    expect(seven, lessThan(five));
    expect(seven, moreOrLessEquals(heightWith(7), epsilon: 0.5));
  });

  testWidgets('it never shrinks away, however many destinations', (
    tester,
  ) async {
    // A tab bar that keeps shrinking would eventually be unusable, so the
    // floor matters more than the ratio here.
    expect(FloatingNavBar.heightFor(30), greaterThanOrEqualTo(44.0));
    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(12)));
    await tester.pumpAndSettle();
    expect(_barRect(tester).height, greaterThanOrEqualTo(44.0));
  });

  testWidgets('icons shrink with the bar', (tester) async {
    double iconAt(int n) => tester
        .widget<IconTheme>(
          find
              .ancestor(
                of: find.byIcon(Icons.circle).first,
                matching: find.byType(IconTheme),
              )
              .first,
        )
        .data
        .size!;

    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(5)));
    await tester.pumpAndSettle();
    final five = iconAt(5);

    await tester.pumpWidget(_host(index: 0, destinations: manyTabs(8)));
    await tester.pumpAndSettle();
    expect(
      iconAt(8),
      lessThan(five),
      reason: 'icons keep their proportion to the bar rather than crowding it',
    );
  });

  testWidgets('tapping a destination reports its index', (tester) async {
    final taps = <int>[];
    await tester.pumpWidget(_host(index: 0, onSelected: taps.add));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.explore_outlined));
    expect(taps, [2]);
  });

  testWidgets('labels survive for screen readers even though they are hidden', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    expect(find.text('Anime'), findsNothing);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Anime')),
      isSemantics(
        label: 'Anime',
        isSelected: true,
        isButton: true,
        hasTapAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.bySemanticsLabel('Browse')),
      isSemantics(
        label: 'Browse',
        isSelected: false,
        isButton: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('the pill follows the pointer during a drag', (tester) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final start = _pillRect(tester);

    final gesture = await tester.startGesture(start.center);
    await gesture.moveBy(const Offset(80, 0));
    // Settle first: the bar grows when a drag starts, and that animation moves
    // the pill's absolute position for a few frames on its own.
    await tester.pumpAndSettle();
    final mid = _pillRect(tester);
    expect(mid.left, greaterThan(start.left));

    // No easing on the pill itself, so a further pump must not move it.
    await tester.pump(const Duration(milliseconds: 200));
    expect(_pillRect(tester).left, moreOrLessEquals(mid.left, epsilon: 0.5));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the tab only changes once the pill is let go', (tester) async {
    final taps = <int>[];
    await tester.pumpWidget(_host(index: 0, onSelected: taps.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(240, 0));
    await tester.pump();
    expect(taps, isEmpty, reason: 'dragging alone must not navigate');

    await gesture.up();
    await tester.pumpAndSettle();
    expect(taps, [2]);
  });

  testWidgets('a drag returned to its own slot changes nothing', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(_host(index: 1, onSelected: taps.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(90, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(-90, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(taps, isEmpty);
  });

  testWidgets('dragging over a tab does not fill it', (tester) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.collections_bookmark_rounded), findsOneWidget);

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(240, 0));
    await tester.pumpAndSettle();

    // Fill and weight belong to the selected tab. Hovering the pill over a
    // different one must leave both alone until the drag is committed.
    expect(find.byIcon(Icons.explore_rounded), findsNothing);
    expect(find.byIcon(Icons.collections_bookmark_rounded), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the resting pill is inset evenly on all four sides', (
    tester,
  ) async {
    // The end slots are the ones that can go wrong: the pill has a bar edge on
    // one side there, not a neighbouring slot.
    for (final index in [0, 2]) {
      await tester.pumpWidget(_host(index: index));
      await tester.pumpAndSettle();
      final pill = _pillRect(tester);
      final bar = _barRect(tester);
      final outer = index == 0 ? pill.left - bar.left : bar.right - pill.right;
      final vertical = pill.top - bar.top;

      expect(
        outer,
        moreOrLessEquals(vertical, epsilon: 0.5),
        reason:
            'slot $index sits against a bar edge, and that gap has to match '
            'the top and bottom gap',
      );
      expect(
        bar.bottom - pill.bottom,
        moreOrLessEquals(vertical, epsilon: 0.5),
      );
    }
  });

  testWidgets('the pill is as round as the bar it sits in', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    final decoration = tester
        .widget<AnimatedContainer>(
          find.descendant(
            of: find.byType(AnimatedPositioned),
            matching: find.byType(AnimatedContainer),
          ),
        )
        .decoration;
    expect(
      (decoration as ShapeDecoration).shape,
      isA<StadiumBorder>(),
      reason:
          'a stadium is a full capsule at any height, so the pill stays as '
          'round as the bar even as the gap animates',
    );
  });

  testWidgets('the pill widens as it is pulled along', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester).width;

    final gesture = await tester.startGesture(_pillRect(tester).center);
    // The move is what starts the drag; wait for the pill to finish travelling
    // to the finger before measuring, or the width is still mid-animation.
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.moveBy(const Offset(20, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(60, 0));
    await tester.pump();
    expect(
      _pillRect(tester).width,
      greaterThan(resting),
      reason: 'a fast drag should stretch it',
    );

    await gesture.moveBy(const Offset(-80, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(_pillRect(tester).width, moreOrLessEquals(resting, epsilon: 1));
  });

  testWidgets('past the end the pill pins without growing backwards', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester).width;

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(400, 0));
    // The move is what starts the drag; only then does the pill begin
    // travelling to the finger, so wait for it to arrive before measuring.
    await tester.pump(const Duration(milliseconds: 300));
    // Let the speed stretch decay before measuring, so what is left is only
    // the edge behaviour.
    for (var i = 0; i < 12; i++) {
      await gesture.moveBy(const Offset(1, 0));
      await tester.pump();
    }

    final pill = _pillRect(tester);
    final bar = _barRect(tester);
    expect(
      bar.right - pill.right,
      moreOrLessEquals(pill.top - bar.top, epsilon: 1),
      reason: 'it pins at the cap but keeps its inset, like at rest',
    );
    expect(
      pill.width,
      lessThan(resting + 8),
      reason:
          'pushing right must not widen the pill leftwards, away from the '
          'push; the bar takes the give instead',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the pill zooms evenly when picked up, not just taller', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester);

    // Has to clear the touch slop, or no drag is recognised at all.
    final gesture = await tester.startGesture(resting.center);
    await gesture.moveBy(const Offset(30, 0));
    await tester.pumpAndSettle();
    final held = _pillRect(tester);

    final sx = held.width / resting.width;
    final sy = held.height / resting.height;
    expect(sy, greaterThan(1.0));
    expect(
      sx,
      moreOrLessEquals(sy, epsilon: 0.02),
      reason:
          'growing only the height makes the pill rounder rather than bigger, '
          'which is what this replaced',
    );

    await gesture.moveBy(const Offset(-30, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      _pillRect(tester).height,
      moreOrLessEquals(resting.height, epsilon: 0.5),
    );
  });

  testWidgets('the bar is edged with glass, not outlined', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    final decorations = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.descendant(
              of: find.byType(FloatingNavBar),
              matching: find.byType(ClipRRect),
            ),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((b) => b.decoration)
        .whereType<BoxDecoration>();

    expect(
      decorations.every((d) => d.border == null),
      isTrue,
      reason: 'a hard outline all the way round is what we are replacing',
    );
    // Painted as a stroke along the outline rather than a decoration
    // gradient. A horizontal band cannot reach a stadium's far left and right
    // points, which sit at mid height, so those ends were left unlit.
    expect(
      find.descendant(
        of: find.byType(FloatingNavBar),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );
    expect(
      FloatingNavBar.glassStrokeWidth,
      lessThanOrEqualTo(1.0),
      reason: 'heavier than a hairline reads as a border, not glass',
    );

    // Uneven along its length, the way glass catches light in patches. The
    // distinction that matters is uneven versus faded: it must not trend down
    // towards the centre.
    final mask = tester.widget<ShaderMask>(
      find.descendant(
        of: find.byType(FloatingNavBar),
        matching: find.byType(ShaderMask),
      ),
    );
    expect(mask.blendMode, BlendMode.dstIn);

    final alphas = FloatingNavBar.glassPatchAlphas;
    final mid = alphas[alphas.length ~/ 2];
    expect(
      mid,
      greaterThan(alphas.reduce(math.min)),
      reason: 'the centre must not be the darkest point',
    );
    // Genuinely irregular rather than a smooth ramp either way.
    var reversals = 0;
    for (var i = 2; i < alphas.length; i++) {
      final a = alphas[i] - alphas[i - 1];
      final b = alphas[i - 1] - alphas[i - 2];
      if (a.sign != b.sign) reversals++;
    }
    expect(reversals, greaterThan(2), reason: 'a ramp is not unevenness');
  });

  testWidgets('the focused icon is thickened for icons that cannot fill', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    IconThemeData themeFor(IconData icon) => tester
        .widget<IconTheme>(
          find
              .ancestor(of: find.byIcon(icon), matching: find.byType(IconTheme))
              .first,
        )
        .data;

    expect(
      themeFor(Icons.video_library_rounded).shadows,
      isNotNull,
      reason: 'selected icons carry a stroke so line-art icons read as active',
    );
    expect(themeFor(Icons.explore_outlined).shadows, isNull);
  });

  testWidgets('the pill nearly fills the bar it sits in', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    final pill = _pillRect(tester);
    final bar = _barRect(tester);
    // Stated as a proportion rather than a fixed gap, so tuning the inset
    // does not break this. The even-inset test pins the exact spacing.
    expect(
      pill.height / bar.height,
      greaterThan(0.78),
      reason: 'a small gap top and bottom, not a chip floating in the middle',
    );
  });

  testWidgets('the whole bar zooms while the pill is dragged', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final resting = _barRect(tester);

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(30, 0));
    await tester.pumpAndSettle();

    final lifted = _barRect(tester);
    // A zoom, not a stretch: both axes grow by the same factor, so the bar
    // keeps its proportions instead of deforming.
    final sx = lifted.width / resting.width;
    final sy = lifted.height / resting.height;
    expect(sy, greaterThan(1.0));
    expect(
      sx,
      greaterThan(1.0),
      reason: 'width has to scale too, or it is a stretch',
    );
    expect(
      sx,
      moreOrLessEquals(sy, epsilon: 0.02),
      reason: 'uniform scale keeps the proportions',
    );

    await gesture.moveBy(const Offset(-30, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      _barRect(tester).height,
      moreOrLessEquals(resting.height, epsilon: 0.5),
    );
  });

  /// WCAG contrast ratio between two opaque colours.
  double contrastOf(Color a, Color b) {
    final la = a.computeLuminance(), lb = b.computeLuminance();
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  /// The bar's fill. Its glass-edge overlay is also a DecoratedBox and sits
  /// outside it, but only the fill carries a colour.
  Color barFillOf(WidgetTester tester) {
    final boxes = tester.widgetList<DecoratedBox>(
      find.descendant(
        of: find.descendant(
          of: find.byType(FloatingNavBar),
          matching: find.byType(ClipRRect),
        ),
        matching: find.byType(DecoratedBox),
      ),
    );
    return boxes
        .map((b) => b.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((d) => d.color != null)
        .color!;
  }

  Widget themed(Brightness brightness) => MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: 360,
          child: FloatingNavBar(
            destinations: _destinations,
            currentIndex: 1,
            onSelected: (_) {},
          ),
        ),
      ),
    ),
  );

  testWidgets('the bar is nearly opaque in light, where blur cannot help', (
    tester,
  ) async {
    final theme = ThemeData(brightness: Brightness.light);
    await tester.pumpWidget(themed(Brightness.light));
    await tester.pumpAndSettle();

    final page = theme.scaffoldBackgroundColor;
    // The fill is translucent, so what matters is the colour once it has
    // composited over the page behind it.
    final composited = Color.alphaBlend(barFillOf(tester), page);
    expect(
      contrastOf(composited, page),
      greaterThan(1.12),
      reason:
          'light mode measured 1.05 on device, which is invisible. A light '
          'page gives the backdrop blur nothing darker to pull in, so the '
          'fill itself has to carry the separation here.',
    );
  });

  testWidgets('the bar keeps its glass fill in dark', (tester) async {
    await tester.pumpWidget(themed(Brightness.dark));
    await tester.pumpAndSettle();
    expect(
      barFillOf(tester).a,
      lessThan(0.8),
      reason: 'dark keeps the translucency; the blur has content to work with',
    );
  });

  testWidgets('a shadow separates the bar in either theme', (tester) async {
    // Dark relies on the blur, and the blur only helps when there is content
    // behind the bar. Over a flat background the shadow is what is left, so it
    // has to exist and it has to sit outside the clip to be drawn at all.
    for (final brightness in Brightness.values) {
      await tester.pumpWidget(themed(brightness));
      await tester.pumpAndSettle();

      final outer =
          tester
                  .widget<DecoratedBox>(
                    find
                        .descendant(
                          of: find.byType(FloatingNavBar),
                          matching: find.byType(DecoratedBox),
                        )
                        .first,
                  )
                  .decoration
              as BoxDecoration;
      expect(outer.boxShadow, isNotNull, reason: '$brightness has no shadow');
      expect(outer.boxShadow!.single.blurRadius, greaterThan(0));

      // The shadow box has to wrap the clip, not sit inside it, or the clip
      // cuts the shadow off and it never draws.
      expect(
        find.ancestor(
          of: find.descendant(
            of: find.byType(FloatingNavBar),
            matching: find.byType(ClipRRect),
          ),
          matching: find.byType(DecoratedBox),
        ),
        findsWidgets,
        reason: '$brightness draws its shadow inside the clip',
      );
    }
  });

  testWidgets('the end icons sit centred in the pill, not in their slot', (
    tester,
  ) async {
    // The end slots push the pill inwards so it keeps its inset from the bar's
    // caps. Icons that stayed centred in their slot then sat off centre inside
    // the pill, which is visible at both ends.
    for (final index in [0, 2]) {
      await tester.pumpWidget(_host(index: index));
      await tester.pumpAndSettle();

      final icon = tester.getRect(
        find
            .byIcon(
              index == 0
                  ? Icons.collections_bookmark_rounded
                  : Icons.explore_rounded,
            )
            .first,
      );
      expect(
        icon.center.dx,
        moreOrLessEquals(_pillRect(tester).center.dx, epsilon: 0.5),
        reason: 'slot $index icon is off centre in its pill',
      );
    }
  });

  testWidgets('middle icons are not nudged', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final bar = _barRect(tester);
    final icon = tester.getRect(find.byIcon(Icons.video_library_rounded).first);
    expect(
      icon.center.dx,
      moreOrLessEquals(bar.center.dx, epsilon: 0.5),
      reason: 'the middle slot of three is the bar centre; nothing to nudge',
    );
  });

  Color pillColourOf(WidgetTester tester) =>
      (tester
                  .widget<AnimatedContainer>(
                    find.descendant(
                      of: find.byType(AnimatedPositioned),
                      matching: find.byType(AnimatedContainer),
                    ),
                  )
                  .decoration
              as ShapeDecoration)
          .color!;

  testWidgets('the pill carries the theme, the bar stays neutral', (
    tester,
  ) async {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF7B4BD6));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: scheme, useMaterial3: true),
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 360,
              child: FloatingNavBar(
                destinations: _destinations,
                currentIndex: 1,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      pillColourOf(tester).withValues(alpha: 1),
      scheme.secondaryContainer,
      reason: 'the pill is the one element that takes the accent',
    );
    // The bar is glass: it should take colour from what is behind it, not
    // impose its own, and a coloured slab would fight the cover art.
    final fill = barFillOf(tester);
    expect(
      (fill.r - fill.g).abs() < 0.25 && (fill.g - fill.b).abs() < 0.25,
      isTrue,
      reason: 'the bar itself must stay near-neutral',
    );
  });

  test('a selected icon stays legible on the pill in any scheme', () {
    // This pairing is the reason the pill carries the theme rather than the
    // icon. Tinting the icon against the bar would have to hold up against
    // every scheme the user can choose, with no guarantee behind it.
    double contrast(Color a, Color b) {
      final la = a.computeLuminance(), lb = b.computeLuminance();
      return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
    }

    final seeds = [
      const Color(0xFF6750A4),
      const Color(0xFF0061A4),
      const Color(0xFF006E1C),
      const Color(0xFFBA1A1A),
      const Color(0xFFFFD600),
      const Color(0xFF00696E),
      const Color(0xFF8F4C38),
      const Color(0xFF4A4458),
    ];
    for (final seed in seeds) {
      for (final brightness in Brightness.values) {
        final s = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
        expect(
          contrast(s.onSecondaryContainer, s.secondaryContainer),
          greaterThan(4.5),
          reason: 'seed $seed in $brightness fails the pairing',
        );
      }
    }
  });

  testWidgets('grabbing another tab pulls the pill over, not teleports it', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final start = _pillRect(tester).center.dx;

    // Press on the far tab and drag from there.
    final target = tester.getCenter(find.byIcon(Icons.explore_outlined));
    final gesture = await tester.startGesture(target);
    // Enough to clear the touch slop in one go, so the drag is definitely
    // running by the time the first frame is measured.
    await gesture.moveBy(const Offset(40, 0));
    // The first frame after the target changes still renders the old value,
    // since that is where the animation starts; the second one advances it.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));

    final partway = _pillRect(tester).center.dx;
    expect(
      partway,
      greaterThan(start),
      reason: 'it should have set off towards the finger',
    );
    expect(
      partway,
      lessThan(target.dx),
      reason: 'and should still be on its way, not already there',
    );

    await tester.pump(const Duration(milliseconds: 400));
    expect(
      _pillRect(tester).center.dx,
      greaterThan(partway),
      reason: 'it keeps going and arrives',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('unselected icons are not dimmed', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    IconThemeData themeOf(IconData icon) => tester
        .widget<IconTheme>(
          find
              .ancestor(of: find.byIcon(icon), matching: find.byType(IconTheme))
              .first,
        )
        .data;

    expect(
      themeOf(Icons.explore_outlined).color!.a,
      1.0,
      reason:
          'the pill, the fill and the stroke weight already mark the active '
          'tab, so dimming the others only made them harder to read',
    );
  });

  testWidgets('the bar reports its own height, not the screen height', (
    tester,
  ) async {
    // Scaffold lays a bottomNavigationBar out with the screen height as its
    // maximum. A widget that fills those constraints still *looks* right,
    // because its content is pinned to the bottom, but with extendBody the
    // Scaffold hands that height to the body as bottom padding. Every page
    // that respects the inset then pushes its content off screen: More showed
    // one item and a void, Browse and Extensions came up blank.
    late double bodyBottomInset;
    late Size barSize;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          extendBody: true,
          bottomNavigationBar: FloatingNavBar(
            destinations: _destinations,
            currentIndex: 0,
            onSelected: (_) {},
          ),
          body: Builder(
            builder: (context) {
              bodyBottomInset = MediaQuery.paddingOf(context).bottom;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    barSize = tester.getSize(find.byType(FloatingNavBar));

    final screen = tester.getSize(find.byType(Scaffold)).height;
    expect(
      barSize.height,
      lessThan(screen / 3),
      reason: 'the bar box swallowed the screen',
    );
    expect(
      bodyBottomInset,
      moreOrLessEquals(barSize.height, epsilon: 1),
      reason: 'the inset handed to the body has to be the bar, nothing more',
    );
  });

  testWidgets('grabbing the pill itself tracks at once, without easing', (
    tester,
  ) async {
    // Easing towards a target that moves with the finger made the pill stutter.
    // It only ever needs to travel when the grab landed somewhere else.
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(_pillRect(tester).center);
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    final first = _pillRect(tester).center.dx;

    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    final second = _pillRect(tester).center.dx;

    // Each move lands in full on the very next frame. Under the easing it
    // arrived over several frames, which is what read as jitter.
    expect(second - first, moreOrLessEquals(30, epsilon: 2));

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a tap lifts the bar the same way a drag does', (tester) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final resting = _barRect(tester);

    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));

    expect(
      _barRect(tester).height,
      greaterThan(resting.height),
      reason: 'a press should react, not only a drag',
    );

    await tester.pumpAndSettle(const Duration(milliseconds: 400));
    expect(
      _barRect(tester).height,
      moreOrLessEquals(resting.height, epsilon: 0.5),
      reason: 'and settle back on its own',
    );
  });

  test('a short viewport gets a shorter bar', () {
    // Landscape on a phone has very little height to spare, and a bar sized
    // for portrait eats into the content.
    const portrait = 900.0;
    const landscape = 390.0;
    expect(
      FloatingNavBar.heightFor(5, viewportHeight: landscape),
      lessThan(FloatingNavBar.heightFor(5, viewportHeight: portrait)),
    );
    // Crowding and a short viewport both apply, and the floor still wins.
    expect(
      FloatingNavBar.heightFor(9, viewportHeight: landscape),
      greaterThanOrEqualTo(44.0),
    );
    // No viewport given means no assumption either way.
    expect(
      FloatingNavBar.heightFor(5),
      FloatingNavBar.heightFor(5, viewportHeight: portrait),
    );
  });

  testWidgets('the bar is laid out from the viewport it is actually in', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1560, 720);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final wide = _barRect(tester).height;

    tester.view.physicalSize = const Size(780, 1690);
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final tall = _barRect(tester).height;

    expect(
      wide,
      lessThan(tall),
      reason: 'landscape has less height to give the bar',
    );
  });

  testWidgets('labels sit beside the icons in the landscape layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 700,
              child: FloatingNavBar(
                destinations: _destinations,
                currentIndex: 1,
                showLabels: true,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final label in ['Manga', 'Anime', 'Browse']) {
      expect(find.text(label), findsOneWidget);
    }

    // Beside, not above: same row, so their vertical centres line up.
    final icon = tester.getRect(find.byIcon(Icons.video_library_rounded).first);
    final text = tester.getRect(find.text('Anime'));
    expect(text.left, greaterThan(icon.right));
    expect(text.center.dy, moreOrLessEquals(icon.center.dy, epsilon: 2));
  });

  testWidgets('a labelled item is as wide as its own label', (tester) async {
    const wordy = [
      NavigationDestination(icon: Icon(Icons.circle), label: 'Hi'),
      NavigationDestination(
        icon: Icon(Icons.square),
        label: 'A considerably longer label',
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 700,
              child: FloatingNavBar(
                destinations: wordy,
                currentIndex: 0,
                showLabels: true,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The pill is sized from the same widths, so it must fit the short item
    // rather than half the bar.
    final pill = _pillRect(tester);
    final bar = _barRect(tester);
    expect(
      pill.width,
      lessThan(bar.width / 2),
      reason: 'even slots would give the short label half the bar',
    );
    expect(pill.center.dx, lessThan(bar.center.dx));
  });

  testWidgets('the labelled bar hugs its tabs and centres them', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 900,
              child: FloatingNavBar(
                destinations: _destinations,
                currentIndex: 1,
                showLabels: true,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final bar = _barRect(tester);
    final host = tester.getRect(find.byType(FloatingNavBar));
    // Three short labels cannot need 900pt. Filling the width is what spread
    // the tabs right across the screen.
    expect(
      bar.width,
      lessThan(host.width * 0.75),
      reason: 'the bar should be as wide as its tabs and no wider',
    );
    expect(
      bar.center.dx,
      moreOrLessEquals(host.center.dx, epsilon: 1),
      reason: 'and sit in the middle',
    );
  });

  testWidgets('icon-only still spans the width it is given', (tester) async {
    await tester.pumpWidget(_host(index: 1));
    await tester.pumpAndSettle();
    final bar = _barRect(tester);
    final host = tester.getRect(find.byType(FloatingNavBar));
    expect(
      bar.width,
      moreOrLessEquals(host.width - 40, epsilon: 1),
      reason: 'portrait keeps the full width less its margins',
    );
  });

  Widget reaching({required int index, int? target, double progress = 0}) =>
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 360,
              child: FloatingNavBar(
                destinations: _destinations,
                currentIndex: index,
                swipeTarget: target,
                swipeProgress: progress,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );

  testWidgets('the pill reaches for the tab a swipe is heading to', (
    tester,
  ) async {
    await tester.pumpWidget(reaching(index: 0));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester);

    await tester.pumpWidget(reaching(index: 0, target: 1, progress: 0.5));
    await tester.pumpAndSettle();
    final midway = _pillRect(tester);

    // Stretched, not slid: it is wider in the middle of the swipe than at
    // either end of it, which is what makes it read as reaching.
    expect(midway.width, greaterThan(resting.width));
    expect(midway.left, greaterThan(resting.left));
    expect(midway.right, greaterThan(resting.right));
  });

  testWidgets('the reach strains but does not travel', (tester) async {
    await tester.pumpWidget(reaching(index: 0));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester);

    await tester.pumpWidget(reaching(index: 1));
    await tester.pumpAndSettle();
    final nextSlot = _pillRect(tester);
    final distance = nextSlot.center.dx - resting.center.dx;

    await tester.pumpWidget(reaching(index: 0, target: 1, progress: 1));
    await tester.pumpAndSettle();
    final strained = _pillRect(tester);

    // Leaning, not walking: even at full swipe it has covered only a fraction
    // of the way. Travelling most of the distance read as having already
    // arrived, which made the actual arrival an anticlimax.
    final covered = (strained.center.dx - resting.center.dx) / distance;
    expect(covered, greaterThan(0));
    expect(
      covered,
      lessThan(0.2),
      reason: 'it should still be sitting on its own tab',
    );
  });

  testWidgets('straining makes the pill thinner, not just longer', (
    tester,
  ) async {
    await tester.pumpWidget(reaching(index: 0));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester);

    await tester.pumpWidget(reaching(index: 0, target: 1, progress: 1));
    await tester.pumpAndSettle();
    final strained = _pillRect(tester);

    expect(strained.width, greaterThan(resting.width));
    expect(
      strained.height,
      lessThan(resting.height),
      reason: 'something pulled longer gets narrower, or it just looks bigger',
    );
  });

  testWidgets('reaching backwards stretches the other way', (tester) async {
    await tester.pumpWidget(reaching(index: 2));
    await tester.pumpAndSettle();
    final resting = _pillRect(tester);

    await tester.pumpWidget(reaching(index: 2, target: 1, progress: 0.5));
    await tester.pumpAndSettle();
    final midway = _pillRect(tester);

    expect(midway.width, greaterThan(resting.width));
    expect(midway.left, lessThan(resting.left));
  });

  testWidgets('no target leaves the pill where it is', (tester) async {
    await tester.pumpWidget(reaching(index: 1));
    await tester.pumpAndSettle();
    final plain = _pillRect(tester);

    await tester.pumpWidget(reaching(index: 1, target: 1, progress: 0.7));
    await tester.pumpAndSettle();
    expect(
      _pillRect(tester).left,
      moreOrLessEquals(plain.left, epsilon: 0.5),
      reason: 'reaching for the tab it is already on is not a reach',
    );
  });

  testWidgets('every labelled pill sits exactly on its own item', (
    tester,
  ) async {
    // The regression this exists for: item widths were predicted from the icon
    // size and a TextPainter run on the label, and the prediction disagreed
    // with the real layout. The error was a scale mismatch, so it grew towards
    // the ends of the bar and reversed sign across the middle: the first tab's
    // pill sat right of its content and the last tab's sat seventeen points
    // left of it. Checking one tab, or only the middle, would have missed it.
    const many = [
      NavigationDestination(icon: Icon(Icons.book), label: 'Manga'),
      NavigationDestination(icon: Icon(Icons.play_circle), label: 'Anime'),
      NavigationDestination(icon: Icon(Icons.menu_book), label: 'Novel'),
      NavigationDestination(icon: Icon(Icons.new_releases), label: 'Updates'),
      NavigationDestination(icon: Icon(Icons.history), label: 'History'),
      NavigationDestination(icon: Icon(Icons.explore), label: 'Browse'),
      NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
    ];
    const icons = [
      Icons.book,
      Icons.play_circle,
      Icons.menu_book,
      Icons.new_releases,
      Icons.history,
      Icons.explore,
      Icons.more_horiz,
    ];
    const names = [
      'Manga',
      'Anime',
      'Novel',
      'Updates',
      'History',
      'Browse',
      'More',
    ];

    // Landscape-sized. Seven labelled tabs do not fit the default 800pt test
    // surface, and a bar forced to overflow is not the case under test.
    tester.view.physicalSize = const Size(1900, 500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    for (var sel = 0; sel < many.length; sel++) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingNavBar(
                destinations: many,
                currentIndex: sel,
                showLabels: true,
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final pill = _pillRect(tester);
      final icon = tester.getRect(find.byIcon(icons[sel]));
      final text = tester.getRect(find.text(names[sel]));

      expect(
        icon.left,
        greaterThan(pill.left),
        reason: '${names[sel]}: icon starts outside its pill',
      );
      expect(
        text.right,
        lessThan(pill.right),
        reason: '${names[sel]}: label runs past its pill',
      );
      expect(
        pill.center.dx,
        moreOrLessEquals((icon.left + text.right) / 2, epsilon: 1),
        reason: '${names[sel]}: pill is off centre from its own content',
      );
    }
  });

  testWidgets('labelled items are evenly spaced whatever their width', (
    tester,
  ) async {
    const mixed = [
      NavigationDestination(icon: Icon(Icons.circle), label: 'Hi'),
      NavigationDestination(icon: Icon(Icons.square), label: 'Considerably'),
      NavigationDestination(icon: Icon(Icons.star), label: 'Mid'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingNavBar(
              destinations: mixed,
              currentIndex: 0,
              showLabels: true,
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final a = tester.getRect(find.text('Hi'));
    final b = tester.getRect(find.byIcon(Icons.square));
    final c = tester.getRect(find.text('Considerably'));
    final d = tester.getRect(find.byIcon(Icons.star));

    // Same gap between neighbours regardless of how wide either one is.
    expect(b.left - a.right, moreOrLessEquals(d.left - c.right, epsilon: 1));

    // And the same again at each end.
    final bar = _barRect(tester);
    final first = tester.getRect(find.byIcon(Icons.circle));
    final last = tester.getRect(find.text('Mid'));
    expect(
      first.left - bar.left,
      moreOrLessEquals(bar.right - last.right, epsilon: 1),
      reason: 'the two ends should have the same spacing',
    );
  });
}
