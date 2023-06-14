import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends ConsumerWidget {
  final String lang;

  final GetManga? getMangaDetail;

  const MangaImageCardWidget({
    required this.lang,
    super.key,
    required this.getMangaDetail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: isar.mangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetail!.name)
            .sourceEqualTo(getMangaDetail!.source)
            .favoriteEqualTo(true)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          return CoverViewWidget(
              image: CachedNetworkImageProvider(
                getMangaDetail!.imageUrl!,
                headers:
                    ref.watch(headersProvider(source: getMangaDetail!.source!)),
              ),
              onTap: () {
                pushToMangaReaderDetail(
                    context: context, getManga: getMangaDetail!, lang: lang);
              },
              children: [
                Container(
                  color: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? Colors.black.withOpacity(0.7)
                      : null,
                ),
                if (snapshot.hasData && snapshot.data!.isNotEmpty)
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          decoration: BoxDecoration(
                              color: primaryColor(context),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              "In library",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ),
                        ),
                      )),
                BottomTextWidget(text: getMangaDetail!.name!)
              ]);
        });
  }
}

void pushToMangaReaderDetail(
    {GetManga? getManga,
    required String lang,
    required BuildContext context,
    int? archiveId,
    Manga? mangaM}) {
  int? mangaId;
  if (archiveId == null) {
    final manga = mangaM ??
        Manga(
            imageUrl: getManga!.imageUrl,
            name: getManga.name,
            genre: getManga.genre,
            author: getManga.author,
            status: getManga.status!,
            description: getManga.description,
            link: getManga.url,
            source: getManga.source,
            lang: lang,
            lastUpdate: DateTime.now().millisecondsSinceEpoch);

    final empty = isar.mangas
        .filter()
        .langEqualTo(lang)
        .nameEqualTo(manga.name)
        .sourceEqualTo(manga.source)
        .isEmptySync();
    if (empty) {
      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
        for (var i = 0; i < getManga!.chapters.length; i++) {
          final chapters = Chapter(
            name: getManga.chapters[i].name,
            url: getManga.chapters[i].url,
            dateUpload: getManga.chapters[i].dateUpload,
            scanlator: getManga.chapters[i].scanlator,
          )..manga.value = manga;
          isar.chapters.putSync(chapters);
          chapters.manga.saveSync();
        }
      });
    }

    mangaId = isar.mangas
        .filter()
        .langEqualTo(lang)
        .nameEqualTo(manga.name)
        .sourceEqualTo(manga.source)
        .findFirstSync()!
        .id!;
  } else {
    mangaId = archiveId;
  }

  final settings = isar.settings.getSync(227)!;
  final sortList = settings.sortChapterList ?? [];
  final checkIfExist =
      sortList.where((element) => element.mangaId == mangaId).toList();
  if (checkIfExist.isEmpty) {
    isar.writeTxnSync(
      () {
        List<SortChapter>? sortChapterList = [];
        for (var sortChapter in settings.sortChapterList ?? []) {
          sortChapterList.add(sortChapter);
        }
        List<ChapterFilterBookmarked>? chapterFilterBookmarkedList = [];
        for (var sortChapter in settings.chapterFilterBookmarkedList ?? []) {
          chapterFilterBookmarkedList.add(sortChapter);
        }
        List<ChapterFilterDownloaded>? chapterFilterDownloadedList = [];
        for (var sortChapter in settings.chapterFilterDownloadedList ?? []) {
          chapterFilterDownloadedList.add(sortChapter);
        }
        List<ChapterFilterUnread>? chapterFilterUnreadList = [];
        for (var sortChapter in settings.chapterFilterUnreadList ?? []) {
          chapterFilterUnreadList.add(sortChapter);
        }
        sortChapterList.add(SortChapter()..mangaId = mangaId);
        chapterFilterBookmarkedList
            .add(ChapterFilterBookmarked()..mangaId = mangaId);
        chapterFilterDownloadedList
            .add(ChapterFilterDownloaded()..mangaId = mangaId);
        chapterFilterUnreadList.add(ChapterFilterUnread()..mangaId = mangaId);
        isar.settings.putSync(settings
          ..sortChapterList = sortChapterList
          ..chapterFilterBookmarkedList = chapterFilterBookmarkedList
          ..chapterFilterDownloadedList = chapterFilterDownloadedList
          ..chapterFilterUnreadList = chapterFilterUnreadList);
      },
    );
  }

  context.push('/manga-reader/detail', extra: mangaId);
}
