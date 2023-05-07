// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:html/dom.dart';
import 'package:mangayomi/models/comick/popular_manga_comick.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/source/source_list.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_popular_manga.g.dart';

class GetMangaModel {
  late List<String?> url;
  late List<String?> name;
  late List<String?> image;
  GetMangaModel({
    required this.name,
    required this.url,
    required this.image,
  });
}

String getWpMangaUrl(String source) {
  String url = "";
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      url = sourcesList[i].url;
    }
  }
  return url;
}

TypeSource getWpMangTypeSource(String source) {
  TypeSource? typeSource;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      typeSource = sourcesList[i].typeSource;
    }
  }
  return typeSource!;
}

String getFormatDate(String source) {
  String? dateFormat;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      dateFormat = sourcesList[i].dateFormat;
    }
  }
  return dateFormat!;
}

String getFormatDateLocale(String source) {
  String? dateFormatLocale;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      dateFormatLocale = sourcesList[i].dateFormatLocale;
    }
  }
  return dateFormatLocale!;
}

bool isCloudflare(String source) {
  bool? isCloudflare;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      isCloudflare = sourcesList[i].isCloudflare;
    }
  }
  return isCloudflare!;
}

@riverpod
Future<GetMangaModel> getPopularManga(GetPopularMangaRef ref,
    {required String source, required int page}) async {
  List<String?> url = [];
  List<String?> name = [];
  List<String?> image = [];
  source = source.toLowerCase();

  /*********/
  /*comick*/
  /*******/
  if (getWpMangTypeSource(source) == TypeSource.comick) {
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
  }

  /***************/
  /*mangathemesia*/
  /**************/
  if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpGet(
        useUserAgent: true,
        url: '${getWpMangaUrl(source)}/manga/?title=&page=$page&order=popular',
        source: source,
        resDom: true) as Document?;
    if (dom!
        .querySelectorAll(
            '.utao .uta .imgu, .listupd .bs .bsx, .listo .bs .bsx')
        .isNotEmpty) {
      url = dom
          .querySelectorAll(
              '.utao .uta .imgu, .listupd .bs .bsx, .listo .bs .bsx')
          .map((e) {
        RegExp exp = RegExp(r'href="([^"]+)"');
        Iterable<Match> matches = exp.allMatches(e.innerHtml);
        String? firstMatch = matches.first.group(1);
        return firstMatch;
      }).toList();

      image = dom
          .querySelectorAll(
              '.utao .uta .imgu, .listupd .bs .bsx, .listo .bs .bsx')
          .map((e) {
        RegExp exp = RegExp(r'src="([^"]+)"');
        Iterable<Match> matches = exp.allMatches(e.innerHtml);
        String? firstMatch = matches.first.group(1);
        return firstMatch;
      }).toList();

      name = dom
          .querySelectorAll(
              '.utao .uta .imgu, .listupd .bs .bsx, .listo .bs .bsx ')
          .map((e) {
        RegExp exp = RegExp(r'title="([^"]+)"');
        Iterable<Match> matches = exp.allMatches(e.innerHtml);
        String? firstMatch = matches.first.group(1);
        return firstMatch;
      }).toList();
    }
  }

  /***********/
  /*mangakawaii*/
  /***********/
  if (source == "mangakawaii") {
    final dom = await httpGet(
        url: 'https://www.mangakawaii.io/',
        source: source,
        resDom: true) as Document?;
    if (dom!.querySelectorAll('a.hot-manga__item').isNotEmpty) {
      url = dom
          .querySelectorAll('a.hot-manga__item ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      name = dom
          .querySelectorAll('a > div > div.hot-manga__item-name')
          .map((e) => e.innerHtml)
          .toList();
      for (var ia in name) {
        image.add("");
      }
    }
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source) == TypeSource.mmrcms) {
    final dom = await httpGet(
        url:
            '${getWpMangaUrl(source)}/filterList?page=$page&sortBy=views&asc=false',
        source: source,
        resDom: true) as Document?;
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
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    final dom = await httpGet(
        url: 'https://www.mangahere.cc/ranking/',
        source: source,
        resDom: true) as Document?;
    if (dom!
        .querySelectorAll(
            'body > div.container.weekrank.ranking > div > div > ul > li > a')
        .isNotEmpty) {
      url = dom
          .querySelectorAll(
              'body > div.container.weekrank.ranking > div > div > ul > li > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      image = dom
          .querySelectorAll(
              ' body > div.container.weekrank.ranking > div > div > ul > li > a > img')
          .where((e) => e.attributes.containsKey('src'))
          .where((e) => e.attributes['src']!.contains("cover"))
          .map((e) => e.attributes['src'])
          .toList();

      name = dom
          .querySelectorAll(
              'body > div.container.weekrank.ranking > div > div > ul > li > a ')
          .where((e) => e.attributes.containsKey('title'))
          .map((e) => e.attributes['title'])
          .toList();
    }
  }
  /***********/
  /*japscan*/
  /***********/
  else if (source == "japscan") {
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
  }
  return GetMangaModel(
    name: name,
    url: url,
    image: image,
  );
}
