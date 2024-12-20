import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'dart:async';
import 'dart:io';
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;
import 'package:mangayomi/models/settings.dart';
import 'package:http/io_client.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:mangayomi/services/http/rhttp/rhttp.dart' as rhttp;

class MClient {
  MClient();
  static Client httpClient(
      {Map<String, dynamic>? reqcopyWith, rhttp.ClientSettings? settings}) {
    if (!(reqcopyWith?["useDartHttpClient"] ?? false)) {
      try {
        settings ??= rhttp.ClientSettings(
            throwOnStatusCode: false,
            proxySettings: reqcopyWith?["noProxy"] ?? false
                ? const rhttp.ProxySettings.noProxy()
                : null,
            timeout: reqcopyWith?["timeout"] != null
                ? Duration(seconds: reqcopyWith?["timeout"])
                : null,
            connectTimeout: reqcopyWith?["connectTimeout"] != null
                ? Duration(seconds: reqcopyWith?["connectTimeout"])
                : null,
            tlsSettings: rhttp.TlsSettings(
                verifyCertificates:
                    reqcopyWith?["verifyCertificates"] ?? false));
        return rhttp.RhttpCompatibleClient.createSync(settings: settings);
      } catch (_) {}
    }
    return IOClient(HttpClient());
  }

  static InterceptedClient init(
      {MSource? source,
      Map<String, dynamic>? reqcopyWith,
      rhttp.ClientSettings? settings,
      bool showCloudFlareError = true}) {
    return InterceptedClient.build(
        client: httpClient(settings: settings, reqcopyWith: reqcopyWith),
        retryPolicy: ResolveCloudFlareChallenge(showCloudFlareError),
        interceptors: [
          MCookieManager(reqcopyWith),
          LoggerInterceptor(showCloudFlareError)
        ]);
  }

  static Map<String, String> getCookiesPref(String url) {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    if (cookiesList.isEmpty) return {};
    final cookies = cookiesList
        .firstWhere(
          (element) =>
              element.host == Uri.parse(url).host ||
              Uri.parse(url).host.contains(element.host!),
          orElse: () => MCookie(cookie: ""),
        )
        .cookie!;
    if (cookies.isEmpty) return {};
    return {HttpHeaders.cookieHeader: cookies};
  }

  static Future<void> setCookie(String url, String ua,
      flutter_inappwebview.InAppWebViewController? webViewController,
      {String? cookie}) async {
    List<String> cookies = [];
    if (Platform.isLinux) {
      cookies = cookie
              ?.split(RegExp('(?<=)(,)(?=[^;]+?=)'))
              .where((cookie) => cookie.isNotEmpty)
              .toList() ??
          [];
    } else {
      cookies = (await flutter_inappwebview.CookieManager.instance(
                  webViewEnvironment: webViewEnvironment)
              .getCookies(
                  url: flutter_inappwebview.WebUri(url),
                  webViewController: webViewController))
          .map((e) => "${e.name}=${e.value}")
          .toList();
    }
    if (cookies.isNotEmpty) {
      final host = Uri.parse(url).host;
      final newCookie = cookies.join("; ");
      final settings = isar.settings.getSync(227);
      List<MCookie>? cookieList = [];
      for (var cookie in settings!.cookiesList ?? []) {
        if (cookie.host != host || (!host.contains(cookie.host))) {
          cookieList.add(cookie);
        }
      }
      cookieList.add(MCookie()
        ..host = host
        ..cookie = newCookie);
      isar.writeTxnSync(
          () => isar.settings.putSync(settings..cookiesList = cookieList));
    }
    if (ua.isNotEmpty) {
      final settings = isar.settings.getSync(227);
      isar.writeTxnSync(() => isar.settings.putSync(settings!..userAgent = ua));
    }
  }

  static void deleteAllCookies(String url) {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    List<MCookie>? cookieList = [];
    for (var cookie in cookiesList) {
      if (!(cookie.host == Uri.parse(url).host ||
          Uri.parse(url).host.contains(cookie.host!))) {
        cookieList.add(cookie);
      }
    }
    isar.writeTxnSync(() => isar.settings
        .putSync(isar.settings.getSync(227)!..cookiesList = cookieList));
  }
}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.reqcopyWith);
  Map<String, dynamic>? reqcopyWith;

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    final cookie = MClient.getCookiesPref(request.url.toString());
    if (cookie.isNotEmpty) {
      final userAgent = isar.settings.getSync(227)!.userAgent!;
      if (request.headers[HttpHeaders.cookieHeader] == null) {
        request.headers.addAll(cookie);
      }
      if (request.headers[HttpHeaders.userAgentHeader] == null) {
        request.headers[HttpHeaders.userAgentHeader] = userAgent;
      }
    }
    try {
      if (reqcopyWith != null) {
        if (reqcopyWith!["followRedirects"] != null) {
          request.followRedirects = reqcopyWith!["followRedirects"];
        }
        if (reqcopyWith!["maxRedirects"] != null) {
          request.maxRedirects = reqcopyWith!["maxRedirects"];
        }
        if (reqcopyWith!["contentLength"] != null) {
          request.contentLength = reqcopyWith!["contentLength"];
        }
        if (reqcopyWith!["persistentConnection"] != null) {
          request.persistentConnection = reqcopyWith!["persistentConnection"];
        }
      }
    } catch (_) {}
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    return response;
  }
}

class LoggerInterceptor extends InterceptorContract {
  LoggerInterceptor(this.showCloudFlareError);
  bool showCloudFlareError;
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    if (useLogger) {
      Logger.add(LoggerLevel.info,
          '----- Request -----\n${request.toString()}\nheaders: ${request.headers.toString()}');
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (showCloudFlareError) {
      final cloudflare = [403, 503].contains(response.statusCode) &&
          ["cloudflare-nginx", "cloudflare"]
              .contains(response.headers["server"]);
      if (useLogger) {
        Logger.add(LoggerLevel.info,
            "----- Response -----\n${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}");
      }
      if (cloudflare) {
        botToast("${response.statusCode} Failed to bypass Cloudflare",
            hasCloudFlare: cloudflare, url: response.request!.url.toString());
      }
    }

    return response;
  }
}

class ResolveCloudFlareChallenge extends RetryPolicy {
  bool showCloudFlareError;
  ResolveCloudFlareChallenge(this.showCloudFlareError);
  @override
  int get maxRetryAttempts => 2;
  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (!showCloudFlareError || Platform.isLinux) return false;
    flutter_inappwebview.HeadlessInAppWebView? headlessWebView;
    int time = 0;
    bool timeOut = false;
    final cloudflare = [403, 503].contains(response.statusCode) &&
        ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
    if (cloudflare) {
      bool isCloudFlare = true;
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        initialUrlRequest: flutter_inappwebview.URLRequest(
            url: flutter_inappwebview.WebUri(response.request!.url.toString())),
        onLoadStop: (controller, url) async {
          isCloudFlare = await controller.platform.evaluateJavascript(
              source:
                  "document.head.innerHTML.includes('#challenge-success-text')");

          await Future.doWhile(() async {
            if (timeOut == true) {
              return false;
            }
            if (isCloudFlare) {
              isCloudFlare = await controller.platform.evaluateJavascript(
                  source:
                      "document.head.innerHTML.includes('#challenge-success-text')");
              return true;
            }
            return false;
          });
          if (!timeOut) {
            final ua = await controller.evaluateJavascript(
                    source: "navigator.userAgent") ??
                "";
            await MClient.setCookie(url.toString(), ua, controller);
          }
        },
      );

      headlessWebView.run();

      await Future.doWhile(() async {
        timeOut = time == 15;
        if (!isCloudFlare || timeOut) {
          return false;
        }
        await Future.delayed(const Duration(seconds: 1));
        time++;
        return true;
      });
      try {
        headlessWebView.dispose();
      } catch (_) {}

      return true;
    }

    return false;
  }
}
