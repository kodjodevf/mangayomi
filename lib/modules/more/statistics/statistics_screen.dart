import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/status_window_view.dart';
import 'package:mangayomi/modules/more/statistics/recap/status_window/sw_theme.dart';
import 'package:mangayomi/modules/more/statistics/statistics_provider.dart';
import 'package:mangayomi/providers/statistics_recap_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<ItemType> _visibleTabTypes;

  @override
  void initState() {
    super.initState();
    // Anime-only TV layout shows just the anime tab. Force it rather than
    // intersecting with hiddenItemTypes: the Anime library can be hidden from
    // that list, which would leave us with no tabs at all.
    _visibleTabTypes = ref.read(animeOnlyTvModeProvider)
        ? const [ItemType.anime]
        : hiddenItemTypes(ref.read(hideItemsStateProvider));
    _tabController = TabController(
      length: _visibleTabTypes.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleTabTypes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.statistics)),
        body: ShioriEmptyState(
          icon: Symbols.query_stats_rounded,
          title: context.l10n.no_result,
          compact: true,
        ),
      );
    }
    final l10n = context.l10n;
    final recap = ref.watch(statisticsRecapStateProvider);
    final tabs = _visibleTabTypes.map((type) {
      return Tab(text: type.localized(l10n));
    }).toList();
    return Scaffold(
      // The recap is always dark, whatever the app theme.
      backgroundColor: recap ? SwColors.bg : null,
      appBar: AppBar(
        title: Text(l10n.statistics),
        backgroundColor: recap ? SwColors.bgTop : null,
        foregroundColor: recap ? SwColors.text : null,
        actions: [
          PopupMenuButton<bool>(
            icon: const Icon(Symbols.more_vert_rounded),
            onSelected: (v) =>
                ref.read(statisticsRecapStateProvider.notifier).set(v),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: !recap,
                child: Text(
                  recap ? l10n.recapClassicView : l10n.recapRecapView,
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: tabs,
          labelColor: recap ? SwColors.cyan : null,
          unselectedLabelColor: recap ? SwColors.muted : null,
          indicatorColor: recap ? SwColors.cyan : null,
          dividerColor: recap ? SwColors.hairline : null,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _visibleTabTypes.map((type) {
          return recap
              ? StatusWindowView(itemType: type)
              : _buildStatisticsTab(itemType: type);
        }).toList(),
      ),
    );
  }

  Widget _buildStatisticsTab({required ItemType itemType}) {
    final l10n = context.l10n;
    final stats = ref.watch(getStatisticsProvider(itemType: itemType));

    final chapterLabel = switch (itemType) {
      ItemType.anime => l10n.episodes,
      _ => l10n.chapters,
    };
    final unreadLabel = switch (itemType) {
      ItemType.anime => l10n.unwatched,
      _ => l10n.unread,
    };
    // A count's word: "read" here is the past, not the button's "Read".
    final readLabel = switch (itemType) {
      ItemType.anime => l10n.watched_count,
      _ => l10n.read_count,
    };

    return stats.when(
      loading: () => ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [for (var i = 0; i < 6; i++) const ShioriSkeletonRow()],
      ),
      error: (err, stack) => ErrorState(detail: err.toString()),
      data: (stats) {
        final totalItems = stats.totalItems;
        final totalChapters = stats.totalChapters;
        final readChapters = stats.readChapters;
        final unreadChapters = totalChapters - readChapters;
        final completedItems = stats.completedItems;
        final downloadedItems = stats.downloadedItems;

        final averageChapters = totalItems > 0 ? totalChapters / totalItems : 0;
        final readPercentage = totalChapters > 0
            ? (readChapters / totalChapters) * 100
            : 0;
        final completedPercentage = totalItems > 0
            ? (completedItems / totalItems) * 100
            : 0;
        final totalReadingTimeSeconds = stats.totalReadingTimeSeconds;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(ShioriSpace.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader(l10n.entries),
              _buildEntriesCard(
                totalItems: totalItems,
                completedItems: completedItems,
                completedPercentage: completedPercentage.toDouble(),
              ),
              const SizedBox(height: ShioriSpace.s12),
              _buildSectionHeader(chapterLabel),
              _buildChaptersCard(
                totalChapters: totalChapters,
                readChapters: readChapters,
                unreadChapters: unreadChapters,
                downloadedItems: downloadedItems,
                averageChapters: averageChapters.toDouble(),
                readPercentage: readPercentage.toDouble(),
                title: itemType.localized(l10n),
                context: context,
                unreadLabel: unreadLabel,
                readLabel: readLabel,
                l10n: l10n,
              ),
              const SizedBox(height: ShioriSpace.s12),
              _buildSectionHeader(_trackingTimeLabel(itemType, l10n)),
              _buildTrackingTimeCard(
                totalSeconds: totalReadingTimeSeconds,
                totalItems: totalItems,
                itemType: itemType,
                l10n: l10n,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return ShioriSectionHeader(
      title: title,
      overline: true,
      padding: const EdgeInsets.fromLTRB(
        ShioriSpace.s4,
        ShioriSpace.s16,
        ShioriSpace.s4,
        ShioriSpace.s8,
      ),
    );
  }

  Widget _buildEntriesCard({
    required int totalItems,
    required int completedItems,
    required double completedPercentage,
  }) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s8),
        child: Row(
          children: [
            _buildStatisticColumn(
              value: "$totalItems",
              label: l10n.in_library,
              icon: Symbols.collections_bookmark_rounded,
            ),
            _buildStatisticColumn(
              value: "$completedItems",
              label: l10n.completed,
              icon: Symbols.local_library_rounded,
            ),
            _buildStatisticColumn(
              value: "${completedPercentage.round()} %",
              label: l10n.completion_rate,
              icon: Symbols.percent_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChaptersCard({
    required int totalChapters,
    required int readChapters,
    required int unreadChapters,
    required int downloadedItems,
    required double averageChapters,
    required double readPercentage,
    required String title,
    required BuildContext context,
    required String unreadLabel,
    required String readLabel,
    required AppLocalizations l10n,
  }) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(ShioriSpace.s8),
            child: Row(
              children: [
                _buildStatisticColumn(
                  value: "$totalChapters",
                  label: l10n.total,
                  icon: Symbols.format_list_numbered_rounded,
                ),
                _buildStatisticColumn(
                  value: "$readChapters",
                  label: readLabel,
                  icon: Symbols.done_all_rounded,
                ),
                _buildStatisticColumn(
                  value: "$unreadChapters",
                  label: unreadLabel,
                  icon: Symbols.pending_rounded,
                ),
                _buildStatisticColumn(
                  value: "$downloadedItems",
                  label: context.l10n.downloaded,
                  icon: Symbols.download_done_rounded,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              0,
              ShioriSpace.s16,
              ShioriSpace.s16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: ShioriSpace.s12,
              children: [
                _line(
                  l10n.average_chapters_per_title(title),
                  averageChapters.toStringAsFixed(1),
                ),
                _line(l10n.read_percentage, "${readPercentage.round()} %"),
                ShioriProgressBar(value: readPercentage / 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// One number: a small icon, the figure large and tabular, its label
  /// under it.
  Widget _buildStatisticColumn({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final tokens = context.shiori;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s12),
        child: Column(
          spacing: ShioriSpace.s4,
          children: [
            Icon(icon, size: tokens.scaled(18), color: tokens.color.fgMuted),
            Text(
              value,
              style: tokens.text.seriesTitle.copyWith(
                color: tokens.color.fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tokens.caption,
            ),
          ],
        ),
      ),
    );
  }

  /// A label and its figure across the card.
  Widget _line(String label, String value) {
    final tokens = context.shiori;
    return Row(
      spacing: ShioriSpace.s12,
      children: [
        Expanded(
          child: Text(
            label,
            style: tokens.text.row.copyWith(color: tokens.color.fg),
          ),
        ),
        Text(
          value,
          style: tokens.text.row.copyWith(
            color: tokens.color.fg,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  String _trackingTimeLabel(ItemType itemType, AppLocalizations l10n) {
    return switch (itemType) {
      ItemType.anime => l10n.watching_time,
      _ => l10n.reading_time,
    };
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds <= 0) return '0m';
    final days = totalSeconds ~/ 86400;
    final hours = (totalSeconds % 86400) ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final parts = <String>[];
    if (days > 0) parts.add('${days}d');
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0 || parts.isEmpty) parts.add('${minutes}m');
    return parts.join(' ');
  }

  Widget _buildTrackingTimeCard({
    required int totalSeconds,
    required int totalItems,
    required ItemType itemType,
    required AppLocalizations l10n,
  }) {
    final averagePerTitle = totalItems > 0
        ? (totalSeconds / totalItems).round()
        : 0;
    final isAnime = itemType == ItemType.anime;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s8),
        child: Row(
          children: [
            _buildStatisticColumn(
              value: _formatDuration(totalSeconds),
              label: l10n.total,
              icon: isAnime
                  ? Symbols.play_circle_rounded
                  : Symbols.auto_stories_rounded,
            ),
            _buildStatisticColumn(
              value: _formatDuration(averagePerTitle),
              label: l10n.mean_per_title,
              icon: Symbols.timer_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
