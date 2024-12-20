import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/get_detail.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(Ref ref,
    {required int? mangaId, required bool isInit}) async {
  final manga = isar.mangas.getSync(mangaId!);
  if (manga!.chapters.isNotEmpty && isInit) {
    return;
  }
  final source = getSource(manga.lang!, manga.source!);
  MManga getManga;
  try {
    getManga = await ref
        .watch(getDetailProvider(url: manga.link!, source: source!).future);
  } catch (e) {
    botToast(e.toString());
    return;
  }
  final genre = getManga.genre
          ?.map((e) => e.toString().trim().trimLeft().trimRight())
          .toList()
          .toSet()
          .toList() ??
      [];
  manga
    ..imageUrl = getManga.imageUrl ?? manga.imageUrl
    ..name = getManga.name?.trim().trimLeft().trimRight() ?? manga.name
    ..genre = (genre.isEmpty ? null : genre) ?? manga.genre ?? []
    ..author =
        getManga.author?.trim().trimLeft().trimRight() ?? manga.author ?? ""
    ..artist =
        getManga.artist?.trim().trimLeft().trimRight() ?? manga.artist ?? ""
    ..status =
        getManga.status == Status.unknown ? manga.status : getManga.status!
    ..description = getManga.description?.trim().trimLeft().trimRight() ??
        manga.description ??
        ""
    ..link = getManga.link?.trim().trimLeft().trimRight() ?? manga.link
    ..source = manga.source
    ..lang = manga.lang
    ..isManga = source.isManga
    ..lastUpdate = DateTime.now().millisecondsSinceEpoch;
  final checkManga = isar.mangas.getSync(mangaId);
  if (checkManga!.chapters.isNotEmpty && isInit) {
    return;
  }
  isar.writeTxnSync(() {
    isar.mangas.putSync(manga);
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
        )..manga.value = manga;
        chapters.add(chapter);
      }
    }
    if (chapters.isNotEmpty) {
      for (var chap in chapters.reversed.toList()) {
        ref
            .read(changedItemsManagerProvider(managerId: 1).notifier)
            .addUpdatedChapter(chap, false, false);
        isar.chapters.putSync(chap);
        chap.manga.saveSync();
        if (manga.chapters.isNotEmpty) {
          final update = Update(
              mangaId: mangaId,
              chapterName: chap.name,
              date: DateTime.now().millisecondsSinceEpoch.toString())
            ..chapter.value = chap;
          isar.updates.putSync(update);
          update.chapter.saveSync();
        }
      }
    }
    final oldChapers =
        isar.mangas.getSync(mangaId)!.chapters.toList().reversed.toList();
    if (oldChapers.length == chaps.length) {
      for (var i = 0; i < oldChapers.length; i++) {
        final oldChap = oldChapers[i];
        final newChap = chaps[i];
        oldChap.name = newChap.name;
        oldChap.url = newChap.url;
        oldChap.scanlator = newChap.scanlator;
        ref
            .read(changedItemsManagerProvider(managerId: 1).notifier)
            .addUpdatedChapter(oldChap, false, false);
        isar.chapters.putSync(oldChap);
        oldChap.manga.saveSync();
      }
    }
  });
}
