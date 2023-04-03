import 'dart:async';
import 'dart:developer';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

class GetMangaDetailModel {
  List<String> genre = [];
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? author;
  String? status;
  String? source;
  String? url;
  String? name;
  String? imageUrl;
  String? description;
  GetMangaDetailModel({
    required this.genre,
    required this.author,
    required this.status,
    required this.chapterDate,
    required this.chapterTitle,
    required this.chapterUrl,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.name,
    required this.source,
  });
}

@riverpod
Future<GetMangaDetailModel> getMangaDetail(GetMangaDetailRef ref,
    {required String imageUrl,
    required String url,
    required String name,
    required String lang,
    required String source}) async {
  List<String> genre = [];
  String? author;
  String? status;
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  source = source.toLowerCase();
  String? description;
  if (source == "mangahere") {
    final dom = await httpResToDom(
        url: "http://www.mangahere.cc$url",
        headers: {
          "Referer": "https://www.mangahere.cc/",
          "Cookie": "isAdult=1"
        });

    if (dom
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
          .map((e) => e.text.trim())
          .toList();

      status = tt[0];
    } else {
      status = "";
    }
    if (dom
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-say > a')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-say > a')
          .map((e) => e.text.trim())
          .toList();

      author = tt[0];
    } else {
      author = "";
    }

    if (dom
        .querySelectorAll(
            'body > div > div > div.detail-info-right > p.detail-info-right-content')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll(
              'body > div > div > div.detail-info-right > p.detail-info-right-content')
          .map((e) => e.text.trim())
          .toList();

      description = tt.first;
    }

    if (dom.querySelectorAll('ul > li > a').isNotEmpty) {
      final udl = dom
          .querySelectorAll('ul > li > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      for (var ok in udl) {
        chapterUrl.add(ok!);
      }
    }
    if (dom.querySelectorAll('ul > li > a > div > p.title3').isNotEmpty) {
      final tt = dom
          .querySelectorAll('ul > li > a > div > p.title3')
          .map((e) => e.text.trim())
          .toList();
      for (var ok in tt) {
        chapterTitle.add(ok);
      }
    }
    if (dom.querySelectorAll('ul > li > a > div > p.title2').isNotEmpty) {
      final tt = dom
          .querySelectorAll('ul > li > a > div > p.title2')
          .map((e) => e.text.trim())
          .toList();
      for (var ok in tt) {
        chapterDate.add(ok);
      }
    }
    if (dom
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-tag-list > a')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-tag-list > a')
          .map((e) => e.text.trim())
          .toList();

      for (var ok in tt) {
        genre.add(ok);
      }
    }
  }

  return GetMangaDetailModel(
    chapterDate: chapterDate,
    chapterTitle: chapterTitle,
    chapterUrl: chapterUrl,
    status: status,
    genre: genre,
    author: author,
    description: description,
    name: name,
    url: url,
    source: source,
    imageUrl: imageUrl,
  );
}
