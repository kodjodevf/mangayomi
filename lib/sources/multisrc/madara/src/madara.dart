import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/multisrc/madara/src/utils.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/xpath_selector.dart';
import 'package:http/http.dart' as http;

class Madara extends MangaYomiServices {
  @override
  Future<List<String>> getChapterUrl(
      {required Chapter chapter,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await await ref.watch(httpGetProvider(
            useUserAgent: true,
            url: chapter.url!,
            source: chapter.manga.value!.source!.toLowerCase(),
            resDom: true)
        .future) as Document?;
    final res = dom!.querySelector(
        "div.page-break, li.blocks-gallery-item, .reading-content, .text-left img");
    final imgs = res!
        .querySelectorAll('img')
        .map((i) => regSrcMatcher(i.outerHtml).trim().trimLeft().trimRight())
        .toList();
    if (imgs.isNotEmpty && imgs.length == 1) {
      final pagesNumber = dom
          .querySelector("#single-pager")!
          .querySelectorAll("option")
          .map((e) => e.outerHtml)
          .toList();
      for (var i = 0; i < pagesNumber.length; i++) {
        if (i.toString().length == 1) {
          pageUrls.add(
              imgs.first.replaceAll("01", '0${int.parse(i.toString()) + 1}'));
        } else if (i.toString().length == 2) {
          pageUrls.add(
              imgs.first.replaceAll("01", '${int.parse(i.toString()) + 1}'));
        } else if (i.toString().length == 3) {
          pageUrls.add(
              imgs.first.replaceAll("01", '${int.parse(i.toString()) + 1}'));
        }
      }
    } else {
      pageUrls = imgs;
    }

    return pageUrls;
  }

  @override
  Future<GetManga?> getMangaDetail(
      {required GetManga manga,
      required String lang,
      required String source,
      required AutoDisposeFutureProviderRef ref}) async {
    final dom = await ref.watch(
        httpGetProvider(url: manga.url!, source: source, resDom: true)
            .future) as Document?;
    author = dom!
        .querySelectorAll("div.author-content > a")
        .map((e) => e.text)
        .toList()
        .join(', ');
    description = dom
        .querySelectorAll(
            "div.description-summary div.summary__content, div.summary_content div.post-content_item > h5 + div, div.summary_content div.manga-excerpt, div.sinopsis div.contenedor, .description-summary > p")
        .map((e) => e.text)
        .toList()
        .first;
    status = madaraStatusParser(dom
        .querySelectorAll("div.summary-content")
        .map((e) => e.text.trim().trimLeft().trimRight())
        .toList()
        .last);

    manga.imageUrl = dom
        .querySelectorAll("div.summary_image img")
        .map((e) => regSrcMatcher(e.outerHtml))
        .toList()
        .first;
    genre = dom
        .querySelectorAll("div.genres-content a")
        .map((e) => e.text)
        .toList();
    final mangaId = dom
        .querySelectorAll("div[id^=manga-chapters-holder]")
        .map((e) => e.attributes['data-id'])
        .first;
    Response? mangaResponse;
    final headers = {
      "Referer": "${getMangaBaseUrl(source)}/",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Requested-With": "XMLHttpRequest"
    };
    mangaResponse = await http.post(
        Uri.parse(
            "${getMangaBaseUrl(source)}/wp-admin/admin-ajax.php?action=manga_get_chapters&manga=$mangaId"),
        headers: headers);

    if (mangaResponse.statusCode == 400) {
      mangaResponse = await http.post(Uri.parse("${manga.url}ajax/chapters"),
          headers: headers);
    }

    final xpath = xpathSelector(mangaResponse.body);
    for (var url in xpath.query("//li/a/@href").attrs) {
      chapterUrl.add(url!);
    }
    for (var title in xpath.query("//li/a/text()").attrs) {
      chapterTitle.add(title!.trim().trimLeft().trimRight());
    }
    final dateF = xpath.query("//li/span/i/text()").attrs;

    if (dateF.length == chapterUrl.length) {
      for (var date in dateF) {
        chapterDate.add(parseChapterDate(date!, source).toString());
      }
    } else if (dateF.length < chapterUrl.length) {
      final length = chapterUrl.length - dateF.length;
      for (var i = 0; i < length; i++) {
        chapterDate.add(DateTime.now().millisecondsSinceEpoch.toString());
      }
      for (var date in dateF) {
        chapterDate.add(parseChapterDate(date!, source).toString());
      }
    }
    return mangadetailRes(manga: manga, source: source);
  }

  @override
  Future<List<GetManga?>> getPopularManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    String? html;
    html = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/manga/page/$page/?m_orderby=views',
            source: source,
            resDom: false)
        .future) as String?;
    if (xpathSelector(html!)
        .query('//*[@id^="manga-item"]/a/@title')
        .attrs
        .isEmpty) {
      html = await ref.watch(httpGetProvider(
              url:
                  '${getMangaBaseUrl(source)}/manga/page/$page/?m_orderby=trending',
              source: source,
              resDom: false)
          .future) as String?;
      if (xpathSelector(html!)
          .query('//*[@id^="manga-item"]/a/@title')
          .attrs
          .isEmpty) {
        html = await ref.watch(httpGetProvider(
                url: getMangaBaseUrl(source), source: source, resDom: false)
            .future) as String?;
      }
    }
    final xpath = xpathSelector(html!);
    name = xpath.query('//*[@id^="manga-item"]/a/@title').attrs;
    url = xpath.query('//*[@class^="post-title"]/h3/a/@href').attrs;
    image = xpath.query('//*[@id^="manga-item"]/a/img/@data-src=').attrs;

    return mangaRes();
  }

  @override
  Future<List<GetManga?>> searchManga(
      {required String source,
      required String query,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    final html = await ref.watch(httpGetProvider(
            url: '${getMangaBaseUrl(source)}/?s=$query&post_type=wp-manga',
            source: source,
            resDom: false)
        .future) as String?;
    final xpath = xpathSelector(html!);
    name = xpath.query('//*[@class^="post-title"]/h3/a/text()').attrs;
    url = xpath.query('//*[@class^="post-title"]/h3/a/@href').attrs;
    image = name;
    return mangaRes();
  }

  @override
  Future<List<GetManga?>> getLatestUpdatesManga(
      {required String source,
      required int page,
      required String lang,
      required AutoDisposeFutureProviderRef ref}) async {
    String? html;
    html = await ref.watch(httpGetProvider(
            url:
                '${getMangaBaseUrl(source)}/manga/page/$page/?m_orderby=latest',
            source: source,
            resDom: false)
        .future) as String?;
    final xpath = xpathSelector(html!);
    name = xpath.query('//*[@id^="manga-item"]/a/@title').attrs;
    url = xpath.query('//*[@class^="post-title"]/h3/a/@href').attrs;
    image = xpath.query('//*[@id^="manga-item"]/a/img/@data-src=').attrs;
    return mangaRes();
  }
}
