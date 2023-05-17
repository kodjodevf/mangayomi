import 'dart:async';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

@riverpod
Future<GetManga> getMangaDetail(GetMangaDetailRef ref,
    {required GetManga manga,
    required String lang,
    required String source}) async {
  GetManga? mangadetail;

  /********/
  /*comick*/
  /********/

  if (getMangaTypeSource(source.toLowerCase()) == TypeSource.comick) {
    mangadetail = await Comick()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }
  /*************/
  /*mangathemesia*/
  /**************/

  if (getMangaTypeSource(source.toLowerCase()) == TypeSource.mangathemesia) {
    mangadetail = await MangaThemeSia()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }
  /***********/
  /*mangakawaii*/
  /***********/
  else if (source.toLowerCase() == "mangakawaii") {
    mangadetail = await MangaKawaii()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source.toLowerCase()) == TypeSource.mmrcms) {
    mangadetail = await Mmrcms()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source.toLowerCase() == "mangahere") {
    mangadetail = await Mangahere()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }

  /***********/
  /*japscan*/
  /***********/

  else if (source.toLowerCase() == "japscan") {
    mangadetail = await Japscan()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }

  /***********/
  /*heancms*/
  /***********/

  else if (getMangaTypeSource(source.toLowerCase()) == TypeSource.heancms) {
    mangadetail = await HeanCms()
        .getMangaDetail(manga: manga, lang: lang, source: source, ref: ref);
  }
  return mangadetail!;
}
