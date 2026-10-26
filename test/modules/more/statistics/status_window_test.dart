import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/status_window_view.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_bonded_list.dart';
import 'package:mangayomi/modules/more/statistics/statistics_provider.dart';
import 'package:mangayomi/modules/more/statistics/statistics_screen.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/statistics_recap_state_provider.dart';
import 'package:shiori/shiori.dart';

class _NotTv extends AnimeOnlyTvMode {
  @override
  bool build() => false;
}

class _AllTypes extends HideItemsState {
  @override
  List<String> build() => const [];
}

class _Recap extends StatisticsRecapState {
  _Recap(this.on);
  final bool on;

  @override
  bool build() => on;

  @override
  void set(bool value) => state = value;
}

class _NoName extends StatisticsReaderNameState {
  @override
  String? build() => null;
}

StatusWindowData _veteranData() => deriveStatusWindow(
  favs: [
    for (var i = 0; i < 30; i++)
      RecapSeries(
        id: i + 1,
        name: 'Return of Series $i',
        genres: const ['Action', 'Regression'],
        source: 'Asura Scans',
        chaptersRead: 10 + i,
        seconds: 3600 * (30 - i),
      ),
  ],
  units: 37709,
  clearedCount: 13,
  clockMs: [DateTime(2026, 10, 19, 7).millisecondsSinceEpoch],
  firstLogMs: null,
  maxDayCompletions: 3,
  now: DateTime(2026, 10, 25),
);

StatusWindowData _emptyData() => deriveStatusWindow(
  favs: const [],
  units: 0,
  clearedCount: 0,
  clockMs: const [],
  firstLogMs: null,
  maxDayCompletions: 0,
  now: DateTime(2026, 10, 25),
);

/// A series whose cover link is gone, as after a restore from a dead CDN.
Manga _coverless(int id, String name) => Manga(
  source: 'Asura Scans',
  author: '',
  artist: '',
  genre: const [],
  imageUrl: null,
  lang: 'en',
  link: '/$id',
  name: name,
  status: Status.ongoing,
  description: '',
  sourceId: null,
  itemType: ItemType.manga,
);

Future<void> _pump(
  WidgetTester tester, {
  bool recap = true,
  StatusWindowData? data,
  double width = 420,
  Manga? Function(int id)? manga,
  Widget home = const StatisticsScreen(),
}) async {
  tester.view.physicalSize = Size(width, 5200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        animeOnlyTvModeProvider.overrideWith(_NotTv.new),
        hideItemsStateProvider.overrideWith(_AllTypes.new),
        statisticsRecapStateProvider.overrideWith(() => _Recap(recap)),
        statisticsReaderNameStateProvider.overrideWith(_NoName.new),
        recapFontsProvider.overrideWithValue(RecapFonts.system),
        recapMangaProvider.overrideWith((ref, id) async => manga?.call(id)),
        statusWindowProvider.overrideWith(
          (ref, type) async => data ?? _veteranData(),
        ),
        getStatisticsProvider.overrideWith(
          (ref, type) async => const StatisticsData(
            totalItems: 546,
            totalChapters: 40000,
            readChapters: 37709,
            completedItems: 13,
            downloadedItems: 0,
            totalReadingTimeSeconds: 3600,
          ),
        ),
      ],
      child: MaterialApp(
        theme: buildShioriTheme(
          brightness: Brightness.light,
          colors: FlexColor.schemesList[2].light,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: home,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(StatisticsScreen)))!;

void main() {
  testWidgets('bonded tiles show how long you have read each series', (
    tester,
  ) async {
    int ms(int y, int m, int d) => DateTime(y, m, d).millisecondsSinceEpoch;
    await _pump(
      tester,
      data: deriveStatusWindow(
        favs: [
          RecapSeries(
            id: 1,
            name: 'Nano Machine',
            dateAdded: ms(2021, 3, 1),
            lastReadMs: ms(2026, 10, 1),
            chaptersRead: 100,
          ),
          RecapSeries(
            id: 2,
            name: 'Binge',
            dateAdded: ms(2026, 2, 10),
            lastReadMs: ms(2026, 10, 1),
            chaptersRead: 300,
          ),
        ],
        units: 400,
        clearedCount: 0,
        clockMs: const [],
        firstLogMs: null,
        maxDayCompletions: 0,
        now: DateTime(2026, 10, 25),
      ),
    );

    expect(find.textContaining('5 years together'), findsOneWidget);
    expect(find.text('7mo'), findsOneWidget);
  });

  testWidgets('without reading dates bonded tiles fall back to hours', (
    tester,
  ) async {
    // _veteranData has no last-read dates, like a library restored before
    // the restore fix.
    await _pump(tester);

    expect(find.textContaining('hours together'), findsOneWidget);
    expect(find.textContaining('together'), findsOneWidget);
    // Equal (unknown) bonds rank by chapters: ids 30, then 29 to 26.
    expect(find.text('2h'), findsOneWidget);
  });

  testWidgets('bonded series without a cover show their titles', (
    tester,
  ) async {
    await _pump(tester, manga: (id) => _coverless(id, 'Cover $id'));

    // #2 to #5 are small tiles whose only text would otherwise be hours.
    expect(find.text('Cover 27'), findsOneWidget);
  });
  testWidgets('bonded offers every series past the top five', (tester) async {
    await _pump(tester);

    expect(find.textContaining('VIEW ALL 30'), findsOneWidget);
  });

  testWidgets('five bonded series or fewer have nothing more to view', (
    tester,
  ) async {
    final five = _veteranData();
    await _pump(
      tester,
      data: deriveStatusWindow(
        favs: five.bonded.take(5).toList(),
        units: 100,
        clearedCount: 0,
        clockMs: const [],
        firstLogMs: null,
        maxDayCompletions: 0,
        now: DateTime(2026, 10, 25),
      ),
    );

    expect(find.textContaining('VIEW ALL'), findsNothing);
  });

  testWidgets('the bonded list ranks every series', (tester) async {
    await _pump(
      tester,
      home: const SwBondedListScreen(itemType: ItemType.manga),
    );

    expect(find.text('#1'), findsOneWidget);
    expect(find.text('#30'), findsOneWidget);
    // No dates, so chapters decide: series 29 first, series 0 last.
    expect(
      tester.getTopLeft(find.text('Return of Series 29')).dy,
      lessThan(tester.getTopLeft(find.text('Return of Series 0')).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows level 97 and 707 to next', (tester) async {
    await _pump(tester);

    expect(find.byType(StatusWindowView), findsOneWidget);
    expect(find.text('97'), findsOneWidget);
    expect(find.textContaining('707'), findsOneWidget);
    expect(find.textContaining('Lv. 98'), findsOneWidget);
    expect(find.text('Regressor'), findsWidgets);
    expect(find.textContaining('Asura Scans'), findsWidgets);
  });

  testWidgets('locked badge shows ???', (tester) async {
    await _pump(tester);

    // Regressor (30 series) is unlocked; Collector (30 < 500) is not.
    expect(find.text('???'), findsWidgets);
    expect(find.textContaining('30 regression'), findsOneWidget);
  });

  testWidgets('empty data renders without exceptions', (tester) async {
    await _pump(tester, data: _emptyData());

    expect(tester.takeException(), isNull);
    expect(find.byType(StatusWindowView), findsOneWidget);
    expect(find.text('0'), findsWidgets);
    expect(find.text('???'), findsNWidgets(BadgeId.values.length));
    expect(find.textContaining('NaN'), findsNothing);
  });

  testWidgets('fits a narrow phone', (tester) async {
    await _pump(tester, width: 360);

    expect(tester.takeException(), isNull);
    expect(find.text('97'), findsOneWidget);
  });

  testWidgets('toggle off shows classic cards', (tester) async {
    await _pump(tester, recap: false);
    final l10n = _l10n(tester);

    expect(find.byType(StatusWindowView), findsNothing);
    expect(find.text(l10n.in_library), findsOneWidget);
  });

  testWidgets('overflow menu switches to the classic view', (tester) async {
    await _pump(tester);
    final l10n = _l10n(tester);

    await tester.tap(find.byType(PopupMenuButton<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.recapClassicView));
    await tester.pumpAndSettle();

    expect(find.byType(StatusWindowView), findsNothing);
    expect(find.text(l10n.in_library), findsOneWidget);
  });
}
