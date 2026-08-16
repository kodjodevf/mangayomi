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
      order: [for (var i = 0; i < count; i++) i],
      onSwitch: onSwitch,
      branches: [
        for (var i = 0; i < count; i++)
          Center(key: ValueKey('page$i'), child: Text('page$i')),
      ],
    ),
  ),
);

void main() {
  testWidgets('the neighbour comes into view while the finger is down', (
    tester,
  ) async {
    await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('page2')), findsNothing);

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(-120, 0));
    await tester.pump();

    // Both pages on screen at once is the whole point: it has to be a drag you
    // can hold, not a transition that fires on release.
    expect(find.byKey(const ValueKey('page1')), findsOneWidget);
    expect(find.byKey(const ValueKey('page2')), findsOneWidget);

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
    expect(find.byKey(const ValueKey('page2')), findsNothing);
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
    // There is no tab before the first, so nothing may be revealed. The first
    // tab is itself on screen, of course; it is a neighbour that must not be.
    expect(find.byKey(const ValueKey('page0')), findsOneWidget);
    expect(find.byKey(const ValueKey('page1')), findsNothing);
    expect(find.byKey(const ValueKey('page2')), findsNothing);
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
            order: const [0, 1, 2],
            onSwitch: switched.add,
            branches: const [Text('page0'), Text('page1'), Text('page2')],
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
              order: const [0, 1, 2],
              onSwitch: switched.add,
              branches: const [
                Center(child: Text('page0')),
                TabBarView(
                  children: [
                    Center(child: Text('a')),
                    Center(child: Text('b')),
                  ],
                ),
                Center(child: Text('page2')),
              ],
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

    final live = tester.getRect(find.byKey(const ValueKey('page1')));
    final peek = tester.getRect(find.byKey(const ValueKey('page2')));
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
            order: const [0, 1, 2],
            onSwitch: (_) {},
            branches: [
              const SizedBox(),
              LayoutBuilder(
                builder: (context, constraints) {
                  seen = constraints;
                  return const SizedBox.expand();
                },
              ),
              const SizedBox(),
            ],
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
            order: const [0, 1, 2],
            onSwitch: (_) {},
            branches: [
              const SizedBox.expand(),
              const SizedBox.expand(),
              GestureDetector(
                onTap: () => peekTaps++,
                child: Container(
                  key: const ValueKey('peekTarget'),
                  color: const Color(0xFF000000),
                ),
              ),
            ],
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
            order: const [0, 1, 2],
            onSwitch: (_) {},
            onProgress: (target, progress) => reports.add((target, progress)),
            branches: const [
              SizedBox.expand(),
              SizedBox.expand(),
              SizedBox.expand(),
            ],
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
            order: const [0, 1, 2],
            onSwitch: (_) {},
            onProgress: (target, progress) => reports.add((target, progress)),
            branches: const [
              SizedBox.expand(),
              SizedBox.expand(),
              SizedBox.expand(),
            ],
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
        order: const [0, 1, 2],
        onSwitch: (_) {},
        onProgress: (target, progress) => into.add((target, progress)),
        branches: const [
          SizedBox.expand(),
          SizedBox.expand(),
          SizedBox.expand(),
        ],
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

  group('a tab change that came from a tap', () {
    testWidgets('slides in from the right for a tab to the right', (
      tester,
    ) async {
      await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_host(index: 2, count: 3, onSwitch: (_) {}));
      await tester.pump(const Duration(milliseconds: 40));

      final arriving = tester.getRect(find.byKey(const ValueKey('page2')));
      expect(
        arriving.left,
        greaterThan(0),
        reason: 'still on its way in from the right',
      );

      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const ValueKey('page2'))).left, 0);
    });

    testWidgets('slides in from the left for a tab to the left', (
      tester,
    ) async {
      await tester.pumpWidget(_host(index: 2, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_host(index: 0, count: 3, onSwitch: (_) {}));
      await tester.pump(const Duration(milliseconds: 40));

      expect(
        tester.getRect(find.byKey(const ValueKey('page0'))).left,
        lessThan(0),
        reason: 'still on its way in from the left',
      );
      await tester.pumpAndSettle();
    });

    testWidgets('the page being left goes out, whichever tab it was', (
      tester,
    ) async {
      // A jump of more than one tab: the page sliding out is the one you left,
      // not whichever happens to sit next to the one you landed on.
      await tester.pumpWidget(_host(index: 0, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();

      await tester.pumpWidget(_host(index: 2, count: 3, onSwitch: (_) {}));
      await tester.pump(const Duration(milliseconds: 40));

      expect(find.byKey(const ValueKey('page0')), findsOneWidget);
      expect(find.byKey(const ValueKey('page1')), findsNothing);
    });

    testWidgets('still slides when the swipe gesture is turned off', (
      tester,
    ) async {
      Widget host(int index) => MaterialApp(
        home: Scaffold(
          body: SwipeableTabs(
            enabled: false,
            currentIndex: index,
            order: const [0, 1, 2],
            onSwitch: (_) {},
            branches: const [
              Center(key: ValueKey('page0'), child: Text('page0')),
              Center(key: ValueKey('page1'), child: Text('page1')),
              Center(key: ValueKey('page2'), child: Text('page2')),
            ],
          ),
        ),
      );

      await tester.pumpWidget(host(0));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(1));
      await tester.pump(const Duration(milliseconds: 40));

      expect(
        tester.getRect(find.byKey(const ValueKey('page1'))).left,
        greaterThan(0),
        reason: 'the slide is the transition, not part of the gesture',
      );
      await tester.pumpAndSettle();
    });

    testWidgets('a rebuild on the same tab does not slide', (tester) async {
      await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();
      await tester.pumpWidget(_host(index: 1, count: 3, onSwitch: (_) {}));
      await tester.pump(const Duration(milliseconds: 40));
      expect(tester.getRect(find.byKey(const ValueKey('page1'))).left, 0);
    });
  });

  group('handing over to the shell', () {
    testWidgets('the page just left never comes back to the middle', (
      tester,
    ) async {
      await tester.pumpWidget(const _LiveTabs(start: 1, count: 3));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(400, 300));
      await gesture.moveBy(const Offset(-400, 0));
      await tester.pump();
      await gesture.up();

      // Where the page being left sits on every frame of the settle and the
      // handover. Missing means it has gone offstage, which is the end of it.
      final trail = <double>[];
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        final outgoing = find.byKey(const ValueKey('page1'));
        if (outgoing.evaluate().isEmpty) break;
        trail.add(tester.getRect(outgoing).left);
      }

      // Once it has started leaving it must keep leaving. Coming back to the
      // middle is the flicker: for one frame the shell still has the old tab
      // selected while the offset has already been zeroed.
      var departed = false;
      for (final left in trail) {
        if (left.abs() > 50) {
          departed = true;
        } else if (departed) {
          fail('the page just left returned to the middle at $left');
        }
      }
      expect(departed, isTrue, reason: 'it never left at all');

      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(const ValueKey('page2'))).left, 0);
    });

    testWidgets('the arriving page ends up centred', (tester) async {
      await tester.pumpWidget(const _LiveTabs(start: 0, count: 3));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(400, 300));
      await gesture.moveBy(const Offset(-400, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byKey(const ValueKey('page1'))).left, 0);
      expect(find.byKey(const ValueKey('page0')), findsNothing);
    });
  });

  group('the ends', () {
    testWidgets('the last tab does not shift when dragged further', (
      tester,
    ) async {
      await tester.pumpWidget(_host(index: 2, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();
      final rest = tester.getRect(find.byKey(const ValueKey('page2')));

      final gesture = await tester.startGesture(const Offset(400, 300));
      await gesture.moveBy(const Offset(-200, 0));
      await tester.pump();

      expect(
        tester.getRect(find.byKey(const ValueKey('page2'))),
        rest,
        reason: 'there is no next tab, so nothing should give',
      );
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('the first tab does not shift either', (tester) async {
      await tester.pumpWidget(_host(index: 0, count: 3, onSwitch: (_) {}));
      await tester.pumpAndSettle();
      final rest = tester.getRect(find.byKey(const ValueKey('page0')));

      final gesture = await tester.startGesture(const Offset(400, 300));
      await gesture.moveBy(const Offset(200, 0));
      await tester.pump();

      expect(tester.getRect(find.byKey(const ValueKey('page0'))), rest);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('a drag away from the end still works', (tester) async {
      final switched = <int>[];
      await tester.pumpWidget(
        _host(index: 2, count: 3, onSwitch: switched.add),
      );
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(400, 300));
      await gesture.moveBy(const Offset(400, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(switched, [1]);
    });
  });
}

/// A host that switches tab when the swipe commits, like the shell does.
///
/// The change lands a frame late on purpose. go_router does not swap the
/// branch in the same frame the swipe asks it to, and that gap is exactly
/// where the outgoing page can flash back into the middle.
class _LiveTabs extends StatefulWidget {
  const _LiveTabs({required this.start, required this.count});
  final int start;
  final int count;

  @override
  State<_LiveTabs> createState() => _LiveTabsState();
}

class _LiveTabsState extends State<_LiveTabs> {
  late int _index = widget.start;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SwipeableTabs(
        currentIndex: _index,
        order: [for (var i = 0; i < widget.count; i++) i],
        onSwitch: (i) => WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _index = i);
        }),
        branches: [
          for (var i = 0; i < widget.count; i++)
            Center(key: ValueKey('page$i'), child: Text('page$i')),
        ],
      ),
    ),
  );
}
