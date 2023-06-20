import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/multisrc/heancms/model/search.dart';
import 'package:mangayomi/sources/multisrc/heancms/utils/utils.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/sources/utils/utils.dart';

class HeanCms extends MangaYomiServices {
  Map<String, String> _headers(String source) => {
        'Origin': getMangaBaseUrl(source),
        'Referer': getMangaAPIUrl(source),
        'Accept': 'application/json, text/plain, */*',
        'Content-Type': 'application/json'
      };
  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    final chapterId = chapter.url!.split("#").last;
    var request = http.Request(
        'GET',
        Uri.parse(
            '${getMangaAPIUrl("${chapter.manga.value!.source}")}series/chapter/$chapterId'));
    request.headers.addAll({
      'Accept': 'application/json, text/plain, */*',
    });
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    var page = jsonDecode(res) as Map<String, dynamic>;
    for (var url in page["content"]["images"]) {
      if (url.startsWith("http")) {
        pageUrls.add(url);
      } else {
        pageUrls.add("${getMangaAPIUrl("${chapter.manga.value!.source}")}$url");
      }
    }
    return pageUrls;
  }

  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    String currentSlug = manga.url!.split('/').last;

    var request = http.Request(
        'GET',
        Uri.parse(
            '${getMangaAPIUrl(source)}series/$currentSlug#${manga.status}'));
    request.headers.addAll({
      'Accept': 'application/json, text/plain, */*',
    });
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    var mangaDetail = jsonDecode(res) as Map<String, dynamic>;

    final d = Data.fromJson(mangaDetail);

    final dom = await httpResToDom(
        url: '${getMangaBaseUrl(source)}/series/$currentSlug', headers: {});
    final des = dom
        .querySelectorAll("div.description-container")
        .map((e) => e.text.trim())
        .toList();
    final genres = dom
        .querySelectorAll("div.tags-container.pt-3 > span")
        .map((e) => e.text)
        .toList();
    final auth = dom
        .querySelectorAll("div > p")
        .where((element) =>
            element.outerHtml.toLowerCase().contains('autor') ||
            element.outerHtml.toLowerCase().contains('author'))
        .map((e) => e.text)
        .toList();
    author = auth.first.split(":").last;
    status = manga.status;
    genre = source == "OmegaScans" ? [] : genres;
    description = des.first;
    for (var chapter in d.chapters!) {
      chapterUrl
          .add("/series/$currentSlug/${chapter.chapterSlug}#${chapter.id}");
      chapterTitle.add(chapter.chapterName!.trim());
      chapterDate.add(parseDate(chapter.createdAt!, source));
    }
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga>> getPopularManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    var request = http.Request(
        'POST', Uri.parse('${getMangaAPIUrl(source)}series/querysearch'));
    request.body = json.encode({
      "page": page,
      "order": "desc",
      "order_by": "total_views",
      "series_status": "Ongoing",
      "series_type": "Comic"
    });
    request.headers.addAll(_headers(source));

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    List<Data>? data;
    if (res.startsWith("{")) {
      var popularManga = jsonDecode(res) as Map<String, dynamic>;
      var popularMangaList = HeanCmsSearchModel.fromJson(popularManga);
      data = popularMangaList.data!;
    } else {
      var popularManga = jsonDecode(res) as List;
      data = popularManga.map((e) => Data.fromJson(e)).toList();
    }

    for (var a in data) {
      final status = parseHeanCmsStatus(a.status!);
      statusList.add(status);
      image.add(a.thumbnail!.startsWith("https://")
          ? a.thumbnail
          : "${getMangaAPIUrl(source)}cover/${a.thumbnail}");
      name.add(a.title);
      url.add("/series/${a.seriesSlug!.replaceAll(timeStampRegex, '')}");
    }

    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    var request = http.Request(
        'POST', Uri.parse('${getMangaAPIUrl(source)}series/search'));
    request.body = json.encode({"term": query.trim()});
    request.headers.addAll({
      'Accept': 'application/json, text/plain, */*',
      'Content-Type': 'application/json'
    });
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    List<Data>? data;
    if (res.startsWith("{")) {
      var popularManga = jsonDecode(res) as Map<String, dynamic>;
      var popularMangaList = HeanCmsSearchModel.fromJson(popularManga);
      data = popularMangaList.data!;
    } else {
      var popularManga = jsonDecode(res) as List;
      data = popularManga.map((e) => Data.fromJson(e)).toList();
    }

    for (var a in data) {
      final status = parseHeanCmsStatus(a.status!);
      statusList.add(status);
      image.add(a.thumbnail!.startsWith("https://")
          ? a.thumbnail
          : "${getMangaAPIUrl(source)}cover/${a.thumbnail}");
      name.add(a.title);
      url.add("/series/${a.seriesSlug!.replaceAll(timeStampRegex, '')}");
    }
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    var request = http.Request(
        'POST', Uri.parse('${getMangaAPIUrl(source)}series/querysearch'));
    request.body = json.encode({
      "page": page,
      "order": "desc",
      "order_by": "latest",
      "series_status": "Ongoing",
      "series_type": "Comic"
    });
    request.headers.addAll(_headers(source));

    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    List<Data>? data;
    if (res.startsWith("{")) {
      var popularManga = jsonDecode(res) as Map<String, dynamic>;
      var popularMangaList = HeanCmsSearchModel.fromJson(popularManga);
      data = popularMangaList.data!;
    } else {
      var popularManga = jsonDecode(res) as List;
      data = popularManga.map((e) => Data.fromJson(e)).toList();
    }

    for (var a in data) {
      final status = parseHeanCmsStatus(a.status!);
      statusList.add(status);
      image.add(a.thumbnail!.startsWith("https://")
          ? a.thumbnail
          : "${getMangaAPIUrl(source)}cover/${a.thumbnail}");
      name.add(a.title);
      url.add("/series/${a.seriesSlug!.replaceAll(timeStampRegex, '')}");
    }

    return mangaRes();
  }
}
