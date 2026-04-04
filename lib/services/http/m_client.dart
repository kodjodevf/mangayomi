import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
import 'package:mangayomi/services/http/doh/doh_resolver.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';

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
    final appSettings = isar.settings.getSync(227);
    final useDoH = appSettings?.doHEnabled ?? false;
    final doHProviderId = appSettings?.doHProviderId;

    DnsSettings? dnsSettings;

    if (useDoH && doHProviderId != null) {
      // Use DoH resolver with specific provider
      final provider = DoHProviders.byId[doHProviderId];
      if (provider != null) {
        dnsSettings = DnsSettings.dynamic(
          resolver: (host) => DoHResolver.resolve(host, provider: provider),
        );
      }
    } else if (customDns != null && customDns!.trim().isNotEmpty) {
      // Fallback to custom static DNS
      dnsSettings = DnsSettings.dynamic(resolver: (host) async => [customDns!]);
    }

    // Apply DNS settings if configured
    final clientSettings = dnsSettings != null
        ? settings?.copyWith(dnsSettings: dnsSettings) ??
              ClientSettings(dnsSettings: dnsSettings)
        : settings;

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

    if (kDebugMode || useLogger) {
      // ignore: avoid_print
      print(content);
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
      if (cloudflare &&
          !Platform.isLinux &&
          response.request?.method.toUpperCase() == "GET") {
        final requestUrl = response.request?.url.toString();
        if (requestUrl != null) {
          var resolution = _cloudflareResolutionCache.remove(requestUrl);
          resolution ??= await _resolveCloudflareForUrl(
            requestUrl,
            captureBody: true,
          );
          final body = resolution?.body;
          if (resolution != null &&
              resolution.resolved &&
              body != null &&
              body.isNotEmpty &&
              !_containsCloudflareChallengeHtml(body)) {
            final fallbackContent =
                "----- Response (fallback) -----\n${response.request?.method}: ${response.request?.url}, statusCode: 200";
            if (kDebugMode || useLogger) {
              // ignore: avoid_print
              print(fallbackContent);
              Logger.add(LoggerLevel.info, fallbackContent);
            }
            return http.Response(
              body,
              200,
              headers: {
                HttpHeaders.contentTypeHeader: 'text/html; charset=utf-8',
              },
              request: response.request,
            );
          }
        }
      }
      final content =
          "----- Response -----\n${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}";

      if (kDebugMode || useLogger) {
        // ignore: avoid_print
        print(content);
        Logger.add(LoggerLevel.info, content);
      }
      if (cloudflare) {
        try {
          botToast(
            "${response.statusCode} Failed to bypass Cloudflare",
            hasCloudFlare: cloudflare,
            url: response.request!.url.toString(),
          );
        } catch (e) {
          throw "Failed to bypass Cloudflare.\n\n\nYou can try to bypass it manually in the webview \n\n\nstatusCode: ${response.statusCode}";
        }
      }
    }

    return response;
  }
}

bool isCloudflare(BaseResponse response) {
  return [403, 503].contains(response.statusCode) &&
      ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
}

bool _boolFromDynamic(dynamic value) {
  if (value is bool) return value;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == "true" || normalized == "1";
  }
  if (value is num) return value != 0;
  return false;
}

class _CloudflareResolutionResult {
  _CloudflareResolutionResult({
    required this.resolved,
    required this.timeout,
    this.body,
    this.finalUrl,
  });

  final bool resolved;
  final bool timeout;
  final String? body;
  final String? finalUrl;

  factory _CloudflareResolutionResult.fromJson(Map<String, dynamic> data) {
    return _CloudflareResolutionResult(
      resolved: data.containsKey('resolved')
          ? _boolFromDynamic(data['resolved'])
          : _boolFromDynamic(data['result']),
      timeout: _boolFromDynamic(data['timeout']),
      body: data['body'] is String ? data['body'] as String : null,
      finalUrl: data['finalUrl'] is String ? data['finalUrl'] as String : null,
    );
  }
}

final Map<String, _CloudflareResolutionResult> _cloudflareResolutionCache = {};

bool _containsCloudflareChallengeHtml(String html) {
  if (html.isEmpty) return false;
  return RegExp(
    r'cdn-cgi/challenge-platform|cf_chl|just a moment|security verification|enable javascript and cookies',
    caseSensitive: false,
  ).hasMatch(html);
}

Future<_CloudflareResolutionResult?> _resolveCloudflareForUrl(
  String requestUrl, {
  bool captureBody = false,
}) async {
  try {
    final res = await http.post(
      Uri.parse('http://localhost:$cfPort/resolve_cf'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: jsonEncode({'url': requestUrl, 'captureBody': captureBody}),
    );
    if (res.statusCode != 200) return null;
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return _CloudflareResolutionResult.fromJson(data);
  } catch (_) {
    return null;
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
    bool isCloudFlare = isCloudflare(response);
    if (isCloudFlare) {
      final requestUrl = response.request?.url.toString();
      if (requestUrl == null) return false;
      final resolution = await _resolveCloudflareForUrl(
        requestUrl,
        captureBody: true,
      );
      if (resolution != null) {
        if (resolution.body != null &&
            resolution.body!.isNotEmpty &&
            !_containsCloudflareChallengeHtml(resolution.body!)) {
          _cloudflareResolutionCache[requestUrl] = resolution;
        }
        return resolution.resolved;
      }
      return false;
    }

    return false;
  }
}

int cfPort = 0;
HttpServer? _cfServer;

/// Cloudflare Resolution Webview Server
Future<void> cfResolutionWebviewServer() async {
  try {
    _cfServer = await HttpServer.bind(InternetAddress.loopbackIPv4, cfPort);
    cfPort = _cfServer!.port;
    _cfServer!.listen(
      (HttpRequest request) {
        if (request.method == 'POST' && request.uri.path == '/resolve_cf') {
          _handleResolveCf(request);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
        }
      },
      onError: (e, st) {
        debugPrint("CF server listener error: $e\n$st");
      },
      cancelOnError: false,
    );
  } catch (e, st) {
    debugPrint("Couldn't start Cloudflare Resolution Webview Server: $e\n$st");
    botToast("Couldn't start Cloudflare Resolution Webview Server.");
  }
}

Future<void> stopCfResolutionWebviewServer() async {
  final server = _cfServer;
  if (server == null) return;
  try {
    await server.close(force: true);
  } finally {
    _cfServer = null;
    cfPort = 0;
  }
}

void _handleResolveCf(HttpRequest request) async {
  int time = 0;
  bool timeOut = false;
  bool isCloudFlareChallengeActive = true;
  bool resolved = false;
  String? capturedBody;
  String? finalUrl;
  try {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final url = data['url'] as String?;
    final captureBody = _boolFromDynamic(data['captureBody']);

    if (url == null) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode({'error': 'Missing url parameter'}))
        ..close();
      return;
    }

    flutter_inappwebview.HeadlessInAppWebView? headlessWebView;
    headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialUrlRequest: flutter_inappwebview.URLRequest(
        url: flutter_inappwebview.WebUri(url),
      ),
      onLoadStop: (controller, url) async {
        isCloudFlareChallengeActive = await _isCloudflareChallengePage(
          controller,
        );

        await Future.doWhile(() async {
          if (!timeOut && isCloudFlareChallengeActive) {
            isCloudFlareChallengeActive = await _isCloudflareChallengePage(
              controller,
            );
          }
          if (isCloudFlareChallengeActive) {
            await Future.delayed(Duration(milliseconds: 300));
          }

          return isCloudFlareChallengeActive;
        });
        if (!timeOut && !isCloudFlareChallengeActive) {
          final ua =
              await controller.evaluateJavascript(
                source: "navigator.userAgent",
              ) ??
              "";
          await MClient.setCookie(url.toString(), ua, controller);
          resolved = true;
          if (captureBody) {
            final html = await controller.evaluateJavascript(
              source: "document.documentElement?.outerHTML ?? ''",
            );
            capturedBody = html?.toString();
            finalUrl =
                (await controller.getUrl())?.toString() ?? url.toString();
          }
        }
      },
    );

    headlessWebView.run();

    await Future.doWhile(() async {
      timeOut = time == 15;
      if (!isCloudFlareChallengeActive || timeOut) {
        return false;
      }
      await Future.delayed(const Duration(seconds: 1));
      time++;
      return true;
    });
    try {
      headlessWebView.dispose();
    } catch (_) {}

    request.response
      ..headers.contentType = ContentType.json
      ..write(
        jsonEncode({
          // Backward compatible `result`, but now aligned with retry semantics.
          'result': resolved,
          'resolved': resolved,
          'timeout': timeOut,
          'body': capturedBody,
          'finalUrl': finalUrl,
        }),
      )
      ..close();
  } catch (e) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'error': 'Invalid JSON'}))
      ..close();
  }
}

Future<bool> _isCloudflareChallengePage(
  flutter_inappwebview.InAppWebViewController controller,
) async {
  try {
    final result = await controller.platform.evaluateJavascript(
      source: """
(() => {
  const title = String(document.title || "");
  const bodyText = String(document.body?.innerText || "");
  const href = String(location.href || "");
  const content = `\${title}\n\${bodyText}\n\${href}`;
  return /cdn-cgi\\/challenge-platform|cf_chl|just a moment|security verification|enable javascript and cookies/i.test(content);
})()
""",
    );
    return _boolFromDynamic(result);
  } catch (_) {
    return false;
  }
}
