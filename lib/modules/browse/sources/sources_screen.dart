import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/browse/sources/widgets/source_list_tile.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: isar.sources
                      .filter()
                      .idIsNotNull()
                      .isAddedEqualTo(true)
                      .and()
                      .isActiveEqualTo(true)
                      .and()
                      .lastUsedEqualTo(true)
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text(""));
                    }
                    final entries = snapshot.data!
                        .where((element) => ref.watch(showNSFWStateProvider)
                            ? true
                            : element.isNsfw == false)
                        .toList();
                    return GroupedListView<Source, String>(
                      elements: entries,
                      groupBy: (element) => "",
                      groupSeparatorBuilder: (String groupByValue) =>
                          const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              "Last used",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, Source element) {
                        return SourceListTile(
                          source: element,
                        );
                      },
                      shrinkWrap: true,
                      groupComparator: (group1, group2) =>
                          group1.compareTo(group2),
                      itemComparator: (item1, item2) =>
                          item1.sourceName!.compareTo(item2.sourceName!),
                      order: GroupedListOrder.ASC,
                    );
                  }),
              StreamBuilder(
                  stream: isar.sources
                      .filter()
                      .idIsNotNull()
                      .isAddedEqualTo(true)
                      .and()
                      .isActiveEqualTo(true)
                      .and()
                      .isPinnedEqualTo(true)
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text(""));
                    }
                    final entries = snapshot.data!
                        .where((element) => ref.watch(showNSFWStateProvider)
                            ? true
                            : element.isNsfw == false)
                        .toList();
                    return GroupedListView<Source, String>(
                      elements: entries,
                      groupBy: (element) => "",
                      groupSeparatorBuilder: (String groupByValue) =>
                          const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              "Pinned",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, Source element) {
                        return SourceListTile(
                          source: element,
                        );
                      },
                      shrinkWrap: true,
                      groupComparator: (group1, group2) =>
                          group1.compareTo(group2),
                      itemComparator: (item1, item2) =>
                          item1.sourceName!.compareTo(item2.sourceName!),
                      order: GroupedListOrder.ASC,
                    );
                  }),
              StreamBuilder(
                  stream: isar.sources
                      .filter()
                      .idIsNotNull()
                      .isAddedEqualTo(true)
                      .and()
                      .isActiveEqualTo(true)
                      .and()
                      .isPinnedEqualTo(false)
                      .watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Empty"));
                    }
                    final entries = snapshot.data!
                        .where((element) => ref.watch(showNSFWStateProvider)
                            ? true
                            : element.isNsfw == false)
                        .toList();
                    return GroupedListView<Source, String>(
                      elements: entries,
                      groupBy: (element) =>
                          completeLang(element.lang!.toLowerCase()),
                      groupSeparatorBuilder: (String groupByValue) => Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Text(
                              groupByValue,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, Source element) {
                        return SourceListTile(
                          source: element,
                        );
                      },
                      shrinkWrap: true,
                      groupComparator: (group1, group2) =>
                          group1.compareTo(group2),
                      itemComparator: (item1, item2) =>
                          item1.sourceName!.compareTo(item2.sourceName!),
                      order: GroupedListOrder.ASC,
                    );
                  }),
            ],
          ),
        ));
  }
}
