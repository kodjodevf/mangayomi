import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_list_screen.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_routes.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_screen.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/biggest_day_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/calendar_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/cliffhanger_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/clock_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/counts_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/finished_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/genres_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/hours_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/prologue_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/title_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/panels/top_series_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/share_panel.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/strip_theme.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_cover.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:shiori/shiori.dart';

MonthStats _october({
  List<int> finishedIds = const [2, 3],
  List<Skill>? genres,
}) => MonthStats(
  month: DateTime(2026, 10),
  seconds: 40 * 3600,
  completions: 340,
  seriesCount: 25,
  newSeriesCount: 4,
  biggestDay: (day: DateTime(2026, 10, 12), completions: 61),
  daysRead: const {1, 2, 3, 5, 12, 13, 14},
  longestStreak: 3,
  top: const RecapSeries(
    id: 1,
    name: 'Nano Machine',
    chaptersRead: 80,
    seconds: 9 * 3600,
  ),
  genres:
      genres ??
      const [
        Skill(genre: 'Action', count: 20, share: 0.8, rank: SkillRank.sss),
        Skill(genre: 'Murim', count: 6, share: 0.24, rank: SkillRank.b),
      ],
  hourHistogram: [for (var h = 0; h < 24; h++) h == 7 ? 30 : 1],
  finishedIds: finishedIds,
  previousSeconds: 28 * 3600,
);

StatusWindowData _allTime() => deriveStatusWindow(
  favs: [
    for (var i = 0; i < 12; i++)
      RecapSeries(
        id: i + 1,
        name: 'Series $i',
        genres: const ['Action'],
        source: 'Asura Scans',
        dateAdded: DateTime(2023, 3, 4).millisecondsSinceEpoch,
        chaptersRead: 40 + i,
        seconds: 3600 * (12 - i),
      ),
  ],
  units: 37709,
  clearedCount: 13,
  clockMs: [DateTime(2026, 10, 19, 7).millisecondsSinceEpoch],
  firstLogMs: null,
  maxDayCompletions: 0,
  now: DateTime(2026, 10, 25),
);

EpisodeSummary _summary(int month, int hours) => EpisodeSummary(
  month: DateTime(2026, month),
  seconds: hours * 3600,
  completions: 100 + month,
  coverMangaIds: const [1, 2, 3],
);

Future<void> _pump(
  WidgetTester tester,
  String location, {
  List<EpisodeSummary>? months,
  MonthStats? month,
  double width = 420,
}) async {
  tester.view.physicalSize = Size(width, 4200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(initialLocation: location, routes: episodeRoutes);
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        recapFontsProvider.overrideWithValue(RecapFonts.system),
        recapMangaProvider.overrideWith((ref, id) async => null),
        statusWindowProvider.overrideWith((ref, type) async => _allTime()),
        episodeListProvider.overrideWith(
          (ref, type) async => (
            months: months ?? [_summary(10, 40), _summary(9, 28)],
            prologue: _allTime(),
          ),
        ),
        episodeProvider.overrideWith((ref, args) async => month ?? _october()),
      ],
      child: MaterialApp.router(
        theme: buildShioriTheme(
          brightness: Brightness.light,
          colors: FlexColor.schemesList[2].light,
          tintSurfaces: false,
          blendLevel: 10,
          density: ShioriDensity.phone,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

AppLocalizations _l10n(WidgetTester tester) =>
    AppLocalizations.of(tester.element(find.byType(Scaffold).first))!;

double _top(WidgetTester tester, Finder finder) => tester.getTopLeft(finder).dy;

void main() {
  testWidgets('list shows months newest first plus Prologue', (tester) async {
    await _pump(tester, '/statistics/episodes?type=manga');
    final l10n = _l10n(tester);

    final october = find.textContaining('October 2026');
    final september = find.textContaining('September 2026');
    final prologue = find.text(l10n.recapPrologue);
    expect(october, findsOneWidget);
    expect(september, findsOneWidget);
    expect(prologue, findsOneWidget);
    expect(_top(tester, october), lessThan(_top(tester, september)));
    expect(_top(tester, september), lessThan(_top(tester, prologue)));
    expect(find.text(l10n.recapEpisodesEmpty), findsNothing);
  });

  testWidgets('empty log shows only Prologue and the note', (tester) async {
    await _pump(tester, '/statistics/episodes?type=manga', months: const []);
    final l10n = _l10n(tester);

    expect(find.text(l10n.recapPrologue), findsOneWidget);
    expect(find.text(l10n.recapEpisodesEmpty), findsOneWidget);
    expect(find.textContaining('2026'), findsNothing);
  });

  testWidgets('tapping a month opens its episode', (tester) async {
    await _pump(tester, '/statistics/episodes?type=manga');

    await tester.tap(find.textContaining('October 2026'));
    await tester.pumpAndSettle();

    expect(find.byType(EpisodeScreen), findsOneWidget);
    expect(find.byType(TitlePanel), findsOneWidget);
  });

  testWidgets('episode renders panels in order', (tester) async {
    await _pump(tester, '/statistics/episodes/2026-10?type=manga');

    const order = [
      TitlePanel,
      HoursPanel,
      CountsPanel,
      TopSeriesPanel,
      BiggestDayPanel,
      CalendarPanel,
      GenresPanel,
      ClockPanel,
      FinishedPanel,
      CliffhangerPanel,
    ];
    for (final type in order) {
      expect(find.byType(type), findsOneWidget, reason: '$type');
    }
    final tops = [for (final type in order) _top(tester, find.byType(type))];
    expect(tops, orderedEquals([...tops]..sort()));
    expect(tester.takeException(), isNull);
  });

  testWidgets('hours panel shows +12h vs previous', (tester) async {
    await _pump(tester, '/statistics/episodes/2026-10?type=manga');

    expect(find.textContaining('+12h'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
  });

  testWidgets('a month with nothing finished omits that panel', (tester) async {
    await _pump(
      tester,
      '/statistics/episodes/2026-10?type=manga',
      month: _october(finishedIds: const []),
    );

    expect(find.byType(FinishedPanel), findsNothing);
    expect(find.byType(CliffhangerPanel), findsOneWidget);
  });

  testWidgets('prologue episode is built from all-time totals', (tester) async {
    await _pump(tester, '/statistics/episodes/prologue?type=manga');

    expect(find.byType(ProloguePanel), findsOneWidget);
    expect(find.textContaining('2023'), findsWidgets);
    expect(find.byType(HoursPanel), findsOneWidget);
    expect(find.textContaining('vs previous'), findsNothing);
  });

  testWidgets('bad month param returns to list', (tester) async {
    await _pump(tester, '/statistics/episodes/2026-13?type=manga');

    expect(find.byType(EpisodeScreen), findsNothing);
    expect(find.byType(EpisodeListScreen), findsOneWidget);
  });

  testWidgets('share buttons never cover panel content', (tester) async {
    // Wide enough that the date fits one line, as it does in real fonts.
    await _pump(tester, '/statistics/episodes/2026-10?type=manga', width: 600);

    final panel = find.ancestor(
      of: find.byType(BiggestDayPanel),
      matching: find.byType(SharePanel),
    );
    final button = tester.getRect(
      find.descendant(of: panel, matching: find.byType(IconButton)),
    );
    final numeral = tester.getRect(
      find.descendant(of: panel, matching: find.byType(StripSfx)).last,
    );
    expect(button.overlaps(numeral), isFalse);
  });

  testWidgets('every panel spans the full strip width', (tester) async {
    // Wide enough that the label fits one line and can't stretch the panel.
    await _pump(
      tester,
      '/statistics/episodes/2026-10?type=manga',
      width: 600,
      month: _october(
        genres: const [
          Skill(genre: 'Gag', count: 1, share: 0.1, rank: SkillRank.c),
        ],
      ),
    );

    final full = tester.getSize(find.byType(TitlePanel)).width;
    expect(tester.getSize(find.byType(GenresPanel)).width, full);
  });

  testWidgets('episode and list fit a narrow phone', (tester) async {
    await _pump(tester, '/statistics/episodes/2026-10?type=manga', width: 360);
    expect(tester.takeException(), isNull);

    await _pump(tester, '/statistics/episodes?type=manga', width: 360);
    expect(tester.takeException(), isNull);
  });
}
