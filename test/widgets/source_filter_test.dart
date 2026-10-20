import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/model/filter.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/home/widget/filter_widget.dart';
import 'package:shiori/shiori.dart';

void main() {
  late List<dynamic> filters;

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => FilterWidget(
              filterList: filters,
              onChanged: (values) => setState(() => filters = values),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() {
    filters = [
      HeaderFilter('Genres', null),
      TriStateFilter(null, 'Action', 'action', null),
      CheckBoxFilter(null, 'Completed', 'completed', null),
      SelectFilter(null, 'Type', 1, [
        SelectFilterOption('Manga', 'manga', null),
        SelectFilterOption('Manhwa', 'manhwa', null),
      ], null),
    ];
  });

  testWidgets('a tri-state filter cycles through include and exclude', (
    tester,
  ) async {
    await pump(tester);
    expect(
      find.byIcon(Symbols.check_box_outline_blank_rounded),
      findsNWidgets(2),
    );

    await tester.tap(find.text('Action'));
    await tester.pumpAndSettle();
    expect((filters[1] as TriStateFilter).state, 1);

    await tester.tap(find.text('Action'));
    await tester.pumpAndSettle();
    expect((filters[1] as TriStateFilter).state, 2);
    // Excluded is the cross, not Material's dash.
    expect(find.byIcon(Symbols.disabled_by_default_rounded), findsOneWidget);

    await tester.tap(find.text('Action'));
    await tester.pumpAndSettle();
    expect((filters[1] as TriStateFilter).state, 0);
  });

  testWidgets(
    'a box toggles, a header is a group label, a list shows its value',
    (tester) async {
      await pump(tester);
      expect(find.byType(ShioriGroupLabel), findsOneWidget);
      expect(find.text('GENRES'), findsOneWidget);

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect((filters[2] as CheckBoxFilter).state, isTrue);

      // The value is in the row, without opening it.
      expect(find.text('Manhwa'), findsOneWidget);
    },
  );
}
