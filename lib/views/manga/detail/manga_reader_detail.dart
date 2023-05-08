import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/views/manga/detail/manga_details_view.dart';
import 'package:mangayomi/views/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/views/widgets/error_text.dart';
import 'package:mangayomi/views/widgets/progress_center.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int mangaId;
  const MangaReaderDetail({super.key, required this.mangaId});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manga =
        ref.watch(getMangaDetailStreamProvider(mangaId: widget.mangaId));
    return Scaffold(
        body: manga.when(
      data: (modelManga) {
        return RefreshIndicator(
          onRefresh: () async {
            bool isOk = false;
            ref
                .watch(getMangaDetailProvider(
                        imageUrl: modelManga.imageUrl!,
                        lang: modelManga.lang!,
                        title: modelManga.name!,
                        source: modelManga.source!,
                        url: modelManga.link!)
                    .future)
                .then((value) async {
              if (value.chapters.isNotEmpty &&
                  value.chapters.length > modelManga.chapters.length) {
                await isar.writeTxn(() async {
                  int newChapsIndex =
                      value.chapters.length - modelManga.chapters.length;
                  modelManga.lastUpdate = DateTime.now().millisecondsSinceEpoch;
                  for (var i = 0; i < newChapsIndex; i++) {
                    final chapters = Chapter(
                        name: value.chapters[i].name,
                        url: value.chapters[i].url,
                        dateUpload: value.chapters[i].dateUpload,
                        isBookmarked: false,
                        scanlator: value.chapters[i].scanlator,
                        isRead: false,
                        lastPageRead: '',
                        mangaId: modelManga.id)
                      ..manga.value = modelManga;
                    await isar.chapters.put(chapters);
                    await chapters.manga.save();
                  }
                });
              }
              if (mounted) {
                setState(() {
                  isOk = true;
                });
              }
            });
            await Future.doWhile(() async {
              await Future.delayed(const Duration(seconds: 1));
              if (isOk == true) {
                return false;
              }
              return true;
            });
          },
          child: MangaDetailsView(
            manga: modelManga!,
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        return ErrorText(error);
      },
      loading: () {
        return const ProgressCenter();
      },
    ));
  }
}
