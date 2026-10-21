import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<void> pump(WidgetTester tester, String notes) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: DownloadFileScreen(
              updateAvailable: ('0.7.0', notes, 'https://example.org', []),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('is a Shiori dialog with the version and the notes', (
    tester,
  ) async {
    await pump(tester, '- Faster library\n\n**Full Changelog**: v0.6...v0.7');

    expect(find.byType(ShioriDialog), findsOneWidget);
    expect(find.textContaining('v0.7.0', findRichText: true), findsOneWidget);
    expect(find.text('- Faster library'), findsOneWidget);
    // The link to the full changelog is dropped from the notes.
    expect(find.textContaining('Full Changelog'), findsNothing);
  });

  testWidgets('says so when a release has no notes', (tester) async {
    await pump(tester, '');
    final l10n = AppLocalizations.of(
      tester.element(find.byType(DownloadFileScreen)),
    )!;
    expect(find.text(l10n.update_no_notes), findsOneWidget);
  });

  testWidgets('fits a phone', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pump(tester, List.filled(40, '- A change').join('\n'));
    expect(tester.takeException(), isNull);
  });
}
