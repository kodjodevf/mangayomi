import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/anime/widgets/gesture_hint_overlay.dart';
import 'package:shiori/shiori.dart';

void main() {
  testWidgets('names every gesture, fits a landscape phone, taps away', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(780, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: buildShioriTheme(
          brightness: Brightness.dark,
          colors: FlexColor.schemesList[2].dark,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(780, 360),
            textScaler: TextScaler.linear(1.3),
          ),
          child: Scaffold(
            body: GestureHintOverlay(onDismiss: () => dismissed = true),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('brightness'), findsOneWidget);
    expect(find.textContaining('volume'), findsOneWidget);
    await tester.tap(find.text('Tap anywhere to continue'));
    expect(dismissed, isTrue);
  });
}
