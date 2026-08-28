import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// Measured on a Fire TV: every branch left mounted holds roughly 14 MB of GPU
/// surfaces. Three tabs took Graphics from 27 MB to 69 MB on a box with about
/// 300 MB free and most of its swap already spent.
///
/// So a television shows only the branch it is on, and everywhere else keeps
/// the IndexedStack, where the trade runs the other way: retention buys scroll
/// position and loaded images for memory that is not scarce.
///
/// This exercises the container builder's shape rather than a whole router,
/// which would need every screen in the app to build.
Widget container(
  BuildContext context,
  int currentIndex,
  List<Widget> children,
) => isTv
    ? children[currentIndex]
    : IndexedStack(index: currentIndex, children: children);

void main() {
  tearDown(() => debugIsTvOverride = null);

  Future<void> pump(WidgetTester tester, int index) => tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => container(context, index, const [
          Text('branch 0'),
          Text('branch 1'),
          Text('branch 2'),
        ]),
      ),
    ),
  );

  testWidgets('a television mounts only the branch it is showing', (
    tester,
  ) async {
    debugIsTvOverride = true;

    await pump(tester, 1);

    expect(find.text('branch 1'), findsOneWidget);
    expect(find.text('branch 0'), findsNothing, reason: 'not retained');
    expect(find.text('branch 2'), findsNothing);
    expect(find.byType(IndexedStack), findsNothing);
  });

  testWidgets('and drops the old one when the tab changes', (tester) async {
    debugIsTvOverride = true;
    await pump(tester, 0);
    expect(find.text('branch 0'), findsOneWidget);

    await pump(tester, 2);

    expect(find.text('branch 2'), findsOneWidget);
    expect(find.text('branch 0'), findsNothing);
  });

  testWidgets('everywhere else keeps every branch mounted', (tester) async {
    debugIsTvOverride = false;

    await pump(tester, 1);

    expect(find.byType(IndexedStack), findsOneWidget);
    // Offstage children are still in the tree, which is the point of them.
    expect(find.text('branch 0', skipOffstage: false), findsOneWidget);
    expect(find.text('branch 2', skipOffstage: false), findsOneWidget);
  });
}
