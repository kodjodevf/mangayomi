import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_gate.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
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
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: StreamBuilder<List<Download>>(
          initialData: initialDownload != null ? [initialDownload] : const [],
          stream: downloadRepository.watchByChapterId(chapter.id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              final download = entries.first;

              // 1. Completely downloaded
              if (download.isDownload == true) {
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: Icon(
                    size: 25,
                    Icons.check_circle,
                    color: Theme.of(context).iconTheme.color!
                        .withValues(alpha: 0.7),
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      _sendFile(context);
                    } else if (value == 1) {
                      chapter.deleteDownloadedFiles();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text(l10n.send)),
                    PopupMenuItem(value: 1, child: Text(l10n.delete)),
                  ],
                );
              }

              // 2. Failed download state
              if ((download.failed ?? 0) > 0 &&
                  download.isStartDownload != true) {
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: const Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                  onSelected: (value) {
                    if (value == 0) {
                      _downloadChapter(context, ref);
                    } else if (value == 1) {
                      _cancelTasks(downloadId: download.id);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: Text(l10n.retry)),
                    PopupMenuItem(value: 1, child: Text(l10n.cancel)),
                  ],
                );
              }

              // 3. Active download in progress or queued
              if (download.isStartDownload == true) {
                final succeeded = download.succeeded ?? 0;
                final total = download.total ?? 0;

                if (succeeded > 0 && total > 0) {
                  final progress = (succeeded / total).clamp(0.0, 1.0);
                  return PopupMenuButton<int>(
                    popUpAnimationStyle: popupAnimationStyle,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            tween: Tween<double>(begin: 0, end: progress),
                            builder: (context, value, _) => SizedBox(
                              height: 2,
                              width: 2,
                              child: CircularProgressIndicator(
                                strokeWidth: 19,
                                value: value,
                                color: Theme.of(context).iconTheme.color!
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_downward_sharp,
                            color: progress > 0.5
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).iconTheme.color!
                                      .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                        _cancelTasks(downloadId: download.id);
                      } else if (value == 1) {
                        _downloadChapter(context, ref, useWifi: false);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 1, child: Text(l10n.retry)),
                      PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                    ],
                  );
                }

                // Started / queued with zero progress yet
                return PopupMenuButton<int>(
                  popUpAnimationStyle: popupAnimationStyle,
                  child: const _DownloadProgressIcon(isLoading: true),
                  onSelected: (value) {
                    if (value == 0) {
                      _cancelTasks(downloadId: download.id);
                    } else if (value == 1) {
                      _downloadChapter(context, ref, useWifi: false);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(l10n.start_downloading),
                    ),
                    PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                  ],
                );
              }

              // 4. Queued / paused but not started
              return IconButton(
                onPressed: () {
                  _downloadChapter(context, ref);
                },
                icon: FaIcon(
                  FontAwesomeIcons.circleDown,
                  color: Theme.of(context).iconTheme.color!
                      .withValues(alpha: 0.7),
                  size: 25,
                ),
              );
            }

            // 5. Not downloaded
            return IconButton(
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
}

class _DownloadProgressIcon extends StatelessWidget {
  final bool isLoading;

  const _DownloadProgressIcon({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color!.withValues(alpha: 0.7);
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Icon(size: 18, Icons.arrow_downward_sharp, color: color),
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
