import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/detail/widgets/manga_info_header.dart';
import 'package:shiori/shiori.dart';

void main() {
  /// Opens the list in a sheet over a page, as the Explore action does.
  Future<List<String>> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final opened = <String>[];
    final actions = [
      for (final (icon, label, description) in [
        (
          Symbols.auto_awesome_rounded,
          'Recommendations',
          'Titles like this one',
        ),
        (
          Symbols.account_tree_rounded,
          'Related titles',
          'Its adaptations, spin-offs and other versions',
        ),
        (
          Symbols.format_list_numbered_rounded,
          'Watch order',
          'The order to watch the whole story in',
        ),
        (
          Symbols.playlist_play_rounded,
          'Sequels',
          'What comes after, from your tracker',
        ),
      ])
        DetailExploreAction(
          icon: icon,
          label: label,
          description: description,
          onPressed: () => opened.add(label),
        ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showShioriSheet<void>(
                context,
                title: 'Explorer',
                builder: (_) => DetailExploreList(actions: actions),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return opened;
  }

  testWidgets('each place is a row that says what is there', (tester) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ShioriSettingRow), findsNWidgets(4));
    expect(
      find.text('Its adaptations, spin-offs and other versions'),
      findsOneWidget,
    );
  });

  testWidgets('a row closes the sheet, then opens its place', (tester) async {
    final opened = await open(tester);
    await tester.tap(find.text('Related titles'));
    await tester.pumpAndSettle();
    expect(opened, ['Related titles']);
    expect(find.byType(DetailExploreList), findsNothing);
  });
}
