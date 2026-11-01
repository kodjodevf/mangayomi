import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/widgets/foreign_updates_dialog.dart';
import 'package:shiori/shiori.dart';

final _source = Source(id: 1, name: 'Asura Scans')
  ..repo = Repo(name: 'Origin', jsonUrl: 'https://origin.test/index.json')
  ..updateRepo = Repo(name: 'Fork', jsonUrl: 'https://fork.test/index.json');

void main() {
  /// Opens the dialog and gives back how it was answered, once it is.
  Future<ForeignUpdatesChoice? Function()> open(
    WidgetTester tester, {
    required bool hasOthers,
    int count = 1,
  }) async {
    ForeignUpdatesChoice? answer;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.light,
          colors: FlexColor.schemesList[2].light,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              answer = await showForeignUpdatesDialog(
                context,
                foreign: List.filled(count, _source),
                hasOthers: hasOthers,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => answer;
  }

  testWidgets('names each extension and where it would move', (tester) async {
    await open(tester, hasOthers: true);
    expect(find.text('Asura Scans'), findsOneWidget);
    expect(find.text('Origin → Fork'), findsOneWidget);
  });

  testWidgets('update all includes them', (tester) async {
    final answer = await open(tester, hasOthers: true);
    await tester.tap(find.text('Update all'));
    await tester.pumpAndSettle();
    expect(answer(), ForeignUpdatesChoice.includeThem);
  });

  testWidgets('they can be left out', (tester) async {
    final answer = await open(tester, hasOthers: true);
    await tester.tap(find.text('Only from their own repository'));
    await tester.pumpAndSettle();
    expect(answer(), ForeignUpdatesChoice.skipThem);
  });

  testWidgets('leaving them out is no choice when nothing else is left', (
    tester,
  ) async {
    await open(tester, hasOthers: false);
    expect(find.text('Only from their own repository'), findsNothing);
    expect(find.text('Update all'), findsOneWidget);
  });

  testWidgets('cancelling updates nothing', (tester) async {
    final answer = await open(tester, hasOthers: true);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(answer(), isNull);
  });

  testWidgets('a long list scrolls instead of overflowing', (tester) async {
    await open(tester, hasOthers: true, count: 60);
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsWidgets);
  });
}
