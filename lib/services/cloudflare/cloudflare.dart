import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/services/cloudflare/cookie.dart';

Future<String> cloudflareBypass(
    {required String url, required String sourceId}) async {
  String ua = "";
  bool isOk = false;
  String? html;
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        windowHeight: 500,
        windowWidth: 500,
        userDataFolderWindows: await getWebViewPath(),
      ),
    );
    webview
      ..setBrightness(Brightness.dark)
      ..launch(url);

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      html = await decodeHtml(webview, sourceId: sourceId);
      if (html == null ||
          html!.contains("Just a moment") ||
          html!.contains("challenges.cloudflare.com")) {
        return true;
      }
      return false;
    });

    isOk = true;
    webview.close();
  } else {
    HeadlessInAppWebView? headlessWebView;
    headlessWebView = HeadlessInAppWebView(
      onLoadStop: (controller, u) async {
        html = await controller.getHtml();
        await Future.doWhile(() async {
          if (html == null ||
              html!.contains("Just a moment") ||
              html!.contains("challenges.cloudflare.com")) {
            html = await controller.getHtml();
            return true;
          }
          return false;
        });
        html = await controller.getHtml();
        ua = await controller.evaluateJavascript(
                source: "navigator.userAgent") ??
            "";
        isOk = true;
        headlessWebView!.dispose();
      },
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
    );

    headlessWebView.run();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true) {
        return false;
      }
      return true;
    });
    await addCookie(sourceId, url, ua);
  }
  return html!;
}