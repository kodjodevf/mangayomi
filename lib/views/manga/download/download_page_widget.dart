// ignore_for_file: implementation_imports, depend_on_referenced_packages
import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_chapter_url.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/views/manga/download/download_model.dart';
import 'package:mangayomi/views/manga/download/providers/download_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'download_page_widget.g.dart';

@riverpod
class ChapterPageDownloads extends _$ChapterPageDownloads {
  @override
  Widget build({required ModelManga modelManga, required int index}) {
    return ChapterPageDownload(
      index: index,
      modelManga: modelManga,
    );
  }

  // ...
}

class ChapterPageDownload extends ConsumerStatefulWidget {
  final ModelManga modelManga;
  final int index;
  const ChapterPageDownload(
      {super.key, required this.modelManga, required this.index});

  @override
  ConsumerState createState() => _ChapterPageDownloadState();
}

class _ChapterPageDownloadState extends ConsumerState<ChapterPageDownload>
    with AutomaticKeepAliveClientMixin<ChapterPageDownload> {
  List _urll = [];

  final StorageProvider _storageProvider = StorageProvider();
  _startDownload() async {
    final data = await ref.watch(downloadChapterProvider(
            modelManga: widget.modelManga, index: widget.index)
        .future);
    if (mounted) {
      setState(() {
        _urll = data;
      });
    }
  }

  _deleteFile(List pageUrl) async {
    final path = await _storageProvider.getMangaChapterDirectory(
        widget.modelManga, widget.index);

    try {
      path!.deleteSync(recursive: true);
      ref.watch(hiveBoxMangaDownloads).delete(
            widget.modelManga.chapters![widget.index].name!,
          );
    } catch (e) {
      ref.watch(hiveBoxMangaDownloads).delete(
            widget.modelManga.chapters![widget.index].name!,
          );
    }
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
        child: ValueListenableBuilder<Box<DownloadModel>>(
          valueListenable: ref.watch(hiveBoxMangaDownloads).listenable(),
          builder: (context, val, child) {
            final entries = val.values
                .where((element) =>
                    element.modelManga.chapters![element.index].name ==
                    widget.modelManga.chapters![widget.index].name)
                .toList();

            if (entries.isNotEmpty) {
              return entries.first.isDownload
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
                          _deleteFile(entries.first.taskIds);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Send', child: Text("Send")),
                        const PopupMenuItem(
                            value: 'Delete', child: Text('Delete')),
                      ],
                    )
                  : entries.first.isStartDownload &&
                          entries.first.succeeded == 0
                      ? SizedBox(
                          height: 41,
                          width: 35,
                          child: PopupMenuButton(
                            child: _downloadWidget(context, true),
                            onSelected: (value) {
                              if (value.toString() == 'Cancel') {
                                setState(() {
                                  _isStarted = false;
                                });
                                List<String> taskIds = [];
                                for (var id in entries.first.taskIds) {
                                  taskIds.add(id);
                                }
                                FileDownloader()
                                    .cancelTasksWithIds(taskIds)
                                    .then((value) async {
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  ref.watch(hiveBoxMangaDownloads).delete(
                                        widget.modelManga
                                            .chapters![widget.index].name,
                                      );
                                });
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
                                        child: Icon(
                                          Icons.arrow_downward_sharp,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color!
                                              .withOpacity(0.7),
                                        )),
                                    Align(
                                      alignment: Alignment.center,
                                      child: TweenAnimationBuilder<double>(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        curve: Curves.easeInOut,
                                        tween: Tween<double>(
                                          begin: 0,
                                          end: (entries.first.succeeded /
                                              entries.first.total),
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
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        )),
                                  ],
                                ),
                                onSelected: (value) {
                                  if (value.toString() == 'Cancel') {
                                    setState(() {
                                      _isStarted = false;
                                    });
                                    List<String> taskIds = [];
                                    for (var id in entries.first.taskIds) {
                                      taskIds.add(id);
                                    }
                                    FileDownloader()
                                        .cancelTasksWithIds(taskIds)
                                        .then((value) async {
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      ref.watch(hiveBoxMangaDownloads).delete(
                                            widget.modelManga
                                                .chapters![widget.index].name,
                                          );
                                    });
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
                                        ref.watch(hiveBoxMangaDownloads).delete(
                                              widget.modelManga
                                                  .chapters![widget.index].name,
                                            );
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
                          setState(() {
                            _isStarted = false;
                          });
                          List<String> taskIds = [];
                          for (var id in _urll) {
                            taskIds.add(id);
                          }
                          FileDownloader()
                              .cancelTasksWithIds(taskIds)
                              .then((value) async {
                            await Future.delayed(const Duration(seconds: 1));
                            ref.watch(hiveBoxMangaDownloads).delete(
                                  widget
                                      .modelManga.chapters![widget.index].name!,
                                );
                          });
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
