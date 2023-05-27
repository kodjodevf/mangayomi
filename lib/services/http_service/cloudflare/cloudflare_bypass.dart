import 'dart:io';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/dom.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/services/http_service/cloudflare/cookie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cloudflare_bypass.g.dart';

@riverpod
Future<dom.Document?> cloudflareBypassDom(CloudflareBypassDomRef ref,
    {required String url,
    required String source,
    required bool useUserAgent}) async {
  final ua = isar.settings.getSync(227)!.userAgent!;
  bool isOk = false;
  dom.Document? htmll;
  if (Platform.isWindows || Platform.isLinux) {
    String? html;
    final webview = await WebviewWindow.create(
      configuration: CreateConfiguration(
        windowHeight: 500,
        windowWidth: 500,
        userDataFolderWindows: await getWebViewPath(),
      ),
    );
    webview
      ..setBrightness(Brightness.dark)
      ..setApplicationNameForUserAgent(useUserAgent ? ua : '')
      ..launch(url);

    await Future.delayed(const Duration(seconds: 10));
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
    htmll = dom.Document.html(html!);
    isOk = true;
    webview.close();
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (isOk == true) {
        return false;
      }
      return true;
    });
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
      initialSettings:
          useUserAgent ? InAppWebViewSettings(userAgent: ua) : null,
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
    await ref.watch(setCookieProvider(source, url).future);
  }
  return htmll;
}

@riverpod
Future<String> cloudflareBypassHtml(CloudflareBypassHtmlRef ref,
    {required String url,
    required String source,
    required bool useUserAgent}) async {
  final ua = isar.settings.getSync(227)!.userAgent!;
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
      ..setApplicationNameForUserAgent(useUserAgent ? ua : '')
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
    HeadlessInAppWebView? headlessWebViewJapScan;
    headlessWebViewJapScan = HeadlessInAppWebView(
      onLoadStop: (controller, u) async {
        html = await controller.evaluateJavascript(
            source:
                "window.document.getElementsByTagName('html')[0].outerHTML;");
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
        await Future.delayed(const Duration(seconds: 10));
        html = await controller.evaluateJavascript(
            source:
                "window.document.getElementsByTagName('html')[0].outerHTML;");
        isOk = true;
        headlessWebViewJapScan!.dispose();
      },
      initialSettings:
          useUserAgent ? InAppWebViewSettings(userAgent: ua) : null,
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
    await ref.watch(setCookieProvider(source, url).future);
  }
  return html!;
}
