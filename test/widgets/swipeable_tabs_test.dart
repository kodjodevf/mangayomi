import 'package:flutter/gestures.dart';
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

  testWidgets('a diagonal drag is left to the content', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    // Well past the slop sideways, but going down almost as steeply. A drag
    // like this is meant for whatever is on the page, not for the tabs.
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-50, 40));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, isEmpty);
  });

  testWidgets('a flat drag is taken', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-50, 6));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, [2], reason: 'a little drift must not disqualify a swipe');
  });

  testWidgets('the page still gets the constraints a Scaffold body gives it', (
    tester,
  ) async {
    // A Stack hands loose constraints to its children. A page built for the
    // tight ones a Scaffold body provides then collapses: a library's category
    // TabBar simply stopped being laid out. Only pages that fill their parent
    // show this, which is why the earlier tests missed it.
    late BoxConstraints seen;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            currentIndex: 1,
            count: 3,
            onSwitch: (_) {},
            pageBuilder: (i) => const SizedBox(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                seen = constraints;
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(seen.hasBoundedHeight, isTrue, reason: 'height came through loose');
    expect(seen.maxHeight, greaterThan(0));
    expect(seen.maxWidth, greaterThan(0));
  });

  testWidgets('the page being dragged in cannot be touched yet', (
    tester,
  ) async {
    var peekTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            currentIndex: 1,
            count: 3,
            onSwitch: (_) {},
            pageBuilder: (i) => GestureDetector(
              onTap: () => peekTaps++,
              child: Container(
                key: const ValueKey('peekTarget'),
                color: const Color(0xFF000000),
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(-50, 0));
      await tester.pump();
    }
    // It is on screen, but it belongs to the finger that is still on the page
    // behind it.
    expect(find.byKey(const ValueKey('peekTarget')), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('peekTarget')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(peekTaps, 0);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('the swipe reports where it is heading and how far', (
    tester,
  ) async {
    final reports = <(int?, double)>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            currentIndex: 1,
            count: 3,
            onSwitch: (_) {},
            onProgress: (target, progress) => reports.add((target, progress)),
            pageBuilder: (i) => Text('page$i'),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(-60, 0));
      await tester.pump();
    }

    expect(reports, isNotEmpty);
    final heading = reports.where((r) => r.$1 != null).toList();
    expect(heading.map((r) => r.$1).toSet(), {2});
    // Monotonic while the finger keeps going the same way, which is what lets
    // the pill stretch smoothly rather than jump.
    for (var i = 1; i < heading.length; i++) {
      expect(heading[i].$2, greaterThanOrEqualTo(heading[i - 1].$2 - 0.001));
    }
    expect(heading.last.$2, greaterThan(0));

    await gesture.up();
    await tester.pumpAndSettle();
    // Once it lands, the bar's own selection takes over.
    expect(reports.last.$1, isNull);
    expect(reports.last.$2, 0);
  });

  testWidgets('a swipe that springs back reports its way home', (tester) async {
    final reports = <(int?, double)>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            currentIndex: 1,
            count: 3,
            onSwitch: (_) {},
            onProgress: (target, progress) => reports.add((target, progress)),
            pageBuilder: (i) => Text('page$i'),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-60, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(reports.last, (
      null,
      0.0,
    ), reason: 'the pill has to be told to stop reaching, not just left there');
  });

  Widget reporting(List<(int?, double)> into, {int index = 1}) => MaterialApp(
    home: Scaffold(
      body: SwipeableTabs(
        currentIndex: index,
        count: 3,
        onSwitch: (_) {},
        onProgress: (target, progress) => into.add((target, progress)),
        pageBuilder: (i) => Text('page$i'),
        child: const SizedBox.expand(),
      ),
    ),
  );

  testWidgets('a deliberate drag reports a reach', (tester) async {
    final reports = <(int?, double)>[];
    await tester.pumpWidget(reporting(reports));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    // Slow: small steps, well spaced. The timestamp matters as much as the
    // pump; without it every event looks instantaneous and infinitely fast.
    var at = Duration.zero;
    for (var i = 0; i < 10; i++) {
      at += const Duration(milliseconds: 20);
      await gesture.moveBy(const Offset(-8, 0), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 20));
    }

    final reach = reports.where((r) => r.$1 != null).map((r) => r.$2);
    expect(
      reach.isNotEmpty && reach.last > 0.02,
      isTrue,
      reason: 'a slow pull is exactly when the pill should strain',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a hurried flick reports almost none', (tester) async {
    final reports = <(int?, double)>[];
    await tester.pumpWidget(reporting(reports));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(const Offset(400, 300));
    // Fast: much further in much less time.
    var at = Duration.zero;
    for (var i = 0; i < 5; i++) {
      at += const Duration(milliseconds: 8);
      await gesture.moveBy(const Offset(-60, 0), timeStamp: at);
      await tester.pump(const Duration(milliseconds: 8));
    }

    final reach = reports.where((r) => r.$1 != null).map((r) => r.$2).toList();
    expect(
      reach.every((r) => r < 0.05),
      isTrue,
      reason:
          'flicking through tabs should just switch; a pill stretching on '
          'every flick is noise',
    );

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('a mouse drag does not switch tabs', (tester) async {
    // The same shell runs on desktop. Dragging a mouse across a page does not
    // mean "next tab" there, and click-dragging into a tab change would fight
    // selecting and dragging content.
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      const Offset(400, 300),
      kind: PointerDeviceKind.mouse,
    );
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-60, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, isEmpty);
  });

  testWidgets('a finger still does', (tester) async {
    final switched = <int>[];
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: switched.add));
    await tester.pumpAndSettle();

    final gesture = await tester.startGesture(
      const Offset(400, 300),
      kind: PointerDeviceKind.touch,
    );
    for (var i = 0; i < 8; i++) {
      await gesture.moveBy(const Offset(-60, 0));
      await tester.pump();
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(switched, [2]);
  });
}
