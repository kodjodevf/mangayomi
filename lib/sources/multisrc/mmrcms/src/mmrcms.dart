import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/multisrc/mmrcms/src/utils.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class Mmrcms extends MangaYomiServices {
  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(
        httpGetProvider(url: manga.url!, source: source, resDom: true)
            .future) as Document?;
    description = dom!
        .querySelectorAll('.row .well p')
        .map((e) => e.text.trim())
        .toList()
        .first;
    status = mmrcmsStatusParser(dom
        .querySelectorAll('.row .dl-horizontal dt')
        .where((e) =>
            e.innerHtml.toString().toLowerCase().contains("status") ||
            e.innerHtml.toString().toLowerCase().contains("statut") ||
            e.innerHtml.toString().toLowerCase().contains("estado") ||
            e.innerHtml.toString().toLowerCase().contains("durum"))
        .map((e) => e.nextElementSibling!.text.trim())
        .toList()
        .first);
    if (dom.querySelectorAll(".row .dl-horizontal dt").isNotEmpty) {
      author = dom
          .querySelectorAll('.row .dl-horizontal dt')
          .where((e) =>
              e.innerHtml.toString().toLowerCase().contains("auteur(s)") ||
              e.innerHtml.toString().toLowerCase().contains("author(s)") ||
              e.innerHtml.toString().toLowerCase().contains("autor(es)") ||
              e.innerHtml.toString().toLowerCase().contains("yazar(lar)") ||
              e.innerHtml.toString().toLowerCase().contains("mangaka(lar)") ||
              e.innerHtml
                  .toString()
                  .toLowerCase()
                  .contains("pengarang/penulis") ||
              e.innerHtml.toString().toLowerCase().contains("autor") ||
              e.innerHtml.toString().toLowerCase().contains("penulis"))
          .map((e) => e.nextElementSibling!.text
              .trim()
              .replaceAll(RegExp(r"\s+\b|\b\s"), ""))
          .toList()
          .first;
      final genr = dom
          .querySelectorAll('.row .dl-horizontal dt')
          .where((e) =>
              e.innerHtml.toString().toLowerCase().contains("categories") ||
              e.innerHtml.toString().toLowerCase().contains("categorías") ||
              e.innerHtml.toString().toLowerCase().contains("catégories") ||
              e.innerHtml.toString().toLowerCase().contains("kategoriler") ||
              e.innerHtml.toString().toLowerCase().contains("categorias") ||
              e.innerHtml.toString().toLowerCase().contains("kategorie") ||
              e.innerHtml.toString().toLowerCase().contains("kategori") ||
              e.innerHtml.toString().toLowerCase().contains("tagi"))
          .map((e) => e.nextElementSibling!.text.trim())
          .toList();
      if (genr.isNotEmpty) {
        genre = genr.first.replaceAll(RegExp(r"\s+\b|\b\s"), "").split(',');
      }
    }
    final rrr = dom.querySelectorAll(".row [class^=img-responsive]");
    final data = rrr.map((e) => e.outerHtml).toList();
    if (source.toLowerCase() == 'jpmangas' ||
        source.toLowerCase() == 'fr scan') {
      manga.imageUrl = regSrcMatcher(data.first).replaceAll('//', 'https://');
    } else {
      manga.imageUrl = regSrcMatcher(data.first);
    }

    final ttt = dom
        .querySelectorAll("ul[class^=chapters] > li:not(.btn), table.table tr");
    if (ttt.isNotEmpty) {
      final data = ttt
          .map((e) => e.querySelector("[class^=chapter-title-rtl]")!)
          .toList();
      var name = data;
      for (var iaa in name) {
        chapterTitle.add(iaa.getElementsByTagName("a").first.text);
        chapterUrl
            .add(regHrefMatcher(iaa.getElementsByTagName("a").first.outerHtml));
      }
      final date = ttt
          .map((e) => e
              .getElementsByClassName("date-chapter-title-rtl")
              .map((e) => e.text.trim())
              .first)
          .toList();

      for (var da in date) {
        chapterDate.add(parseDate(da, source));
      }
    }
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url:
                '${getMangaBaseUrl(source)}/filterList?page=$page&sortBy=views&asc=false',
            source: source,
            resDom: true)
        .future) as Document?;
    final urlElement = dom!.getElementsByClassName('chart-title');
    for (var e in urlElement) {
      RegExp exp = RegExp(r'href="([^"]+)"');
      Iterable<Match> matches = exp.allMatches(e.outerHtml);
      String? firstMatch = matches.first.group(1);
      url.add(firstMatch);
      name.add(e.text);
    }
    final imgElement = dom.getElementsByTagName('img');
    for (var e in imgElement) {
      RegExp exp = RegExp(r'src="([^"]+)"');
      Iterable<Match> matches = exp.allMatches(e.outerHtml);
      String? firstMatch = matches.first.group(1);
      image.add(firstMatch);
    }
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required AutoDisposeFutureProviderRef ref}) async {
    final response = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/search?query=${query.trim()}',
            source: source,
            resDom: false)
        .future) as String?;
    final rep = jsonDecode(response!);
    for (var ok in rep['suggestions']) {
      if (source == 'Read Comics Online') {
        url.add('${getMangaBaseUrl(source)}/comic/${ok['data']}');
      } else if (source == 'Scan VF') {
        url.add('${getMangaBaseUrl(source)}/${ok['data']}');
      } else {
        url.add('${getMangaBaseUrl(source)}/manga/${ok['data']}');
      }
      name.add(ok["value"]);
      image.add('');
    }
    return mangaRes();
  }

  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await await ref.watch(httpGetProvider(
            useUserAgent: true,
            url: chapter.url!,
            source: chapter.manga.value!.source!.toLowerCase(),
            resDom: true)
        .future) as Document?;
    if (dom!.querySelectorAll('#all > .img-responsive').isNotEmpty) {
      pageUrls = dom.querySelectorAll('#all > .img-responsive').map((e) {
        final RegExp regexx = RegExp(r'data-src="([^"]+)"');
        if (chapter.manga.value!.source!.toLowerCase() == 'fr scan' ||
            chapter.manga.value!.source!.toLowerCase() == 'jpmangas') {
          return regexx
              .allMatches(e.outerHtml)
              .first
              .group(1)!
              .replaceAll('//', 'https://')
              .replaceAll(RegExp(r"\s+\b|\b\s"), "")
              .replaceAll("https:https://", "https://");
        }
        return regexx
            .allMatches(e.outerHtml)
            .first
            .group(1)!
            .replaceAll(RegExp(r"\s+\b|\b\s"), "")
            .replaceAll("https:https://", "https://");
      }).toList();
    }
    return pageUrls;
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/latest-release?page=$page',
            source: source,
            resDom: true)
        .future) as Document?;
    final urlElement = dom!.querySelectorAll("div.mangalist div.manga-item");

    for (var e in urlElement) {
      RegExp exp = RegExp(r'href="([^"]+)"');
      Iterable<Match> matches = exp.allMatches(e.querySelector("a")!.outerHtml);
      String? firstMatch = matches.first.group(1);
      url.add(firstMatch);
      name.add(e.querySelector("a")!.text);
      image.add(
          "${getMangaBaseUrl(source)}/uploads/manga/${firstMatch!.split('/').last}/cover/cover_250x350.jpg");
    }
    return mangaRes();
  }
}
