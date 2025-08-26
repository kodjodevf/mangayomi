import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/download/providers/download_provider.dart';
import 'package:mangayomi/utils/extensions/chapter.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

class ChapterPageDownload extends ConsumerWidget {
  final Chapter chapter;

  const ChapterPageDownload({super.key, required this.chapter});

  void _startDownload(bool? useWifi, int? downloadId, WidgetRef ref) async {
    _cancelTasks(downloadId: downloadId);
    ref.read(downloadChapterProvider(chapter: chapter, useWifi: useWifi));
  }

  void _sendFile(BuildContext context) async {
    final storageProvider = StorageProvider();
    final mangaDir = await storageProvider.getMangaMainDirectory(chapter);
    final path = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDir,
    );

    List<XFile> files = [];

    final cbzFile = File(p.join(mangaDir!.path, "${chapter.name}.cbz"));
    final mp4File = File(
      p.join(
        mangaDir.path,
        "${chapter.name!.replaceForbiddenCharacters(' ')}.mp4",
      ),
    );
    final htmlFile = File(p.join(mangaDir.path, "${chapter.name}.html"));
    if (cbzFile.existsSync()) {
      files = [XFile(cbzFile.path)];
    } else if (mp4File.existsSync()) {
      files = [XFile(mp4File.path)];
    } else if (htmlFile.existsSync()) {
      files = [XFile(htmlFile.path)];
    } else {
      files = path!.listSync().map((e) => XFile(e.path)).toList();
    }
    if (files.isNotEmpty && context.mounted) {
      final box = context.findRenderObject() as RenderBox?;
      Share.shareXFiles(
        files,
        text: chapter.name,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  void _deleteFile(int downloadId) async {
    final storageProvider = StorageProvider();
    final mangaDir = await storageProvider.getMangaMainDirectory(chapter);
    final path = await storageProvider.getMangaChapterDirectory(
      chapter,
      mangaMainDirectory: mangaDir,
    );

    try {
      try {
        final cbzFile = File(p.join(mangaDir!.path, "${chapter.name}.cbz"));
        if (cbzFile.existsSync()) {
          cbzFile.deleteSync();
        }
      } catch (_) {}
      try {
        final mp4File = File(
          p.join(
            mangaDir!.path,
            "${chapter.name!.replaceForbiddenCharacters(' ')}.mp4",
          ),
        );
        if (mp4File.existsSync()) {
          mp4File.deleteSync();
        }
      } catch (_) {}
      try {
        final htmlFile = File(p.join(mangaDir!.path, "${chapter.name}.html"));
        if (htmlFile.existsSync()) {
          htmlFile.deleteSync();
        }
      } catch (_) {}
      path!.deleteSync(recursive: true);
    } catch (_) {}
    chapter.cancelDownloads(downloadId);
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
                        color: Theme.of(
                          context,
                        ).iconTheme.color!.withValues(alpha: 0.7),
                      ),
                      onSelected: (value) {
                        if (value == 0) {
                          _sendFile(context);
                        } else if (value == 1) {
                          _deleteFile(download.id!);
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
                            _startDownload(false, download.id, ref);
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
                                    color: Theme.of(
                                      context,
                                    ).iconTheme.color!.withValues(alpha: 0.7),
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
                                    : Theme.of(
                                        context,
                                      ).iconTheme.color!.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                        onSelected: (value) {
                          if (value == 0) {
                            _cancelTasks(downloadId: download.id!);
                          } else if (value == 1) {
                            _startDownload(false, download.id, ref);
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
                  : download.succeeded == 0
                  ? IconButton(
                      onPressed: () {
                        _startDownload(null, download.id, ref);
                      },
                      icon: Icon(
                        FontAwesomeIcons.circleDown,
                        color: Theme.of(
                          context,
                        ).iconTheme.color!.withValues(alpha: 0.7),
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
                            _startDownload(null, download.id, ref);
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
                _startDownload(null, null, ref);
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
