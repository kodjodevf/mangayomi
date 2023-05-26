// import 'dart:developer';
// import 'dart:io';
// import 'package:desktop_webview_window/desktop_webview_window.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:html/dom.dart';
// import 'package:html/parser.dart';
// import 'package:mangayomi/models/chapter.dart';
// import 'package:mangayomi/modules/webview/webview.dart';
// import 'package:mangayomi/services/http_service/http_service.dart';
// import 'package:mangayomi/sources/service.dart';
// import 'package:mangayomi/sources/utils/utils.dart';
// import 'package:mangayomi/utils/constant.dart';
// import 'package:mangayomi/utils/reg_exp_matcher.dart';
// // import 'package:mangayomi/utils/xpath_selector.dart';

// class Madara extends MangaYomiServices {
//   @override
//   Future<List<String>> getChapterUrl(
//       {required Chapter chapter,
//       required AutoDisposeFutureProviderRef ref}) async {
//     final dom = await await ref.watch(httpGetProvider(
//             useUserAgent: true,
//             url: chapter.url!,
//             source: chapter.manga.value!.source!.toLowerCase(),
//             resDom: true)
//         .future) as Document?;
//     final res = dom!.querySelector(
//         "div.page-break, li.blocks-gallery-item, .reading-content, .text-left img");
//     final imgs = res!
//         .querySelectorAll('img')
//         .map((i) => regSrcMatcher(i.outerHtml).trim().trimLeft().trimRight())
//         .toList();
//     if (imgs.isNotEmpty && imgs.length == 1) {
//       final pagesNumber = dom
//           .querySelector("#single-pager")!
//           .querySelectorAll("option")
//           .map((e) => e.outerHtml)
//           .toList();
//       for (var i = 0; i < pagesNumber.length; i++) {
//         if (i.toString().length == 1) {
//           pageUrls.add(
//               imgs.first.replaceAll("01", '0${int.parse(i.toString()) + 1}'));
//         } else if (i.toString().length == 2) {
//           pageUrls.add(
//               imgs.first.replaceAll("01", '${int.parse(i.toString()) + 1}'));
//         } else if (i.toString().length == 3) {
//           pageUrls.add(
//               imgs.first.replaceAll("01", '${int.parse(i.toString()) + 1}'));
//         }
//       }
//     } else {
//       pageUrls = imgs;
//     }
//     log(pageUrls.toString());

//     return pageUrls;
//   }

//   @override
//   Future<GetManga?> getMangaDetail(
//       {required GetManga manga,
//       required String lang,
//       required String source,
//       required AutoDisposeFutureProviderRef ref}) async {
//     final dom = await ref.watch(
//         httpGetProvider(url: manga.url!, source: source, resDom: true)
//             .future) as Document?;
//     author = dom!
//         .querySelectorAll("div.author-content > a")
//         .map((e) => e.text)
//         .toList()
//         .join(', ');
//     description = dom
//         .querySelectorAll(
//             "div.description-summary div.summary__content, div.summary_content div.post-content_item > h5 + div, div.summary_content div.manga-excerpt, div.sinopsis div.contenedor")
//         .map((e) => e.text)
//         .toList()
//         .first;
//     status = dom
//         .querySelectorAll("div.summary-content")
//         .map((e) => e.text.trim().trimLeft().trimRight())
//         .toList()
//         .last;

//     manga.imageUrl = dom
//         .querySelectorAll("div.summary_image img")
//         .map((e) => regSrcMatcher(e.outerHtml))
//         .toList()
//         .first;
//     genre = dom
//         .querySelectorAll("div.genres-content a")
//         .map((e) => e.text)
//         .toList();
//     bool isOk = false;
//     String? html;
//     if (Platform.isWindows || Platform.isLinux) {
//       final webview = await WebviewWindow.create(
//         configuration: CreateConfiguration(
//           windowHeight: 500,
//           windowWidth: 500,
//           userDataFolderWindows: await getWebViewPath(),
//         ),
//       );
//       webview
//         ..setBrightness(Brightness.dark)
//         ..setApplicationNameForUserAgent(defaultUserAgent)
//         ..launch(manga.url!);

//       await Future.doWhile(() async {
//         await Future.delayed(const Duration(seconds: 10));
//         html = await decodeHtml(webview);
//         if (parse(html!)
//             .querySelector("div[id^=manga-chapters-holder]")!
//             .querySelectorAll("li.wp-manga-chapter")
//             .isEmpty) {
//           html = await decodeHtml(webview);
//           return true;
//         }
//         return false;
//       });
//       html = await decodeHtml(webview);
//       isOk = true;
//       await Future.doWhile(() async {
//         await Future.delayed(const Duration(seconds: 1));
//         if (isOk == true) {
//           return false;
//         }
//         return true;
//       });
//       html = await decodeHtml(webview);
//       webview.close();
//     } else {
//       HeadlessInAppWebView? headlessWebViewJapScan;
//       headlessWebViewJapScan = HeadlessInAppWebView(
//         onLoadStop: (controller, u) async {
//           html = await controller.evaluateJavascript(
//               source:
//                   "window.document.getElementsByTagName('html')[0].outerHTML;");
//           await Future.doWhile(() async {
//             html = await controller.evaluateJavascript(
//                 source:
//                     "window.document.getElementsByTagName('html')[0].outerHTML;");
//             if (parse(html!)
//                 .querySelector("div[id^=manga-chapters-holder]")!
//                 .querySelectorAll("li.wp-manga-chapter")
//                 .isEmpty) {
//               html = await controller.evaluateJavascript(
//                   source:
//                       "window.document.getElementsByTagName('html')[0].outerHTML;");
//               return true;
//             }
//             return false;
//           });
//           html = await controller.evaluateJavascript(
//               source:
//                   "window.document.getElementsByTagName('html')[0].outerHTML;");
//           isOk = true;
//           headlessWebViewJapScan!.dispose();
//         },
//         initialUrlRequest: URLRequest(
//           url: WebUri.uri(Uri.parse(manga.url!)),
//         ),
//       );
//       headlessWebViewJapScan.run();
//       await Future.doWhile(() async {
//         await Future.delayed(const Duration(seconds: 1));
//         if (isOk == true) {
//           return false;
//         }
//         return true;
//       });
//     }
//     // final xpath = xpathSelector(html!);
//     // // log(parse(html!)
//     // //     .querySelector("div[id^=manga-chapters-holder]")!
//     // //     .querySelectorAll("li.wp-manga-chapter")
//     // //     .map((e) => e.text)
//     // //     .toList()
//     // //     .toString());
//     // for (var url in xpath
//     //     .query("//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/@href")
//     //     .attrs) {
//     //   chapterUrl.add(url!);
//     // }
//     chapterUrl = parse(html!)
//         .querySelector("div[id^=manga-chapters-holder]")!
//         .querySelectorAll("li.wp-manga-chapter")
//         .map((e) => regHrefMatcher(e.outerHtml))
//         .toList();
//     // for (var title in xpath
//     //     .query("//*[@id='manga-chapters-holder']/div[2]/div/ul/li/a/text()")
//     //     .attrs) {
//     //   chapterTitle.add(title!.trim().trimLeft().trimRight());
//     // }
//     // log(chapterUrl.toString());
//     chapterTitle = parse(html!)
//         .querySelector("div[id^=manga-chapters-holder]")!
//         .querySelectorAll("li.wp-manga-chapter a")
//         .map((e) => e.text.trim().trimLeft().trimRight())
//         .toList();
//     // log(chapterTitle.toString());
//     final dateF = parse(html!)
//         .querySelector("div[id^=manga-chapters-holder]")!
//         .querySelectorAll("li.wp-manga-chapter span")
//         .map((e) => e.text.trim().trimLeft().trimRight())
//         .toList();
//     log(dateF.toString());
//     // xpath
//     //     .query(
//     //         "//*[@id='manga-chapters-holder']/div[2]/div/ul/li/span/i/text()")
//     //     .attrs;

//     if (dateF.length == chapterUrl.length) {
//       for (var date in dateF) {
//         chapterDate.add(parseDate(date, source));
//       }
//     } else if (dateF.length < chapterUrl.length) {
//       final length = chapterUrl.length - dateF.length;
//       for (var i = 0; i < length; i++) {
//         chapterDate.add(DateTime.now().millisecondsSinceEpoch.toString());
//       }
//       for (var date in dateF) {
//         chapterDate.add(parseDate(date!, source));
//       }
//     }

//     return mangadetailRes(manga: manga, source: source);
//   }

//   @override
//   Future<List<GetManga?>> getPopularManga(
//       {required String source,
//       required int page,
//       required AutoDisposeFutureProviderRef ref}) async {
//     String? html;
//     html = await ref.watch(httpGetProvider(
//             url: '${getMangaBaseUrl(source)}/manga/page/$page/?m_orderby=views',
//             source: source,
//             resDom: false)
//         .future) as String?;
//     if (parse(html!)
//         .querySelectorAll('div.post-title a')
//         .map((e) => e.text)
//         .toList()
//         .isEmpty) {
//       html = await ref.watch(httpGetProvider(
//               url:
//                   '${getMangaBaseUrl(source)}/manga/page/$page/?m_orderby=trending',
//               source: source,
//               resDom: false)
//           .future) as String?;
//       if (parse(html!)
//           .querySelectorAll('div.post-title a')
//           .map((e) => e.text)
//           .toList()
//           .isEmpty) {
//         html = await ref.watch(httpGetProvider(
//                 url: getMangaBaseUrl(source), source: source, resDom: false)
//             .future) as String?;
//       }
//     }
//     final dom = parse(html!);
//     name = dom.querySelectorAll('div.post-title a').map((e) => e.text).toList();
//     image = name;
//     url = dom
//         .querySelectorAll('div.post-title a')
//         .map((e) => regHrefMatcher(e.outerHtml))
//         .toList();

//     return mangaRes();
//   }

//   @override
//   Future<List<GetManga?>> searchManga(
//       {required String source,
//       required String query,
//       required AutoDisposeFutureProviderRef ref}) async {
//     final html = await ref.watch(httpGetProvider(
//             url: '${getMangaBaseUrl(source)}/?s=$query&post_type=wp-manga',
//             source: source,
//             resDom: false)
//         .future) as String?;
//     final dom = parse(html!);
//     name = dom.querySelectorAll('div.post-title a').map((e) => e.text).toList();
//     image = name;
//     url = dom
//         .querySelectorAll('div.post-title a')
//         .map((e) => regHrefMatcher(e.outerHtml))
//         .toList();

//     return mangaRes();
//   }
// }
