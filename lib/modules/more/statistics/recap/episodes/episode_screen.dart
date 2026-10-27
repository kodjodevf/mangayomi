import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/statistics/recap/episodes/episode_routes.dart';
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
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_format.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_math.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_models.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_providers.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// One Episode as a vertical comic strip. [month] null is the Prologue.
class EpisodeScreen extends ConsumerWidget {
  const EpisodeScreen({super.key, required this.itemType, this.month});

  final ItemType itemType;
  final DateTime? month;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final text = StripText(ref.watch(recapFontsProvider));
    final month = this.month;
    final months =
        ref.watch(episodeListProvider(itemType: itemType)).value?.months ??
        const <EpisodeSummary>[];
    final Widget body;
    if (month == null) {
      body = ref
          .watch(statusWindowProvider(itemType: itemType))
          .when(
            loading: _loading,
            error: (err, _) => ErrorState(detail: err.toString()),
            data: (data) =>
                _strip(context, _prologuePanels(context, data, months, text)),
          );
    } else {
      body = ref
          .watch(
            episodeProvider(
              itemType: itemType,
              year: month.year,
              month: month.month,
            ),
          )
          .when(
            loading: _loading,
            error: (err, _) => ErrorState(detail: err.toString()),
            data: (stats) =>
                _strip(context, _monthPanels(context, stats, months, text)),
          );
    }
    return Scaffold(
      backgroundColor: StripColors.bg,
      appBar: AppBar(
        backgroundColor: StripColors.bg,
        foregroundColor: StripColors.paper,
        surfaceTintColor: StripColors.bg,
        title: Text(
          month == null ? l10n.recapPrologue : monthLabel(context, month),
          style: text.nav,
        ),
      ),
      body: body,
    );
  }

  Widget _loading() =>
      const Center(child: CircularProgressIndicator(color: StripColors.yellow));

  Widget _strip(BuildContext context, List<(String, Widget)> panels) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s8,
        ShioriSpace.s8,
        ShioriSpace.s8,
        ShioriSpace.s48,
      ),
      children: [
        for (final (name, panel) in panels)
          Padding(
            padding: const EdgeInsets.only(bottom: ShioriSpace.s8),
            child: SharePanel(
              name: 'mangayomi-${itemType.name}-${episodeSlug(month)}-$name',
              child: panel,
            ),
          ),
      ],
    );
  }

  List<(String, Widget)> _monthPanels(
    BuildContext context,
    MonthStats stats,
    List<EpisodeSummary> months,
    StripText text,
  ) {
    final l10n = context.l10n;
    final type = itemType.name;
    final label = monthLabel(context, stats.month);
    final summary = months.where((m) => m.month == stats.month).firstOrNull;
    final top = stats.top;
    final biggest = stats.biggestDay;
    final newer = months.where((m) => m.month.isAfter(stats.month)).lastOrNull;
    final next = DateTime(stats.month.year, stats.month.month + 1);
    return [
      (
        'title',
        TitlePanel(
          label: l10n.recapStripEpisodeLabel,
          title: label.toUpperCase(),
          tagline: l10n.recapStripTagline(
            HoursPanel.hoursText(context, stats.seconds),
            formatCount(context, stats.seriesCount),
          ),
          coverIds: summary?.coverMangaIds ?? [if (top != null) top.id],
          text: text,
        ),
      ),
      if (stats.seconds > 0)
        (
          'hours',
          HoursPanel(
            seconds: stats.seconds,
            previousSeconds: stats.previousSeconds,
            intro: l10n.recapStripHoursIntro(label, type),
            text: text,
          ),
        ),
      if (stats.completions > 0 || stats.seriesCount > 0)
        (
          'counts',
          CountsPanel(
            count: stats.completions,
            label: l10n.recapStripCountsLabel(type),
            lines: [
              l10n.recapStripSeriesLine(stats.seriesCount),
              if (stats.newSeriesCount > 0)
                l10n.recapStripNewLine(
                  formatCount(context, stats.newSeriesCount),
                ),
            ],
            text: text,
          ),
        ),
      if (top != null) ('top', _topPanel(context, top, text)),
      if (biggest != null && biggest.completions > 0)
        (
          'biggest-day',
          BiggestDayPanel(
            day: biggest.day,
            completions: biggest.completions,
            units: _units(context, biggest.completions),
            text: text,
          ),
        ),
      if (stats.daysRead.isNotEmpty)
        (
          'calendar',
          CalendarPanel(
            month: stats.month,
            daysRead: stats.daysRead,
            longestStreak: stats.longestStreak,
            text: text,
          ),
        ),
      if (stats.genres.isNotEmpty)
        (
          'genres',
          GenresPanel(
            genres: stats.genres,
            label: l10n.recapStripGenresLabel,
            text: text,
          ),
        ),
      if (stats.hourHistogram.any((h) => h > 0))
        (
          'clock',
          ClockPanel(
            hours: stats.hourHistogram,
            itemType: itemType,
            text: text,
          ),
        ),
      if (stats.finishedIds.isNotEmpty)
        ('finished', FinishedPanel(ids: stats.finishedIds, text: text)),
      (
        'next',
        CliffhangerPanel(
          next: monthLabel(context, newer?.month ?? next),
          onOpen: newer == null
              ? null
              : () => context.pushReplacement(
                  episodeLocation(itemType, newer.month),
                ),
          text: text,
        ),
      ),
    ];
  }

  List<(String, Widget)> _prologuePanels(
    BuildContext context,
    StatusWindowData data,
    List<EpisodeSummary> months,
    StripText text,
  ) {
    final l10n = context.l10n;
    final type = itemType.name;
    final since = data.since;
    // Your #1 of all time is the series you've been reading the longest.
    final top = data.bonded.firstOrNull;
    // The oldest monthly Episode follows the Prologue.
    final first = months.lastOrNull;
    return [
      ('title', ProloguePanel(data: data, text: text)),
      if (data.totalSeconds > 0)
        (
          'hours',
          HoursPanel(
            seconds: data.totalSeconds,
            intro: since == null
                ? l10n.recapStripHoursIntroAllTime(type)
                : l10n.recapStripHoursIntroSince(
                    monthLabel(context, since),
                    type,
                  ),
            text: text,
          ),
        ),
      if (data.units > 0 || data.libraryCount > 0)
        (
          'counts',
          CountsPanel(
            count: data.units,
            label: l10n.recapStripCountsLabel(type),
            lines: [
              l10n.recapStripLibraryLine(
                formatCount(context, data.libraryCount),
              ),
            ],
            text: text,
          ),
        ),
      if (top != null) ('top', _topPanel(context, top, text, bond: true)),
      if (data.skills.isNotEmpty)
        (
          'genres',
          GenresPanel(
            genres: data.skills,
            label: l10n.recapStripGenresLabelAllTime,
            text: text,
          ),
        ),
      if (data.hourHistogram.any((h) => h > 0))
        (
          'clock',
          ClockPanel(hours: data.hourHistogram, itemType: itemType, text: text),
        ),
      (
        'next',
        CliffhangerPanel(
          next: monthLabel(context, first?.month ?? DateTime.now()),
          onOpen: first == null
              ? null
              : () => context.pushReplacement(
                  episodeLocation(itemType, first.month),
                ),
          text: text,
        ),
      ),
    ];
  }

  /// With [bond], the caption says how long you've read [top] when known.
  Widget _topPanel(
    BuildContext context,
    RecapSeries top,
    StripText text, {
    bool bond = false,
  }) {
    final l10n = context.l10n;
    return TopSeriesPanel(
      series: top,
      caption: bond && bondMs(top) > 0
          ? l10n.recapStripTopSpan(bondSpan(context, top))
          : top.seconds > 0
          ? l10n.recapStripTopHours(tenthHours(context, top.seconds))
          : l10n.recapStripTopUnits(
              formatCount(context, top.chaptersRead),
              l10n.recapUnits(top.chaptersRead, itemType.name),
            ),
      text: text,
    );
  }

  String _units(BuildContext context, int count) =>
      '${formatCount(context, count)} '
      '${context.l10n.recapUnits(count, itemType.name)}';
}
