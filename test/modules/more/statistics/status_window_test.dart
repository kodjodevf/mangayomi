import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/status_window_view.dart';
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

Future<void> _pump(
  WidgetTester tester, {
  bool recap = true,
  StatusWindowData? data,
  double width = 420,
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
        recapMangaProvider.overrideWith((ref, id) async => null),
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
        home: const StatisticsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(StatisticsScreen)))!;

void main() {
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
