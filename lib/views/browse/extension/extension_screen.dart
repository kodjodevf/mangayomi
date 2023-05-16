import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/refresh_filter_data.dart';
import 'package:mangayomi/views/browse/extension/widgets/extension_list_tile_widget.dart';

class ExtensionScreen extends ConsumerWidget {
  final Function(dynamic) entriesData;
  final List<Source> entriesFilter;
  const ExtensionScreen(
      {required this.entriesData, required this.entriesFilter, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(refreshFilterDataProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream:
              isar.sources.filter().idIsNotNull().watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              entriesData(entries);
              return GroupedListView<Source, String>(
                elements: entriesFilter.isNotEmpty ? entriesFilter : entries,
                groupBy: (element) => completeLang(element.lang!.toLowerCase()),
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Text(
                        groupByValue,
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, Source element) {
                  if (element.isCloudflare! && !Platform.isWindows ||
                      element.isCloudflare! && !Platform.isLinux) {
                    return Container();
                  }

                  return ExtensionListTileWidget(
                    lang: element.lang!,
                    onChanged: (val) {
                      isar.writeTxnSync(() {
                        isar.sources.putSync(element..isAdded = val);
                      });
                    },
                    sourceName: element.sourceName!,
                    value: element.isAdded!,
                    logoUrl: element.logoUrl!,
                    isNsfw: element.isNsfw!,
                  );
                },
                groupComparator: (group1, group2) => group1.compareTo(group2),
                itemComparator: (item1, item2) =>
                    item1.sourceName!.compareTo(item2.sourceName!),
                order: GroupedListOrder.ASC,
              );
            }
            return Container();
          }),
    );
  }
}
