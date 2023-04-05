import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/manga_type.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/source/source_list.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/lang.dart';

// class SourcesScreen extends StatefulWidget {
//   const SourcesScreen({super.key});

//   @override
//   State<SourcesScreen> createState() => _SourcesScreenState();
// }

// class _SourcesScreenState extends State<SourcesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           onTap: () {
//             context.push('/mangaHome',
//                 extra: MangaType(
//                     isFullData: true, lang: 'en', source: 'MangaHere'));
//           },
//           leading: Container(
//             height: 37,
//             width: 37,
//             decoration: BoxDecoration(
//                 color: Colors.grey, borderRadius: BorderRadius.circular(5)),
//           ),
//           subtitle: const Text('English'),
//           title: const Text('MangaHere'),
//           trailing: SizedBox(
//               width: 110,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: const [
//                   Text(
//                     "Latest",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Icon(
//                     Icons.push_pin_outlined,
//                     color: Colors.black,
//                   )
//                 ],
//               )),
//         )
//       ],
//     );
//   }
// }

class SourcesScreen extends ConsumerStatefulWidget {
  const SourcesScreen({super.key});

  @override
  ConsumerState<SourcesScreen> createState() => _SourcesScreenState();
}

class _SourcesScreenState extends ConsumerState<SourcesScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    return ValueListenableBuilder<Box<SourceModel>>(
        valueListenable: ref.watch(hiveBoxMangaSourceProvider).listenable(),
        builder: (context, value, child) {
          final entries =
              value.values.where((element) => element.isAdded == true).toList();
          if (entries.isEmpty) {
            return const Center(child: Text("Empty"));
          }
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
              final source = value.get("${element.sourceName}${element.lang}")!;
              return ListTile(
                onTap: () {
                  if (source.sourceName == 'MangaHere') {
                    context.push('/mangaHome',
                        extra: MangaType(
                            isFullData: true, lang: 'en', source: 'MangaHere'));
                  }
                },
                leading: Container(
                  height: 37,
                  width: 37,
                  decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Icon(Icons.source_outlined),
                ),
                subtitle: Text(completeLang(source.lang.toLowerCase())),
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
            sort: true,
            order: GroupedListOrder.ASC,
          );
        });
  }
}
