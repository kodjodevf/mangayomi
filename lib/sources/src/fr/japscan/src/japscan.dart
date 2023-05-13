// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'package:html/dom.dart' as dom;
import 'package:html/dom.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/cloudflare/cloudflare_bypass.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:collection/collection.dart';

class Japscan extends MangaYomiServices {
  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source}) async {
    final dom = await httpGet(url: manga.url!, source: source, resDom: true)
        as Document?;
    if (dom!.querySelectorAll('.col-7 > p').isNotEmpty) {
      final images =
          dom.querySelectorAll('.col-5 ').map((e) => e.outerHtml).toList();
      RegExp exp = RegExp(r'src="([^"]+)"');

      String? srcValue = exp.firstMatch(images[0])?.group(1);
      manga.imageUrl = 'https://www.japscan.lol$srcValue';

      if (dom.querySelectorAll('.col-7 > p').isNotEmpty) {
        final stat = dom
            .querySelectorAll('.col-7 > p')
            .where((element) => element.innerHtml.contains('Statut:'))
            .map((e) => e.text)
            .toList();
        if (stat.isNotEmpty) {
          status = stat[0].replaceAll('Statut:', '').trim();
        }

        final auth = dom
            .querySelectorAll('.col-7 > p')
            .where((element) => element.innerHtml.contains('Auteur(s):'))
            .map((e) => e.text)
            .toList();
        if (auth.isNotEmpty) {
          author = auth[0].replaceAll('Auteur(s):', '').trim();
        }
      } else {
        author = "";
        status = "";
      }

      final genres = dom
          .querySelectorAll('.col-7 > p')
          .where((element) => element.innerHtml.contains('Genre(s):'))
          .map((e) => e.text.replaceAll('Genre(s):', '').trim())
          .toList();
      if (genres.isNotEmpty) {
        for (var ok in genres[0].split(',')) {
          genre.add(ok);
        }
      }

      final synop = dom
          .querySelectorAll('p.list-group-item ')
          .map((e) => e.text.trim())
          .toList();
      if (synop.isNotEmpty) {
        description = synop[0];
      }
    }

    final urls =
        dom.querySelectorAll('.col-8 ').map((e) => e.outerHtml).toList();

    for (var ok in urls) {
      RegExp exp = RegExp(r'href="([^"]+)"');

      String? srcValue = exp.firstMatch(ok)?.group(1);
      chapterUrl.add('https://www.japscan.lol$srcValue');
    }

    final chapterTitlee =
        dom.querySelectorAll('.col-8').map((e) => e.text.trim()).toList();

    if (chapterTitlee.isNotEmpty) {
      for (var ok in chapterTitlee) {
        chapterTitle.add(ok);
      }
    }

    final chapterDatee =
        dom.querySelectorAll('.col-4').map((e) => e.text.trim()).toList();
    if (chapterDatee.isNotEmpty) {
      for (var ok in chapterDatee) {
        chapterDate.add(parseDate(ok, source));
      }
    }
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source, required int page}) async {
    final dom = await httpGet(
        url: "https://www.japscan.lol/",
        source: source,
        resDom: true) as Document?;
    if (dom!.querySelectorAll('#top_mangas_week > ul > li ').isNotEmpty) {
      final urls = dom
          .querySelectorAll('#top_mangas_week > ul > li > a')
          .where((e) => e.attributes['href'].toString().contains('manga'))
          .map((e) => e.attributes['href'])
          .toList();
      for (var ok in urls) {
        url.add("https://www.japscan.lol$ok");
      }
      name = dom
          .querySelectorAll(
              '#top_mangas_week > ul > li > a.text-dark.font-weight-bold')
          .map((e) => e.innerHtml)
          .toList();
      for (var ia in name) {
        image.add("");
      }
    }
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source, required String query}) async {
    final dom = await httpGet(
        url: "https://www.google.com/search?q=${query.toLowerCase()}+japscan",
        source: source,
        resDom: true) as Document?;

    if (dom!.querySelectorAll("div > div > div > div > div > a").isNotEmpty) {
      final urls = dom
          .querySelectorAll("div > div > div > div > div > a")
          .where((e) => e.attributes.containsKey('href'))
          .where((element) =>
              element.text.toLowerCase().contains("https://www.japscan."))
          .map((e) => e.attributes['href']
              .toString()
              .replaceAll('lecture-en-ligne', 'manga')
              .split("/"))
          .toList();
      List<String?> tt = [];
      List<String?> ta = [];
      for (var ok in urls) {
        tt.add("${ok[0]}//${ok[2]}/${ok[3]}/${ok[4]}/");
        ta.add(ok[4]
            .replaceAll('-', " ")
            .toString()
            .split(' ')
            .map((word) =>
                word.substring(0, 1).toUpperCase() + word.substring(1))
            .join(' '));
      }
      name = ta.toSet().toList();
      url = tt.toSet().toList();
      for (var a in url) {
        image.add("");
      }
    }
    return mangaRes();
  }

  @override
  Future<List<dynamic>> getMangaChapterUrl({required Chapter chapter}) async {
    final response = await httpGet(
        useUserAgent: true,
        url: chapter.url!,
        source: "japscan",
        resDom: false) as String?;
    RegExp regex = RegExp(r'<script src="/zjs/(.*?)"');
    Match? match = regex.firstMatch(response!);
    String zjsurl = match!.group(1)!;
    baseUrl = response;
    zjsUrl = "https://www.japscan.lol/zjs/$zjsurl";
    zjs();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true) {
        return false;
      }
      return true;
    });
    return pageUrls;
  }

  bool isOk = false;
  String? baseUrl;
  String? zjsUrl;
  zjs() async {
    final html = await cloudflareBypassHtml(
        url: zjsUrl!, source: "japscan", useUserAgent: true);
    dom.Document htmll = dom.Document.html(baseUrl!);
    final strings = html
        .replaceAll(RegExp(r'\\[(.*?)\\]'), '')
        .split(",")
        .map((s) => s.trim().replaceAll("'", "").split('').reversed.join());
    final stringLookupTables = strings
        .where((s) =>
            s.length == 62 &&
            s.split('').toSet().toList().sorted().join() ==
                "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        .toList();

    if (stringLookupTables.length != 2) {
      throw Exception("Expected only two lookup tables in ZJS");
    }

    final scrambledData =
        htmll.getElementById("data")!.attributes['data-data']!;

    for (var i = 0; i <= 1; i++) {
      final otherIndex = i == 0 ? 1 : 0;

      final lookupTable = Map.fromIterables(stringLookupTables[i].split(''),
          stringLookupTables[otherIndex].split(''));
      try {
        final unscrambledData = scrambledData
            .split('')
            .map((char) => lookupTable[char] ?? char)
            .join();
        final decoded = utf8.decode(base64.decode(unscrambledData));
        final data = jsonDecode(decoded);
        pageUrls = data["imagesLink"].map((it) => it).toList();
      } catch (_) {}
    }
    isOk = true;
  }
}
