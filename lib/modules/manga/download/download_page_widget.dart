import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/more/settings/downloads/providers/downloads_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/utils/extensions/chapter_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class ChapterPageDownload extends ConsumerWidget {
  final Chapter chapter;

  const ChapterPageDownload({super.key, required this.chapter});

  void _startDownload(
    bool? useWifi,
    int? downloadId,
    WidgetRef ref, {
    LocalFolder? localFolder,
  }) async {
    _cancelTasks(downloadId: downloadId);
    ref.read(
      downloadChapterProvider(
        chapter: chapter,
        useWifi: useWifi,
        localFolder: localFolder,
      ),
    );
  }

  void _sendFile(BuildContext context) async {
    final files = (await _downloadedFiles()).map((e) => XFile(e.path)).toList();
    if (files.isNotEmpty && context.mounted) {
      final box = context.findRenderObject() as RenderBox?;
      SharePlus.instance.share(
        ShareParams(
          files: files,
          text: chapter.name,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        ),
      );
    }
  }

  void _deleteFile(int downloadId) async {
    for (final entity in await _downloadedFileEntities()) {
      try {
        if (entity.existsSync()) entity.deleteSync(recursive: true);
      } catch (_) {}
    }
    chapter.cancelDownloads(downloadId);
  }

  Future<List<File>> _downloadedFiles() async {
    final files = <File>[];
    for (final entity in await _downloadedFileEntities()) {
      if (entity is File && entity.existsSync()) {
        files.add(entity);
      } else if (entity is Directory && entity.existsSync()) {
        files.addAll(entity.listSync().whereType<File>());
      }
    }
    return files;
  }

  Future<List<FileSystemEntity>> _downloadedFileEntities() async {
    final storageProvider = StorageProvider();
    final folders = await getAllLocalFolders();
    final manga = chapter.manga.value!;
    final chapterName = chapter.name!.replaceForbiddenCharacters(' ');
    final candidates = <FileSystemEntity>[];

    for (final folder in folders) {
      final folderPath = folder.path;
      if (folderPath == null || folderPath.isEmpty) continue;
      final mangaDir = Directory(
        p.join(folderPath, manga.name!.replaceForbiddenCharacters('_')),
      );
      final chapterDir = await storageProvider.getMangaChapterDirectory(
        chapter,
        mangaMainDirectory: mangaDir,
      );
      candidates.addAll([
        File(p.join(mangaDir.path, "${chapter.name}.cbz")),
        File(p.join(mangaDir.path, "$chapterName.cbz")),
        File(p.join(mangaDir.path, "$chapterName.mp4")),
        File(p.join(mangaDir.path, "${chapter.name}.html")),
        File(p.join(chapterDir!.path, "$chapterName.html")),
        chapterDir,
      ]);
    }
    return candidates;
  }

  Future<void> _showDownloadFolderDialog(
    BuildContext context,
    WidgetRef ref, {
    bool? useWifi,
    int? downloadId,
  }) async {
    final folders = await getAllLocalFolders();
    if (folders.isEmpty || !context.mounted) return;
    final shouldAsk = ref.read(askDownloadDestinationStateProvider);
    if (!shouldAsk || folders.length == 1) {
      final folder = !shouldAsk
          ? await getDownloadLocalFolder()
          : folders.first;
      if (folder == null) return;
      _startDownload(useWifi, downloadId, ref, localFolder: folder);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.l10n.select_download_destination),
        children: folders
            .map(
              (folder) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  _startDownload(useWifi, downloadId, ref, localFolder: folder);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(folder.name ?? ""),
                  subtitle: Text(folder.path ?? ""),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    return SizedBox(
      height: 41,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: StreamBuilder(
          stream: isar.downloads
              .filter()
              .idEqualTo(chapter.id)
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              final download = entries.first;
              return download.isDownload!
                  ? PopupMenuButton(
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
                    )
                  : download.isStartDownload! && download.succeeded == 0
                  ? SizedBox(
                      height: 41,
                      width: 35,
                      child: PopupMenuButton(
                        popUpAnimationStyle: popupAnimationStyle,
                        child: _downloadWidget(context, true),
                        onSelected: (value) {
                          if (value == 0) {
                            _cancelTasks(downloadId: download.id!);
                          } else if (value == 1) {
                            _showDownloadFolderDialog(
                              context,
                              ref,
                              useWifi: false,
                              downloadId: download.id,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text(l10n.start_downloading),
                          ),
                          PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                        ],
                      ),
                    )
                  : download.succeeded != 0
                  ? SizedBox(
                      height: 41,
                      width: 35,
                      child: PopupMenuButton(
                        popUpAnimationStyle: popupAnimationStyle,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: TweenAnimationBuilder<double>(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: (download.succeeded! / download.total!),
                                ),
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
                                color:
                                    (download.succeeded! / download.total!) >
                                        0.5
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Theme.of(context).iconTheme.color!
                                          .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            _cancelTasks(downloadId: download.id!);
                          } else if (value == 1) {
                            _showDownloadFolderDialog(
                              context,
                              ref,
                              useWifi: false,
                              downloadId: download.id,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          // This download already has progress, so the action is
                          // a restart, not a start — label it Retry (matches the
                          // stalled/no-progress state below).
                          PopupMenuItem(value: 1, child: Text(l10n.retry)),
                          PopupMenuItem(value: 0, child: Text(l10n.cancel)),
                        ],
                      ),
                    )
                  : download.succeeded == 0
                  ? IconButton(
                      onPressed: () {
                        _showDownloadFolderDialog(
                          context,
                          ref,
                          downloadId: download.id,
                        );
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.circleDown,
                        color: Theme.of(context).iconTheme.color!
                            .withValues(alpha: 0.7),
                        size: 25,
                      ),
                    )
                  : SizedBox(
                      height: 50,
                      width: 50,
                      child: PopupMenuButton(
                        popUpAnimationStyle: popupAnimationStyle,
                        child: const Icon(
                          Icons.error_outline_outlined,
                          color: Colors.red,
                          size: 25,
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            _showDownloadFolderDialog(
                              context,
                              ref,
                              downloadId: download.id,
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 0, child: Text(l10n.retry)),
                        ],
                      ),
                    );
            }
            return IconButton(
              splashRadius: 5,
              iconSize: 17,
              onPressed: () {
                _showDownloadFolderDialog(context, ref);
              },
              icon: _downloadWidget(context, false),
            );
          },
        ),
      ),
    );
  }

  void _cancelTasks({int? downloadId}) async {
    chapter.cancelDownloads(downloadId);
  }
}

Widget _downloadWidget(BuildContext context, bool isLoading) {
  return Stack(
    children: [
      Align(
        alignment: Alignment.center,
        child: Icon(
          size: 18,
          Icons.arrow_downward_sharp,
          color: Theme.of(context).iconTheme.color!.withValues(alpha: 0.7),
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            value: isLoading ? null : 1,
            color: Theme.of(context).iconTheme.color!.withValues(alpha: 0.7),
            strokeWidth: 2,
          ),
        ),
      ),
    ],
  );
}
