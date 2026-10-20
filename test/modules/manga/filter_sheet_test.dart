import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:shiori/shiori.dart';

void main() {
  testWidgets('a filters sheet is as tall as its few filters', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showShioriSheet<void>(
                context,
                builder: (_) => FilterSheetBody(
                  filters: [
                    HeaderFilter('Genres', 'HeaderFilter'),
                    TextFilter('', 'Author', 'TextFilter'),
                  ],
                  onChanged: (_) {},
                  onReset: () {},
                  onApply: () {},
                  resetLabel: 'Reset',
                  applyLabel: 'Filter',
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // It held three quarters of the screen whatever the filters.
    expect(tester.getSize(find.byType(FilterSheetBody)).height, lessThan(400));
    expect(find.text('Author'), findsOneWidget);
  });
}
