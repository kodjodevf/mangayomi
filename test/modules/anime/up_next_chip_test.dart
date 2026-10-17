import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/widgets/up_next_chip.dart';
import 'package:shiori/shiori.dart';

void main() {
  testWidgets('counts down, plays now, or stays', (tester) async {
    var played = false, stayed = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: buildShioriTheme(
          brightness: Brightness.light,
          colors: FlexColor.schemesList[2].light,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        home: Scaffold(
          body: Center(
            child: UpNextChip(
              secondsLeft: 12,
              onPlayNow: () => played = true,
              onCancel: () => stayed = true,
            ),
          ),
        ),
      ),
    );
    expect(find.text('Next episode in 12 s'), findsOneWidget);
    // White on the scrim, even in the light theme.
    expect(
      tester.widget<Text>(find.text('Next episode in 12 s')).style!.color,
      Colors.white,
    );
    await tester.tap(find.text('Next episode in 12 s'));
    expect(played, isTrue);
    await tester.tap(find.byTooltip('Stay on this episode'));
    expect(stayed, isTrue);
  });
}
