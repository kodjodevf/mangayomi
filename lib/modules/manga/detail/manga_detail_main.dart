import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/modules/manga/detail/manga_details_view.dart';
import 'package:mangayomi/modules/manga/detail/providers/isar_providers.dart';
import 'package:mangayomi/modules/widgets/error_text.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';

class MangaReaderDetail extends ConsumerStatefulWidget {
  final int mangaId;
  const MangaReaderDetail({super.key, required this.mangaId});

  @override
  ConsumerState<MangaReaderDetail> createState() => _MangaReaderDetailState();
}

class _MangaReaderDetailState extends ConsumerState<MangaReaderDetail> {
  @override
  Widget build(BuildContext context) {
    final manga =
        ref.watch(getMangaDetailStreamProvider(mangaId: widget.mangaId));
    return Scaffold(
        body: manga.when(
      data: (manga) {
        return RefreshIndicator(
          onRefresh: () async {
            final mangaS = GetManga(
                genre: manga.genre!,
                author: manga.author,
                status: manga.status,
                chapters: manga.chapters.toList(),
                imageUrl: manga.imageUrl,
                description: manga.description,
                url: manga.link,
                name: manga.name,
                source: manga.source);
            bool isOk = false;
            ref
                .watch(getMangaDetailProvider(
              manga: mangaS,
              lang: manga.lang!,
              source: manga.source!,
            ).future)
                .then((value) async {
              if (value.chapters.isNotEmpty &&
                  value.chapters.length > manga.chapters.length) {
                await isar.writeTxn(() async {
                  int newChapsIndex =
                      value.chapters.length - manga.chapters.length;
                  manga.lastUpdate = DateTime.now().millisecondsSinceEpoch;
                  for (var i = 0; i < newChapsIndex; i++) {
                    final chapters = Chapter(
                        name: value.chapters[i].name,
                        url: value.chapters[i].url,
                        dateUpload: value.chapters[i].dateUpload,
                        isBookmarked: false,
                        scanlator: value.chapters[i].scanlator,
                        isRead: false,
                        lastPageRead: '',
                        mangaId: manga.id)
                      ..manga.value = manga;
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
            manga: manga!,
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
