import 'package:flutter/foundation.dart';
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
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:mangayomi/services/http/rhttp/rhttp.dart' as rhttp;

class MClient {
  MClient();
  static final defaultClient = IOClient(HttpClient());
  static final Map<rhttp.ClientSettings, Client> rhttpPool = {};
  static Client httpClient({
    Map<String, dynamic>? reqcopyWith,
    rhttp.ClientSettings? settings,
  }) {
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
          timeoutSettings: TimeoutSettings(
            connectTimeout: reqcopyWith?["connectTimeout"] != null
                ? Duration(seconds: reqcopyWith?["connectTimeout"])
                : null,
          ),
          tlsSettings: rhttp.TlsSettings(
            verifyCertificates: reqcopyWith?["verifyCertificates"] ?? false,
          ),
        );
        return rhttpPool.putIfAbsent(settings, () {
          return rhttp.RhttpCompatibleClient.createSync(settings: settings);
        });
      } catch (_) {}
    }
    return defaultClient;
  }

  static InterceptedClient init({
    MSource? source,
    Map<String, dynamic>? reqcopyWith,
    rhttp.ClientSettings? settings,
    bool showCloudFlareError = true,
  }) {
    final clientSettings = customDns == null || customDns!.trim().isEmpty
        ? settings
        : settings?.copyWith(
                dnsSettings: DnsSettings.dynamic(
                  resolver: (host) async => [customDns!],
                ),
              ) ??
              ClientSettings(
                dnsSettings: DnsSettings.dynamic(
                  resolver: (host) async => [customDns!],
                ),
              );
    return InterceptedClient.build(
      client: httpClient(settings: clientSettings, reqcopyWith: reqcopyWith),
      retryPolicy: ResolveCloudFlareChallenge(showCloudFlareError),
      interceptors: [
        MCookieManager(reqcopyWith),
        LoggerInterceptor(showCloudFlareError),
      ],
    );
  }

  static Map<String, String> getCookiesPref(String url) {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    if (cookiesList.isEmpty) return {};
    final host = Uri.parse(url).host;
    final cookies = cookiesList
        .firstWhere(
          (element) => element.host == host || host.contains(element.host!),
          orElse: () => MCookie(cookie: ""),
        )
        .cookie!;
    if (cookies.isEmpty) return {};
    return {HttpHeaders.cookieHeader: cookies};
  }

  static Future<void> setCookie(
    String url,
    String ua,
    flutter_inappwebview.InAppWebViewController? webViewController, {
    String? cookie,
  }) async {
    List<String> cookies = [];
    // if incoming cookie is not empty, use it first
    if (cookie != null && cookie.isNotEmpty) {
      cookies = cookie
          .split(RegExp('(?<=)(,)(?=[^;]+?=)'))
          .where((cookie) => cookie.isNotEmpty)
          .toList();
    } else if (!Platform.isLinux) {
      cookies =
          (await flutter_inappwebview.CookieManager.instance(
                webViewEnvironment: webViewEnvironment,
              ).getCookies(
                url: flutter_inappwebview.WebUri(url),
                webViewController: webViewController,
              ))
              .map((e) => "${e.name}=${e.value}")
              .toList();
    }
    if (cookies.isNotEmpty) {
      final host = Uri.parse(url).host;
      final newCookie = cookies.join("; ");
      final settings = await isar.settings.get(227);
      final existingCookies = settings!.cookiesList ?? [];
      final filteredCookies = removeCookiesForHost(existingCookies, host);
      filteredCookies.add(
        MCookie()
          ..host = host
          ..cookie = newCookie,
      );
      await isar.writeTxn(
        () => isar.settings.put(settings..cookiesList = filteredCookies),
      );
    }
    if (ua.isNotEmpty) {
      final settings = await isar.settings.get(227);
      await isar.writeTxn(
        () => isar.settings.put(
          settings!
            ..userAgent = ua
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }

  static List<MCookie> removeCookiesForHost(
    List<MCookie> allCookies,
    String host,
  ) {
    return allCookies
        .where((cookie) => cookie.host != host && !host.contains(cookie.host!))
        .toList();
  }

  static Future<void> deleteAllCookies(String url) async {
    final settings = await isar.settings.get(227);
    final oldCookies = settings!.cookiesList ?? [];
    final host = Uri.parse(url).host;
    settings.cookiesList = removeCookiesForHost(oldCookies, host);
    await isar.writeTxn(() => isar.settings.put(settings));
  }
}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.reqcopyWith);
  Map<String, dynamic>? reqcopyWith;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final cookie = MClient.getCookiesPref(request.url.toString());
    if (cookie.isNotEmpty) {
      final settings = await isar.settings.get(227);
      final userAgent = settings!.userAgent!;
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
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final content =
        "----- Request -----\n${request.toString()}\nheaders: ${request.headers.toString()}";
    if (kDebugMode) {
      print(content);
    }
    if (useLogger) {
      Logger.add(LoggerLevel.info, content);
    }

    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    if (showCloudFlareError) {
      final cloudflare = isCloudflare(response);
      final content =
          "----- Response -----\n${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}";
      if (kDebugMode) {
        print(content);
      }
      if (useLogger) {
        Logger.add(LoggerLevel.info, content);
      }
      if (cloudflare) {
        botToast(
          "${response.statusCode} Failed to bypass Cloudflare",
          hasCloudFlare: cloudflare,
          url: response.request!.url.toString(),
        );
      }
    }

    return response;
  }
}

bool isCloudflare(BaseResponse response) {
  return [403, 503].contains(response.statusCode) &&
      ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
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
    bool isCloudFlare = isCloudflare(response);
    if (isCloudFlare) {
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        initialUrlRequest: flutter_inappwebview.URLRequest(
          url: flutter_inappwebview.WebUri(response.request!.url.toString()),
        ),
        onLoadStop: (controller, url) async {
          try {
            isCloudFlare = await controller.platform.evaluateJavascript(
              source:
                  "document.head.innerHTML.includes('#challenge-success-text')",
            );
          } catch (_) {
            isCloudFlare = false;
          }

          await Future.doWhile(() async {
            if (!timeOut && isCloudFlare) {
              try {
                isCloudFlare = await controller.platform.evaluateJavascript(
                  source:
                      "document.head.innerHTML.includes('#challenge-success-text')",
                );
              } catch (_) {
                isCloudFlare = false;
              }
            }
            if (isCloudFlare) await Future.delayed(Duration(milliseconds: 300));

            return isCloudFlare;
          });
          if (!timeOut) {
            final ua =
                await controller.evaluateJavascript(
                  source: "navigator.userAgent",
                ) ??
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
