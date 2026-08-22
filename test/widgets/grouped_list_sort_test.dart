import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';

/// When the grouped list re-sorts, and when it leaves well alone.
///
/// Sorting used to run inside build, so it was paid again on every rebuild
/// rather than when the data changed. A repo that generates an entry per
/// language pushes that to tens of thousands of elements, and the list then
/// stops painting and will not scroll.
///
/// Counting groupBy calls rather than timing anything: the cost is dominated
/// by the comparator, and a clock makes for a flaky test.
void main() {
  late int groupByCalls;

  setUp(() => groupByCalls = 0);

  Widget host(List<int> elements) => MaterialApp(
    home: Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverGroupedListView<int, String>(
            elements: elements,
            groupBy: (i) {
              groupByCalls++;
              return 'group ${i % 5}';
            },
            groupSeparatorBuilder: (g) => SizedBox(height: 20, child: Text(g)),
            itemBuilder: (context, i) =>
                SizedBox(height: 40, child: Text('item $i')),
          ),
        ],
      ),
    ),
  );

  /// A list with the same contents, rebuilt. This is what callers do: they
  /// collect into a fresh List on every build, so identity never matches and
  /// only the contents can tell you anything.
  List<int> freshCopy(List<int> of) => [...of];

  testWidgets('a rebuild with the same contents does not re-sort', (
    tester,
  ) async {
    final elements = List<int>.generate(300, (i) => 300 - i);
    await tester.pumpWidget(host(elements));
    await tester.pumpAndSettle();

    final afterFirstBuild = groupByCalls;
    expect(afterFirstBuild, greaterThan(0), reason: 'it should sort once');

    // Rebuild several times over, as a scroll or a provider tick would.
    for (var i = 0; i < 5; i++) {
      await tester.pumpWidget(host(freshCopy(elements)));
      await tester.pumpAndSettle();
    }

    // Some calls still happen: the delegate asks for group keys to decide
    // where separators go. What must not happen is the sort itself, which is
    // the part that scales with the list.
    expect(
      groupByCalls - afterFirstBuild,
      lessThan(afterFirstBuild),
      reason: 'five rebuilds cost more than the original sort, so it re-sorted',
    );
  });

  testWidgets('changed contents do re-sort', (tester) async {
    final elements = List<int>.generate(300, (i) => 300 - i);
    await tester.pumpWidget(host(elements));
    await tester.pumpAndSettle();
    final afterFirstBuild = groupByCalls;

    await tester.pumpWidget(host([...elements, 301, 302, 303]));
    await tester.pumpAndSettle();

    expect(
      groupByCalls - afterFirstBuild,
      greaterThan(afterFirstBuild ~/ 2),
      reason: 'new data has to be sorted, memo or not',
    );
  });

  testWidgets('the order it produces is unchanged', (tester) async {
    // The memo must not alter what the list shows, only when it works it out.
    // Grouped first, then ordered inside the group: i % 5 puts 5 in group 0.
    final elements = [5, 3, 1, 4, 2];
    await tester.pumpWidget(host(elements));
    await tester.pumpAndSettle();

    final shown = tester
        .widgetList<Text>(find.byType(Text))
        .map((t) => t.data)
        .where((d) => d != null && d.startsWith('item '))
        .toList();
    expect(shown, ['item 5', 'item 1', 'item 2', 'item 3', 'item 4']);
  });
}
