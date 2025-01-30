import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/global_style.dart';

class DownloadQueueScreen extends ConsumerWidget {
  const DownloadQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    return StreamBuilder(
      stream:
          isar.downloads.filter().idIsNotNull().watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final entries = snapshot.data!
              .where(
                (element) => element.isDownload == false,
              )
              .where((element) => element.isStartDownload == true)
              .toList();
          final allQueueLength = entries.toList().length;
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Text(l10n!.download_queue),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Badge(
                          backgroundColor: Theme.of(context).focusColor,
                          label: Text(
                            allQueueLength.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color),
                          ))),
                ],
              ),
            ),
            body: GroupedListView<Download, String>(
              elements: entries,
              groupBy: (element) =>
                  element.chapter.value?.manga.value?.source ?? "",
              groupSeparatorBuilder: (String groupByValue) {
                final sourceQueueLength = entries
                    .where((element) =>
                        (element.chapter.value?.manga.value?.source ?? "") ==
                        groupByValue)
                    .toList()
                    .length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 12),
                  child: Text('$groupByValue ($sourceQueueLength)'),
                );
              },
              itemBuilder: (context, Download element) {
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
                                  element.chapter.value?.manga.value?.name ??
                                      "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${element.succeeded}/${element.total}",
                                  style: const TextStyle(fontSize: 10),
                                )
                              ],
                            ),
                            Text(
                              element.chapter.value?.name ?? "",
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
                                  end: element.succeeded! / element.total!,
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
                          popUpAnimationStyle: popupAnimationStyle,
                          child: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value.toString() == 'Cancel') {
                              element.chapter.value
                                  ?.cancelDownloads(element.id!);
                            } else if (value.toString() == 'CancelAll') {
                              final a = entries
                                  .where((e) =>
                                      '${e.chapter.value?.manga.value?.name}' ==
                                          '${element.chapter.value?.manga.value?.name}' &&
                                      '${e.chapter.value?.manga.value?.source}' ==
                                          '${element.chapter.value?.manga.value?.source}')
                                  .map((e) => (e.id, e.chapter.value?.id))
                                  .toList();
                              for (var ids in a) {
                                final (downloadId, chapterId) = ids;
                                final chapter =
                                    isar.chapters.getSync(chapterId!);
                                chapter?.cancelDownloads(downloadId!);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 'Cancel', child: Text(l10n.cancel)),
                            PopupMenuItem(
                                value: 'CancelAll',
                                child: Text(l10n.cancel_all_for_this_series)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
              itemComparator: (item1, item2) =>
                  (item1.chapter.value?.manga.value?.source ?? "").compareTo(
                      item2.chapter.value?.manga.value?.source ?? ""),
              order: GroupedListOrder.DESC,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n!.download_queue),
          ),
          body: Center(child: Text(l10n.no_downloads)),
        );
      },
    );
  }
}
