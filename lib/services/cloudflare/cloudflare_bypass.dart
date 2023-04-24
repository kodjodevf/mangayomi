import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/cloudflare/cookie.dart';
import 'package:mangayomi/utils/constant.dart';

Future<dom.Document?> cloudflareBypassDom(
    {required String url, required bool bypass, required String source}) async {
  bool isOk = false;
  dom.Document? htmll;
  if (bypass == false) {
    final response = await http.get(Uri.parse(url));
    htmll = dom.Document.html(response.body);
    isOk = true;
  } else {
    HeadlessInAppWebView? headlessWebViewJapScan;
    headlessWebViewJapScan = HeadlessInAppWebView(
      onLoadStop: (controller, u) async {
        String? html;
        html = await controller.evaluateJavascript(
            source:
                "window.document.getElementsByTagName('html')[0].outerHTML;");
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
            source:
                "window.document.getElementsByTagName('html')[0].outerHTML;");
        htmll = dom.Document.html(html!);
        isOk = true;
        headlessWebViewJapScan!.dispose();
      },
      initialSettings: InAppWebViewSettings(
          userAgent: Hive.box(HiveConstant.hiveBoxAppSettings).get("ua",
              defaultValue:
                  "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0")),
      initialUrlRequest: URLRequest(
        url: WebUri.uri(Uri.parse(url)),
      ),
    );

    headlessWebViewJapScan.run();
  }

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
    {required String url, required String source}) async {
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
    initialSettings: InAppWebViewSettings(
        userAgent: Hive.box(HiveConstant.hiveBoxAppSettings).get("ua",
            defaultValue:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101 Firefox/110.0")),
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
