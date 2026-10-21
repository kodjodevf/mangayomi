import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<void> open(
    WidgetTester tester, {
    ValueChanged<double>? onSlide,
    ValueListenable<bool>? seeThrough,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        home: _Host(onSlide: onSlide ?? (_) {}, seeThrough: seeThrough),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens on the first tab and switches on a tap', (tester) async {
    await open(tester);

    expect(find.text('alpha'), findsOneWidget);
    expect(find.text('beta'), findsNothing);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(find.text('beta'), findsOneWidget);
    expect(find.text('alpha'), findsNothing);
  });

  testWidgets('a swipe on the content moves to the next tab', (tester) async {
    await open(tester);

    await tester.fling(find.text('alpha'), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text('beta'), findsOneWidget);
  });

  testWidgets('dragging a slider in a tab moves the slider, not the tab', (
    tester,
  ) async {
    double? slid;
    await open(tester, onSlide: (v) => slid = v);

    await tester.drag(find.byType(Slider), const Offset(-200, 0));
    await tester.pumpAndSettle();

    expect(slid, isNotNull);
    expect(find.text('alpha'), findsOneWidget);
  });

  testWidgets('a tall tab scrolls inside the sheet', (tester) async {
    await open(tester);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(TabBarView),
        matching: find.byType(SingleChildScrollView),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the sheet is as tall as the tab on show', (tester) async {
    await open(tester);
    final short = tester.getSize(find.byType(TabBarView)).height;

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    final tall = tester.getSize(find.byType(TabBarView)).height;

    expect(tall, greaterThan(short));
  });

  testWidgets('mid-swipe, the height is between the two tabs\'', (
    tester,
  ) async {
    await open(tester);
    final short = tester.getSize(find.byType(TabBarView)).height;
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    final tall = tester.getSize(find.byType(TabBarView)).height;
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();

    final width = tester.getSize(find.byType(TabBarView)).width;
    // From the text, not the middle, where tab A's slider would take it.
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('alpha')),
    );
    await gesture.moveBy(Offset(-width / 4, 0));
    await gesture.moveBy(Offset(-width / 4, 0));
    await tester.pump();
    final between = tester.getSize(find.byType(TabBarView)).height;
    await gesture.up();
    await tester.pumpAndSettle();

    expect(between, greaterThan(short));
    expect(between, lessThan(tall));
  });

  testWidgets('turns see-through on its tab while asked to', (tester) async {
    final clear = ValueNotifier(true);
    await open(tester, seeThrough: clear);
    double alpha() {
      final box = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer).first,
      );
      return (box.decoration! as BoxDecoration).color!.a;
    }

    // Opaque on another tab, whatever is asked.
    expect(alpha(), 1);
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(alpha(), lessThan(1));

    clear.value = false;
    await tester.pumpAndSettle();
    expect(alpha(), 1);
  });
}

class _Host extends StatefulWidget {
  const _Host({required this.onSlide, this.seeThrough});

  final ValueChanged<double> onSlide;
  final ValueListenable<bool>? seeThrough;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => customDraggableTabBar(
        context: context,
        vsync: this,
        seeThroughTab: 1,
        seeThrough: widget.seeThrough,
        tabs: const [
          Tab(text: 'A'),
          Tab(text: 'B'),
        ],
        children: [
          Column(
            children: [
              const Text('alpha'),
              Slider(value: 0.5, onChanged: widget.onSlide),
            ],
          ),
          Column(
            children: [
              const Text('beta'),
              for (var i = 0; i < 40; i++) Text('line $i'),
            ],
          ),
        ],
      ),
      child: const Text('open'),
    ),
  );
}
