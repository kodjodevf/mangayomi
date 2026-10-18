import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/reader/widgets/navigation_overlay.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<List<String>> pump(WidgetTester tester, int layout) async {
    final calls = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ReaderNavigationOverlay(
            navigationLayout: layout,
            tappingInversion: 0,
            isRTL: false,
            onClose: () => calls.add('close'),
          ),
        ),
      ),
    );
    return calls;
  }

  testWidgets("names the zones in the reader's language", (tester) async {
    await pump(tester, 4);
    expect(find.text('Précédente'), findsOneWidget);
    expect(find.text('Suivante'), findsOneWidget);
    expect(find.text('PREV'), findsNothing);
    expect(find.text("Touchez n'importe où pour continuer"), findsOneWidget);
  });

  testWidgets('a tap anywhere closes it', (tester) async {
    final calls = await pump(tester, 0);
    expect(find.text('Menu'), findsWidgets);
    await tester.tapAt(const Offset(200, 300));
    expect(calls, ['close']);
  });
}
