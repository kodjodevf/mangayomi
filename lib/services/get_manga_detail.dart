import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

class GetMangaDetailModel {
  List<String> genre = [];
  List<String> detail = [];
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? source;
  String? url;
  String? name;
  String? image;
  String? synopsys;
  GetMangaDetailModel({
    required this.genre,
    required this.detail,
    required this.chapterDate,
    required this.chapterTitle,
    required this.chapterUrl,
    required this.image,
    required this.synopsys,
    required this.url,
    required this.name,
    required this.source,
  });
}

@riverpod
Future<GetMangaDetailModel> getMangaDetail(GetMangaDetailRef ref,
    {required String image,
    required String url,
    required String name,
    String lang = '',
    required String source}) async {
  List<String> genre = [];
  List<String> detail = [];
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? synopsys;
  if (source == "mangahere") {
    final response = await http.get(Uri.parse("http://www.mangahere.cc$url"),
        headers: {
          "Referer": "https://www.mangahere.cc/",
          "Cookie": "isAdult=1"
        });
    dom.Document htmll = dom.Document.html(response.body);

    if (htmll
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
        .isNotEmpty) {
      final tt = htmll
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
          .map((e) => e.text.trim())
          .toList();

      detail.add(tt[0]);
    } else {
      detail.add("");
    }
    if (htmll
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-say > a')
        .isNotEmpty) {
      final tt = htmll
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-say > a')
          .map((e) => e.text.trim())
          .toList();

      detail.add(tt[0]);
    } else {
      detail.add("");
    }

    if (htmll
        .querySelectorAll(
            'body > div > div > div.detail-info-right > p.detail-info-right-content')
        .isNotEmpty) {
      final tt = htmll
          .querySelectorAll(
              'body > div > div > div.detail-info-right > p.detail-info-right-content')
          .map((e) => e.text.trim())
          .toList();

      synopsys = tt.first;
    }

    if (htmll.querySelectorAll('ul > li > a').isNotEmpty) {
      final udl = htmll
          .querySelectorAll('ul > li > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      for (var ok in udl) {
        chapterUrl.add(ok!);
      }
    }
    if (htmll.querySelectorAll('ul > li > a > div > p.title3').isNotEmpty) {
      final tt = htmll
          .querySelectorAll('ul > li > a > div > p.title3')
          .map((e) => e.text.trim())
          .toList();
      for (var ok in tt) {
        chapterTitle.add(ok);
      }
    }
    if (htmll.querySelectorAll('ul > li > a > div > p.title2').isNotEmpty) {
      final tt = htmll
          .querySelectorAll('ul > li > a > div > p.title2')
          .map((e) => e.text.trim())
          .toList();
      for (var ok in tt) {
        chapterDate.add(ok);
      }
    }
    if (htmll
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-tag-list > a')
        .isNotEmpty) {
      final tt = htmll
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
      detail: detail,
      genre: genre,
      image: image,
      synopsys: synopsys,
      name: name,
      url: url,
      source: source);
}
