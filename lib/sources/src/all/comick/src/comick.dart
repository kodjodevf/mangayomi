import 'dart:convert';

import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/sources/src/all/comick/src/model/chapter_page_comick.dart';
import 'package:mangayomi/sources/src/all/comick/src/model/manga_chapter_detail.dart';
import 'package:mangayomi/sources/src/all/comick/src/model/manga_detail_comick.dart';
import 'package:mangayomi/sources/src/all/comick/src/model/popular_manga_comick.dart';
import 'package:mangayomi/sources/src/all/comick/src/model/search_manga_cimick.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/utils/utils.dart';
import 'package:mangayomi/sources/utils/utils.dart';

class Comick extends MangaYomiServices {
  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source, required int page}) async {
    source = source.toLowerCase();
    final response = await httpGet(
        url:
            'https://api.comick.fun/v1.0/search?sort=follow&page=$page&tachiyomi=true',
        source: source,
        resDom: false) as String?;
    var popularManga = jsonDecode(response!) as List;

    var popularMangaList =
        popularManga.map((e) => PopularMangaModelComick.fromJson(e)).toList();
    for (var popular in popularMangaList) {
      url.add("/comic/${popular.slug}");
      name.add(popular.title);
      image.add(popular.coverUrl);
    }
    return mangaRes();
  }

  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source}) async {
    final response = await httpGet(
        url: 'https://api.comick.fun${manga.url}?tachiyomi=true',
        source: source,
        resDom: false) as String?;
    var mangaDetail = jsonDecode(response!) as Map<String, dynamic>;

    var mangaDetailLMap = MangaDetailModelComick.fromJson(mangaDetail);

    RegExp regExp = RegExp(r'name:\s*(.*?),');

    String authorr =
        regExp.firstMatch(mangaDetailLMap.authors![0].toString())?.group(1) ??
            '';
    String statuss = parseStatut(mangaDetailLMap.comic!.status!);
    status = statuss;
    author = authorr;
    RegExp regExp1 = RegExp(r'name:\s*(.*?)}');
    for (var ok in mangaDetailLMap.genres!) {
      genre.add(regExp1.firstMatch(ok.toString())!.group(1)!);
    }
    description = mangaDetailLMap.comic!.desc;
    String tt = await findCurrentSlug(mangaDetailLMap.comic!.slug!);
    String mangaId = tt.split('":"').last.replaceAll('"}', '');
    String limit = mangaDetailLMap.comic!.chapterCount.toString();

    final responsee = await httpGet(
        url:
            'https://api.comick.fun/comic/$mangaId/chapters?lang=$lang&limit=$limit',
        source: source,
        resDom: false) as String?;
    var chapterDetail = jsonDecode(responsee!) as Map<String, dynamic>;
    var chapterDetailMap = MangaChapterModelComick.fromJson(chapterDetail);
    for (var chapter in chapterDetailMap.chapters!) {
      scanlators.add(chapter.groupName!.isNotEmpty
          ? chapter.groupName!.first.toString() != 'null'
              ? chapter.groupName!.first
              : ""
          : "");
      chapterUrl.add(
          "/comic/${mangaDetailLMap.comic!.slug}/${chapter.hid}-chapter-${chapter.chap}-en");
      chapterDate.add(parseDate(chapter.createdAt!, source));

      chapterTitle.add(beautifyChapterName(
          chapter.vol ?? "", chapter.chap ?? "", chapter.title ?? "", lang));
    }

    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source, required String query}) async {
    final response = await httpGet(
        url:
            'https://api.comick.fun/search?q=${query.trim()}&tachiyomi=true&page=1',
        source: source,
        resDom: false) as String?;
    var popularManga = jsonDecode(response!) as List;
    var popularMangaList =
        popularManga.map((e) => MangaSearchModelComick.fromJson(e)).toList();
    for (var popular in popularMangaList) {
      url.add("/comic/${popular.slug}");
      name.add(popular.title);
      image.add(popular.coverUrl);
    }
    return mangaRes();
  }

  @override
  Future<List<dynamic>> getChapterUrl({required Chapter chapter}) async {
    String mangaId = chapter.url!.split('/').last.split('-').first;

    final response = await httpGet(
        url: 'https://api.comick.fun/chapter/$mangaId?tachiyomi=true',
        source: 'comick',
        resDom: false) as String?;
    var data = jsonDecode(response!) as Map<String, dynamic>;
    var page = ChapterPageComick.fromJson(data);
    for (var url in page.chapter!.images!) {
      pageUrls.add(url.url);
    }
    return pageUrls;
  }
}
