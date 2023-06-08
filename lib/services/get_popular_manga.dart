import 'dart:async';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/multisrc/heancms/heancms.dart';
import 'package:mangayomi/sources/multisrc/madara/src/madara.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/comick.dart';
import 'package:mangayomi/sources/src/all/mangadex/src/mangadex.dart';
import 'package:mangayomi/sources/src/en/mangahere/src/mangahere.dart';
import 'package:mangayomi/sources/src/fr/japscan/src/japscan.dart';
import 'package:mangayomi/sources/src/fr/mangakawaii/src/mangakawaii.dart';
import 'package:mangayomi/sources/multisrc/mangathemesia/src/mangathemesia.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/mmrcms.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular_manga.g.dart';

@riverpod
Future<List<GetManga?>> getPopularManga(GetPopularMangaRef ref,
    {required String source, required int page, required String lang}) async {
  List<GetManga?>? popularManga;
  source = source.toLowerCase();

  /*********/
  /*comick*/
  /*******/
  if (getMangaTypeSource(source) == TypeSource.comick) {
    popularManga = await Comick()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***************/
  /*mangathemesia*/
  /**************/
  if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
    popularManga = await MangaThemeSia()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangakawaii*/
  /***********/
  if (source == "mangakawaii") {
    popularManga = await MangaKawaii()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
    popularManga = await Mmrcms()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    popularManga = await Mangahere()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }
  /***********/
  /*japscan*/
  /***********/
  else if (source == "japscan") {
    popularManga = await Japscan()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*heancms*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.heancms) {
    popularManga = await HeanCms()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }
  /***********/
  /*madara*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.madara) {
    popularManga = await Madara()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangadex*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.mangadex) {
    popularManga = await MangaDex()
        .getPopularManga(source: source, page: page, ref: ref, lang: lang);
  }
  return popularManga!;
}
