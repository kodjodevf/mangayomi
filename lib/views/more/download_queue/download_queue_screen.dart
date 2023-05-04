import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/views/manga/download/model/download_model.dart';

class DownloadQueueScreen extends ConsumerWidget {
  const DownloadQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder<Box<DownloadModel>>(
      valueListenable: ref.watch(hiveBoxMangaDownloadsProvider).listenable(),
      builder: (context, val, child) {
        final entries = val.values
            .where(
              (element) => element.isDownload == false,
            )
            .where((element) => element.isStartDownload == true)
            .toList();
        final allQueueLength = entries.toList().length;

        if (entries.isNotEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Text('Download queue'),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).focusColor,
                      radius: 10,
                      child: Text(
                        allQueueLength.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).textTheme.bodySmall!.color),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: GroupedListView<DownloadModel, String>(
              elements: entries,
              groupBy: (element) => element.mangaSource!,
              groupSeparatorBuilder: (String groupByValue) {
                final sourceQueueLength = entries
                    .where((element) => element.mangaSource! == groupByValue)
                    .toList()
                    .length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 12),
                  child: Text('$groupByValue ($sourceQueueLength)'),
                );
              },
              itemBuilder: (context, DownloadModel element) {
                return SizedBox(
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.drag_handle),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  element.mangaName!,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${element.succeeded}/${element.total}",
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                            Text(
                              element.chapterName!,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: element.succeeded / element.total,
                                ),
                                builder: (context, value, _) =>
                                    LinearProgressIndicator(
                                      value: value,
                                    )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PopupMenuButton(
                          child: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value.toString() == 'Cancel') {
                              List<String> taskIds = [];
                              for (var id in entries.first.taskIds) {
                                taskIds.add(id);
                              }
                              FileDownloader()
                                  .cancelTasksWithIds(taskIds)
                                  .then((value) async {
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                ref.watch(hiveBoxMangaDownloadsProvider).delete(
                                      "${element.chapterName}${element.chapterIndex}${element.chapterId}",
                                    );
                              });
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: 'Cancel', child: Text("Cancel")),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemComparator: (item1, item2) =>
                  item1.mangaSource!.compareTo(item2.mangaSource!),
              order: GroupedListOrder.DESC,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Download queue'),
          ),
          body: const Center(child: Text('No downloads')),
        );
      },
    );
  }
}
