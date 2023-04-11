import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/comick/popular_manga_comick.dart';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
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
    var headers = {
      'Referer': 'https://comick.app/',
      'User-Agent':
          'Tachiyomi Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\\\$userAgentRandomizer1.0.4\\\$userAgentRandomizer3.1\\\$userAgentRandomizer2 Safari/537.36'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.comick.fun/v1.0/search?sort=follow&page=$page&tachiyomi=true'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var popularManga =
          jsonDecode(await response.stream.bytesToString()) as List;

      var popularMangaList =
          popularManga.map((e) => PopularMangaModelComick.fromJson(e)).toList();
      for (var popular in popularMangaList) {
        url.add("/comic/${popular.slug}");
        name.add(popular.title);
        image.add(popular.coverUrl);
      }
    } else {}
  }

  /***************/
  /*mangathemesia*/
  /**************/
  if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpResToDom(
        url: '${getWpMangaUrl(source)}/manga/?title=&page=$page&order=popular',
        headers: {});

    if (dom
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
    final dom =
        await httpResToDom(url: 'https://www.mangakawaii.io/', headers: {});
    if (dom.querySelectorAll('a.hot-manga__item').isNotEmpty) {
      url = dom
          .querySelectorAll('a.hot-manga__item ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      name = dom
          .querySelectorAll('a > div > div.hot-manga__item-name')
          .map((e) => e.innerHtml)
          .toList();
    }
  }
  
  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    final dom = await httpResToDom(
        url: 'https://www.mangahere.cc/ranking/', headers: {});
    if (dom
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
  return GetMangaModel(
    name: name,
    url: url,
    image: image,
  );
}
