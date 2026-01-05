import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/statistics/statistics_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/item_type_filters.dart';
import 'package:mangayomi/utils/item_type_localization.dart';

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
    _visibleTabTypes = hiddenItemTypes(ref.read(hideItemsStateProvider));
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
        body: Center(child: Text("EMPTY\nMPTY\nMTY\nMT\n\n")),
      );
    }
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statistics),
        bottom: TabBar(
          controller: _tabController,
          tabs: _visibleTabTypes.map((type) {
            return Tab(text: type.localized(l10n));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _visibleTabTypes.map((type) {
          return _buildStatisticsTab(itemType: type);
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

    return stats.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Err: $err")),
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
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionHeader('Entries'),
              _buildEntriesCard(
                totalItems: totalItems,
                completedItems: completedItems,
                completedPercentage: completedPercentage.toDouble(),
              ),
              const SizedBox(height: 10),
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEntriesCard({
    required int totalItems,
    required int completedItems,
    required double completedPercentage,
  }) {
    final l10n = context.l10n;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatisticColumn(
              value: "$totalItems",
              label: l10n.in_library,
              icon: Icons.collections_bookmark_outlined,
            ),
            _buildStatisticColumn(
              value: "$completedItems",
              label: "Completed",
              icon: Icons.local_library_outlined,
            ),
            _buildStatisticColumn(
              value: "${completedPercentage.toStringAsFixed(1)}%",
              label: "Completion Rate",
              icon: Icons.percent,
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
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticColumn(
                  value: "$totalChapters",
                  label: "Total",
                  icon: Icons.format_list_numbered,
                ),
                _buildStatisticColumn(
                  value: "$readChapters",
                  label: "Read",
                  icon: Icons.done_all,
                ),
                _buildStatisticColumn(
                  value: "$unreadChapters",
                  label: unreadLabel,
                  icon: Icons.remove,
                ),
                _buildStatisticColumn(
                  value: "$downloadedItems",
                  label: context.l10n.downloaded,
                  icon: Icons.download_done,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Average Chapters per $title"),
            subtitle: Text(averageChapters.toStringAsFixed(2)),
            leading: Icon(Icons.bar_chart, color: context.primaryColor),
          ),
          _buildReadPercentageGraph(readPercentage, context),
        ],
      ),
    );
  }

  Widget _buildStatisticColumn({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10)),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Icon(icon, color: context.primaryColor),
        ),
      ],
    );
  }

  Widget _buildReadPercentageGraph(
    double readPercentage,
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, color: context.primaryColor),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Read Percentage"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    value: readPercentage / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.primaryColor,
                    ),
                  ),
                ),
                Text(
                  "${readPercentage.toStringAsFixed(1)}%",
                  style: TextStyle(fontSize: 18, color: context.secondaryColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
