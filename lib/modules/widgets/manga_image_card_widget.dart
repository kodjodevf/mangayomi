import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/manga/detail/manga_detail_main.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/modules/widgets/bottom_text_widget.dart';
import 'package:mangayomi/modules/widgets/cover_view_widget.dart';

class MangaImageCardWidget extends ConsumerWidget {
  final Source source;
  final ItemType itemType;
  final bool isComfortableGrid;
  final MManga? getMangaDetail;
  final Manga? libraryManga;

  const MangaImageCardWidget({
    required this.source,
    super.key,
    required this.getMangaDetail,
    required this.isComfortableGrid,
    required this.itemType,
    this.libraryManga,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasData = libraryManga != null;
    return CoverViewWidget(
      bottomTextWidget: BottomTextWidget(
        maxLines: 1,
        text: getMangaDetail!.name!,
        isComfortableGrid: isComfortableGrid,
      ),
      isComfortableGrid: isComfortableGrid,
      image: hasData && libraryManga!.customCoverImage != null
          ? MemoryImage(libraryManga!.customCoverImage as Uint8List)
                as ImageProvider
          : CustomExtendedNetworkImageProvider(
              toImgUrl(
                hasData
                    ? libraryManga!.customCoverFromTracker ??
                          libraryManga!.imageUrl ??
                          ""
                    : getMangaDetail!.imageUrl ?? "",
              ),
              headers: ref.watch(
                headersProvider(
                  source: source.name!,
                  lang: source.lang!,
                  sourceId: source.id,
                ),
              ),
              cache: true,
              cacheMaxAge: const Duration(days: 7),
            ),
      onTap: () => pushToMangaReaderDetail(
        ref: ref,
        context: context,
        getManga: getMangaDetail!,
        lang: source.lang!,
        source: source.name!,
        itemType: itemType,
        sourceId: source.id,
      ),
      onLongPress: () => pushToMangaReaderDetail(
        ref: ref,
        context: context,
        getManga: getMangaDetail!,
        lang: source.lang!,
        source: source.name!,
        itemType: itemType,
        addToFavourite: true,
        sourceId: source.id,
      ),
      onSecondaryTap: () => pushToMangaReaderDetail(
        ref: ref,
        context: context,
        getManga: getMangaDetail!,
        lang: source.lang!,
        source: source.name!,
        itemType: itemType,
        addToFavourite: true,
        sourceId: source.id,
      ),
      children: [
        Container(
          color: hasData && libraryManga!.favorite!
              ? Colors.black.withValues(alpha: 0.5)
              : null,
        ),
        if (hasData && libraryManga!.favorite!)
          Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.collections_bookmark_outlined,
                    size: 16,
                    color: context.dynamicWhiteBlackColor,
                  ),
                ),
              ),
            ),
          ),
        if (!isComfortableGrid)
          BottomTextWidget(
            isTorrent: source.isTorrent,
            text: getMangaDetail!.name!,
          ),
      ],
    );
  }
}

class MangaImageCardListTileWidget extends ConsumerWidget {
  final Source source;
  final ItemType itemType;
  final MManga? getMangaDetail;
  final Manga? libraryManga;

  const MangaImageCardListTileWidget({
    required this.source,
    super.key,
    required this.itemType,
    required this.getMangaDetail,
    this.libraryManga,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasData = libraryManga != null;
    final image = hasData && libraryManga!.customCoverImage != null
        ? MemoryImage(libraryManga!.customCoverImage as Uint8List)
              as ImageProvider
        : CustomExtendedNetworkImageProvider(
            toImgUrl(
              hasData
                  ? libraryManga!.customCoverFromTracker ??
                        libraryManga!.imageUrl ??
                        ""
                  : getMangaDetail!.imageUrl ?? "",
            ),
            headers: ref.watch(
              headersProvider(
                source: source.name!,
                lang: source.lang!,
                sourceId: source.id,
              ),
            ),
          );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => pushToMangaReaderDetail(
            ref: ref,
            context: context,
            getManga: getMangaDetail!,
            lang: source.lang!,
            source: source.name!,
            itemType: itemType,
            sourceId: source.id,
          ),
          onLongPress: () => pushToMangaReaderDetail(
            ref: ref,
            context: context,
            getManga: getMangaDetail!,
            lang: source.lang!,
            source: source.name!,
            itemType: itemType,
            addToFavourite: true,
            sourceId: source.id,
          ),
          onSecondaryTap: () => pushToMangaReaderDetail(
            ref: ref,
            context: context,
            getManga: getMangaDetail!,
            lang: source.lang!,
            source: source.name!,
            itemType: itemType,
            addToFavourite: true,
            sourceId: source.id,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      child: Image(
                        height: 55,
                        width: 40,
                        fit: BoxFit.cover,
                        image: image,
                      ),
                    ),
                    Container(
                      height: 55,
                      width: 40,
                      color: hasData && libraryManga!.favorite!
                          ? Colors.black.withValues(alpha: 0.5)
                          : null,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  getMangaDetail!.name!,
                  maxLines: 2,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: context.textColor,
                  ),
                ),
              ),
              if (hasData && libraryManga!.favorite!)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.collections_bookmark_outlined,
                        size: 16,
                        color: context.dynamicWhiteBlackColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> pushToMangaReaderDetail({
  MManga? getManga,
  required WidgetRef ref,
  required String lang,
  required BuildContext context,
  required String source,
  required int? sourceId,
  int? archiveId,
  Manga? mangaM,
  ItemType? itemType,
  bool useMaterialRoute = false,
  bool addToFavourite = false,
}) async {
  int? mangaId =
      (await isar.mangas
              .filter()
              .isLocalArchiveEqualTo(true)
              .sourceEqualTo("local")
              .nameEqualTo(getManga?.name)
              .findFirst())
          ?.id;

  if (mangaId == null) {
    if (archiveId == null) {
      final manga =
          mangaM ??
          Manga(
            imageUrl: getManga!.imageUrl,
            name: getManga.name!.trim(),
            genre: getManga.genre?.map((e) => e.toString()).toList() ?? [],
            author: getManga.author ?? "",
            status: getManga.status ?? Status.unknown,
            description: getManga.description ?? "",
            link: getManga.link,
            source: source,
            lang: lang,
            lastUpdate: 0,
            itemType: itemType ?? ItemType.manga,
            artist: getManga.artist ?? '',
            sourceId: sourceId,
          );
      final empty = await isar.mangas
          .filter()
          .langEqualTo(lang)
          .nameEqualTo(manga.name)
          .sourceEqualTo(manga.source)
          .isEmpty();
      if (empty) {
        await isar.writeTxn(() async {
          await isar.mangas.put(
            manga..updatedAt = DateTime.now().millisecondsSinceEpoch,
          );
        });
      }

      final foundMangas = await isar.mangas
          .filter()
          .langEqualTo(lang)
          .nameEqualTo(manga.name)
          .sourceEqualTo(manga.source)
          .findAll();
      Manga? matchedManga;
      for (final foundManga in foundMangas) {
        if (foundManga.sourceId == null || foundManga.sourceId == sourceId) {
          matchedManga = foundManga;
          break;
        }
      }
      if (matchedManga == null) {
        await isar.writeTxn(() async {
          await isar.mangas.put(
            manga..updatedAt = DateTime.now().millisecondsSinceEpoch,
          );
        });
        matchedManga = manga;
      }
      mangaId = matchedManga.id!;
    } else {
      mangaId = archiveId;
    }
  }

  final mang = await isar.mangas.get(mangaId);
  if (mang!.sourceId == null && !(mang.isLocalArchive ?? false)) {
    await isar.writeTxn(() async {
      await isar.mangas.put(mang..sourceId = sourceId);
    });
  }
  final settings = await isar.settings.get(227);
  final exists =
      settings!.sortChapterList?.any((e) => e.mangaId == mangaId) ?? false;
  if (!exists) {
    await isar.writeTxn(() async {
      settings
        ..sortChapterList = [
          ...(settings.sortChapterList ?? []),
          SortChapter()..mangaId = mangaId,
        ]
        ..chapterFilterBookmarkedList = [
          ...(settings.chapterFilterBookmarkedList ?? []),
          ChapterFilterBookmarked()..mangaId = mangaId,
        ]
        ..chapterFilterDownloadedList = [
          ...(settings.chapterFilterDownloadedList ?? []),
          ChapterFilterDownloaded()..mangaId = mangaId,
        ]
        ..chapterFilterUnreadList = [
          ...(settings.chapterFilterUnreadList ?? []),
          ChapterFilterUnread()..mangaId = mangaId,
        ]
        ..updatedAt = DateTime.now().millisecondsSinceEpoch;

      await isar.settings.put(settings);
    });
  }
  if (!addToFavourite) {
    if (context.mounted) {
      if (useMaterialRoute) {
        await Navigator.push(
          context,
          createRoute(page: MangaReaderDetail(mangaId: mangaId)),
        );
      } else {
        await context.push('/manga-reader/detail', extra: mangaId);
      }
    }
  } else {
    final getManga = await isar.mangas.get(mangaId);
    await isar.writeTxn(() async {
      await isar.mangas.put(
        getManga!
          ..favorite = !getManga.favorite!
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
  }
}
