import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/refresh_filter_data.dart';
import 'package:mangayomi/views/browse/extension/widgets/extension_list_tile_widget.dart';

class ExtensionScreen extends ConsumerWidget {
  final Function(dynamic) entriesData;
  final List<SourceModel> entriesFilter;
  const ExtensionScreen(
      {required this.entriesData, required this.entriesFilter, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(refreshFilterDataProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder<Box<SourceModel>>(
          valueListenable: ref.watch(hiveBoxMangaSourceProvider).listenable(),
          builder: (context, value, child) {
            final entries = value.values.toList();
            entriesData(entries);
            return GroupedListView<SourceModel, String>(
              elements: entriesFilter.isNotEmpty ? entriesFilter : entries,
              groupBy: (element) => completeLang(element.lang.toLowerCase()),
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
              itemBuilder: (context, SourceModel element) {
                if (element.isCloudflare && !Platform.isWindows ||
                    element.isCloudflare && !Platform.isLinux) {
                  return Container();
                }
                final source =
                    value.get("${element.sourceName}${element.lang}")!;
                return ExtensionListTileWidget(
                  lang: value.get("${element.sourceName}${element.lang}")!.lang,
                  onChanged: (val) {
                    value.put(
                        "${element.sourceName}${element.lang}",
                        SourceModel(
                            sourceName: element.sourceName,
                            baseUrl: element.baseUrl,
                            apiUrl: element.apiUrl,
                            isNsfw: element.isNsfw,
                            isCloudflare: element.isCloudflare,
                            lang: element.lang,
                            typeSource: element.typeSource,
                            isAdded: val,
                            logoUrl: element.logoUrl,
                            dateFormat: element.dateFormat,
                            dateFormatLocale: element.dateFormatLocale));
                  },
                  sourceName: source.sourceName,
                  value: source.isAdded,
                  logoUrl: source.logoUrl,
                  isNsfw: source.isNsfw,
                );
              },
              groupComparator: (group1, group2) => group1.compareTo(group2),
              itemComparator: (item1, item2) =>
                  item1.sourceName.compareTo(item2.sourceName),
              order: GroupedListOrder.ASC,
            );
          }),
    );
  }
}
