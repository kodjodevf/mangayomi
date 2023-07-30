import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends ConsumerWidget {
  final String lang;
  final bool isManga;

  final MangaModel? getMangaDetail;

  const MangaImageCardWidget(
      {required this.lang,
      super.key,
      required this.getMangaDetail,
      required this.isManga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context);
    return StreamBuilder(
        stream: isar.mangas
            .filter()
            .langEqualTo(lang)
            .nameEqualTo(getMangaDetail!.name)
            .sourceEqualTo(getMangaDetail!.source)
            .watch(fireImmediately: true),
        builder: (context, snapshot) {
          return CoverViewWidget(
              image: snapshot.hasData &&
                      snapshot.data!.isNotEmpty &&
                      snapshot.data!.first.customCoverImage != null
                  ? MemoryImage(
                          snapshot.data!.first.customCoverImage as Uint8List)
                      as ImageProvider
                  : CachedNetworkImageProvider(
                      snapshot.hasData &&
                              snapshot.data!.isNotEmpty &&
                              snapshot.data!.first.imageUrl != null
                          ? snapshot.data!.first.imageUrl!
                          : getMangaDetail!.imageUrl!,
                      headers: ref.watch(headersProvider(
                          source: getMangaDetail!.source!,
                          lang: getMangaDetail!.lang!)),
                    ),
              onTap: () {
                pushToMangaReaderDetail(
                    context: context,
                    getManga: getMangaDetail!,
                    lang: lang,
                    isManga: isManga);
              },
              children: [
                Container(
                  color: snapshot.hasData &&
                          snapshot.data!.isNotEmpty &&
                          snapshot.data!.first.favorite
                      ? Colors.black.withOpacity(0.7)
                      : null,
                ),
                if (snapshot.hasData &&
                    snapshot.data!.isNotEmpty &&
                    snapshot.data!.first.favorite)
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
                              l10n!.in_library,
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
    {MangaModel? getManga,
    required String lang,
    required BuildContext context,
    int? archiveId,
    Manga? mangaM,
    bool? isManga}) {
  int? mangaId;
  if (archiveId == null) {
    final manga = mangaM ??
        Manga(
            imageUrl: getManga!.imageUrl,
            name: getManga.name!.trim().trimLeft().trimRight(),
            genre: getManga.genre == null
                ? []
                : getManga.genre!.map((e) => e.toString()).toList(),
            author: getManga.author ?? "",
            status: getManga.status == null
                ? Status.unknown
                : switch (getManga.status) {
                    0 => Status.ongoing,
                    1 => Status.completed,
                    2 => Status.onHiatus,
                    3 => Status.canceled,
                    4 => Status.publishingFinished,
                    _ => Status.unknown,
                  },
            description: getManga.description ?? "",
            link: getManga.link,
            source: getManga.source,
            lang: lang,
            lastUpdate: 0,
            isManga: isManga ?? true);
    final empty = isar.mangas
        .filter()
        .langEqualTo(lang)
        .nameEqualTo(manga.name)
        .sourceEqualTo(manga.source)
        .isEmptySync();
    if (empty) {
      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
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
