import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mangayomi/models/comick/manga_chapter_detail.dart';
import 'package:mangayomi/models/comick/manga_detail_comick.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/services/get_popular_manga.dart';
import 'package:mangayomi/services/http_res_to_dom_html.dart';
import 'package:mangayomi/source/source_model.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_manga_detail.g.dart';

class GetMangaDetailModel {
  List<String> genre = [];
  List<ModelChapters> chapters = [];
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
    required this.chapters,
    required this.imageUrl,
    required this.description,
    required this.url,
    required this.name,
    required this.source,
  });
}

_parseStatut(int i) {
  if (i == 1) {
    return 'Ongoing';
  } else if (i == 2) {
    return 'Completed';
  } else if (i == 3) {
    return 'Canceled';
  } else if (i == 4) {
    return '';
  } else {
    return 'Unknown';
  }
}

Future findCurrentSlug(String oldSlug) async {
  var headers = {
    'Referer': 'https://comick.app/',
    'User-Agent':
        'Tachiyomi Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\\\$userAgentRandomizer1.0.4\\\$userAgentRandomizer3.1\\\$userAgentRandomizer2 Safari/537.36'
  };
  var request = http.Request('GET',
      Uri.parse('https://api.comick.fun/tachiyomi/mapping?slugs=$oldSlug'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return await response.stream.bytesToString();
  } else {
    return response.reasonPhrase;
  }
}

beautifyChapterName(String? vol, String? chap, String? title, String? lang) {
  return "${vol!.isNotEmpty ? chap!.isEmpty ? "Volume $vol " : "Vol. $vol " : ""}${chap!.isNotEmpty ? vol.isEmpty ? lang == "fr" ? "Chapitre $chap" : "Chapter $chap" : "Ch. $chap " : ""}${title!.isNotEmpty ? chap.isEmpty ? title : " : $title" : ""}";
}

@riverpod
Future<GetMangaDetailModel> getMangaDetail(GetMangaDetailRef ref,
    {required String imageUrl,
    required String url,
    required String title,
    required String lang,
    required String source}) async {
  List<String> genre = [];
  String? author;
  String? status;
  List<String> chapterTitle = [];
  List<String> chapterUrl = [];
  List<String> chapterDate = [];
  String? description;
  List<ModelChapters> chapters = [];
  /********/
  /*comick*/
  /********/
  if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.comick) {
    var headers = {
      'Referer': 'https://comick.app/',
      'User-Agent':
          'Tachiyomi Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/8\\\$userAgentRandomizer1.0.4\\\$userAgentRandomizer3.1\\\$userAgentRandomizer2 Safari/537.36'
    };
    var request = http.Request(
        'GET', Uri.parse('https://api.comick.fun$url?tachiyomi=true'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var mangaDetail = jsonDecode(await response.stream.bytesToString())
          as Map<String, dynamic>;

      var mangaDetailLMap = MangaDetailModelComick.fromJson(mangaDetail);

      RegExp regExp = RegExp(r'name:\s*(.*?),');

      String authorr =
          regExp.firstMatch(mangaDetailLMap.authors![0].toString())?.group(1) ??
              '';
      String statuss = _parseStatut(mangaDetailLMap.comic!.status!);
      status = statuss;
      author = authorr;
      RegExp regExp1 = RegExp(r'name:\s*(.*?)}');
      for (var ok in mangaDetailLMap.genres!) {
        genre.add(regExp1.firstMatch(ok.toString())!.group(1)!);
      }
      description = mangaDetailLMap.comic!.desc;
      String tt = await findCurrentSlug(mangaDetailLMap.comic!.slug!);
      String mangaId = tt.split('":"').last.replaceAll('"}', '');
      String limit = mangaDetailLMap.comic!.chapterCount.toString();

      var requestt = http.Request(
          'GET',
          Uri.parse(
              'https://api.comick.fun/comic/$mangaId/chapters?lang=$lang&limit=$limit'));

      requestt.headers.addAll(headers);

      http.StreamedResponse responsee = await requestt.send();

      if (responsee.statusCode == 200) {
        List<String> chapterTitles = [];
        List<String> chapterUrls = [];
        List<String> chapterDates = [];
        var chapterDetail = jsonDecode(await responsee.stream.bytesToString())
            as Map<String, dynamic>;
        var chapterDetailMap = MangaChapterModelComick.fromJson(chapterDetail);
        for (var chapter in chapterDetailMap.chapters!) {
          chapterUrls.add(
              "/comic/${mangaDetailLMap.comic!.slug}/${chapter.hid}-chapter-${chapter.chap}-en");
          chapterDates.add(chapter.createdAt!.toString().substring(0, 10));
          chapterTitles.add(beautifyChapterName(chapter.vol ?? "",
              chapter.chap ?? "", chapter.title ?? "", lang));
        }
        List<String> chapterTitless = [];
        for (var i = 0; i < chapterTitles.length; i++) {
          if (!chapterTitless.contains(chapterTitles[i])) {
            chapterTitle.add(chapterTitles[i]);
            chapterUrl.add(chapterUrls[i]);
            chapterDate.add(chapterDates[i].replaceAll('-', "/"));
          }
          chapterTitless.add(chapterTitles[i]);
        }
      }
    }
  }
  /*************/
  /*mangathemesia*/
  /**************/

  if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.mangathemesia) {
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
  }
  /***********/
  /*mangakawaii*/
  /***********/
  else if (source.toLowerCase() == "mangakawaii") {
    final dom = await httpResToDom(
        url: 'https://www.mangakawaii.io$url',
        headers: {"Accept-Language": "fr"});
    List detail = [];
    imageUrl =
        "https://cdn.mangakawaii.pics/uploads$url/cover/cover_250x350.jpg";
    if (dom.querySelectorAll('dd.text-justify.text-break').isNotEmpty) {
      final tt = dom
          .querySelectorAll('dd.text-justify.text-break')
          .map((e) => e.text.trim())
          .toList();
      description = tt[0];
    }
    if (dom
        .querySelectorAll('span.badge.bg-success.text-uppercase')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll('span.badge.bg-success.text-uppercase')
          .map((e) => e.text.trim())
          .toList();
      detail.add(tt[0]);
    } else {
      detail.add("");
    }

    if (dom.querySelectorAll('a[href*=author]').isNotEmpty) {
      final tt = dom
          .querySelectorAll('a[href*=author]')
          .map((e) => e.text.trim())
          .toList();
      detail.add(tt[0]);
    } else {
      detail.add("");
    }

    if (dom.querySelectorAll('a[href*=category]').isNotEmpty) {
      final tt = dom
          .querySelectorAll('a[href*=category]')
          .map((e) => e.text.trim())
          .toList();
      for (var ok in tt) {
        genre.add(ok);
      }
    }
    detail = detail.toSet().toList();
    status = detail[0];
    author = detail[1];
    if (dom.querySelectorAll("tr[class*='volume-']").isNotEmpty) {
      final url = dom.querySelectorAll("tr[class*='volume-']").map((e) {
        RegExp exp = RegExp(r'<a href="([^"]+)"');
        Iterable<Match> matches = exp.allMatches(e.outerHtml);
        String? firstMatch = matches.first.group(1);
        return firstMatch;
      }).toList();
      final htm = await httpResToDom(
          url: 'https://www.mangakawaii.io${url[0]}',
          headers: {"Accept-Language": "fr"});

      if (htm
          .querySelectorAll(
              '#bottom_nav_reader > div > div > ul.chapter-pager.navbar-nav > li.nav-item.dropup.d-inline-block > ul > li > a')
          .isNotEmpty) {
        final tt = htm
            .querySelectorAll(
                '#bottom_nav_reader > div > div > ul.chapter-pager.navbar-nav > li.nav-item.dropup.d-inline-block > ul > li > a')
            .map((e) => e.innerHtml)
            .toList();
        final urlz = htm
            .querySelectorAll(
                "#bottom_nav_reader > div > div > ul.chapter-pager.navbar-nav > li.nav-item.dropup.d-inline-block > ul > li ")
            .map((e) => e.innerHtml)
            .toList();

        for (var ok in urlz) {
          chapterUrl.add(ok.split('href="')[1].split('"').first);
        }
        for (var ok in tt) {
          chapterTitle.add(ok);
        }
        if (dom.querySelectorAll("tr[class*='volume-']").isNotEmpty) {
          final url = dom
              .querySelectorAll("tr[class*='volume-']")
              .map((e) => e
                  .querySelectorAll('td.table__date')
                  .map((e) => e.text.trim())
                  .toList()[0])
              .toList();
          if (urlz.length > url.length) {
            for (var _ in urlz) {
              chapterDate.add(DateTime.now()
                  .toString()
                  .substring(0, 10)
                  .replaceAll('-', "/"));
            }
          } else {
            for (var ok in url) {
              chapterDate.add(ok
                  .split(" ")
                  .first
                  .toString()
                  .substring(0, 10)
                  .replaceAll('.', "/"));
            }
          }
        }
      }
    }
  }

  /***********/
  /*mmrcms*/
  /***********/

  else if (getWpMangTypeSource(source.toLowerCase()) == TypeSource.mmrcms) {
    final dom = await httpResToDom(url: url, headers: {});
    description = dom
        .querySelectorAll('.row .well p')
        .map((e) => e.text.trim())
        .toList()
        .first;
    status = dom
        .querySelectorAll('.row .dl-horizontal dt')
        .where((e) =>
            e.innerHtml.toString().toLowerCase().contains("status") ||
            e.innerHtml.toString().toLowerCase().contains("statut") ||
            e.innerHtml.toString().toLowerCase().contains("estado") ||
            e.innerHtml.toString().toLowerCase().contains("durum"))
        .map((e) => e.nextElementSibling!.text.trim())
        .toList()
        .first;
    if (dom.querySelectorAll(".row .dl-horizontal dt").isNotEmpty) {
      author = dom
          .querySelectorAll('.row .dl-horizontal dt')
          .where((e) =>
              e.innerHtml.toString().toLowerCase().contains("auteur(s)") ||
              e.innerHtml.toString().toLowerCase().contains("author(s)") ||
              e.innerHtml.toString().toLowerCase().contains("autor(es)") ||
              e.innerHtml.toString().toLowerCase().contains("yazar(lar)") ||
              e.innerHtml.toString().toLowerCase().contains("mangaka(lar)") ||
              e.innerHtml
                  .toString()
                  .toLowerCase()
                  .contains("pengarang/penulis") ||
              e.innerHtml.toString().toLowerCase().contains("autor") ||
              e.innerHtml.toString().toLowerCase().contains("penulis"))
          .map((e) => e.nextElementSibling!.text
              .trim()
              .replaceAll(RegExp(r"\s+\b|\b\s"), ""))
          .toList()
          .first;
      final genr = dom
          .querySelectorAll('.row .dl-horizontal dt')
          .where((e) =>
              e.innerHtml.toString().toLowerCase().contains("categories") ||
              e.innerHtml.toString().toLowerCase().contains("categorías") ||
              e.innerHtml.toString().toLowerCase().contains("catégories") ||
              e.innerHtml.toString().toLowerCase().contains("kategoriler") ||
              e.innerHtml.toString().toLowerCase().contains("categorias") ||
              e.innerHtml.toString().toLowerCase().contains("kategorie") ||
              e.innerHtml.toString().toLowerCase().contains("kategori") ||
              e.innerHtml.toString().toLowerCase().contains("tagi"))
          .map((e) => e.nextElementSibling!.text.trim())
          .toList();
      if (genr.isNotEmpty) {
        genre = genr.first.replaceAll(RegExp(r"\s+\b|\b\s"), "").split(',');
      }
    }
    final rrr = dom.querySelectorAll(".row [class^=img-responsive]");
    final data = rrr.map((e) => e.outerHtml).toList();
    if (source.toLowerCase() == 'jpmangas' ||
        source.toLowerCase() == 'fr scan') {
      imageUrl = regSrcMatcher(data.first).replaceAll('//', 'https://');
    } else {
      imageUrl = regSrcMatcher(data.first);
    }

    final ttt = dom
        .querySelectorAll("ul[class^=chapters] > li:not(.btn), table.table tr");
    if (ttt.isNotEmpty) {
      final data = ttt
          .map((e) => e.querySelector("[class^=chapter-title-rtl]")!)
          .toList();
      var name = data;
      for (var iaa in name) {
        chapterTitle.add(iaa.getElementsByTagName("a").first.text);
        chapterUrl
            .add(regHrefMatcher(iaa.getElementsByTagName("a").first.outerHtml));
      }
      final date = ttt
          .map((e) => e
              .getElementsByClassName("date-chapter-title-rtl")
              .map((e) => e.text.trim())
              .first)
          .toList();

      for (var da in date) {
        chapterDate.add(da);
      }
    }
  }

  /***********/
  /*mangahere*/
  /***********/
  else if (source.toLowerCase() == "mangahere") {
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
  if (chapterDate.isNotEmpty &&
      chapterTitle.isNotEmpty &&
      chapterUrl.isNotEmpty) {
    for (var i = 0; i < chapterUrl.length; i++) {
      chapters.add(ModelChapters(
          name: chapterTitle[i],
          url: chapterUrl[i],
          dateUpload: chapterDate[i],
          isBookmarked: false,
          scanlator: "",
          isRead: false,
          lastPageRead: ''));
    }
  }

  return GetMangaDetailModel(
    status: status,
    genre: genre,
    author: author,
    description: description,
    name: title,
    url: url,
    source: source,
    imageUrl: imageUrl,
    chapters: chapters,
  );
}
