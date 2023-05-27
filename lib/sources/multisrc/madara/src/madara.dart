import 'dart:developer';
import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/dom.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/services/http_service/http_service.dart';
import 'package:mangayomi/sources/multisrc/madara/src/utils.dart';
import 'package:mangayomi/sources/service.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/xpath_selector.dart';

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
    log(pageUrls.toString());

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
            "div.description-summary div.summary__content, div.summary_content div.post-content_item > h5 + div, div.summary_content div.manga-excerpt, div.sinopsis div.contenedor")
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
    bool isOk = false;
    String? html;
    if (Platform.isWindows || Platform.isLinux) {
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowHeight: 500,
          windowWidth: 500,
          userDataFolderWindows: await getWebViewPath(),
        ),
      );
      webview
        ..setBrightness(Brightness.dark)
        ..setApplicationNameForUserAgent(defaultUserAgent)
        ..launch(manga.url!);

      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 10));
        html = await decodeHtml(webview);
        if (xpathSelector(html!)
            .query("//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href")
            .attrs
            .isEmpty) {
          html = await decodeHtml(webview);
          return true;
        }
        return false;
      });
      html = await decodeHtml(webview);
      isOk = true;
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (isOk == true) {
          return false;
        }
        return true;
      });
      html = await decodeHtml(webview);
      webview.close();
    } else {
      HeadlessInAppWebView? headlessWebViewJapScan;
      headlessWebViewJapScan = HeadlessInAppWebView(
        onLoadStop: (controller, u) async {
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          await Future.doWhile(() async {
            html = await controller.evaluateJavascript(
                source:
                    "window.document.getElementsByTagName('html')[0].outerHTML;");
            if (xpathSelector(html!)
                .query(
                    "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href")
                .attrs
                .isEmpty) {
              html = await controller.evaluateJavascript(
                  source:
                      "window.document.getElementsByTagName('html')[0].outerHTML;");
              return true;
            }
            return false;
          });
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          isOk = true;
          headlessWebViewJapScan!.dispose();
        },
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(manga.url!)),
        ),
      );
      headlessWebViewJapScan.run();
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (isOk == true) {
          return false;
        }
        return true;
      });
    }
    final xpath = xpathSelector(html!);
    for (var url in xpath
        .query("//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href")
        .attrs) {
      chapterUrl.add(url!);
    }
    for (var title in xpath
        .query("//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/text()")
        .attrs) {
      chapterTitle.add(title!.trim().trimLeft().trimRight());
    }
    final dateF = xpath
        .query(
            "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/span/i/text()")
        .attrs;

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
