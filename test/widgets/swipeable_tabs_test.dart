import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/main_view/swipeable_tabs.dart';

Widget _host({
  required int index,
  required int count,
  required ValueChanged<int> onSwitch,
}) => MaterialApp(
  home: Scaffold(
    body: SwipeableTabs(
      currentIndex: index,
      count: count,
      onSwitch: onSwitch,
      pageBuilder: (i) =>
          Center(key: ValueKey('peek$i'), child: Text('page$i')),
      child: Center(key: const ValueKey('live'), child: Text('page$index')),
    ),
  ),
);

void main() {
  testWidgets('the neighbour comes into view while the finger is down', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('peek2')), findsNothing);

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-120, 0));
    await tester.pump();

    // Both pages on screen at once is the whole point: it has to be a drag you
    // can hold, not a transition that fires on release.
    expect(find.byKey(const ValueKey('live')), findsOneWidget);
    expect(find.byKey(const ValueKey('peek2')), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a short drag springs back without switching', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-40, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, isEmpty);
    expect(find.byKey(const ValueKey('peek2')), findsNothing);
  });

  testWidgets('carrying it far enough switches to that tab', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-400, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, [2]);
  });

  testWidgets('dragging backwards goes to the previous tab', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(400, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, [0]);
  });

  testWidgets('the ends resist instead of dragging a gap into view', (
    tester,
  ) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 0, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(400, 0));
    await tester.pump();
    // There is no tab before the first, so nothing may be revealed.
    expect(find.byKey(const ValueKey('peek0')), findsNothing);
    await gesture.up();
    await tester.pumpAndSettle();
    expect(switched, isEmpty);
  });

  testWidgets('disabled leaves the child completely alone', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            enabled: false,
            currentIndex: 1,
            count: 3,
            onSwitch: switched.add,
            pageBuilder: (i) => Text('peek$i'),
            child: const Text('live'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-400, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, isEmpty, reason: 'the rail platforms own this gesture');
  });

  testWidgets('an inner tab set hands over when it runs out of sections', (
    tester,
  ) async {
    // A TabBarView wins the gesture before SwipeableTabs sees it, so the only
    // way a swipe can run out of the last section and into the next tab is by
    // picking up the overscroll it reports once it has nowhere left to go.
    final switched = <int>[];
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SwipeableTabs(
              currentIndex: 1,
              count: 3,
              onSwitch: switched.add,
              pageBuilder: (i) => Center(child: Text('peek$i')),
              child: const TabBarView(
                children: [
                  Center(child: Text('a')),
                  Center(child: Text('b')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Move to the last section first, so the next drag has nowhere to go.
    var gesture = await tester.startGesture(const Offset(400, 300));
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-50, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(switched, isEmpty, reason: 'that was a move between sections');
    expect(
      find.text('b'),
      findsOneWidget,
      reason: 'inner tabs must still work',
    );

    // Now keep going past the end.
    gesture = await tester.startGesture(const Offset(400, 300));
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-50, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      switched,
      [2],
      reason: 'past the last section the swipe should carry into the next tab',
    );
  });

  testWidgets('the two pages are held apart while both are visible', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-200, 0));
    await tester.pump();

    final live = tester.getRect(find.byKey(const ValueKey('live')));
    final peek = tester.getRect(find.byKey(const ValueKey('peek2')));
    // A gap, not a seam: the incoming page starts after the outgoing one ends.
    expect(peek.left - live.right, greaterThan(0));

    await gesture.up();
    await tester.pumpAndSettle();
  });
}
