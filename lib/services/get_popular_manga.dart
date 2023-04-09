import 'dart:async';
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
  } else
  //mangahere
  if (source == "mangahere") {
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
