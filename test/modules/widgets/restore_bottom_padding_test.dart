import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/restore_bottom_padding.dart';

/// What the library's body sees: a page under the floating navigation bar
/// (reported as [navBarHeight] of bottom padding) whose own Scaffold holds a
/// selection bar that has collapsed to nothing.
Future<double> _bodyBottomPadding(
  WidgetTester tester, {
  required double navBarHeight,
  required bool restore,
}) async {
  late double seen;
  final probe = Builder(
    builder: (context) {
      seen = MediaQuery.paddingOf(context).bottom;
      return const SizedBox.expand();
    },
  );
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(padding: EdgeInsets.only(bottom: navBarHeight)),
        child: Builder(
          builder: (context) {
            final inset = MediaQuery.paddingOf(context).bottom;
            return Scaffold(
              body: restore
                  ? RestoreBottomPadding(bottom: inset, child: probe)
                  : probe,
              bottomNavigationBar: const SizedBox.shrink(),
            );
          },
        ),
      ),
    ),
  );
  return seen;
}

void main() {
  testWidgets('an empty bottomNavigationBar slot strips the padding', (
    tester,
  ) async {
    // Why the library needs the fix: the bar's height never reaches the grid.
    expect(
      await _bodyBottomPadding(tester, navBarHeight: 90, restore: false),
      0,
    );
  });

  testWidgets('the body gets the navigation bar height back', (tester) async {
    expect(
      await _bodyBottomPadding(tester, navBarHeight: 90, restore: true),
      90,
    );
  });

  testWidgets('with no bar below there is nothing to give back', (
    tester,
  ) async {
    expect(
      await _bodyBottomPadding(tester, navBarHeight: 0, restore: true),
      0,
    );
  });
}
