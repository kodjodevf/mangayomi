import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      {required String source,
      required String lang,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    source = source.toLowerCase();
    final response = await ref.watch(httpGetProvider(
            url:
                '${getMangaAPIUrl(source)}/v1.0/search?sort=follow&page=$page&tachiyomi=true',
            source: source,
            resDom: false)
        .future) as String?;
    var popularManga = jsonDecode(response!) as List;
    var popularMangaList =
        popularManga.map((e) => PopularMangaModelComick.fromJson(e)).toList();

    for (var popular in popularMangaList) {
      url.add("/comic/${popular.hid}#");
      name.add(popular.title);
      image.add(popular.coverUrl);
    }

    return mangaRes();
  }

  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
            url:
                '${getMangaAPIUrl(source)}${manga.url!.replaceAll("#", '')}?tachiyomi=true',
            source: source,
            resDom: false)
        .future) as String?;
    var mangaDetail = jsonDecode(response!) as Map<String, dynamic>;
    var mangaDetailLMap = MangaDetailModelComick.fromJson(mangaDetail);
    RegExp regExp = RegExp(r'name:\s*(.*?),');
    String authorr =
        regExp.firstMatch(mangaDetailLMap.authors![0].toString())?.group(1) ??
            '';
    status = parseStatut(mangaDetailLMap.comic!.status!);
    author = authorr;
    RegExp regExp1 = RegExp(r'name:\s*(.*?)}');

    for (var ok in mangaDetailLMap.genres!) {
      genre.add(regExp1.firstMatch(ok.toString())!.group(1)!);
    }

    description = mangaDetailLMap.comic!.desc;
    final request = await paginatedChapterListRequest(
        ref, manga.url!.replaceAll("#", ''), 1, source, lang);
    final chapterListResponse =
        MangaChapterModelComick.fromJson(json.decode(request));
    final mangaUrl = request.substring(request.indexOf(getMangaAPIUrl(source)) +
        getMangaAPIUrl(source).length);
    var resultSize = chapterListResponse.chapters!.length;
    var page = 2;

    while (chapterListResponse.total! > resultSize) {
      final newResponse = await paginatedChapterListRequest(
          ref, manga.url!.replaceAll("#", ''), page, source, lang);
      final newChapterListResponse =
          MangaChapterModelComick.fromJson(json.decode(newResponse));
      chapterListResponse.chapters!.addAll(newChapterListResponse.chapters!);
      resultSize += newChapterListResponse.chapters!.length;
      page += 1;
    }

    for (var chapter in chapterListResponse.chapters!) {
      scanlators.add(chapter.groupName!.isNotEmpty
          ? chapter.groupName!.join()
          : "Unknown");
      chapterUrl.add("$mangaUrl/${chapter.hid}-chapter-${chapter.chap}-$lang");
      chapterDate.add(parseDate(chapter.createdAt!, source));
      chapterTitle.add(beautifyChapterName(
          chapter.vol ?? "", chapter.chap ?? "", chapter.title ?? "", lang));
    }

    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
            url:
                '${getMangaAPIUrl(source)}/v1.0/search?q=${query.trim()}&tachiyomi=true&limit=50&page=1',
            source: source,
            resDom: false)
        .future) as String?;
    var search = jsonDecode(response!) as List;
    var searchList =
        search.map((e) => MangaSearchModelComick.fromJson(e)).toList();

    for (var search in searchList) {
      url.add("/comic/${search.hid}#");
      name.add(search.title);
      image.add(search.coverUrl);
    }

    return mangaRes();
  }

  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    String mangaHid = chapter.url!.split('/').last.split('-').first;
    String source = chapter.manga.value!.source!;
    final response = await ref.watch(httpGetProvider(
            url: '${getMangaAPIUrl(source)}/chapter/$mangaHid?tachiyomi=true',
            source: source,
            resDom: false)
        .future) as String?;
    var data = jsonDecode(response!) as Map<String, dynamic>;
    var page = ChapterPageComick.fromJson(data);

    for (var url in page.chapter!.images!) {
      pageUrls.add(url.url!);
    }

    return pageUrls;
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    source = source.toLowerCase();
    final response = await ref.watch(httpGetProvider(
            url:
                '${getMangaAPIUrl(source)}/v1.0/search?sort=uploaded&page=$page&tachiyomi=true',
            source: source,
            resDom: false)
        .future) as String?;
    var popularManga = jsonDecode(response!) as List;
    var popularMangaList =
        popularManga.map((e) => PopularMangaModelComick.fromJson(e)).toList();

    for (var popular in popularMangaList) {
      url.add("/comic/${popular.hid}#");
      name.add(popular.title);
      image.add(popular.coverUrl);
    }

    return mangaRes();
  }
}
