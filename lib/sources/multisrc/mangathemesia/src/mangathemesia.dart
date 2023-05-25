import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';

class MangaThemeSia extends MangaYomiServices {
  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: manga.url!, source: source, resDom: true, useUserAgent: true)
        .future) as Document?;
    if (dom!
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
          chapterDate.add(parseDate(ok, source));
        }
      }
    }
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required AutoDisposeFutureProviderRef ref}) async {
    source = source.toLowerCase();
    final dom = await ref.watch(httpGetProvider(
            useUserAgent: true,
            url:
                '${getMangaBaseUrl(source)}/manga/?title=&page=$page&order=popular',
            source: source,
            resDom: true)
        .future) as Document?;
    if (dom!
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
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/?s=${query.trim()}',
            source: source,
            resDom: true)
        .future) as Document?;
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
    return mangaRes();
  }

  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(httpGetProvider(
            useUserAgent: true,
            url: chapter.url!,
            source: "mangathemesia",
            resDom: true)
        .future) as Document?;
    if (dom!.querySelectorAll('#readerarea').isNotEmpty) {
      final ta =
          dom.querySelectorAll('#readerarea').map((e) => e.outerHtml).toList();
      final RegExp regex = RegExp(r'<img[^>]+src="([^"]+)"');
      final Iterable<Match> matches = regex.allMatches(ta.first);

      final List<String?> urls = matches.map((m) => m.group(1)).toList();
      Iterable<Match> matchess = [];
      if (dom.querySelectorAll(' #select-paged ').isNotEmpty) {
        final ee = dom
            .querySelectorAll(' #select-paged ')
            .map((e) => e.outerHtml)
            .toList();
        final RegExp regexx = RegExp(r'value="([^"]+)"');
        matchess = regexx.allMatches(ee.first);
      }

      final List<String?> urlss = matchess.map((m) => m.group(1)).toList();
      if (urls.isNotEmpty && urls.length == 1) {
        for (var i = 0; i < urlss.length; i++) {
          if (urlss[i]!.length == 1) {
            pageUrls.add(
                urls.first!.replaceAll("001", '00${int.parse(urlss[i]!) + 1}'));
          } else if (urlss[i]!.length == 2) {
            pageUrls.add(
                urls.first!.replaceAll("001", '0${int.parse(urlss[i]!) + 1}'));
          } else if (urlss[i]!.length == 3) {
            pageUrls.add(
                urls.first!.replaceAll("001", '${int.parse(urlss[i]!) + 1}'));
          }
        }
      } else if (urls.length > 1 && urls.isNotEmpty) {
        for (var tt in urls) {
          pageUrls.add(tt!);
        }
      }
    }
    return pageUrls;
  }
}
