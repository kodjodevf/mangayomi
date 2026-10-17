import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/modules/widgets/entry_badge_chip.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/download_manager/download_queue_order.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/modules/widgets/tv_menu.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
      stream: downloadRepository.watchPending(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.download_queue),
              leading: isTv
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      autofocus: true,
                      icon: const BackButtonIcon(),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
            ),
            body: ShioriEmptyState(
              icon: Symbols.download_done_rounded,
              title: l10n.no_downloads,
              compact: true,
            ),
          );
        }
        // Filter out orphaned downloads (chapter or manga deleted) and auto-
        // clean their records.
        final orphanIds = <int>[];
        final valid = <Download>[];
        for (final d in snapshot.data!) {
          if (d.chapter.value == null || d.chapter.value?.manga.value == null) {
            if (d.id != null) orphanIds.add(d.id!);
          } else {
            valid.add(d);
          }
        }
        if (orphanIds.isNotEmpty) {
          downloadRepository.deleteAll(orphanIds);
        }
        if (valid.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.download_queue),
              leading: isTv
                  ? IconButton(
                      tooltip: MaterialLocalizations.of(context)
                          .backButtonTooltip,
                      autofocus: true,
                      icon: const BackButtonIcon(),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : null,
            ),
            body: ShioriEmptyState(
              icon: Symbols.download_done_rounded,
              title: l10n.no_downloads,
              compact: true,
            ),
          );
        }
        final entries = DownloadQueueOrder.sorted(valid);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              spacing: ShioriSpace.s8,
              children: [
                Flexible(child: Text(l10n.download_queue)),
                EntryBadgeChip(label: entries.length.toString()),
              ],
            ),
            actions: [
              // Starts every download in the queue again, failed ones
              // included. It was a floating button labelled with the
              // screen's own name, which said nothing of what it did.
              IconButton(
                tooltip: l10n.resume_all_downloads,
                onPressed: () => _resumeAll(entries),
                icon: const Icon(Symbols.play_arrow_rounded, fill: 1),
              ),
            ],
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
        );
      },
    );
  }

  Future<void> _resumeAll(List<Download> entries) async {
    for (final entry in entries) {
      final chapter = entry.chapter.value;
      if (chapter != null) {
        await downloadRepository.enqueue(chapter);
      }
    }
    if (!mounted) return;
    ref.invalidate(processDownloadsProvider());
    ref.read(processDownloadsProvider());
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
      height: context.shiori.density.rowHeight + ShioriSpace.s16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.all(ShioriSpace.s8),
              child: Icon(Symbols.drag_handle_rounded, fill: 1),
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                final tokens = context.shiori;
                final failed = (element.failed ?? 0) > 0;
                final total = element.total ?? 0;
                final progress = total > 0
                    ? (element.succeeded ?? 0) / total
                    : 0.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Row(
                      spacing: ShioriSpace.s8,
                      children: [
                        Expanded(
                          child: Text(
                            element.chapter.value?.manga.value?.name ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tokens.text.row.copyWith(
                              color: tokens.color.fg,
                            ),
                          ),
                        ),
                        Text(
                          failed
                              ? l10n.download_failed
                              : '${(progress * 100).round()} %',
                          style: tokens.text.meta.copyWith(
                            color: failed
                                ? tokens.color.error.foreground
                                : tokens.color.fgMuted,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      element.chapter.value?.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.caption,
                    ),
                    const SizedBox(height: ShioriSpace.s4),
                    TweenAnimationBuilder<double>(
                      duration: ShioriMotion.of(context, ShioriMotion.standard),
                      curve: ShioriMotion.standardCurve,
                      tween: Tween<double>(begin: 0, end: progress),
                      builder: (context, value, _) => ShioriProgressBar(
                        value: value,
                        height: 4,
                        color: failed
                            ? tokens.color.error.foreground
                            : tokens.color.accent,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(ShioriSpace.s8),
            child: isTv
                // An anchored dropdown is a poor remote target, so pop the same
                // actions in the centre on TV.
                ? IconButton(
                    tooltip: MaterialLocalizations.of(context)
                        .moreButtonTooltip,
                    icon: const Icon(Symbols.more_vert_rounded, fill: 1),
                    onPressed: () async {
                      final picked = await showTvMenu(
                        context,
                        title: element.chapter.value?.manga.value?.name ?? '',
                        options: [
                          TvMenuOption(l10n.cancel),
                          TvMenuOption(l10n.cancel_all_for_this_series),
                        ],
                      );
                      if (picked != null && context.mounted) {
                        await _onDownloadAction(
                          context,
                          picked == 0 ? 'Cancel' : 'CancelAll',
                          element,
                          entries,
                        );
                      }
                    },
                  )
                : ShioriMenuButton(
                    tooltip: MaterialLocalizations.of(context)
                        .moreButtonTooltip,
                    items: [
                      ShioriMenuItem(
                        label: l10n.cancel,
                        icon: Symbols.close_rounded,
                        onSelected: () => _onDownloadAction(
                          context,
                          'Cancel',
                          element,
                          entries,
                        ),
                      ),
                      ShioriMenuItem(
                        label: l10n.cancel_all_for_this_series,
                        icon: Symbols.cancel_rounded,
                        destructive: true,
                        onSelected: () => _onDownloadAction(
                          context,
                          'CancelAll',
                          element,
                          entries,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// The per-download actions, shared by the popup menu off-TV and the centred
  /// TV menu.
  Future<void> _onDownloadAction(
    BuildContext context,
    String value,
    Download element,
    List<Download> entries,
  ) async {
    if (value == 'Cancel') {
      if (element.chapter.value != null) {
        element.chapter.value!.cancelDownloads(element.id!);
      } else {
        // Orphaned download: just delete the record.
        downloadRepository.delete(element.id!);
      }
    } else if (value == 'CancelAll') {
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
        final chapter = chapterRepository.findByIdSync(chapterId!);
        chapter?.cancelDownloads(downloadId!);
      }
    }
  }
}
