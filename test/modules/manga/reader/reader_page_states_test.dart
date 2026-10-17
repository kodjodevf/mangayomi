import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_page_states.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
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
      // A white reader background, where the old white text vanished.
      home: ColoredBox(color: Colors.white, child: child),
    ),
  );

  testWidgets('loading says how far it has come once it knows', (tester) async {
    await pump(tester, const ReaderPageLoading(progress: 0.42));
    await tester.pumpAndSettle();
    expect(find.text('42 %'), findsOneWidget);

    await pump(tester, const ReaderPageLoading(progress: 0));
    await tester.pump();
    expect(find.byType(ShioriOverlayLabel), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('a failed page says so on its own card, and retries', (
    tester,
  ) async {
    var retried = false;
    await pump(tester, ReaderPageError(onRetry: () => retried = true));
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ReaderPageError)),
    )!;
    expect(find.text(l10n.image_loading_error), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text(l10n.image_loading_error),
        matching: find.byType(Material),
      ),
      findsWidgets,
    );
    await tester.tap(find.text(l10n.retry));
    expect(retried, isTrue);
  });
}
