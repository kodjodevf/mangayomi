import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shiori/shiori.dart';

void main() {
  Widget header({required bool busy}) => MaterialApp(
    theme: buildShioriTheme(
      brightness: Brightness.dark,
      colors: FlexColor.schemesList[2].dark,
      tintSurfaces: false,
      blendLevel: 10,
      density: ShioriDensity.phone,
    ),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ShioriSectionHeader(
          overline: true,
          title: 'Pending',
          actionLabel: 'Update all',
          actionBusy: busy,
          onAction: () {},
        ),
      ),
    ),
  );

  testWidgets('the spinner ends where the label ended, at the same height', (
    tester,
  ) async {
    await tester.pumpWidget(header(busy: false));
    final labelEnd = tester.getTopRight(find.text('Update all')).dx;
    final height = tester.getSize(find.byType(ShioriSectionHeader)).height;

    await tester.pumpWidget(header(busy: true));
    expect(find.text('Update all'), findsNothing);
    final spinner = find.byType(CircularProgressIndicator);
    expect(tester.getTopRight(spinner).dx, labelEnd);
    expect(tester.getSize(find.byType(ShioriSectionHeader)).height, height);
  });

  testWidgets('it cannot be started twice', (tester) async {
    await tester.pumpWidget(header(busy: true));
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).onPressed,
      isNull,
    );
  });
}
