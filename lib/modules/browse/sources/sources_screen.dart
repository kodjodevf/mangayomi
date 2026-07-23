import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/browse/browse_screen.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';
import 'package:mangayomi/utils/platform_utils.dart';

final getSourcesStreamProvider = StreamProvider.family<List<Source>, ItemType>((
  ref,
  itemType,
) {
  return isar.sources
      .filter()
      .idIsNotNull()
      .isAddedEqualTo(true)
      .and()
      .isActiveEqualTo(true)
      .and()
      .itemTypeEqualTo(itemType)
      .watch(fireImmediately: true);
});

class SourcesScreen extends ConsumerStatefulWidget {
  final Function(int) tabIndex;
  final List<BrowseTab> tabs;
  final ItemType itemType;
  const SourcesScreen({
    required this.tabIndex,
    required this.itemType,
    required this.tabs,
    super.key,
  });

  @override
  ConsumerState<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends ConsumerState<SourcesScreen> {
  final controller = ScrollController();

  // Stable focus nodes per source id (source / Latest / Pin buttons) so d-pad
  // focus follows a source when pinning moves it to another group.
  final Map<int, FocusNode> _srcNodes = {};
  final Map<int, FocusNode> _latestNodes = {};
  final Map<int, FocusNode> _pinNodes = {};

  FocusNode _node(Map<int, FocusNode> m, int? id) =>
      m.putIfAbsent(id ?? -1, () => FocusNode());

  /// One source entry: the TV 3-button row on Android TV, else the classic tile.
  ///
  /// [shareNodes] keys the row's focus nodes by source id so d-pad focus follows
  /// a source when pinning moves it between the pinned and language groups
  /// (mutually exclusive, so never contested). Last used is a *second* row for a
  /// source already in one of those groups; a FocusNode attaches to one widget
  /// at a time, so it gets its own nodes to stay focusable.
  Widget _row(Source source, {bool shareNodes = true}) {
    if (isTv) {
      return TvSourceRow(
        source: source,
        itemType: widget.itemType,
        sourceNode: shareNodes ? _node(_srcNodes, source.id) : null,
        latestNode: shareNodes ? _node(_latestNodes, source.id) : null,
        pinNode: shareNodes ? _node(_pinNodes, source.id) : null,
      );
    }
    return SourceListTile(source: source, itemType: widget.itemType);
  }

  @override
  void dispose() {
    for (final n in [
      ..._srcNodes.values,
      ..._latestNodes.values,
      ..._pinNodes.values,
    ]) {
      n.dispose();
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final sourcesStream = ref.watch(getSourcesStreamProvider(widget.itemType));

    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: isTv ? 8 : 0,
        right: isTv ? 8 : 0,
      ),
      child: sourcesStream.when(
        data: (snapshotData) {
          final showNSFW = ref.watch(showNSFWStateProvider);
          List<Source> sources = snapshotData
              .where((e) => showNSFW || !(e.isNsfw ?? false))
              .toList();
          if (sources.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(context.l10n.no_sources_installed),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final extensionIndex = widget.tabs.indexWhere(
                        (t) =>
                            t.type == widget.itemType &&
                            t.kind == BrowseTabKind.extensions,
                      );

                      if (extensionIndex != -1) {
                        widget.tabIndex(extensionIndex);
                      }
                    },
                    icon: const Icon(Icons.extension_rounded),
                    label: Text(context.l10n.show_extensions),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Text(
                        l10n.other,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SourceListTile(
                  source: Source(
                    name: "local",
                    lang: "",
                    itemType: widget.itemType,
                  ),
                  itemType: widget.itemType,
                ),
              ],
            );
          }
          final lastUsedEntries = sources
              .where((element) => element.lastUsed!)
              .toList();
          final isPinnedEntries = sources
              .where((element) => element.isPinned!)
              .toList();
          final allEntriesWithoutIspinned = sources
              .where((element) => !element.isPinned!)
              .toList();
          return Scrollbar(
            interactive: true,
            controller: controller,
            thickness: 12,
            radius: const Radius.circular(10),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                CustomSliverGroupedListView<Source, String>(
                  elements: lastUsedEntries,
                  groupBy: (element) => "",
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        Text(
                          l10n.last_used,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, Source element) {
                    return _row(element, shareNodes: false);
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.name!.compareTo(item2.name!),
                  order: GroupedListOrder.ASC,
                ),
                CustomSliverGroupedListView<Source, String>(
                  elements: isPinnedEntries,
                  groupBy: (element) => "",
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        Text(
                          l10n.pinned,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, Source element) {
                    return _row(element);
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.name!.compareTo(item2.name!),
                  order: GroupedListOrder.ASC,
                ),
                CustomSliverGroupedListView<Source, String>(
                  elements: allEntriesWithoutIspinned,
                  groupBy: (element) =>
                      completeLanguageName(element.lang!.toLowerCase()),
                  groupSeparatorBuilder: (String groupByValue) => Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        Text(
                          groupByValue,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context, Source element) {
                    return _row(element);
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.name!.compareTo(item2.name!),
                  order: GroupedListOrder.ASC,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              l10n.other,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SourceListTile(
                        source: Source(
                          name: "local",
                          lang: "",
                          itemType: widget.itemType,
                        ),
                        itemType: widget.itemType,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
