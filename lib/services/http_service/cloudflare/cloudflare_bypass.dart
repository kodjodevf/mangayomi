import 'dart:convert';
import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/services/http_service/cloudflare/cookie.dart';
import 'package:mangayomi/utils/constant.dart';

Future<String> cloudflareBypass(
    {required String url,
    required String sourceId,
    required int method}) async {
  final ua = isar.settings.getSync(227)!.userAgent!;
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
      ..setApplicationNameForUserAgent(ua)
      ..launch(url);

    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (html == null) {
        html = await decodeHtml(webview);
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
        html = await controller.evaluateJavascript(
            source:
                "window.document.getElementsByTagName('html')[0].outerHTML;");
        await Future.doWhile(() async {
          if (html == null ||
              html!.contains("Just a moment") ||
              html!.contains("challenges.cloudflare.com")) {
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
        headlessWebView!.dispose();
      },
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          userAgent: defaultUserAgent,
        ),
      ),
      initialUrlRequest: URLRequest(
        headers: headers(sourceId: sourceId),
        method: method == 0
            ? 'GET'
            : method == 1
                ? 'POST'
                : method == 2
                    ? 'PUT'
                    : 'DELETE',
        url: Uri.parse(url),
      ),
    );

    headlessWebView.run();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true) {
        return false;
      }
      return true;
    });
    await setCookieB(sourceId, url);
  }
  return html!;
}

Map<String, String> headers({required String sourceId}) {
  final source = isar.sources.getSync(int.parse(sourceId))!;
  if (source.headers!.isEmpty) {
    return {};
  }

  Map<String, String> newHeaders = {};
  final headers = jsonDecode(source.headers!) as Map;
  newHeaders =
      headers.map((key, value) => MapEntry(key.toString(), value.toString()));

  return newHeaders;
}
