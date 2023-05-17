import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/lang.dart';
import 'package:mangayomi/views/browse/extension/refresh_filter_data.dart';

class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(refreshFilterDataProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: StreamBuilder(
          stream: isar.sources
              .filter()
              .idIsNotNull()
              .isAddedEqualTo(true)
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text("Empty"));
            }
            final entries = snapshot.data!;
            return GroupedListView<Source, String>(
              elements: entries,
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
                    child: element.logoUrl!.isEmpty
                        ? const Icon(Icons.source_outlined)
                        : CachedNetworkImage(
                            httpHeaders: ref.watch(
                                headersProvider(source: element.sourceName!)),
                            imageUrl: element.logoUrl!,
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
                  subtitle: Row(
                    children: [
                      Text(
                        completeLang(element.lang!.toLowerCase()),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                      if (element.isNsfw!)
                        Row(
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              "18+",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10,
                                  color: Colors.redAccent
                                      .withBlue(5)
                                      .withOpacity(0.8)),
                            ),
                          ],
                        )
                    ],
                  ),
                  title: Text(element.sourceName!),
                  trailing: const SizedBox(
                      width: 110,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                  item1.sourceName!.compareTo(item2.sourceName!),
              order: GroupedListOrder.ASC,
            );
          }),
    );
  }
}
