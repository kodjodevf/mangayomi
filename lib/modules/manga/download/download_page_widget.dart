import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_gate.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class ChapterPageDownload extends ConsumerWidget {
  final Chapter chapter;

  const ChapterPageDownload({super.key, required this.chapter});

  void _startDownload(WidgetRef ref, {bool? useWifi}) async {
    if (isDownloadScheduled(chapter.id)) return;
    await downloadRepository.enqueue(chapter);
    ref.invalidate(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
    ref.read(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
  }

  void _sendFile(BuildContext context) async {
    final files = (await _downloadedFiles()).map((e) => XFile(e.path)).toList();
    if (files.isNotEmpty && context.mounted) {
      final box = context.mounted
          ? context.findRenderObject() as RenderBox?
          : null;
      final origin = box != null && box.hasSize
          ? (box.localToGlobal(Offset.zero) & box.size)
          : null;
      shareOrCopy(
        ShareParams(
          files: files,
          text: chapter.name,
          sharePositionOrigin: origin,
        ),
      );
    }
  }

  Future<List<File>> _downloadedFiles() async {
    final files = <File>[];
    for (final entity in await _downloadedFileEntities()) {
      if (entity is File && await entity.exists()) {
        files.add(entity);
      } else if (entity is Directory && await entity.exists()) {
        await for (final child in entity.list()) {
          if (child is File) {
            files.add(child);
          }
        }
      }
    }
    return files;
  }

  Future<List<FileSystemEntity>> _downloadedFileEntities() async {
    final name = chapter.name;
    if (name == null || name.isEmpty) return const [];
    final storageProvider = StorageProvider();
    final chapterName = name.replaceForbiddenCharacters(' ');
    final candidates = <FileSystemEntity>[];

    final mangaDir = await storageProvider.getMangaMainDirectory(chapter);
    if (mangaDir != null) {
      candidates.addAll([
        File(p.join(mangaDir.path, "$name.cbz")),
        File(p.join(mangaDir.path, "$chapterName.cbz")),
        File(p.join(mangaDir.path, "$chapterName.mp4")),
        File(p.join(mangaDir.path, "$name.html")),
      ]);
      final chapterDir = await storageProvider.getMangaChapterDirectory(
        chapter,
        mangaMainDirectory: mangaDir,
      );
      if (chapterDir != null) {
        candidates.add(File(p.join(chapterDir.path, "$chapterName.html")));
        candidates.add(chapterDir);
      }
    }
    return candidates;
  }

  void _downloadChapter(BuildContext context, WidgetRef ref, {bool? useWifi}) {
    _startDownload(ref, useWifi: useWifi);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final initialDownload = downloadRepository.getByChapterId(chapter.id);
    return SizedBox(
      height: 41,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s4),
        child: StreamBuilder<List<Download>>(
          initialData: initialDownload != null ? [initialDownload] : const [],
          stream: downloadRepository.watchByChapterId(chapter.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              final download = entries.first;

              // 1. Completely downloaded
              if (download.isDownload == true) {
                return _statusMenu(
                  context,
                  tooltip: l10n.downloaded,
                  icon: Icon(
                    Symbols.check_circle_rounded,
                    fill: 1,
                    color: context.shiori.color.fgMuted,
                  ),
                  items: [
                    ShioriMenuItem(
                      label: l10n.send,
                      icon: Symbols.send_rounded,
                      onSelected: () => _sendFile(context),
                    ),
                    ShioriMenuItem(
                      label: l10n.delete,
                      icon: Symbols.delete_rounded,
                      destructive: true,
                      onSelected: () => chapter.deleteDownloadedFiles(),
                    ),
                  ],
                );
              }

              // 2. Failed download state
              if ((download.failed ?? 0) > 0 &&
                  download.isStartDownload != true) {
                return _statusMenu(
                  context,
                  tooltip: l10n.download_failed,
                  icon: Icon(
                    Symbols.error_rounded,
                    color: context.shiori.color.error.foreground,
                  ),
                  items: [
                    ShioriMenuItem(
                      label: l10n.retry,
                      icon: Symbols.refresh_rounded,
                      onSelected: () => _downloadChapter(context, ref),
                    ),
                    ShioriMenuItem(
                      label: l10n.cancel,
                      icon: Symbols.close_rounded,
                      onSelected: () => _cancelTasks(downloadId: download.id),
                    ),
                  ],
                );
              }

              // 3. Active download in progress or queued
              if (download.isStartDownload == true) {
                final succeeded = download.succeeded ?? 0;
                final total = download.total ?? 0;

                if (succeeded > 0 && total > 0) {
                  final progress = (succeeded / total).clamp(0.0, 1.0);
                  return _statusMenu(
                    context,
                    tooltip: l10n.download,
                    items: _activeItems(context, ref, download, l10n.retry),
                    icon: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TweenAnimationBuilder<double>(
                            duration: ShioriMotion.standard,
                            curve: Curves.easeInOut,
                            tween: Tween<double>(begin: 0, end: progress),
                            builder: (context, value, _) => SizedBox(
                              height: 2,
                              width: 2,
                              child: CircularProgressIndicator(
                                strokeWidth: 19,
                                value: value,
                                color: context.shiori.color.fg.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Symbols.arrow_downward_rounded,
                            fill: 1,
                            color: progress > 0.5
                                ? context.shiori.color.ink0
                                : context.shiori.color.fg.withValues(
                                    alpha: 0.7,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Started / queued with zero progress yet
                return _statusMenu(
                  context,
                  tooltip: l10n.download,
                  icon: const _DownloadProgressIcon(isLoading: true),
                  items: _activeItems(
                    context,
                    ref,
                    download,
                    l10n.start_downloading,
                  ),
                );
              }

              // 4. Queued / paused but not started
              return IconButton(
                tooltip: context.l10n.download,
                splashRadius: 5,
                iconSize: 17,
                onPressed: () {
                  _downloadChapter(context, ref);
                },
                icon: const _DownloadProgressIcon(isLoading: false),
              );
            }

            // 5. Not downloaded
            return IconButton(
              tooltip: context.l10n.download,
              splashRadius: 5,
              iconSize: 17,
              onPressed: () {
                _downloadChapter(context, ref);
              },
              icon: const _DownloadProgressIcon(isLoading: false),
            );
          },
        ),
      ),
    );
  }

  void _cancelTasks({int? downloadId}) {
    chapter.cancelDownloads(downloadId);
  }

  /// A download under way: start it again over any network, or cancel it.
  List<ShioriMenuItem> _activeItems(
    BuildContext context,
    WidgetRef ref,
    Download download,
    String restartLabel,
  ) => [
    ShioriMenuItem(
      label: restartLabel,
      icon: Symbols.play_arrow_rounded,
      onSelected: () => _downloadChapter(context, ref, useWifi: false),
    ),
    ShioriMenuItem(
      label: context.l10n.cancel,
      icon: Symbols.close_rounded,
      onSelected: () => _cancelTasks(downloadId: download.id),
    ),
  ];
}

/// A chapter's download state as a button that opens what can be done
/// with it, reachable by keyboard and remote and named for screen readers.
Widget _statusMenu(
  BuildContext context, {
  required String tooltip,
  required Widget icon,
  required List<ShioriMenuItem> items,
}) => MenuAnchor(
  style: shioriMenuStyle(context),
  menuChildren: [for (final item in items) ShioriMenuEntry(item)],
  builder: (context, controller, _) => IconButton(
    tooltip: tooltip,
    padding: EdgeInsets.zero,
    onPressed: () => controller.isOpen ? controller.close() : controller.open(),
    icon: icon,
  ),
);

class _DownloadProgressIcon extends StatelessWidget {
  final bool isLoading;

  const _DownloadProgressIcon({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final color = context.shiori.color.fg.withValues(alpha: 0.7);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Icon(size: 18, Symbols.arrow_downward_rounded, color: color),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              value: isLoading ? null : 1,
              color: color,
              strokeWidth: 2,
            ),
          ),
        ),
      ],
    );
  }
}
