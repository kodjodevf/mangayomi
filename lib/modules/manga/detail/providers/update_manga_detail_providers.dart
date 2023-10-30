import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/get_manga_detail.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'update_manga_detail_providers.g.dart';

@riverpod
Future<dynamic> updateMangaDetail(UpdateMangaDetailRef ref,
    {required int? mangaId, required bool isInit}) async {
  final manga = isar.mangas.getSync(mangaId!);
  if (manga!.chapters.isNotEmpty && isInit) {
    return;
  }
  final source = getSource(manga.lang!, manga.source!);
  MManga getManga;
  try {
    getManga = await ref.watch(
        getMangaDetailProvider(url: manga.link!, source: source!).future);
  } catch (_) {
    return;
  }
  manga
    ..imageUrl = getManga.imageUrl ?? manga.imageUrl
    ..name = getManga.name?.trim().trimLeft().trimRight() ?? manga.name
    ..genre = getManga.genre
            ?.map((e) => e.toString().trim().trimLeft().trimRight())
            .toList()
            .toSet()
            .toList() ??
        manga.genre ??
        []
    ..author =
        getManga.author?.trim().trimLeft().trimRight() ?? manga.author ?? ""
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
        )..manga.value = manga;
        chapters.add(chapter);
      }
    }
    if (chapters.isNotEmpty) {
      for (var chap in chapters.reversed.toList()) {
        isar.chapters.putSync(chap);
        chap.manga.saveSync();
      }
    }
  });
}
