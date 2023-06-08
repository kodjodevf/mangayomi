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
part 'get_latest_updates_manga.g.dart';

@riverpod
Future<List<GetManga?>> getLatestUpdatesManga(
  GetLatestUpdatesMangaRef ref, {
  required String source,
  required int page,
  required String lang,
}) async {
  List<GetManga?>? latestUpdatesManga;
  source = source.toLowerCase();

  /*********/
  /*comick*/
  /*******/
  if (getMangaTypeSource(source) == TypeSource.comick) {
    latestUpdatesManga = await Comick().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***************/
  /*mangathemesia*/
  /**************/
  if (getMangaTypeSource(source) == TypeSource.mangathemesia) {
    latestUpdatesManga = await MangaThemeSia().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangakawaii*/
  /***********/
  if (source == "mangakawaii") {
    latestUpdatesManga = await MangaKawaii().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getMangaTypeSource(source) == TypeSource.mmrcms) {
    latestUpdatesManga = await Mmrcms().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    latestUpdatesManga = await Mangahere().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }
  /***********/
  /*japscan*/
  /***********/
  else if (source == "japscan") {
    latestUpdatesManga = await Japscan().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*heancms*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.heancms) {
    latestUpdatesManga = await HeanCms().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*madara*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.madara) {
    latestUpdatesManga = await Madara().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }

  /***********/
  /*mangadex*/
  /***********/
  else if (getMangaTypeSource(source) == TypeSource.mangadex) {
    latestUpdatesManga = await MangaDex().getLatestUpdatesManga(
        source: source, page: page, ref: ref, lang: lang);
  }
  return latestUpdatesManga!;
}
