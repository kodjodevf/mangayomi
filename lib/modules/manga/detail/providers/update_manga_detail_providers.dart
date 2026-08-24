import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/fetch_interval.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(
  Ref ref, {
  required int? mangaId,
  required bool isInit,
  bool showToast = true,
}) async {
  try {
    final manga = isar.mangas.getSync(mangaId!);
    if (manga == null) return;

    manga.chapters.loadSync();

    if ((manga.isLocalArchive ?? false) ||
        (manga.chapters.isNotEmpty && isInit)) {
      return;
    }
    final source = getSource(
      manga.lang!,
      manga.source!,
      manga.sourceId,
      installedOnly: true,
    );
    if (source == null) return;

    final getManga = await ref.read(
      getDetailProvider(url: manga.link!, source: source).future,
    );

    final genre =
        getManga.genre
            ?.map((e) => e.toString().trim())
            .toList()
            .toSet()
            .toList() ??
        [];

    final imgUrl = getManga.imageUrl.trimmedOrDefault(manga.imageUrl);
    final now = DateTime.now().millisecondsSinceEpoch;

    manga
      ..imageUrl = imgUrl == null
          ? null
          : imgUrl.startsWith('http')
          ? imgUrl
          : '${source.baseUrl ?? ''}/${imgUrl.getUrlWithoutDomain}'
      ..name = getManga.name.trimmedOrDefault(manga.name)
      ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
      ..author = getManga.author.trimmedOrDefault(manga.author) ?? ""
      ..artist = getManga.artist.trimmedOrDefault(manga.artist) ?? ""
      ..status = getManga.status == Status.unknown
          ? manga.status
          : getManga.status ?? Status.unknown
      ..description =
          getManga.description.trimmedOrDefault(manga.description) ?? ""
      ..link = getManga.link.trimmedOrDefault(manga.link)
      ..source = manga.source
      ..lang = manga.lang
      ..itemType = source.itemType
      ..lastUpdate = now
      ..updatedAt = now;

    final chaps = getManga.chapters;

    await isar.writeTxn(() async {
      final savedMangaId = await isar.mangas.put(manga);

      if (chaps == null || chaps.isEmpty) return;

      final existingChapters = manga.chapters.toList();
      final recognition = ChapterRecognition();

      // The exact number, not the sort key. parseChapterNumber truncates, so
      // chapters 12, 12.1 and 12.5 all answer 12 and every use of this below
      // treats them as the same chapter: the composite key drops two of the
      // three before they reach the library, and read state carries across
      // all three. rawSeasonAndNumber keeps the fraction, and answers null
      // for a name with no number at all rather than folding every "Special"
      // and "Prologue" onto zero.
      double? numberOf(Chapter c) {
        if (c.name == null) return null;
        final (_, number) = recognition.rawSeasonAndNumber(
          manga.name ?? '',
          c.name!,
        );
        return (number ?? 0) > 0 ? number : null;
      }

      final existingByUrl = <String, Chapter>{};
      final existingByComposite = <String, Chapter>{};
      final duplicateIds = <int>{};
      for (final c in existingChapters) {
        final u = c.url?.trim();
        final urlKey = (u == null || u.isEmpty) ? null : u.getUrlWithoutDomain;
        final num = numberOf(c);
        final compositeKey = num == null ? null : '$num::${c.scanlator ?? ''}';

        final prior =
            (urlKey != null ? existingByUrl[urlKey] : null) ??
            (compositeKey != null ? existingByComposite[compositeKey] : null);
        if (prior == null) {
          if (urlKey != null) existingByUrl[urlKey] = c;
          if (compositeKey != null) existingByComposite[compositeKey] = c;
        } else {
          final priorHasState =
              (prior.isRead ?? false) || (prior.lastPageRead ?? '').isNotEmpty;
          final keep = priorHasState ? prior : c;
          final drop = identical(keep, prior) ? c : prior;
          if (urlKey != null) existingByUrl[urlKey] = keep;
          if (compositeKey != null) existingByComposite[compositeKey] = keep;
          if (drop.id != null) duplicateIds.add(drop.id!);
        }
      }

      final readByNumber = <double, bool>{};
      for (final c in existingChapters) {
        final num = numberOf(c);
        if (num != null) {
          readByNumber[num] =
              (readByNumber[num] ?? false) || (c.isRead ?? false);
        }
      }

      final newChapters = <Chapter>[];
      final seenKeys = <String>{};
      final chaptersToUpdate = <Chapter>[];

      for (final chap in chaps) {
        final url = chap.url?.trim();
        if (url == null || url.isEmpty) continue;
        final key = url.getUrlWithoutDomain;

        final (_, chapNumber) = chap.name != null
            ? recognition.rawSeasonAndNumber(manga.name!, chap.name!)
            : (0, null);
        final chapNum = chapNumber ?? 0;
        final compositeKey = chapNum > 0
            ? '$chapNum::${chap.scanlator ?? ''}'
            : null;

        if (!seenKeys.add(key)) continue;
        if (compositeKey != null && !seenKeys.add('c:$compositeKey')) {
          continue;
        }

        final existing =
            existingByUrl[key] ??
            (compositeKey != null ? existingByComposite[compositeKey] : null);

        if (existing == null) {
          final alreadyRead = chapNum > 0 && (readByNumber[chapNum] ?? false);

          final newChapter = Chapter(
            name: chap.name!,
            url: url,
            dateUpload: chap.dateUpload == null
                ? now.toString()
                : chap.dateUpload.toString(),
            scanlator: chap.scanlator ?? '',
            mangaId: savedMangaId,
            updatedAt: now,
            isFiller: chap.isFiller,
            thumbnailUrl: chap.thumbnailUrl,
            description: chap.description,
            downloadSize: chap.downloadSize,
            duration: chap.duration,
          )..manga.value = manga;

          if (alreadyRead) {
            newChapter.isRead = alreadyRead;
            newChapter.lastPageRead = "1";
          }

          existingByUrl[key] = newChapter;
          if (compositeKey != null) {
            existingByComposite[compositeKey] = newChapter;
          }

          newChapters.add(newChapter);
        } else {
          existing
            ..name = chap.name
            ..url = url
            ..scanlator = chap.scanlator
            ..updatedAt = now
            ..isFiller = chap.isFiller
            ..thumbnailUrl = chap.thumbnailUrl
            ..description = chap.description
            ..downloadSize = chap.downloadSize
            ..duration = chap.duration;
          chaptersToUpdate.add(existing);
        }
      }

      if (chaptersToUpdate.isNotEmpty) {
        await isar.chapters.putAll(chaptersToUpdate);
      }

      if (newChapters.isNotEmpty) {
        final hasExisting = existingChapters.isNotEmpty;

        final orderedNew = newChapters.reversed.toList();

        for (final chap in orderedNew) {
          chap.manga.value = manga;
        }

        await isar.chapters.putAll(orderedNew);
        for (final chap in orderedNew) {
          await chap.manga.save();
        }

        final updatesToInsert = <Update>[];
        for (final chap in orderedNew) {
          if (hasExisting && !(chap.isRead ?? false)) {
            updatesToInsert.add(
              Update(
                mangaId: savedMangaId,
                chapterName: chap.name,
                date: now.toString(),
                updatedAt: now,
              )..chapter.value = chap,
            );
          }
        }

        if (updatesToInsert.isNotEmpty) {
          await isar.updates.putAll(updatesToInsert);
          for (final upd in updatesToInsert) {
            await upd.chapter.save();
          }
        }
      }

      if (duplicateIds.isNotEmpty) {
        await isar.chapters.deleteAll(duplicateIds.toList());
      }

      final dedupedExisting = duplicateIds.isEmpty
          ? existingChapters
          : existingChapters
                .where((c) => c.id == null || !duplicateIds.contains(c.id))
                .toList();
      final allChapters = newChapters.isEmpty
          ? dedupedExisting
          : [...dedupedExisting, ...newChapters];
      if (allChapters.isNotEmpty) {
        final interval = FetchInterval.calculateInterval(allChapters);
        manga
          ..id = savedMangaId
          ..smartUpdateDays = interval;
        await isar.mangas.put(manga);
      }
    });
  } catch (e, s) {
    if (showToast) {
      toastError(e, stack: s, source: 'updateMangaDetail');
    } else {
      rethrow;
    }
  }
}
