import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';

const _destinations = [
  NavigationDestination(
    icon: Icon(Icons.collections_bookmark_outlined),
    selectedIcon: Icon(Icons.collections_bookmark),
    label: 'Manga',
  ),
  NavigationDestination(
    icon: Icon(Icons.video_library_outlined),
    selectedIcon: Icon(Icons.video_library),
    label: 'Anime',
  ),
  NavigationDestination(
    icon: Icon(Icons.explore_outlined),
    selectedIcon: Icon(Icons.explore),
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

/// The travelling highlight is the only positioned child in the stack, so it
/// can be picked out by type without reaching for a key that only exists for
/// the test's benefit.
Rect _pillRect(WidgetTester tester) =>
    tester.getRect(find.byType(AnimatedPositioned));

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
    await tester.pumpWidget(_host(index: 0));
    await tester.pumpAndSettle();

    final first = _pillRect(tester);
    final firstIcon = tester.getRect(
      find.byIcon(Icons.collections_bookmark).first,
    );
    expect(
      first.center.dx,
      moreOrLessEquals(firstIcon.center.dx, epsilon: 1),
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

    final lastIcon = tester.getRect(find.byIcon(Icons.explore).first);
    expect(after.center.dx, moreOrLessEquals(lastIcon.center.dx, epsilon: 1));
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
}
