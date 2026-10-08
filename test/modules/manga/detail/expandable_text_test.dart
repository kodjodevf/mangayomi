import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/manga/detail/widgets/expandable_text.dart';

void main() {
  testWidgets('keeps the description chevron below the readable text', (
    tester,
  ) async {
    final changes = <bool>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 240,
                child: ExpandableText(
                  List.filled(
                    12,
                    'A description line that should remain readable.',
                  ).join(' '),
                  expandText: '',
                  maxLines: 3,
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  showGradientOverlay: false,
                  showExpandCollapseIcon: true,
                  expandIcon: Icons.keyboard_arrow_down_sharp,
                  collapseIcon: Icons.keyboard_arrow_up_sharp,
                  onExpandedChanged: changes.add,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final text = find.byType(SelectableText);
    final expand = find.byIcon(Icons.keyboard_arrow_down_sharp);
    expect(text, findsOneWidget);
    expect(expand, findsOneWidget);
    expect(
      tester.getTopLeft(expand).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(text).dy),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(expand);
    await tester.pump();

    final collapse = find.byIcon(Icons.keyboard_arrow_up_sharp);
    expect(changes, [true]);
    expect(collapse, findsOneWidget);
    expect(
      tester.getTopLeft(collapse).dy,
      greaterThanOrEqualTo(tester.getBottomLeft(text).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
