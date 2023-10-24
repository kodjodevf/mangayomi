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

  final getManga = await ref.watch(
      getMangaDetailProvider(manga: manga.toMManga(source!), source: source)
          .future);

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
    ..status = switch (getManga.status) {
      0 => Status.ongoing,
      1 => Status.completed,
      2 => Status.onHiatus,
      3 => Status.canceled,
      4 => Status.publishingFinished,
      _ => Status.unknown,
    }
    ..description = getManga.description?.trim().trimLeft().trimRight() ??
        manga.description ??
        ""
    ..link = getManga.link?.trim().trimLeft().trimRight() ?? manga.link
    ..source = getManga.source?.trim().trimLeft().trimRight() ?? manga.source
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
    if (getManga.names!.isNotEmpty &&
        getManga.names!.length > manga.chapters.length) {
      int newChapsIndex = getManga.names!.length - manga.chapters.length;
      manga.lastUpdate = DateTime.now().millisecondsSinceEpoch;
      for (var i = 0; i < newChapsIndex; i++) {
        String title = "";
        String scanlator = "";
        if (getManga.chaptersChaps != null &&
            getManga.chaptersVolumes != null) {
          title = beautifyChapterName(getManga.chaptersVolumes![i],
              getManga.chaptersChaps![i], getManga.names![i], getManga.lang!);
        } else {
          title = getManga.names![i].trim().trimLeft().trimRight();
        }
        if (getManga.chaptersScanlators != null) {
          scanlator = getManga.chaptersScanlators![i]
              .toString()
              .replaceAll(']', "")
              .replaceAll("[", "");
        }
        final chapter = Chapter(
          name: title,
          url: getManga.urls![i].trim().trimLeft().trimRight(),
          dateUpload: getManga.chaptersDateUploads!.isEmpty
              ? DateTime.now().millisecondsSinceEpoch.toString()
              : getManga.chaptersDateUploads![i],
          scanlator: scanlator,
        )..manga.value = manga;
        chapters.add(chapter);
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

String beautifyChapterName(String vol, String chap, String title, String lang) {
  String result = "";
  vol = vol.trim().trimLeft().trimRight();
  chap = chap.trim().trimLeft().trimRight();
  title = title.trim().trimLeft().trimRight();

  if (vol != "null" && vol.isNotEmpty) {
    if (chap != "null" && chap.isEmpty) {
      result += "Volume $vol ";
    } else {
      result += "Vol. $vol ";
    }
  }

  if (chap != "null" && chap.isNotEmpty) {
    if (vol != "null" && vol.isEmpty) {
      if (lang != "null" && lang == "fr") {
        result += "Chapitre $chap";
      } else {
        result += "Chapter $chap";
      }
    } else {
      result += "Ch. $chap ";
    }
  }

  if (title != "null" && title.isNotEmpty) {
    if (chap != "null" && chap.isEmpty) {
      result += title;
    } else {
      result += " : $title";
    }
  }

  return result;
}
