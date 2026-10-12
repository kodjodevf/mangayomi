import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:mangayomi/modules/widgets/listview_widget.dart';
import 'package:mangayomi/utils/platform_utils.dart';

const _screen = Size(400, 800);
const _itemCount = 40;
const _destinations = [
  NavigationDestination(icon: Icon(Icons.book), label: 'Manga'),
  NavigationDestination(icon: Icon(Icons.movie), label: 'Anime'),
  NavigationDestination(icon: Icon(Icons.explore), label: 'Browse'),
  NavigationDestination(icon: Icon(Icons.history), label: 'History'),
  NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
];

Future<void> _pumpShell(WidgetTester tester, Widget Function() body) async {
  tester.view
    ..physicalSize = _screen
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: FloatingNavigationScope(
        enabled: true,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: SizedBox(
            width: _screen.width,
            child: FloatingNavBar(
              destinations: _destinations,
              currentIndex: 0,
              onSelected: (_) {},
            ),
          ),
          body: body(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// The painted capsule, which is what the eye reads as the bar's top edge.
Rect _pillRect(WidgetTester tester) => tester.getRect(
  find.descendant(
    of: find.byType(AnimatedPositioned),
    matching: find.byType(AnimatedContainer),
  ),
);

void main() {
  testWidgets('grid ends its last row above the floating capsule', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpShell(
      tester,
      () => GridViewWidget(
        controller: controller,
        itemCount: _itemCount,
        gridSize: 1,
        childAspectRatio: 4,
        itemBuilder: (context, index) =>
            SizedBox.expand(key: ValueKey('item-$index')),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();

    final lastBottom = tester
        .getRect(find.byKey(ValueKey('item-${_itemCount - 1}')))
        .bottom;
    expect(lastBottom, lessThanOrEqualTo(_pillRect(tester).top));
  });

  testWidgets('list ends its last row above the floating capsule', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await _pumpShell(
      tester,
      () => SuperListViewWidget(
        controller: controller,
        itemCount: _itemCount,
        itemBuilder: (context, index) => SizedBox(
          key: ValueKey('item-$index'),
          height: 100,
          width: double.infinity,
        ),
      ),
    );

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();

    final lastBottom = tester
        .getRect(find.byKey(ValueKey('item-${_itemCount - 1}')))
        .bottom;
    expect(lastBottom, lessThanOrEqualTo(_pillRect(tester).top));
  });
}
