import 'dart:convert';
import 'package:html/dom.dart';
import 'package:mangayomi/models/comick/search_manga_cimick.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
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
  }

  /***************/
  /*mangathemesia*/
  /***************/
  else if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpGet(
        url: '${getWpMangaUrl(source)}/?s=${query.trim()}',
        source: source,
        resDom: true) as Document?;
    if (dom!
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
    final dom = await httpGet(
        url:
            'https://www.mangakawaii.io/search?query=${query.trim()}&search_type=manga',
        source: source,
        resDom: true) as Document?;
    if (dom!
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
    final response = await httpGet(
        url: '${getWpMangaUrl(source)}/search?query=${query.trim()}',
        source: source,
        resDom: false) as String?;
    final rep = jsonDecode(response!);
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
    final dom = await httpGet(
        url:
            '${getWpMangaUrl(source)}/search?title=${query.trim()}&genres=&nogenres=&sort=&stype=1&name=&type=0&author_method=cw&author=&artist_method=cw&artist=&rating_method=eq&rating=&released_method=eq&released=&st=0',
        source: source,
        resDom: true) as Document?;

    if (dom!
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
