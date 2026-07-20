import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/manga/detail/widgets/custom_floating_action_btn.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/download_manager/download_queue_order.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';

class DownloadQueueScreen extends ConsumerStatefulWidget {
  const DownloadQueueScreen({super.key});

  @override
  ConsumerState<DownloadQueueScreen> createState() =>
      _DownloadQueueScreenState();
}

class _DownloadQueueScreenState extends ConsumerState<DownloadQueueScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    return StreamBuilder(
      // No explicit sort: the natural (insertion) id order is the stable base
      // the manual queue order is applied on top of, so rows don't reshuffle as
      // download progress ticks.
      stream: isar.downloads
          .filter()
          .idIsNotNull()
          .isDownloadEqualTo(false)
          .isStartDownloadEqualTo(true)
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.download_queue)),
            body: Center(child: Text(l10n.no_downloads)),
          );
        }
        // Filter out orphaned downloads (chapter or manga deleted) and auto-
        // clean their records.
        final orphanIds = <int>[];
        final valid = <Download>[];
        for (final d in snapshot.data!) {
          if (d.chapter.value == null ||
              d.chapter.value?.manga.value == null) {
            if (d.id != null) orphanIds.add(d.id!);
          } else {
            valid.add(d);
          }
        }
        if (orphanIds.isNotEmpty) {
          isar.writeTxnSync(() {
            for (final id in orphanIds) {
              isar.downloads.deleteSync(id);
            }
          });
        }
        if (valid.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.download_queue)),
            body: Center(child: Text(l10n.no_downloads)),
          );
        }
        final entries = DownloadQueueOrder.sorted(valid);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(l10n.download_queue),
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Badge(
                    backgroundColor: Theme.of(context).focusColor,
                    label: Text(
                      entries.length.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            itemCount: entries.length,
            // onReorderItem already accounts for the item being lifted out at
            // oldIndex, so newIndex arrives adjusted and must not be shifted
            // again here.
            onReorderItem: (oldIndex, newIndex) {
              final ids = entries.map((e) => e.id!).toList();
              final moved = ids.removeAt(oldIndex);
              ids.insert(newIndex, moved);
              DownloadQueueOrder.setOrder(ids);
              setState(() {});
            },
            itemBuilder: (context, index) {
              final element = entries[index];
              return _buildRow(context, l10n, entries, element, index);
            },
          ),
          floatingActionButton: CustomFloatingActionBtn(
            isExtended: false,
            label: l10n.download_queue,
            onPressed: () {
              ref.read(processDownloadsProvider());
            },
          ),
        );
      },
    );
  }

  Widget _buildRow(
    BuildContext context,
    AppLocalizations l10n,
    List<Download> entries,
    Download element,
    int index,
  ) {
    return SizedBox(
      key: ValueKey(element.id),
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.drag_handle),
            ),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      element.chapter.value?.manga.value?.name ?? "",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "${element.succeeded}/${element.total}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                Text(
                  element.chapter.value?.name ?? "",
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0,
                    end: element.succeeded! / element.total!,
                  ),
                  builder: (context, value, _) =>
                      LinearProgressIndicator(value: value),
                ),
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
                  if (element.chapter.value != null) {
                    element.chapter.value!.cancelDownloads(element.id!);
                  } else {
                    // Orphaned download: just delete the record.
                    isar.writeTxnSync(() {
                      isar.downloads.deleteSync(element.id!);
                    });
                  }
                } else if (value.toString() == 'CancelAll') {
                  final a = entries
                      .where(
                        (e) =>
                            '${e.chapter.value?.manga.value?.name}' ==
                                '${element.chapter.value?.manga.value?.name}' &&
                            '${e.chapter.value?.manga.value?.source}' ==
                                '${element.chapter.value?.manga.value?.source}',
                      )
                      .map((e) => (e.id, e.chapter.value?.id))
                      .toList();
                  for (var ids in a) {
                    final (downloadId, chapterId) = ids;
                    final chapter = isar.chapters.getSync(chapterId!);
                    chapter?.cancelDownloads(downloadId!);
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'Cancel', child: Text(l10n.cancel)),
                PopupMenuItem(
                  value: 'CancelAll',
                  child: Text(l10n.cancel_all_for_this_series),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
