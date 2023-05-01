import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:mangayomi/services/http_service/cloudflare/cookie.dart';
import 'package:mangayomi/utils/constant.dart';

Future<dom.Document?> cloudflareBypassDom(
    {required String url,
    required String source,
    required bool useUserAgent}) async {
  // log(source);
  bool isOk = false;
  dom.Document? htmll;
  final ua = Hive.box(HiveConstant.hiveBoxAppSettings)
      .get("ua", defaultValue: defaultUserAgent);
  HeadlessInAppWebView? headlessWebViewJapScan;
  headlessWebViewJapScan = HeadlessInAppWebView(
    onLoadStop: (controller, u) async {
      String? html;
      html = await controller.evaluateJavascript(
          source: "window.document.getElementsByTagName('html')[0].outerHTML;");
      await Future.doWhile(() async {
        if (html == null ||
            html!.contains("Just a moment") ||
            html!.contains("https://challenges.cloudflare.com")) {
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          return true;
        }
        return false;
      });
      html = await controller.evaluateJavascript(
          source: "window.document.getElementsByTagName('html')[0].outerHTML;");
      htmll = dom.Document.html(html!);
      isOk = true;
      headlessWebViewJapScan!.dispose();
    },
    initialSettings: useUserAgent ? InAppWebViewSettings(userAgent: ua) : null,
    initialUrlRequest: URLRequest(
      url: WebUri.uri(Uri.parse(url)),
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
  await setCookie(source, url);
  return htmll;
}

Future<String> cloudflareBypassHtml(
    {required String url,
    required String source,
    required bool useUserAgent}) async {
  final ua = Hive.box(HiveConstant.hiveBoxAppSettings)
      .get("ua", defaultValue: defaultUserAgent);
  bool isOk = false;
  String? html;
  HeadlessInAppWebView? headlessWebViewJapScan;
  headlessWebViewJapScan = HeadlessInAppWebView(
    onLoadStop: (controller, u) async {
      html = await controller.evaluateJavascript(
          source: "window.document.getElementsByTagName('html')[0].outerHTML;");
      await Future.doWhile(() async {
        if (html == null ||
            html!.contains("Just a moment") ||
            html!.contains("Un instant…")) {
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          return true;
        }
        return false;
      });
      html = await controller.evaluateJavascript(
          source: "window.document.getElementsByTagName('html')[0].outerHTML;");
      isOk = true;
      headlessWebViewJapScan!.dispose();
    },
    initialSettings: useUserAgent ? InAppWebViewSettings(userAgent: ua) : null,
    initialUrlRequest: URLRequest(
      url: WebUri.uri(Uri.parse(url)),
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
  await setCookie(source, url);
  return html!;
}
