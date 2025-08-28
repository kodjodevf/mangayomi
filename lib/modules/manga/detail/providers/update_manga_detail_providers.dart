import 'dart:math';

import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    if (manga!.chapters.isNotEmpty && isInit) {
      return;
    }
    final source = getSource(manga.lang!, manga.source!, manga.sourceId);
    MManga getManga;

    getManga = await ref.read(
      getDetailProvider(url: manga.link!, source: source!).future,
    );

    final genre =
        getManga.genre
            ?.map((e) => e.toString().trim().trimLeft().trimRight())
            .toList()
            .toSet()
            .toList() ??
        [];
    final tempName = getManga.name?.trim().trimLeft().trimRight();
    final tempLink = getManga.link?.trim().trimLeft().trimRight();
    manga
      ..imageUrl = getManga.imageUrl ?? manga.imageUrl
      ..name = tempName != null && tempName.isNotEmpty ? tempName : manga.name
      ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
      ..author =
          getManga.author?.trim().trimLeft().trimRight() ?? manga.author ?? ""
      ..artist =
          getManga.artist?.trim().trimLeft().trimRight() ?? manga.artist ?? ""
      ..status = getManga.status == Status.unknown
          ? manga.status
          : getManga.status ?? Status.unknown
      ..description =
          getManga.description?.trim().trimLeft().trimRight() ??
          manga.description ??
          ""
      ..link = tempLink != null && tempLink.isNotEmpty ? tempLink : manga.link
      ..source = manga.source
      ..lang = manga.lang
      ..itemType = source.itemType
      ..lastUpdate = DateTime.now().millisecondsSinceEpoch
      ..updatedAt = DateTime.now().millisecondsSinceEpoch;
    final checkManga = isar.mangas.getSync(mangaId);
    if (checkManga!.chapters.isNotEmpty && isInit) {
      return;
    }
    isar.writeTxnSync(() {
      final mangaId = isar.mangas.putSync(manga);
      manga.lastUpdate = DateTime.now().millisecondsSinceEpoch;

      List<Chapter> chapters = [];

      final chaps = getManga.chapters;
      if (chaps!.isNotEmpty && chaps.length > manga.chapters.length) {
        int newChapsIndex = chaps.length - manga.chapters.length;
        manga.lastUpdate = DateTime.now().millisecondsSinceEpoch;
        for (var i = 0; i < newChapsIndex; i++) {
          final chapter = Chapter(
            name: chaps[i].name!,
            url: chaps[i].url!.trim().trimLeft().trimRight(),
            dateUpload: chaps[i].dateUpload == null
                ? DateTime.now().millisecondsSinceEpoch.toString()
                : chaps[i].dateUpload.toString(),
            scanlator: chaps[i].scanlator ?? '',
            mangaId: mangaId,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
            isFiller: chaps[i].isFiller,
            thumbnailUrl: chaps[i].thumbnailUrl,
            description: chaps[i].description,
            downloadSize: chaps[i].downloadSize,
            duration: chaps[i].duration,
          )..manga.value = manga;
          chapters.add(chapter);
        }
      }
      if (chapters.isNotEmpty) {
        for (var chap in chapters.reversed.toList()) {
          isar.chapters.putSync(chap);
          chap.manga.saveSync();
          if (manga.chapters.isNotEmpty) {
            final update = Update(
              mangaId: mangaId,
              chapterName: chap.name,
              date: DateTime.now().millisecondsSinceEpoch.toString(),
              updatedAt: DateTime.now().millisecondsSinceEpoch,
            )..chapter.value = chap;
            isar.updates.putSync(update);
            update.chapter.saveSync();
          }
        }
      }
      final oldChapers = isar.mangas
          .getSync(mangaId)!
          .chapters
          .toList()
          .reversed
          .toList();
      if (oldChapers.length == chaps.length) {
        for (var i = 0; i < oldChapers.length; i++) {
          final oldChap = oldChapers[i];
          final newChap = chaps[i];
          oldChap.name = newChap.name;
          oldChap.url = newChap.url;
          oldChap.scanlator = newChap.scanlator;
          oldChap.updatedAt = DateTime.now().millisecondsSinceEpoch;
          oldChap.isFiller = newChap.isFiller;
          oldChap.thumbnailUrl = newChap.thumbnailUrl;
          oldChap.description = newChap.description;
          oldChap.downloadSize = newChap.downloadSize;
          oldChap.duration = newChap.duration;
          isar.chapters.putSync(oldChap);
          oldChap.manga.saveSync();
        }
      }
      final List<int> daysBetweenUploads = [];
      for (var i = 0; i + 1 < chaps.length; i++) {
        if (chaps[i].dateUpload != null && chaps[i + 1].dateUpload != null) {
          final date1 = DateTime.fromMillisecondsSinceEpoch(
            int.parse(chaps[i].dateUpload!),
          );
          final date2 = DateTime.fromMillisecondsSinceEpoch(
            int.parse(chaps[i + 1].dateUpload!),
          );
          daysBetweenUploads.add(date1.difference(date2).abs().inDays);
        }
      }
      if (daysBetweenUploads.isNotEmpty) {
        final median = daysBetweenUploads.median();
        isar.mangas.putSync(
          manga
            ..id = mangaId
            ..smartUpdateDays = max(
              median,
              daysBetweenUploads.arithmeticMean(),
            ),
        );
      }
    });
  } catch (e, s) {
    if (showToast) botToast('$e\n$s');
    return;
  }
}
