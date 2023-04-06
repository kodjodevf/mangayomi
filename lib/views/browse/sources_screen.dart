import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/refresh_filter_data.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshFilter = ref.watch(refreshFilterDataProvider);

    return refreshFilter.when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ValueListenableBuilder<Box<SourceModel>>(
              valueListenable:
                  ref.watch(hiveBoxMangaSourceProvider).listenable(),
              builder: (context, value, child) {
                final entries = value.values
                    .where((element) => element.isAdded == true)
                    .toList();
                if (entries.isEmpty) {
                  return const Center(child: Text("Empty"));
                }
                return GroupedListView<SourceModel, String>(
                  elements: entries,
                  groupBy: (element) =>
                      completeLang(element.lang.toLowerCase()),
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
                    final source =
                        value.get("${element.sourceName}${element.lang}")!;
                    return ListTile(
                      onTap: () {
                        context.push('/mangaHome',
                            extra: MangaType(
                                isFullData: element.isFullData,
                                lang: element.lang,
                                source: element.sourceName));
                      },
                      leading: Container(
                        height: 37,
                        width: 37,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: element.logoUrl.isEmpty
                            ? const Icon(Icons.source_outlined)
                            : CachedNetworkImage(
                                imageUrl: element.logoUrl,
                                fit: BoxFit.contain,
                                width: 37,
                                height: 37,
                                errorWidget: (context, url, error) {
                                  return const SizedBox(
                                    width: 37,
                                    height: 37,
                                    child: Center(
                                      child: Icon(Icons.source_outlined),
                                    ),
                                  );
                                },
                              ),
                      ),
                      subtitle: Text(
                        completeLang(source.lang.toLowerCase()),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                      title: Text(source.sourceName),
                      trailing: SizedBox(
                          width: 110,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                Icons.push_pin_outlined,
                                color: Colors.black,
                              )
                            ],
                          )),
                    );
                  },
                  groupComparator: (group1, group2) => group1.compareTo(group2),
                  itemComparator: (item1, item2) =>
                      item1.sourceName.compareTo(item2.sourceName),
                  order: GroupedListOrder.ASC,
                );
              }),
        );
      },
      error: (error, stackTrace) {
        return Container();
      },
      loading: () {
        return Container();
      },
    );
  }
}
