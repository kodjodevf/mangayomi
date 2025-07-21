import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/widgets/custom_sliver_grouped_list_view.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/language.dart';

class SourcesScreen extends ConsumerStatefulWidget {
  final Function(int) tabIndex;
  final ItemType itemType;
  const SourcesScreen({
    required this.tabIndex,
    required this.itemType,
    super.key,
  });

  @override
  ConsumerState<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends ConsumerState<SourcesScreen> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
        stream: isar.sources
            .filter()
            .idIsNotNull()
            .isAddedEqualTo(true)
            .and()
            .isActiveEqualTo(true)
            .and()
            .itemTypeEqualTo(widget.itemType)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          List<Source> sources = snapshot.data!;
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
                    onPressed: () => widget.tabIndex(
                      widget.itemType == ItemType.manga
                          ? 3
                          : widget.itemType == ItemType.anime
                          ? 4
                          : 5,
                    ),
                    icon: const Icon(Icons.extension_rounded),
                    label: Text(context.l10n.show_extensions),
                  ),
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
                    return SourceListTile(
                      source: element,
                      itemType: widget.itemType,
                    );
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
                    return SourceListTile(
                      source: element,
                      itemType: widget.itemType,
                    );
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
                    return SourceListTile(
                      source: element,
                      itemType: widget.itemType,
                    );
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.name!.compareTo(item2.name!),
                  order: GroupedListOrder.ASC,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
