import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/extension/providers/extensions_provider.dart';
import 'package:mangayomi/modules/browse/extension/widgets/extension_list_tile_widget.dart';
import 'package:mangayomi/modules/browse/sources/sources_screen.dart' show getSourcesStreamProvider;
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/extension_server_warning_banner.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/item_type_localization.dart';
import 'package:mangayomi/utils/language.dart';

/// Merged Sources + Extensions view for one content type: a short Sources
/// section followed by the full Extensions list, on a single scrollable
/// page. Replaces the old separate Sources tab / Extensions tab.
class BrowseContentScreen extends ConsumerStatefulWidget {
  final ItemType itemType;
  final String query;
  const BrowseContentScreen({
    required this.itemType,
    required this.query,
    super.key,
  });

  @override
  ConsumerState<BrowseContentScreen> createState() =>
      _BrowseContentScreenState();
}

/// Below this width, Sources and Extensions stack in one column (mobile /
/// narrow desktop window). At or above it, there's room for the two-pane
/// layout: Sources on the left, Extensions on the right, each scrolling
/// independently — makes use of a wide desktop window instead of one
/// narrow stretched-out list with empty space beside it.
const _wideLayoutBreakpoint = 800.0;

class _BrowseContentScreenState extends ConsumerState<BrowseContentScreen> {
  final ScrollController controller = ScrollController();
  final ScrollController _extensionsController = ScrollController();
  bool isUpdating = false;

  // Collapsed state for the two top-level sections, so a long Sources list
  // doesn't force scrolling past it to reach Extensions (or vice versa).
  // Only relevant to the single-column layout — the two-pane layout shows
  // both at once since they're no longer competing for the same scroll.
  bool _sourcesExpanded = true;
  bool _extensionsExpanded = true;

  @override
  void dispose() {
    controller.dispose();
    _extensionsController.dispose();
    super.dispose();
  }

  Future<void> _refreshSources() {
    return ref.refresh(
      fetchItemSourcesListProvider(
        id: null,
        reFresh: true,
        itemType: widget.itemType,
      ).future,
    );
  }

  Future<void> _updateSource(Source source) {
    return ref.read(
      fetchItemSourcesListProvider(
        id: source.id,
        reFresh: true,
        itemType: source.itemType,
      ).future,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.read(
      fetchItemSourcesListProvider(
        id: null,
        reFresh: false,
        itemType: widget.itemType,
      ),
    );

    final l10n = l10nLocalizations(context)!;
    final showNSFW = ref.watch(showNSFWStateProvider);
    final sourcesAsync = ref.watch(getSourcesStreamProvider(widget.itemType));
    final extensionsAsync = ref.watch(
      getExtensionsStreamProvider(widget.itemType),
    );
    final repositories = ref.watch(
      extensionsRepoStateProvider(widget.itemType),
    );

    return sourcesAsync.when(
      data: (sourcesData) {
        return extensionsAsync.when(
          data: (extensionsData) {
            final sources = sourcesData
                .where((e) => showNSFW || !(e.isNsfw ?? false))
                .toList();

            final filteredExtensions = widget.query.isEmpty
                ? extensionsData
                : extensionsData
                      .where(
                        (element) =>
                            element.name?.toLowerCase().contains(
                              widget.query.toLowerCase(),
                            ) ??
                            false,
                      )
                      .toList();

            final updateEntries = <Source>[];
            final notInstalledEntries = <Source>[];
            var showMihonWarning = false;

            for (var element in filteredExtensions) {
              if (repositories
                      .firstWhereOrNull((e) => e == element.repo)
                      ?.hidden ??
                  false) {
                continue;
              }
              if (!showNSFW && (element.isNsfw ?? false)) {
                continue;
              }
              if (element.sourceCodeLanguage == SourceCodeLanguage.mihon) {
                showMihonWarning = true;
              }
              final isLatestVersion = element.version == element.versionLast;
              if (compareVersions(
                    element.version ?? '',
                    element.versionLast ?? '',
                  ) <
                  0) {
                updateEntries.add(element);
              } else if (isLatestVersion) {
                // Already-installed, up-to-date extensions are shown as a
                // Source above, so they're skipped here to avoid listing
                // the same entry twice on one page.
                if (!(element.isAdded ?? false)) {
                  notInstalledEntries.add(element);
                }
              }
            }

            final lastUsedEntries = sources.where((e) => e.lastUsed!).toList();
            final isPinnedEntries = sources.where((e) => e.isPinned!).toList();
            final allEntriesWithoutIsPinned = sources
                .where((element) => !element.isPinned!)
                .toList();
            final showSourceMihonWarning = sources
                .where((e) => e.sourceCodeLanguage == SourceCodeLanguage.mihon)
                .isNotEmpty;

            final hasExtensionEntries =
                updateEntries.isNotEmpty || notInstalledEntries.isNotEmpty;

            if (sources.isEmpty && !hasExtensionEntries) {
              return RefreshIndicator(
                onRefresh: _refreshSources,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(context.l10n.no_sources_installed),
                      ),
                    ),
                  ],
                ),
              );
            }

            final sourceSlivers = _sourceSlivers(
              l10n: l10n,
              sources: sources,
              lastUsedEntries: lastUsedEntries,
              isPinnedEntries: isPinnedEntries,
              allEntriesWithoutIsPinned: allEntriesWithoutIsPinned,
            );
            final extensionSlivers = _extensionSlivers(
              l10n: l10n,
              hasExtensionEntries: hasExtensionEntries,
              updateEntries: updateEntries,
              notInstalledEntries: notInstalledEntries,
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _wideLayoutBreakpoint) {
                  return RefreshIndicator(
                    onRefresh: _refreshSources,
                    child: _scrollPane(
                      controller: controller,
                      showWarningBanner: showSourceMihonWarning || showMihonWarning,
                      slivers: [...sourceSlivers, ...extensionSlivers],
                    ),
                  );
                }

                // Wide layout: Sources and Extensions side by side, each with
                // their own scroll position, so neither pushes the other one
                // off screen on a big window.
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _scrollPane(
                        controller: controller,
                        showWarningBanner: showSourceMihonWarning,
                        slivers: sourceSlivers,
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: _scrollPane(
                        controller: _extensionsController,
                        showWarningBanner: showMihonWarning,
                        slivers: extensionSlivers,
                      ),
                    ),
                  ],
                );
              },
            );
          },
          error: (error, _) => Center(
            child: ElevatedButton(
              onPressed: _refreshSources,
              child: Text(context.l10n.refresh),
            ),
          ),
          loading: () => const ProgressCenter(),
        );
      },
      error: (error, _) => ErrorState(
        detail: error.toString(),
        onRetry: () =>
            ref.invalidate(getSourcesStreamProvider(widget.itemType)),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  /// The scrollable, scrollbar-wrapped shell shared by every pane on this
  /// screen — the single-column layout uses it once with both sections'
  /// slivers combined, the wide layout uses it twice, one per side.
  Widget _scrollPane({
    required ScrollController controller,
    required bool showWarningBanner,
    required List<Widget> slivers,
  }) {
    return Scrollbar(
      interactive: true,
      controller: controller,
      thickness: 12,
      radius: const Radius.circular(10),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          if (showWarningBanner)
            const SliverToBoxAdapter(child: ExtensionServerWarningBanner()),
          ...slivers,
        ],
      ),
    );
  }

  List<Widget> _sourceSlivers({
    required dynamic l10n,
    required List<Source> sources,
    required List<Source> lastUsedEntries,
    required List<Source> isPinnedEntries,
    required List<Source> allEntriesWithoutIsPinned,
  }) {
    if (sources.isEmpty) return const [];
    return [
      SliverToBoxAdapter(
        child: _SectionHeader(
          title: widget.itemType.localizedSources(l10n),
          expanded: _sourcesExpanded,
          topPadding: 16,
          onTap: () => setState(() => _sourcesExpanded = !_sourcesExpanded),
        ),
      ),
      if (_sourcesExpanded) ...[
        CustomSliverGroupedListView<Source, String>(
          elements: lastUsedEntries,
          groupBy: (element) => "",
          groupSeparatorBuilder: (String groupByValue) => Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Text(
              l10n.last_used,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          itemBuilder: (context, Source element) =>
              SourceListTile(source: element, itemType: widget.itemType),
          groupComparator: (group1, group2) => group1.compareTo(group2),
          itemComparator: (item1, item2) => item1.name!.compareTo(item2.name!),
          order: GroupedListOrder.ASC,
        ),
        CustomSliverGroupedListView<Source, String>(
          elements: isPinnedEntries,
          groupBy: (element) => "",
          groupSeparatorBuilder: (String groupByValue) => Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              l10n.pinned,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          itemBuilder: (context, Source element) =>
              SourceListTile(source: element, itemType: widget.itemType),
          groupComparator: (group1, group2) => group1.compareTo(group2),
          itemComparator: (item1, item2) => item1.name!.compareTo(item2.name!),
          order: GroupedListOrder.ASC,
        ),
        CustomSliverGroupedListView<Source, String>(
          elements: allEntriesWithoutIsPinned,
          groupBy: (element) =>
              completeLanguageName(element.lang!.toLowerCase()),
          groupSeparatorBuilder: (String groupByValue) => Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              groupByValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          itemBuilder: (context, Source element) =>
              SourceListTile(source: element, itemType: widget.itemType),
          groupComparator: (group1, group2) => group1.compareTo(group2),
          itemComparator: (item1, item2) => item1.name!.compareTo(item2.name!),
          order: GroupedListOrder.ASC,
        ),
      ],
    ];
  }

  List<Widget> _extensionSlivers({
    required dynamic l10n,
    required bool hasExtensionEntries,
    required List<Source> updateEntries,
    required List<Source> notInstalledEntries,
  }) {
    return [
      if (hasExtensionEntries)
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: widget.itemType.localizedExtensions(l10n),
            expanded: _extensionsExpanded,
            topPadding: 14,
            onTap: () =>
                setState(() => _extensionsExpanded = !_extensionsExpanded),
          ),
        ),
      if (_extensionsExpanded) ...[
        if (updateEntries.isNotEmpty) _buildUpdateSection(updateEntries, l10n),
        if (notInstalledEntries.isNotEmpty)
          _buildNotInstalledSection(notInstalledEntries),
      ],
    ];
  }

  Widget _buildUpdateSection(List<Source> updateEntries, dynamic l10n) {
    return CustomSliverGroupedListView<Source, String>(
      elements: updateEntries,
      groupBy: (_) => "",
      groupSeparatorBuilder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.update_pending,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                ElevatedButton(
                  onPressed: isUpdating
                      ? null
                      : () async {
                          setState(() => isUpdating = true);
                          try {
                            for (var source in updateEntries) {
                              await _updateSource(source);
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isUpdating = false);
                            }
                          }
                        },
                  child: isUpdating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.update_all),
                ),
              ],
            ),
          );
        },
      ),
      itemBuilder: (context, Source element) =>
          ExtensionListTileWidget(key: ValueKey(element.id), source: element),
      groupComparator: (group1, group2) => group1.compareTo(group2),
      itemComparator: (item1, item2) =>
          item1.name?.compareTo(item2.name ?? '') ?? 0,
      order: GroupedListOrder.ASC,
    );
  }

  Widget _buildNotInstalledSection(List<Source> notInstalledEntries) {
    return CustomSliverGroupedListView<Source, String>(
      elements: notInstalledEntries,
      groupBy: (element) =>
          completeLanguageName(element.lang?.toLowerCase() ?? ''),
      groupSeparatorBuilder: (String groupByValue) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          groupByValue,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
      itemBuilder: (context, Source element) =>
          ExtensionListTileWidget(key: ValueKey(element.id), source: element),
      groupComparator: (group1, group2) => group1.compareTo(group2),
      itemComparator: (item1, item2) =>
          item1.name?.compareTo(item2.name ?? '') ?? 0,
      order: GroupedListOrder.ASC,
    );
  }
}

/// A tappable section title with a chevron that flips to collapse/expand
/// the sliver(s) that follow it, so a long Sources or Extensions list
/// doesn't force scrolling past it to reach the rest of the page.
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  final double topPadding;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.expanded,
    required this.onTap,
    this.topPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, topPadding, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            AnimatedRotation(
              turns: expanded ? 0 : -0.25,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.expand_more_rounded,
                size: 20,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
