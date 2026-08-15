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
  bool shrunk = false,
  ValueChanged<int>? onSelected,
}) => MaterialApp(
  home: Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: 360,
        height: 80,
        child: FloatingNavBar(
          destinations: _destinations,
          currentIndex: index,
          shrunk: shrunk,
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

double _barHeight(WidgetTester tester) => tester
    .getSize(
      find.descendant(
        of: find.byType(FloatingNavBar),
        matching: find.byType(ClipRRect),
      ),
    )
    .height;

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

  testWidgets('shrinking lowers the bar without moving its bottom edge', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();
    final tall = _barHeight(tester);
    final tallBottom = tester
        .getRect(
          find.descendant(
            of: find.byType(FloatingNavBar),
            matching: find.byType(ClipRRect),
          ),
        )
        .bottom;

    await tester.pumpWidget(_host(index: 0, shrunk: true));
    await tester.pumpAndSettle();
    final short = _barHeight(tester);
    final shortBottom = tester
        .getRect(
          find.descendant(
            of: find.byType(FloatingNavBar),
            matching: find.byType(ClipRRect),
          ),
        )
        .bottom;

    expect(short, lessThan(tall));
    expect(
      shortBottom,
      moreOrLessEquals(tallBottom, epsilon: 0.5),
      reason: 'it should shrink upwards, staying anchored to the bottom',
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
    await tester.pump();
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
          height: 90,
          child: FloatingNavBar(
            destinations: _destinations,
            currentIndex: 1,
            shrunk: false,
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
}
