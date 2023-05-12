import 'package:html/dom.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_res_to_dom_html.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/service/service.dart';
import 'package:mangayomi/sources/src/all/comick/src/utils/utils.dart';
import 'package:mangayomi/sources/utils/utils.dart';

class MangaKawaii extends MangaYomiServices {
  @override
  Future<GetMangaDetailModel?> getMangaDetail(
      {required String imageUrl,
      required String url,
      required String title,
      required String lang,
      required String source}) async {
    final dom = await httpGet(
        url: 'https://www.mangakawaii.io$url',
        source: source,
        resDom: true) as Document?;
    List detail = [];
    imageUrl =
        "https://cdn.mangakawaii.pics/uploads$url/cover/cover_250x350.jpg";
    if (dom!.querySelectorAll('dd.text-justify.text-break').isNotEmpty) {
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
              chapterDate.add(parseDate(
                  "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                  source));
            }
          } else {
            for (var ok in url) {
              chapterDate.add(parseDate(
                  ok.split(" ").first.toString().substring(0, 10), source));
            }
          }
        }
      }
    }
    return mangadetailRes(
        imageUrl: imageUrl, url: url, title: title, source: source);
  }

  @override
  Future<GetMangaModel?> getPopularManga(
      {required String source, required int page}) async {
    final dom = await httpGet(
        url: 'https://www.mangakawaii.io/',
        source: source,
        resDom: true) as Document?;
    if (dom!.querySelectorAll('a.hot-manga__item').isNotEmpty) {
      url = dom
          .querySelectorAll('a.hot-manga__item ')
          .where((e) => e.attributes.containsKey('href'))
          .map((e) => e.attributes['href'])
          .toList();
      name = dom
          .querySelectorAll('a > div > div.hot-manga__item-name')
          .map((e) => e.innerHtml)
          .toList();
      for (var ia in name) {
        image.add("");
      }
    }
    return mangaRes();
  }

  @override
  Future<GetMangaModel?> searchManga(
      {required String source, required String query}) async {
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
    return mangaRes();
  }

  @override
  Future<List<dynamic>> getMangaChapterUrl({required Chapter chapter}) async {
    final response =
        await httpGet(url: chapter.url!, source: "mangakawaii", resDom: false)
            as String?;
    var chapterSlug = RegExp("""var chapter_slug = "([^"]*)";""")
        .allMatches(response!)
        .last
        .group(1);
    var mangaSlug = RegExp("""var oeuvre_slug = "([^"]*)";""")
        .allMatches(response)
        .last
        .group(1);
    var pages = RegExp('''"page_image":"([^"]*)"''')
        .allMatches(response)
        .map((e) => e.group(1));

    for (var tt in pages) {
      pageUrls.add(
          'https://cdn.mangakawaii.pics/uploads/manga/$mangaSlug/chapters_fr/$chapterSlug/$tt');
    }
    return pageUrls;
  }
}
