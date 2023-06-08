import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/chapter.dart' as mdx;
import 'package:mangayomi/sources/src/all/mangadex/model/cover.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/aggregate.dart';
import 'package:mangayomi/sources/src/all/mangadex/model/get_chapter_url.dart'
    as get_chap_url;
import 'package:mangayomi/sources/src/all/mangadex/model/manga.dart'
    as manga_dx;
import 'package:mangayomi/sources/src/all/mangadex/model/mdx_detail.dart'
    as mdx_detail;
import 'package:mangayomi/sources/src/all/mangadex/src/utils/utils.dart';
import 'package:mangayomi/sources/utils/utils.dart';

class MangaDex extends MangaYomiServices {
  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    String chapterId = chapter.url!.split('/').last;
    String source = chapter.manga.value!.source!;
    final response = await ref.watch(httpGetProvider(
            url: '${getMangaAPIUrl(source)}/at-home/server/$chapterId',
            source: source,
            resDom: false)
        .future) as String?;
    final result = jsonDecode(response!) as Map<String, dynamic>;
    final atHome = get_chap_url.GetChapterUrl.fromJson(result);
    final host = atHome.baseUrl;
    final hash = atHome.chapter!.hash!;
    List<String> pageSuffix = [];
    for (var data in atHome.chapter!.data!) {
      pageSuffix.add("/data/$hash/$data");
    }
    for (var url in pageSuffix) {
      pageUrls.add("$host$url");
    }

    return pageUrls;
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/chapter?limit=20&offset=${(20 * (page - 1))}&translatedLanguage[]=$lang&includeFutureUpdates=0${getMDXContentRating()}&order[publishAt]=desc&includeFuturePublishAt=0&includeEmptyPages=0',
      source: source,
      resDom: false,
    ).future) as String?;
    final result = jsonDecode(response!) as Map<String, dynamic>;
    final chapterList = mdx.ChapterMDX.fromJson(result);
    List<String> mangaIds = [];
    for (var element in chapterList.data!) {
      for (var el in element.relationships!) {
        mangaIds.add(el.id!);
      }
    }
    mangaIds = mangaIds.toSet().toList();
    String manga = "";
    for (var id in mangaIds) {
      manga = "$manga&ids[]=$id";
    }

    final mangaResponse = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/manga?includes[]=cover_art&limit=${mangaIds.length}${getMDXContentRating()}$manga',
      source: source,
      resDom: false,
    ).future) as String?;
    final res = jsonDecode(mangaResponse!) as Map<String, dynamic>;
    final resultt = manga_dx.MangaDexDto.fromJson(res);

    final firstVolumeCovers =
        await fetchFirstVolumeCovers(resultt.data, source, ref);
    for (var da in resultt.data!) {
      url.add("/manga/${da.id}");
      name.add(findTitle(da.attributes!.altTitles, da.attributes!.title, lang));
      image.add(
          "https://uploads.mangadex.org/covers/${da.id}/${getFileName(da.id!, resultt.data, firstVolumeCovers)}");
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
          '${getMangaAPIUrl(source)}${manga.url}?includes[]=cover_art&includes[]=author&includes[]=artist',
      source: source,
      resDom: false,
    ).future) as String?;
    final res = jsonDecode(response!) as Map<String, dynamic>;
    final result = mdx_detail.MDXDetail.fromJson(res);
    final aggregate = await fetchSimpleChapterList(result, lang, source, ref);

    List<String> authors = [];
    for (var element in result.data!.relationships!) {
      if (element.attributes != null) {
        authors.add(element.attributes!.name ?? "");
      }
    }
    final attr = result.data!.attributes!;
    author = authors.join(", ");
    Map<String, dynamic>? descrip = attr.description;
    description = descrip![lang] ?? descrip["en"] ?? "";
    for (var element in attr.tags!) {
      if (element.attributes != null) {
        genre.add(element.attributes!.name!.en!);
      }
    }
    genre = [
      ...genre,
      attr.publicationDemographic ?? "",
      attr.contentRating != null && attr.contentRating!.toLowerCase() != "safe"
          ? "Content rating: ${attr.contentRating}"
          : ""
    ].where((element) => element.isNotEmpty).toList();

    status = getPublicationStatus(aggregate, attr);
    String mangaId = manga.url!.split('/').last;
    final paginatedChapterList =
        await paginatedChapterListRequest(mangaId, 0, ref, source, lang);
    final rres = jsonDecode(paginatedChapterList) as Map<String, dynamic>;
    final chapterListResponse = mdx.ChapterMDX.fromJson(rres);
    final chapterListResults = chapterListResponse.data;
    var limit = chapterListResponse.limit!;
    var offset = chapterListResponse.offset!;
    var hasMoreResults = (limit + offset) < chapterListResponse.total!;

    while (hasMoreResults) {
      offset += limit;
      var newRequest =
          await paginatedChapterListRequest(mangaId, offset, ref, source, lang);
      final rres = jsonDecode(newRequest) as Map<String, dynamic>;
      var newChapterList = mdx.ChapterMDX.fromJson(rres);

      chapterListResults!.addAll(newChapterList.data!);
      hasMoreResults = (limit + offset) < newChapterList.total!;
    }

    for (var chapterData in chapterListResults!) {
      List<String> chapName = [];
      var chapAttr = chapterData.attributes!;
      if (chapAttr.volume != null && chapAttr.volume!.isNotEmpty) {
        chapName.add("Vol.${chapAttr.volume}");
      }
      if (chapAttr.chapter != null && chapAttr.chapter!.isNotEmpty) {
        chapName.add("Ch.${chapAttr.chapter}");
      }
      if (chapAttr.title != null && chapAttr.title!.isNotEmpty) {
        if (chapName.isNotEmpty) {
          chapName.add("-");
        }
        chapName.add(chapAttr.title!);
      }
      if (chapName.isEmpty) {
        chapName.add("Oneshot");
      }
      chapterUrl.add("/chapter/${chapterData.id}");
      chapterTitle.add(chapName.join(" "));
      chapterDate.add(parseDate(chapAttr.publishAt!, source));
    }

    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/manga?limit=20&offset=${(20 * (page - 1))}&availableTranslatedLanguage[]=$lang&includes[]=cover_art${getMDXContentRating()}&order[followedCount]=desc',
      source: source,
      resDom: false,
    ).future) as String?;
    final res = jsonDecode(response!) as Map<String, dynamic>;
    final result = manga_dx.MangaDexDto.fromJson(res);

    final firstVolumeCovers =
        await fetchFirstVolumeCovers(result.data, source, ref);
    for (var da in result.data!) {
      url.add("/manga/${da.id}");
      name.add(findTitle(da.attributes!.altTitles, da.attributes!.title, lang));
      image.add(
          "https://uploads.mangadex.org/covers/${da.id}/${getFileName(da.id!, result.data, firstVolumeCovers)}");
    }

    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/manga?includes[]=cover_art&offset=0&limit=20&title=${query.toLowerCase().trim()}${getMDXContentRating()}&order[followedCount]=desc&availableTranslatedLanguage[]=$lang',
      source: source,
      resDom: false,
    ).future) as String?;
    final res = jsonDecode(response!) as Map<String, dynamic>;
    final resultt = manga_dx.MangaDexDto.fromJson(res);
    final firstVolumeCovers =
        await fetchFirstVolumeCovers(resultt.data, source, ref);
    for (var da in resultt.data!) {
      url.add("/manga/${da.id}");
      name.add(findTitle(da.attributes!.altTitles, da.attributes!.title, lang));
      image.add(
          "https://uploads.mangadex.org/covers/${da.id}/${getFileName(da.id!, resultt.data, firstVolumeCovers)}");
    }

    return mangaRes();
  }

  Future<List<CoverData>?> fetchFirstVolumeCovers(List<manga_dx.Data>? data,
      String source, AutoDisposeFutureProviderRef ref) async {
    List<String> mangaIds = [];
    List<String> locales = [];
    for (var element in data!) {
      final attributes = element.attributes;
      if (attributes!.originalLanguage != null &&
          attributes.originalLanguage!.isNotEmpty) {
        mangaIds.add(element.id!);
        locales.add(attributes.originalLanguage!);
      }
    }

    int limit = (mangaIds.length * locales.length);
    if (limit > 100) {
      limit = 100;
    }
    String manga = "";
    for (var id in mangaIds) {
      manga = "$manga&manga[]=$id";
    }
    String locale = "";
    for (var loc in locales.toSet()) {
      locale = "$locale&locales[]=$loc";
    }
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/cover?order[volume]=asc&limit=$limit&offset=0$manga$locale',
      source: source,
      resDom: false,
    ).future) as String?;

    final res = jsonDecode(response!) as Map<String, dynamic>;

    final result = CoverAA.fromJson(res).data;
    result!.sort(
      (a, b) => a.relationships!.firstOrNull!.id!
          .compareTo(b.relationships!.firstOrNull!.id!),
    );

    return result.where((element) {
      return mangaIds.contains(element.relationships!.first.id);
    }).toList();
  }

  Future<Aggregate>? fetchSimpleChapterList(mdx_detail.MDXDetail? data,
      String lang, String source, AutoDisposeFutureProviderRef ref) async {
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/manga/${data!.data!.id}/aggregate?translatedLanguage[]=$lang',
      source: source,
      resDom: false,
    ).future) as String?;
    final res = jsonDecode(response!) as Map<String, dynamic>;

    return Aggregate.fromJson(res);
  }

  Future<String> paginatedChapterListRequest(String mangaId, int offset,
      AutoDisposeFutureProviderRef ref, String source, String lang) async {
    final response = await ref.watch(httpGetProvider(
      url:
          '${getMangaAPIUrl(source)}/manga/$mangaId/feed?limit=500&offset=$offset&includes[]=user&includes[]=scanlation_group&order[volume]=desc&order[chapter]=desc&translatedLanguage[]=$lang&includeFuturePublishAt=0&includeEmptyPages=0&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic',
      source: source,
      resDom: false,
    ).future) as String?;
    return response!;
  }
}
