import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/comick/search_manga_cimick.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'search_manga.g.dart';

class SearchMangaModel {
  late List<String?> url;
  late List<String?> name;
  late List<String?> image;

  SearchMangaModel({
    required this.name,
    required this.url,
    required this.image,
  });
}

@riverpod
Future<SearchMangaModel> searchManga(SearchMangaRef ref,
    {required String source, required String query}) async {
  List<String?> url = [];
  List<String?> name = [];
  List<String?> image = [];
  source = source.toLowerCase();

  /********/
  /*comick*/
  /********/
  if (getWpMangTypeSource(source) == TypeSource.comick) {
    var headers = {
      'Referer': 'https://comick.app/',
      'User-Agent':
          'Tachiyomi Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\\\$userAgentRandomizer1.0.4\\\$userAgentRandomizer3.1\\\$userAgentRandomizer2 Safari/537.36'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.comick.fun/search?q=${query.trim()}&tachiyomi=true&page=1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var popularManga =
          jsonDecode(await response.stream.bytesToString()) as List;
      var popularMangaList =
          popularManga.map((e) => MangaSearchModelComick.fromJson(e)).toList();
      for (var popular in popularMangaList) {
        url.add("/comic/${popular.slug}");
        name.add(popular.title);
        image.add(popular.coverUrl);
      }
    }
  }

  /***************/
  /*mangathemesia*/
  /***************/
  else if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpResToDom(
        url: '${getWpMangaUrl(source)}/?s=${query.trim()}', headers: {});

    if (dom
        .querySelectorAll(
            '#content > div > div.postbody > div > div.listupd > div > div > a')
        .isNotEmpty) {
      url = dom
          .querySelectorAll(
              '#content > div > div.postbody > div > div.listupd > div > div > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      image = dom
          .querySelectorAll(
              ' #content > div > div.postbody > div > div.listupd > div > div > a > div > img')
          .where((e) => e.attributes.containsKey('src'))
          .map((e) => e.attributes['src'])
          .toList();

      name = dom
          .querySelectorAll(
              '#content > div > div.postbody > div > div.listupd > div > div > a ')
          .where((e) => e.attributes.containsKey('title'))
          .map((e) => e.attributes['title'])
          .toList();
    }
  }
  /***********/
  /*mangakawaii*/
  /***********/
  else if (source == "mangakawaii") {
    final dom = await httpResToDom(
        url:
            'https://www.mangakawaii.io/search?query=${query.trim()}&search_type=manga',
        headers: {'Accept-Language': 'fr'});

    if (dom
        .querySelectorAll(
            '#page-content > div > div > ul > li > div.section__list-group-right > div.section__list-group-header > div > h4 > a')
        .isNotEmpty) {
      final ur = dom
          .querySelectorAll(
              '#page-content > div > div > ul > li > div.section__list-group-right > div.section__list-group-header > div > h4 > a')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      for (var a in ur) {
        url.add(a!);
      }

      final nam = dom
          .querySelectorAll(
              '#page-content > div > div > ul > li > div.section__list-group-right > div.section__list-group-header > div > h4 > a')
          .map((e) => e.text)
          .toList();
      for (var a in nam) {
        name.add(a);
        image.add('');
      }
    }
  }
  /***********/
  /*mmrcms*/
  /***********/
  else if (getWpMangTypeSource(source) == TypeSource.mmrcms) {
    final response = await http.get(
        Uri.parse('${getWpMangaUrl(source)}/search?query=${query.trim()}'));
    final rep = jsonDecode(response.body);
    for (var ok in rep['suggestions']) {
      if (source == 'Read Comics Online') {
        url.add('${getWpMangaUrl(source)}/comic/${ok['data']}');
      } else if (source == 'Scan VF') {
        url.add('${getWpMangaUrl(source)}/${ok['data']}');
      } else {
        url.add('${getWpMangaUrl(source)}/manga/${ok['data']}');
      }
      name.add(ok["value"]);
      image.add('');
    }
  }
  /***********/
  /*mangahere*/
  /***********/
  else if (source == "mangahere") {
    final dom = await httpResToDom(
        url:
            '${getWpMangaUrl(source)}/search?title=${query.trim()}&genres=&nogenres=&sort=&stype=1&name=&type=0&author_method=cw&author=&artist_method=cw&artist=&rating_method=eq&rating=&released_method=eq&released=&st=0',
        headers: {});
    if (dom
        .querySelectorAll(
            'body > div.container > div > div > ul > li > p.manga-list-4-item-title > a')
        .isNotEmpty) {
      url = dom
          .querySelectorAll(
              'body > div.container > div > div > ul > li > p.manga-list-4-item-title > a')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      image = dom
          .querySelectorAll(
              'body > div.container > div > div > ul > li > a > img')
          .where((e) => e.attributes.containsKey('src'))
          .where((e) => e.attributes['src']!.contains("cover"))
          .map((e) => e.attributes['src'])
          .toList();

      name = dom
          .querySelectorAll(
              'body > div.container > div > div > ul > li > p.manga-list-4-item-title > a')
          .where((e) => e.attributes.containsKey('title'))
          .map((e) => e.attributes['title'])
          .toList();
    }
  }

  return SearchMangaModel(name: name, url: url, image: image);
}
