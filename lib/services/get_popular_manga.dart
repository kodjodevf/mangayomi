import 'dart:async';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
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

@riverpod
Future<GetMangaModel> getPopularManga(GetPopularMangaRef ref,
    {required String source, required int page}) async {
  List<String?> url = [];
  List<String?> name = [];
  List<String?> image = [];

  //mangahere
  if (source == "mangahere") {
    final dom = await httpResToDom(url: 'https://www.mangahere.cc/ranking/');
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
