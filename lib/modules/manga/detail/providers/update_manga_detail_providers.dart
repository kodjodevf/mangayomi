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
      genre: manga.genre,
      author: manga.author,
      status: switch (manga.status) {
        Status.ongoing => 0,
        Status.completed => 1,
        Status.onHiatus => 2,
        Status.canceled => 3,
        Status.publishingFinished => 4,
        _ => 5,
      },
      description: manga.description,
      imageUrl: manga.imageUrl,
      baseUrl: source.baseUrl,
      apiUrl: source.apiUrl,
      lang: manga.lang,
      dateFormat: source.dateFormat,
      dateFormatLocale: source.dateFormatLocale);
  final getManga = await ref
      .watch(getMangaDetailProvider(manga: mangaS, source: source).future);

  final imageUrl = getManga.imageUrl != null && getManga.imageUrl!.isNotEmpty
      ? getManga.imageUrl
      : manga.imageUrl ?? "";
  final name = getManga.name != null && getManga.name!.isNotEmpty
      ? getManga.name!.trim().trimLeft().trimRight()
      : manga.name ?? "";
  final genre = getManga.genre != null && getManga.genre!.isNotEmpty
      ? getManga.genre!
          .map((e) => e.toString().trim().trimLeft().trimRight())
          .toList()
          .toSet()
          .toList()
      : manga.genre ?? [];

  final author = getManga.author != null && getManga.author!.isNotEmpty
      ? getManga.author!.trim().trimLeft().trimRight()
      : manga.author ?? "";
  final description =
      getManga.description != null && getManga.description!.isNotEmpty
          ? getManga.description!.trim().trimLeft().trimRight()
          : manga.description ?? "";
  final link = getManga.link != null && getManga.link!.isNotEmpty
      ? getManga.link!.trim().trimLeft().trimRight()
      : manga.link ?? "";
  final sourceA = getManga.source != null && getManga.source!.isNotEmpty
      ? getManga.source!.trim().trimLeft().trimRight()
      : manga.source ?? "";
  final lang = getManga.lang != null && getManga.lang!.isNotEmpty
      ? getManga.lang!.trim().trimLeft().trimRight()
      : manga.lang ?? "";
  manga
    ..imageUrl = imageUrl
    ..name = name
    ..genre = genre
    ..author = author
    ..status = switch (getManga.status) {
      0 => Status.ongoing,
      1 => Status.completed,
      2 => Status.onHiatus,
      3 => Status.canceled,
      4 => Status.publishingFinished,
      _ => Status.unknown,
    }
    ..description = description
    ..link = link
    ..source = sourceA
    ..lang = lang
    ..isManga = source.isManga
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
          dateUpload: getManga.chaptersDateUploads!.isEmpty
              ? null
              : getManga.chaptersDateUploads![i],
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
