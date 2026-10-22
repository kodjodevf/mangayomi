import 'dart:isolate';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/history.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/backup_format.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupAniyomi.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupMihon.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore_invalidation.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/download_repository.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/restore_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:mangayomi/repositories/track_repository.dart';
import 'package:mangayomi/repositories/update_repository.dart';
import 'package:protobuf/protobuf.dart';

/// Service responsible for restoring protobuf backups from Mihon, Aniyomi, and Neko.
class TachiyomiRestoreService {
  const TachiyomiRestoreService._();

  static Future<void> restore(
    Ref ref,
    String path,
    BackupType bkType, {
    bool merge = false,
    Map<String, bool> categoryDecisions = const {},
    Map<String, int> sourceDecisions = const {},
  }) async {
    final content = await Isolate.run(() {
      final inputStream = InputFileStream(path);
      try {
        return GZipDecoder().decodeBytes(inputStream.toUint8List());
      } finally {
        inputStream.close();
      }
    });
    final backup = BackupMihon.create();
    backup.mergeFromCodedBufferReader(
      CodedBufferReader(content, sizeLimit: 250 << 20),
    );

    final installedSources = sourceRepository
        .getAll()
        .where((s) => s.isAdded ?? false)
        .toList();

    Source? resolveSource(String originalName, ItemType itemType) {
      final decision = sourceDecisions[originalName];
      if (decision != null) return sourceRepository.getById(decision);
      return installedSources.firstWhereOrNull(
        (s) =>
            s.itemType == itemType &&
            s.name?.toLowerCase() == originalName.toLowerCase(),
      );
    }

    final categoryByOrder = <int, Category>{};
    await restoreRepository.run(() {
      if (!merge) {
        categoryRepository.clearSync();
        mangaRepository.clearSync();
        chapterRepository.clearSync();
        historyRepository.clearSync();
      }
      final existingCategories = merge
          ? categoryRepository.getByItemType(ItemType.manga)
          : <Category>[];
      for (var category in backup.backupCategories) {
        final order = protoInt(category.order);
        final existing = existingCategories.firstWhereOrNull(
          (c) => c.name == category.name,
        );
        if (existing != null) {
          if (categoryDecisions[category.name] == false) continue;
          categoryByOrder[order] = existing;
          continue;
        }
        final cat = Category(
          name: category.name,
          forItemType: ItemType.manga,
          pos: order,
        );
        categoryRepository.putSync(cat);
        categoryByOrder[order] = cat;
      }
      final existingMangaByLink = merge
          ? {
              for (var m in mangaRepository.getByItemType(ItemType.manga))
                if (m.link != null) m.link!: m,
            }
          : <String, Manga>{};
      for (var tempManga in backup.backupManga) {
        final sourceId = protoInt(tempManga.source);
        final categoryOrders = tempManga.categories.map(protoInt).toSet();
        final newCategoryIds = categoryOrders
            .map((o) => categoryByOrder[o]?.id)
            .whereType<int>()
            .toList();
        final existingManga = existingMangaByLink[tempManga.url];
        final Manga manga;
        final bool isNewManga = existingManga == null;
        if (existingManga != null) {
          manga = existingManga;
          manga.favorite = true;
          manga.categories = {...?manga.categories, ...newCategoryIds}.toList();
        } else {
          final originalSourceName =
              backup.backupSources
                  .firstWhereOrNull((src) => protoInt(src.sourceId) == sourceId)
                  ?.name ??
              "Unknown";
          final boundSource = resolveSource(originalSourceName, ItemType.manga);
          manga = Manga(
            source: boundSource?.name ?? originalSourceName,
            author: tempManga.author,
            artist: tempManga.artist,
            genre: tempManga.genre,
            imageUrl: tempManga.thumbnailUrl,
            lang: boundSource?.lang ?? 'en',
            link: tempManga.url,
            name: tempManga.title,
            status: convertStatusFromTachiBk(tempManga.status),
            description: tempManga.description,
            categories: newCategoryIds,
            itemType: ItemType.manga,
            favorite: true,
            dateAdded: protoInt(tempManga.dateAdded),
            lastUpdate: protoInt(tempManga.lastModifiedAt),
            sourceId: boundSource?.id,
          );
          if (bkType == BackupType.neko && boundSource == null) {
            manga.source = "MangaDex";
          }
        }
        mangaRepository.putSync(manga);
        final existingChaptersByUrl = merge && !isNewManga
            ? {
                for (var c in chapterRepository.getAllByMangaId(manga.id))
                  if (c.url != null) c.url!: c,
              }
            : <String, Chapter>{};
        History? history;
        for (var tempChapter in tempManga.chapters) {
          if (existingChaptersByUrl.containsKey(tempChapter.url)) continue;
          final chapter = Chapter(
            mangaId: manga.id!,
            name: tempChapter.name,
            dateUpload: bkType != BackupType.neko
                ? "${protoInt(tempChapter.dateUpload)}"
                : "${DateTime.now().millisecondsSinceEpoch - protoInt(tempChapter.dateUpload).abs()}",
            isBookmarked: tempChapter.bookmark,
            isRead: tempChapter.read,
            lastPageRead: protoInt(tempChapter.lastPageRead) != 0
                ? "${protoInt(tempChapter.lastPageRead)}"
                : "1",
            scanlator: tempChapter.scanlator,
            url: tempChapter.url,
          );
          chapterRepository.putSync(chapter..manga.value = manga);
          chapter.manga.saveSync();
          if ((history == null ||
              int.parse(history.date ?? "0") <
                  protoInt(tempChapter.lastModifiedAt))) {
            history = History(
              mangaId: manga.id,
              date: bkType != BackupType.neko
                  ? "${protoInt(tempChapter.lastModifiedAt)}"
                  : "${DateTime.now().millisecondsSinceEpoch - protoInt(tempChapter.dateUpload).abs()}",
              itemType: ItemType.manga,
              chapterId: chapter.id,
            )..chapter.value = chapter;
          }
        }
        if (history != null &&
            (!merge ||
                historyRepository.findFirstByMangaId(manga.id) == null)) {
          historyRepository.putSync(history);
          history.chapter.saveSync();
        }
      }
    });

    if (bkType == BackupType.aniyomi) {
      final backupAnime = BackupAniyomi.fromBuffer(content);
      final animeCategories = backupAnime.backupAnimeCategories.isNotEmpty
          ? backupAnime.backupAnimeCategories
          : backupAnime.legacyBackupAnimeCategories;
      final animeEntries = backupAnime.backupAnime.isNotEmpty
          ? backupAnime.backupAnime
          : backupAnime.legacyBackupAnime;
      final animeSources = backupAnime.backupAnimeSources.isNotEmpty
          ? backupAnime.backupAnimeSources
          : backupAnime.legacyBackupAnimeSources;
      final categoryByOrder = <int, Category>{};
      await restoreRepository.run(() {
        final existingAnimeCategories = merge
            ? categoryRepository.getByItemType(ItemType.anime)
            : <Category>[];
        for (var category in animeCategories) {
          final order = protoInt(category.order);
          final existing = existingAnimeCategories.firstWhereOrNull(
            (c) => c.name == category.name,
          );
          if (existing != null) {
            if (categoryDecisions[category.name] == false) continue;
            categoryByOrder[order] = existing;
            continue;
          }
          final cat = Category(
            name: category.name,
            forItemType: ItemType.anime,
            pos: order,
          );
          categoryRepository.putSync(cat);
          categoryByOrder[order] = cat;
        }
        final existingAnimeByLink = merge
            ? {
                for (var m in mangaRepository.getByItemType(ItemType.anime))
                  if (m.link != null) m.link!: m,
              }
            : <String, Manga>{};
        for (var tempAnime in animeEntries) {
          final sourceId = protoInt(tempAnime.source);
          final categoryOrders = tempAnime.categories.map(protoInt).toSet();
          final newCategoryIds = categoryOrders
              .map((o) => categoryByOrder[o]?.id)
              .whereType<int>()
              .toList();
          final existingAnime = existingAnimeByLink[tempAnime.url];
          final Manga anime;
          final bool isNewAnime = existingAnime == null;
          if (existingAnime != null) {
            anime = existingAnime;
            anime.favorite = true;
            anime.categories = {
              ...?anime.categories,
              ...newCategoryIds,
            }.toList();
          } else {
            final originalSourceName =
                animeSources
                    .firstWhereOrNull(
                      (src) => protoInt(src.sourceId) == sourceId,
                    )
                    ?.name ??
                "Unknown";
            final boundSource = resolveSource(
              originalSourceName,
              ItemType.anime,
            );
            anime = Manga(
              source: boundSource?.name ?? originalSourceName,
              author: tempAnime.author,
              artist: tempAnime.artist,
              genre: tempAnime.genre,
              imageUrl: tempAnime.thumbnailUrl,
              lang: boundSource?.lang ?? 'en',
              link: tempAnime.url,
              name: tempAnime.title,
              status: convertStatusFromTachiBk(tempAnime.status),
              description: tempAnime.description,
              categories: newCategoryIds,
              itemType: ItemType.anime,
              favorite: true,
              dateAdded: protoInt(tempAnime.dateAdded),
              lastUpdate: protoInt(tempAnime.lastModifiedAt),
              sourceId: boundSource?.id,
            );
          }
          mangaRepository.putSync(anime);
          final existingEpisodesByUrl = merge && !isNewAnime
              ? {
                  for (var c in chapterRepository.getAllByMangaId(anime.id))
                    if (c.url != null) c.url!: c,
                }
              : <String, Chapter>{};
          History? history;
          for (var tempEpisode in tempAnime.episodes) {
            if (existingEpisodesByUrl.containsKey(tempEpisode.url)) continue;
            final episode = Chapter(
              mangaId: anime.id!,
              name: tempEpisode.name,
              dateUpload: "${protoInt(tempEpisode.dateUpload)}",
              isBookmarked: tempEpisode.bookmark,
              isRead: tempEpisode.seen,
              lastPageRead: protoInt(tempEpisode.lastSecondSeen) != 0
                  ? "${secondsToMillis(tempEpisode.lastSecondSeen)}"
                  : "1",
              scanlator: tempEpisode.scanlator,
              url: tempEpisode.url,
            );
            chapterRepository.putSync(episode..manga.value = anime);
            episode.manga.saveSync();
            if ((history == null ||
                int.parse(history.date ?? "0") <
                    protoInt(tempEpisode.lastModifiedAt))) {
              history = History(
                mangaId: anime.id,
                date: "${protoInt(tempEpisode.lastModifiedAt)}",
                itemType: ItemType.anime,
                chapterId: episode.id,
              )..chapter.value = episode;
            }
          }
          if (history != null &&
              (!merge ||
                  historyRepository.findFirstByMangaId(anime.id) == null)) {
            historyRepository.putSync(history);
            history.chapter.saveSync();
          }
        }
      });
    }

    await restoreRepository.run(() {
      if (!merge) {
        downloadRepository.clearSync();
        updateRepository.clearSync();
        trackRepository.clearSync();
        trackRepository.clearPreferencesSync();
      }
    });
    invalidateCommonRestoreState(ref);
  }
}
