import 'dart:async';
import 'dart:developer';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
import 'package:mangayomi/source/source_model.dart';
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
  if (getWpMangTypeSource(source) == TypeSource.mangathemesia) {
    final dom = await httpResToDom(url: url, headers: {});
    if (dom
        .querySelectorAll(
            'div.bigcontent, div.animefull, div.main-info, div.postbody')
        .isNotEmpty) {
      final resHtml = dom.querySelector(
          'div.bigcontent, div.animefull, div.main-info, div.postbody');
      if (resHtml!.querySelectorAll('.tsinfo .imptdt').isNotEmpty) {
        status = resHtml
            .querySelectorAll('.tsinfo .imptdt')
            .where((e) =>
                e.innerHtml.contains("Status") ||
                e.innerHtml.contains("Situação"))
            .map((e) => e.innerHtml.contains("Situação")
                ? e.text.replaceAll('Situação', '').trim()
                : e.text.replaceAll('Status', '').trim())
            .toList()
            .last;
      } else if (resHtml.querySelectorAll('.infotable tr').isNotEmpty) {
        status = resHtml
            .querySelectorAll('.infotable tr')
            .where((e) =>
                e.innerHtml.toLowerCase().contains('statut') ||
                e.innerHtml.toLowerCase().contains('status'))
            .map((e) => e.querySelector('td:last-child')!.text)
            .toList()
            .first;
      } else if (resHtml.querySelectorAll('.fmed').isNotEmpty) {
        status = resHtml
            .querySelectorAll('.tsinfo .imptdt')
            .map((e) => e.text.replaceAll('Status', '').trim())
            .toList()
            .first;
      } else {
        status = "";
      }

      //2
      if (resHtml.querySelectorAll('.fmed').isNotEmpty) {
        author = resHtml
            .querySelectorAll('.fmed')
            .where((e) => e.innerHtml.contains("Author"))
            .map((e) => e.text.replaceAll('Author', '').trim())
            .toList()
            .first;
      } else if (resHtml.querySelectorAll('.tsinfo .imptdt').isNotEmpty) {
        author = resHtml
            .querySelectorAll('.tsinfo .imptdt')
            .where((e) =>
                e.innerHtml.contains("Author") ||
                e.innerHtml.contains("Auteur") ||
                e.innerHtml.contains("Autor"))
            .map((e) => e.innerHtml.contains("Autor")
                ? e.text.replaceAll('Autor', '').trim()
                : e.innerHtml.contains("Autheur")
                    ? e.text.replaceAll('Auteur', '').trim()
                    : e.text.replaceAll('Author', '').trim())
            .toList()
            .first;
      } else if (resHtml.querySelectorAll('.infotable tr').isNotEmpty) {
        author = resHtml
            .querySelectorAll('.infotable tr')
            .where((e) =>
                e.innerHtml.toLowerCase().contains('auteur') ||
                e.innerHtml.toLowerCase().contains('author'))
            .map((e) => e.querySelector('td:last-child')!.text)
            .toList()
            .first;
      } else {
        author = "";
      }

      description = resHtml
          .querySelector(".desc, .entry-content[itemprop=description]")!
          .text;
      if (resHtml
          .querySelectorAll('div.gnr a, .mgen a, .seriestugenre a')
          .isNotEmpty) {
        final tt = resHtml
            .querySelectorAll('div.gnr a, .mgen a, .seriestugenre a')
            .map((e) => e.text.trim())
            .toList();

        for (var ok in tt) {
          genre.add(ok);
        }
      } else {
        genre.add('');
      }
      if (resHtml.querySelectorAll('#chapterlist a').isNotEmpty) {
        final udl = resHtml
            .querySelectorAll('#chapterlist a ')
            .where((e) => e.attributes.containsKey('href'))
            .map((e) => e.attributes['href'])
            .toList();

        for (var ok in udl) {
          chapterUrl.add(ok!);
        }
      }
      if (resHtml.querySelectorAll('.lch a, .chapternum').isNotEmpty) {
        final tt = resHtml
            .querySelectorAll('.lch a, .chapternum')
            .map((e) => e.text.trim())
            .toList();

        tt.removeWhere((element) => element.contains('{{number}}'));
        for (var ok in tt) {
          chapterTitle.add(ok.trimLeft());
        }
      }
      if (resHtml.querySelectorAll('.chapterdate').isNotEmpty) {
        final tt = resHtml
            .querySelectorAll('.chapterdate')
            .map((e) => e.text.trim())
            .toList();
        tt.removeWhere((element) => element.contains('{{date}}'));
        for (var ok in tt) {
          chapterDate.add(ok);
        }
      }
    }
  } else if (source == "mangahere") {
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
