import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track_search.dart';
import 'package:mangayomi/modules/tracker_library/tracker_item_card.dart';
import 'package:shiori/shiori.dart';

void main() {
  Future<AppLocalizations> pump(
    WidgetTester tester,
    TrackSearch track, {
    int? mangaId,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TrackerItemCard(
            track: track,
            itemType: ItemType.manga,
            mangaId: mangaId,
          ),
        ),
      ),
    );
    await tester.pump();
    return AppLocalizations.of(tester.element(find.byType(TrackerItemCard)))!;
  }

  testWidgets('shows the entry and the add action', (tester) async {
    final l10n = await pump(
      tester,
      TrackSearch(title: 'Pluto', score: 8.5, totalChapter: 65, summary: ''),
    );
    expect(find.text('Pluto'), findsOneWidget);
    expect(find.text('★ 8.5 · 65 ${l10n.chapters}'), findsOneWidget);
    expect(
      find.widgetWithText(ShioriButton, l10n.track_library_add),
      findsOneWidget,
    );
    // Not in the library, and no page on the tracker: neither action.
    expect(find.text(l10n.track_library_navigate), findsNothing);
    expect(find.text(l10n.open_in_browser), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('offers to open it in the library when it is there', (
    tester,
  ) async {
    final l10n = await pump(
      tester,
      TrackSearch(
        title: 'Pluto',
        summary: '',
        trackingUrl: 'https://example.org/pluto',
      ),
      mangaId: 1,
    );
    expect(find.text(l10n.track_library_navigate), findsOneWidget);
    expect(find.text(l10n.open_in_browser), findsOneWidget);
  });
}
