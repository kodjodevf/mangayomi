import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/source/source_list.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/widgets/extension_list_tile_widget.dart';

class ExtensionScreen extends ConsumerStatefulWidget {
  const ExtensionScreen({super.key});

  @override
  ConsumerState<ExtensionScreen> createState() => _ExtensionScreenState();
}

class _ExtensionScreenState extends ConsumerState<ExtensionScreen> {
  _init() {
    for (var element in sourcesList) {
      if (!ref
          .watch(hiveBoxMangaSourceProvider)
          .containsKey("${element.sourceName}${element.lang}")) {
        ref
            .watch(hiveBoxMangaSourceProvider)
            .put("${element.sourceName}${element.lang}", element);
      }
    }
    _isLoading = false;
  }

  bool _isLoading = true;
  @override
  Widget build(
    BuildContext context,
  ) {
    _init();
    return _isLoading
        ? Container()
        : ValueListenableBuilder<Box<SourceModel>>(
            valueListenable: ref.watch(hiveBoxMangaSourceProvider).listenable(),
            builder: (context, value, child) {
              final entries = value.values.toList();
              return GroupedListView<SourceModel, String>(
                elements: entries,
                groupBy: (element) => element.lang,
                groupSeparatorBuilder: (String groupByValue) => Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 8),
                  child: Row(
                    children: [
                      Text(
                        completeLang(groupByValue.toLowerCase()),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (context, SourceModel element) {
                  final source =
                      value.get("${element.sourceName}${element.lang}")!;
                  return ExtensionListTileWidget(
                    lang:
                        value.get("${element.sourceName}${element.lang}")!.lang,
                    onChanged: (val) {
                      value.put(
                          "${element.sourceName}${element.lang}",
                          SourceModel(
                              sourceName: element.sourceName,
                              url: element.url,
                              lang: element.lang,
                              typeSource: element.typeSource,
                              isAdded: val));
                    },
                    sourceName: source.sourceName,
                    value: source.isAdded,
                  );
                },
                order: GroupedListOrder.ASC,
              );
            });
  }
}
