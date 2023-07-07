import 'package:mangayomi/eval/bridge_class/model.dart';
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
  final mangaS = MangaModel(
      name: manga.name,
      link: manga.link,
      imageUrl: manga.imageUrl,
      baseUrl: source.baseUrl,
      apiUrl: source.apiUrl,
      lang: manga.lang,
      dateFormat: source.dateFormat,
      dateFormatLocale: source.dateFormatLocale);
  final getManga = await ref
      .watch(getMangaDetailProvider(manga: mangaS, source: source).future);
  manga
    ..imageUrl =
        getManga.imageUrl!.isEmpty ? manga.imageUrl ?? "" : getManga.imageUrl
    ..name = getManga.name!.isEmpty
        ? manga.name ?? ""
        : getManga.name!.trim().trimLeft().trimRight()
    ..genre = getManga.genre!.isEmpty
        ? manga.genre ?? []
        : getManga.genre!
            .map((e) => e.toString().trim().trimLeft().trimRight())
            .toList()
    ..author = getManga.author!.isEmpty
        ? manga.author ?? ""
        : getManga.author!.trim().trimLeft().trimRight()
    ..status = switch (getManga.status) {
      0 => Status.ongoing,
      1 => Status.completed,
      2 => Status.onHiatus,
      3 => Status.canceled,
      4 => Status.publishingFinished,
      _ => Status.unknown,
    }
    ..description = getManga.description!.isEmpty
        ? manga.description ?? ""
        : getManga.description!.trim().trimLeft().trimRight()
    ..link = getManga.link!.isEmpty ? manga.link ?? "" : getManga.link
    ..source = getManga.source!.isEmpty ? manga.source ?? "" : getManga.source
    ..lang = getManga.lang!.isEmpty ? manga.lang ?? "" : getManga.lang
    ..lastUpdate = DateTime.now().millisecondsSinceEpoch;

  isar.writeTxnSync(() {
    isar.mangas.putSync(manga);
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
        final chapters = Chapter(
          name: title,
          url: getManga.urls![i].trim().trimLeft().trimRight(),
          dateUpload: getManga.chaptersDateUploads![i],
          scanlator: scanlator,
        )..manga.value = manga;
        isar.chapters.putSync(chapters);
        chapters.manga.saveSync();
      }
    }
  });
}

String beautifyChapterName(String vol, String chap, String title, String lang) {
  String result = "";

  if (vol.trim().trimLeft().trimRight() != "null" && vol.isNotEmpty) {
    if (chap.trim().trimLeft().trimRight() != "null" && chap.isEmpty) {
      result += "Volume ${vol.trim().trimLeft().trimRight()} ";
    } else {
      result += "Vol. ${vol.trim().trimLeft().trimRight()} ";
    }
  }

  if (chap.trim().trimLeft().trimRight() != "null" && chap.isNotEmpty) {
    if (vol.trim().trimLeft().trimRight() != "null" && vol.isEmpty) {
      if (lang.trim().trimLeft().trimRight() != "null" && lang == "fr") {
        result += "Chapitre ${chap.trim().trimLeft().trimRight()}";
      } else {
        result += "Chapter ${chap.trim().trimLeft().trimRight()}";
      }
    } else {
      result += "Ch. ${chap.trim().trimLeft().trimRight()} ";
    }
  }

  if (title.trim().trimLeft().trimRight() != "null" && title.isNotEmpty) {
    if (chap.trim().trimLeft().trimRight() != "null" && chap.isEmpty) {
      result += title.trim().trimLeft().trimRight();
    } else {
      result += " : ${title.trim().trimLeft().trimRight()}";
    }
  }

  return result;
}
