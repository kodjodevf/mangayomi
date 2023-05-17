// ignore_for_file: implementation_imports, depend_on_referenced_packages
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';

class ChapterPageDownload extends ConsumerStatefulWidget {
  final Chapter chapter;

  const ChapterPageDownload({
    super.key,
    required this.chapter,
  });

  @override
  ConsumerState createState() => _ChapterPageDownloadState();
}

class _ChapterPageDownloadState extends ConsumerState<ChapterPageDownload>
    with AutomaticKeepAliveClientMixin<ChapterPageDownload> {
  List<String> _pageUrls = [];

  final StorageProvider _storageProvider = StorageProvider();
  _startDownload() async {
    final data = await ref
        .watch(downloadChapterProvider(chapter: widget.chapter).future);
    if (mounted) {
      setState(() {
        _pageUrls = data;
      });
    }
  }

  late final manga = widget.chapter.manga.value!;
  _deleteFile(List pageUrl) async {
    final path = await _storageProvider.getMangaChapterDirectory(
      widget.chapter,
    );

    try {
      path!.deleteSync(recursive: true);
    } catch (_) {}
    isar.writeTxnSync(() {
      int id = isar.downloads
          .filter()
          .chapterIdEqualTo(widget.chapter.id!)
          .findFirstSync()!
          .id!;
      isar.downloads.deleteSync(id);
    });
  }

  bool _isStarted = false;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 41,
      width: 35,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: StreamBuilder(
          stream: isar.downloads
              .filter()
              .idIsNotNull()
              .and()
              .chapterIdEqualTo(widget.chapter.id)
              .watch(fireImmediately: true),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final entries = snapshot.data!;
              return entries.first.isDownload!
                  ? PopupMenuButton(
                      child: Icon(
                        size: 25,
                        Icons.check_circle,
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(0.7),
                      ),
                      onSelected: (value) {
                        if (value.toString() == 'Delete') {
                          setState(() {
                            _isStarted = false;
                          });
                          _deleteFile(entries.first.taskIds!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Send', child: Text("Send")),
                        const PopupMenuItem(
                            value: 'Delete', child: Text('Delete')),
                      ],
                    )
                  : entries.first.isStartDownload! &&
                          entries.first.succeeded == 0
                      ? SizedBox(
                          height: 41,
                          width: 35,
                          child: PopupMenuButton(
                            child: _downloadWidget(context, true),
                            onSelected: (value) {
                              if (value.toString() == 'Cancel') {
                                _cancelTasks();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                  value: 'Cancel', child: Text("Cancel")),
                            ],
                          ))
                      : entries.first.succeeded != 0
                          ? SizedBox(
                              height: 41,
                              width: 35,
                              child: PopupMenuButton(
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: TweenAnimationBuilder<double>(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: (entries.first.succeeded! /
                                              entries.first.total!),
                                        ),
                                        builder: (context, value, _) =>
                                            SizedBox(
                                          height: 2,
                                          width: 2,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 19,
                                            value: value,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color!
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.arrow_downward_sharp,
                                          color: (entries.first.succeeded! /
                                                      entries.first.total!) >
                                                  0.5
                                              ? Theme.of(context)
                                                  .scaffoldBackgroundColor
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color!
                                                  .withOpacity(0.7),
                                        )),
                                  ],
                                ),
                                onSelected: (value) {
                                  if (value.toString() == 'Cancel') {
                                    _cancelTasks();
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'Cancel', child: Text("Cancel")),
                                ],
                              ))
                          : entries.first.succeeded == 0
                              ? IconButton(
                                  onPressed: () {
                                    // _startDownload();
                                    setState(() {
                                      _isStarted = true;
                                    });
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.circleDown,
                                    color: Theme.of(context)
                                        .iconTheme
                                        .color!
                                        .withOpacity(0.7),
                                    size: 25,
                                  ))
                              : SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: PopupMenuButton(
                                    child: const Icon(
                                      Icons.error_outline_outlined,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                    onSelected: (value) {
                                      if (value.toString() == 'Retry') {
                                        _cancelTasks();
                                        _startDownload();
                                        setState(() {
                                          _isStarted = true;
                                        });
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                          value: 'Retry', child: Text("Retry")),
                                    ],
                                  ));
            }
            return _isStarted
                ? SizedBox(
                    height: 50,
                    width: 50,
                    child: PopupMenuButton(
                      child: _downloadWidget(context, true),
                      onSelected: (value) {
                        if (value.toString() == 'Cancel') {
                          _cancelTasks();
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                            value: 'Cancel', child: Text("Cancel")),
                      ],
                    ))
                : IconButton(
                    splashRadius: 5,
                    iconSize: 17,
                    onPressed: () {
                      _startDownload();
                      setState(() {
                        _isStarted = true;
                      });
                    },
                    icon: _downloadWidget(context, false),
                  );
          },
        ),
      ),
    );
  }

  _cancelTasks() {
    setState(() {
      _isStarted = false;
    });

    FileDownloader().cancelTasksWithIds(_pageUrls).then((value) async {
      await Future.delayed(const Duration(seconds: 1));
      isar.writeTxnSync(() {
        int id = isar.downloads
            .filter()
            .chapterIdEqualTo(widget.chapter.id!)
            .findFirstSync()!
            .id!;

        isar.downloads.deleteSync(id);
      });
    });
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _downloadWidget(BuildContext context, bool isLoading) {
  return Stack(
    children: [
      Align(
          alignment: Alignment.center,
          child: Icon(
            size: 18,
            Icons.arrow_downward_sharp,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.7),
          )),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            value: isLoading ? null : 1,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.7),
            strokeWidth: 2,
          ),
        ),
      ),
    ],
  );
}
