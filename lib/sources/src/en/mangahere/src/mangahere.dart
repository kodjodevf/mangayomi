import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:mangayomi/sources/utils/utils.dart';

class Mangahere extends MangaYomiServices {
  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: "${getMangaBaseUrl(source)}/${manga.url}",
            source: source,
            resDom: true)
        .future) as Document?;
    if (dom!
        .querySelectorAll(
            ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
        .isNotEmpty) {
      final tt = dom
          .querySelectorAll(
              ' body > div > div > div.detail-info-right > p.detail-info-right-title > span.detail-info-right-title-tip')
          .map((e) => e.text.trim())
          .toList();

      status = switch (tt[0].toLowerCase()) {
        "ongoing" => Status.ongoing,
        "completed" => Status.completed,
        _ => Status.unknown,
      };
    } else {
      status = Status.unknown;
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
        chapterDate.add(parseMangaHereChapterDate(ok, source).toString());
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
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/directory/$page.htm',
            source: source,
            resDom: true)
        .future) as Document?;
    if (dom!.querySelectorAll('.manga-list-1-list li').isNotEmpty) {
      url = dom
          .querySelectorAll('.manga-list-1-list li > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      image = dom
          .querySelectorAll('.manga-list-1-list li > a > img')
          .where((e) => e.attributes.containsKey('src'))
          .where((e) => e.attributes['src']!.contains("cover"))
          .map((e) => e.attributes['src'])
          .toList();

      name = dom
          .querySelectorAll('.manga-list-1-list li > a ')
          .where((e) => e.attributes.containsKey('title'))
          .map((e) => e.attributes['title'])
          .toList();
    }
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url:
                '${getMangaBaseUrl(source)}/search?title=${query.trim()}&genres=&nogenres=&sort=&stype=1&name=&type=0&author_method=cw&author=&artist_method=cw&artist=&rating_method=eq&rating=&released_method=eq&released=&st=0',
            source: source,
            resDom: true)
        .future) as Document?;

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
    return mangaRes();
  }

  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    JavascriptRuntime? flutterJs;
    flutterJs = getJavascriptRuntime();
    extractSecretKey(String response, JavascriptRuntime? flutterJs) {
      var secretKeyScriptLocation =
          response.indexOf("eval(function(p,a,c,k,e,d)");
      var secretKeyScriptEndLocation =
          response.indexOf("</script>", secretKeyScriptLocation);
      var secretKeyScript = response
          .substring(secretKeyScriptLocation, secretKeyScriptEndLocation)
          .replaceAll("eval", "");
      var secretKeyDeobfuscatedScript =
          flutterJs!.evaluate(secretKeyScript).toString();
      var secretKeyStartLoc = secretKeyDeobfuscatedScript.indexOf("'");
      var secretKeyEndLoc = secretKeyDeobfuscatedScript.indexOf(";");

      var secretKeyResultScript = secretKeyDeobfuscatedScript.substring(
          secretKeyStartLoc, secretKeyEndLoc);

      return secretKeyResultScript;
    }

    var link =
        "${getMangaBaseUrl(chapter.manga.value!.source!)}${chapter.url!}";
    final response = await ref.watch(
        httpGetProvider(url: link, source: "mangahere", resDom: false)
            .future) as String?;

    dom.Document htmll = dom.Document.html(response!);
    int? pagesNumber = -1;
    if (htmll.querySelectorAll('body > div > div > span > a:').isNotEmpty) {
      final ta = htmll
          .querySelectorAll('body > div > div > span > a:')
          .map((e) => e.text.trim())
          .toList();
      ta.removeLast();
      pagesNumber = int.parse(ta.last);
    }
    if (pagesNumber == -1) {
      final script = htmll
          .getElementsByTagName("script")
          .firstWhere((e) => e.innerHtml.contains(
                "function(p,a,c,k,e,d)",
              ))
          .innerHtml
          .replaceAll("eval", "");

      String deobfuscatedScript = flutterJs.evaluate(script).toString();
      List<String> urlss = deobfuscatedScript
          .substring(
              deobfuscatedScript.indexOf("newImgs=['") + "newImgs=['".length,
              deobfuscatedScript.indexOf("'];"))
          .split("','");
      for (var tt in urlss) {
        pageUrls.add("https:$tt");
      }
      flutterJs.dispose();
    } else {
      var secretKey = extractSecretKey(response, flutterJs);

      var chapterIdStartLoc = response.indexOf("chapterid");
      var chapterId = response
          .substring(
              chapterIdStartLoc + 11, response.indexOf(";", chapterIdStartLoc))
          .trim();

      var pageBase = link.substring(0, link.lastIndexOf("/"));

      for (int i = 1; i <= pagesNumber; i++) {
        var pageLink =
            "$pageBase/chapterfun.ashx?cid=$chapterId&page=$i&key=$secretKey";
        var responseText = "";

        for (int tr = 1; tr <= 3; tr++) {
          var response = await http.get(Uri.parse(pageLink), headers: {
            "Referer": link,
            "Accept": "*/*",
            "Accept-Language": "en-US,en;q=0.9",
            "Connection": "keep-alive",
            "Host": "www.mangahere.cc",
            "X-Requested-With": "XMLHttpRequest"
          });
          responseText = response.body;
          if (responseText.isNotEmpty) {
            break;
          } else {
            secretKey = "";
          }
        }

        var deobfuscatedScript =
            flutterJs.evaluate(responseText.replaceAll("eval", "")).toString();

        var baseLinkStartPos = deobfuscatedScript.indexOf("pix=") + 5;
        var baseLinkEndPos =
            deobfuscatedScript.indexOf(";", baseLinkStartPos) - 1;
        var baseLink =
            deobfuscatedScript.substring(baseLinkStartPos, baseLinkEndPos);

        var imageLinkStartPos = deobfuscatedScript.indexOf("pvalue=") + 9;
        var imageLinkEndPos =
            deobfuscatedScript.indexOf("\"", imageLinkStartPos);
        var imageLink =
            deobfuscatedScript.substring(imageLinkStartPos, imageLinkEndPos);
        pageUrls.add("https:$baseLink$imageLink");
      }

      flutterJs.dispose();
    }
    return pageUrls;
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/directory/$page.htm?latest',
            source: source,
            resDom: true)
        .future) as Document?;
    if (dom!.querySelectorAll('.manga-list-1-list li').isNotEmpty) {
      url = dom
          .querySelectorAll('.manga-list-1-list li > a ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();

      image = dom
          .querySelectorAll('.manga-list-1-list li > a > img')
          .where((e) => e.attributes.containsKey('src'))
          .where((e) => e.attributes['src']!.contains("cover"))
          .map((e) => e.attributes['src'])
          .toList();

      name = dom
          .querySelectorAll('.manga-list-1-list li > a ')
          .where((e) => e.attributes.containsKey('title'))
          .map((e) => e.attributes['title'])
          .toList();
    }
    return mangaRes();
  }
}

int parseMangaHereChapterDate(String date, String source) {
  if (date.contains('Today') || date.contains(' ago')) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today.millisecondsSinceEpoch;
  } else if (date.contains('Yesterday')) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return yesterday.millisecondsSinceEpoch;
  } else {
    try {
      final dateFormat =
          DateFormat(getFormatDate(source), getFormatDateLocale(source));
      final parsedDate = dateFormat.parse(date);
      return parsedDate.millisecondsSinceEpoch;
    } catch (e) {
      return 0;
    }
  }
}
