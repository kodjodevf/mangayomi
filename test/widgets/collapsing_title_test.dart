import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/collapsing_header.dart';
import 'package:shiori/shiori.dart';

void main() {
  const follower = Key('follower');

  Widget host(String title) => MaterialApp(
    theme: buildShioriTheme(
      brightness: Brightness.dark,
      colors: FlexColor.schemesList[2].dark,
      tintSurfaces: false,
      blendLevel: 10,
      density: ShioriDensity.phone,
    ),
    home: Scaffold(
      body: Row(
        children: [
          Flexible(child: CollapsingTitle(title)),
          const SizedBox(key: follower, width: 20, height: 20),
        ],
      ),
    ),
  );

  double followerStart(WidgetTester tester) =>
      tester.getTopLeft(find.byKey(follower)).dx;

  Future<void> settle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  for (final (from, to) in [
    ('A much longer title', 'Short'),
    ('Short', 'A much longer title'),
  ]) {
    testWidgets('what follows moves with the title: "$from" to "$to"', (
      tester,
    ) async {
      await tester.pumpWidget(host(from));
      final start = followerStart(tester);

      await tester.pumpWidget(host(to));
      // Nothing jumps when the change starts.
      await tester.pump();
      expect(followerStart(tester), closeTo(start, 1));

      final motion = ShioriMotion.of(
        tester.element(find.byType(CollapsingTitle)),
        ShioriMotion.standard,
      );
      await tester.pump(motion * 0.5);
      final halfway = followerStart(tester);

      await settle(tester);
      final end = followerStart(tester);
      expect(end, isNot(closeTo(start, 1)));
      // On its way while the old words are still fading.
      final travelled = (halfway - start) / (end - start);
      expect(travelled, greaterThan(0.2));
      expect(travelled, lessThan(1));
      expect(tester.getTopLeft(find.text(to)).dx, 0);
      expect(find.text(from), findsNothing);
    });
  }

  testWidgets('the old words keep their width while they fade', (tester) async {
    await tester.pumpWidget(host('A much longer title'));
    final width = tester.getSize(find.text('A much longer title')).width;

    await tester.pumpWidget(host('Short'));
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.getSize(find.text('A much longer title')).width, width);
  });

  testWidgets('a title too long for the row still ends in an ellipsis', (
    tester,
  ) async {
    await tester.pumpWidget(host('Short'));
    await tester.pumpWidget(host('Long ' * 100));
    await settle(tester);
    expect(tester.takeException(), isNull);
    expect(
      followerStart(tester) + 20,
      lessThanOrEqualTo(tester.getSize(find.byType(Scaffold)).width),
    );
  });
}
