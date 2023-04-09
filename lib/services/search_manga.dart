import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
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
  //mangathemesia
  if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
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
  //mangahere
  else if (source == "mangahere") {
    log("message");
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
