import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';

import 'dart:async';
import 'dart:io';

import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;
import 'package:mangayomi/models/settings.dart';
import 'package:http/io_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/utils/log/log.dart';
import 'package:mangayomi/services/http/rhttp/rhttp.dart' as rhttp;
import 'package:mangayomi/services/http/doh/doh_resolver.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';
import 'package:mangayomi/services/http/doh/doh_custom_store.dart';
import 'package:mangayomi/services/http/cf_proxy_store.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:mangayomi/utils/constant.dart';

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
    bool useDefaultUserAgent = false,
  }) {
    final appSettings = settingsRepository.currentOrNull;
    final useDoH = appSettings?.doHEnabled ?? false;
    final doHProviderId = appSettings?.doHProviderId;

    DnsSettings? dnsSettings;

    if (useDoH && doHProviderId != null) {
      // Use DoH resolver with the selected provider — either a preset or, when
      // the custom sentinel id is set, one built from the user's saved URL.
      final provider = doHProviderId == DoHProviders.customId
          ? (DohCustomStore.url.trim().isNotEmpty
                ? DoHProviders.custom(DohCustomStore.url.trim())
                : null)
          : DoHProviders.byId[doHProviderId];
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
        MCookieManager(reqcopyWith, useDefaultUserAgent: useDefaultUserAgent),
        LoggerInterceptor(showCloudFlareError),
      ],
    );
  }

  // Matches request/stored hosts either way (exact, or one a subdomain of
  // the other) on a real dot boundary - a plain host.contains(stored) check
  // only matched when the stored host happened to be the shorter one, so a
  // cookie captured under a more specific host (e.g. the WebView landing on
  // "www.example.com") never got attached to requests against the bare
  // domain "example.com" a source actually scrapes, leaving Cloudflare
  // looking "unresolved" even right after a successful manual bypass.
  static bool _hostsMatch(String a, String b) {
    return a == b || a.endsWith('.$b') || b.endsWith('.$a') || a.contains(b);
  }

  static Map<String, String> getCookiesPref(
    String url, {
    List<MCookie>? cookiesList,
  }) {
    cookiesList ??= settingsRepository.currentOrNull?.cookiesList ?? [];
    if (cookiesList.isEmpty) return {};
    final host = Uri.parse(url).host;
    final matching = cookiesList.where(
      (element) =>
          element.host != null &&
          element.cookie != null &&
          element.cookie!.isNotEmpty &&
          _hostsMatch(host, element.host!),
    );
    if (matching.isEmpty) return {};
    final cookieMap = <String, String>{};
    for (final entry in matching) {
      for (final pair in entry.cookie!.split(';')) {
        final trimmed = pair.trim();
        if (trimmed.isEmpty) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final val = parts.sublist(1).join('=').trim();
          cookieMap[key] = val;
        }
      }
    }
    if (cookieMap.isEmpty) return {};
    final combined = cookieMap.entries
        .map((e) => '${e.key}=${e.value}')
        .join('; ');
    return {HttpHeaders.cookieHeader: combined};
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
      final existingCookies = settingsRepository.current.cookiesList ?? [];
      final filteredCookies = removeCookiesForHost(existingCookies, host);
      filteredCookies.add(
        MCookie()
          ..host = host
          ..cookie = newCookie,
      );
      await settingsRepository.update((s) => s.cookiesList = filteredCookies);
    }
    ua = normalizeUserAgent(ua);
    if (ua.isNotEmpty) {
      await settingsRepository.update((s) => s.userAgent = ua);
    }
  }

  static List<MCookie> removeCookiesForHost(
    List<MCookie> allCookies,
    String host,
  ) {
    return allCookies
        .where((cookie) => !_hostsMatch(host, cookie.host!))
        .toList();
  }

  static Future<void> deleteAllCookies(String url) async {
    final oldCookies = settingsRepository.current.cookiesList ?? [];
    final host = Uri.parse(url).host;
    final newCookies = removeCookiesForHost(oldCookies, host);
    await settingsRepository.update((s) => s.cookiesList = newCookies);
  }
}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.reqcopyWith, {this.useDefaultUserAgent = false});

  Map<String, dynamic>? reqcopyWith;
  final bool useDefaultUserAgent;

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final settings = settingsRepository.currentOrNull;
    final cookie = MClient.getCookiesPref(
      request.url.toString(),
      cookiesList: settings?.cookiesList ?? const <MCookie>[],
    );
    applyStoredRequestHeaders(
      request,
      cookieHeaders: cookie,
      userAgent: settings?.userAgent ?? defaultUserAgent,
      useDefaultUserAgent: useDefaultUserAgent,
    );
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

/// Linux WebViews can persist `navigator.userAgent` as a JSON string, including
/// the outer quotes. Normalize both newly captured and already saved values so
/// they cannot keep producing rejected requests after an app update.
@visibleForTesting
String normalizeUserAgent(String userAgent) {
  final value = userAgent.trim();
  if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is String) return decoded.trim();
    } catch (_) {}
  }
  return value;
}

/// Applies the configured browser identity as a fallback. Extensions that need
/// a source-specific user agent keep their explicit header.
@visibleForTesting
void applyDefaultUserAgent(BaseRequest request, String? userAgent) {
  if (hasUserAgentHeader(request.headers) || userAgent == null) return;

  final normalized = normalizeUserAgent(userAgent);
  if (normalized.isNotEmpty) {
    request.headers[HttpHeaders.userAgentHeader] = normalized;
  }
}

@visibleForTesting
bool hasUserAgentHeader(Map<String, String> headers) =>
    headers.keys.any((key) => key.toLowerCase() == HttpHeaders.userAgentHeader);

@visibleForTesting
void applyStoredRequestHeaders(
  BaseRequest request, {
  required Map<String, String> cookieHeaders,
  required String? userAgent,
  required bool useDefaultUserAgent,
}) {
  if (cookieHeaders.isNotEmpty &&
      request.headers[HttpHeaders.cookieHeader] == null) {
    request.headers.addAll(cookieHeaders);
  }
  if (cookieHeaders.isNotEmpty || useDefaultUserAgent) {
    applyDefaultUserAgent(request, userAgent);
  }
}

const _redactedHeaders = {
  'authorization',
  'proxy-authorization',
  'cookie',
  'set-cookie',
  'x-api-key',
  'simkl-api-key',
  'trakt-api-key',
};

/// Logs end up in a file users share on bug reports, so tracker bearer
/// tokens and site session cookies must never be written there.
@visibleForTesting
Map<String, String> redactHeaders(Map<String, String> headers) => {
  for (final MapEntry(:key, :value) in headers.entries)
    key: _redactedHeaders.contains(key.toLowerCase()) ? '<redacted>' : value,
};

final _redactedHeaderInText = RegExp(
  '\\b(${_redactedHeaders.map(RegExp.escape).join('|')}): [^,}]*',
  caseSensitive: false,
);

/// [redactHeaders] for a line that already holds a printed header map, such
/// as the worker isolate's request logs, which reach the main isolate as text.
String redactHeadersInText(String text) =>
    text.replaceAllMapped(_redactedHeaderInText, (m) => '${m[1]}: <redacted>');

class LoggerInterceptor extends InterceptorContract {
  LoggerInterceptor(this.showCloudFlareError);
  bool showCloudFlareError;
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final head = "----- Request -----\n${request.toString()}\nheaders: ";

    if (kDebugMode || useLogger) {
      // The console keeps the real headers for debugging; only the log file,
      // which gets shared, has them redacted.
      // ignore: avoid_print
      print("$head${request.headers}");
      Logger.add(LoggerLevel.info, "$head${redactHeaders(request.headers)}");
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

      if (kDebugMode || useLogger) {
        // ignore: avoid_print
        print(content);
        Logger.add(LoggerLevel.info, content);
      }
      if (cloudflare) {
        final scope = Zone.current[_cloudflareAlertScopeKey];
        if (scope is CloudflareAlertScope) {
          scope._record(response);
        } else {
          _showCloudflareAlert(response);
        }
      }
    }

    return response;
  }
}

final _cloudflareAlertScopeKey = Object();

/// Defers a final Cloudflare alert until a higher-level operation knows
/// whether that challenged request actually prevented a usable result.
class CloudflareAlertScope {
  CloudflareAlertScope({void Function(BaseResponse)? onShow})
    : _onShow = onShow ?? _showCloudflareAlert;

  final void Function(BaseResponse) _onShow;
  BaseResponse? _pendingResponse;

  Future<T> run<T>(
    Future<T> Function() operation, {
    required bool Function(T result) hasUsableResult,
  }) async {
    _pendingResponse = null;
    try {
      final result = await runZoned(
        operation,
        zoneValues: {_cloudflareAlertScopeKey: this},
      );
      _complete(hasUsableResult: hasUsableResult(result));
      return result;
    } catch (_) {
      _complete(hasUsableResult: false);
      rethrow;
    }
  }

  void _record(BaseResponse response) {
    _pendingResponse = response;
  }

  void _complete({required bool hasUsableResult}) {
    if (hasUsableResult) {
      _pendingResponse = null;
      return;
    }
    final response = _pendingResponse;
    _pendingResponse = null;
    if (response != null) _onShow(response);
  }
}

void _showCloudflareAlert(BaseResponse response) {
  // The in-app resolver is disabled on Linux, and cookies cannot be read back
  // from a webview there either, so the offer to solve it manually in one is
  // an offer nobody on Linux can take. A proxy is the only thing that gets
  // past this, so say that instead.
  final noResolverAvailable =
      Platform.isLinux && CfProxyStore.url.trim().isEmpty;
  try {
    botToast(
      noResolverAvailable
          ? "Cloudflare check. Add bypass URL: Settings > General."
          : "Cloudflare verification required (HTTP ${response.statusCode})",
      // The button opens the webview resolver, which does nothing on Linux.
      hasCloudFlare: !noResolverAvailable,
      url: response.request?.url.toString(),
      maxLines: noResolverAvailable ? 6 : 2,
    );
  } catch (e) {
    throw noResolverAvailable
        ? "Blocked by Cloudflare.\n\n\nThe in-app resolver is not available on Linux. Set a FlareSolverr or Byparr URL in Settings > General.\n\n\nstatusCode: ${response.statusCode}"
        : "Failed to bypass Cloudflare.\n\n\nYou can try to bypass it manually in the webview \n\n\nstatusCode: ${response.statusCode}";
  }
}

bool isCloudflare(BaseResponse response) {
  // `server: cloudflare` only means Cloudflare proxied the response. The
  // origin can still return its own ordinary 403 or 503. Cloudflare documents
  // `cf-mitigated: challenge` as the authoritative Challenge Page signal.
  for (final entry in response.headers.entries) {
    if (entry.key.trim().toLowerCase() == 'cf-mitigated') {
      return entry.value.trim().toLowerCase() == 'challenge';
    }
  }
  return false;
}

class ResolveCloudFlareChallenge extends RetryPolicy {
  bool showCloudFlareError;
  ResolveCloudFlareChallenge(this.showCloudFlareError);
  @override
  int get maxRetryAttempts => 2;
  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    if (!showCloudFlareError) return false;
    if (!isCloudflare(response)) return false;
    final url = response.request!.url.toString();

    // Prefer an external Cloudflare-bypass proxy (FlareSolverr / Byparr) when
    // one is configured. It also works on Linux, where the in-app webview
    // resolver below is disabled.
    final proxyUrl = CfProxyStore.url.trim();
    if (proxyUrl.isNotEmpty) {
      return solveWithCfProxy(proxyUrl, url);
    }

    // Fall back to the bundled webview resolver (not available on Linux).
    if (Platform.isLinux) return false;
    try {
      return await http
          .post(
            Uri.parse('http://localhost:$cfPort/resolve_cf'),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: jsonEncode({'url': url}),
          )
          .then((res) {
            if (res.statusCode == 200) {
              final data = jsonDecode(res.body) as Map<String, dynamic>;
              return data['result'] as bool;
            }
            return false;
          });
    } catch (e) {
      return false;
    }
  }
}

/// Solves a Cloudflare challenge for [targetUrl] through a FlareSolverr- /
/// Byparr-compatible proxy at [proxyUrl] (e.g. `http://localhost:8191/v1`).
///
/// On success it stores the returned `cf_clearance` cookies + user-agent via
/// [MClient.setCookie] (exactly like the webview resolver does), so the retried
/// request carries them, and returns `true` to trigger the retry.
Future<bool> solveWithCfProxy(String proxyUrl, String targetUrl) async {
  try {
    final res = await http
        .post(
          Uri.parse(proxyUrl),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode({
            'cmd': 'request.get',
            'url': targetUrl,
            'maxTimeout': 60000,
          }),
        )
        .timeout(const Duration(seconds: 70));
    if (res.statusCode != 200) return false;

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data['status'] != 'ok') return false;

    final solution = data['solution'] as Map<String, dynamic>?;
    if (solution == null) return false;

    final cookieList = (solution['cookies'] as List?) ?? [];
    final cookie = cookieList
        .whereType<Map>()
        .map((c) => "${c['name']}=${c['value']}")
        .join('; ');
    if (cookie.isEmpty) return false;

    final ua = (solution['userAgent'] as String?) ?? '';
    await MClient.setCookie(targetUrl, ua, null, cookie: cookie);
    return true;
  } catch (e) {
    if (kDebugMode) {
      debugPrint('CF proxy solve failed: $e');
    }
    return false;
  }
}

int cfPort = 0;
HttpServer? _cfServer;

/// Cloudflare Resolution Webview Server
Future<void> webviewServer() async {
  try {
    _cfServer = await HttpServer.bind(InternetAddress.loopbackIPv4, cfPort);
    cfPort = _cfServer!.port;
    _cfServer!.listen(
      (HttpRequest request) {
        if (request.method == 'POST' && request.uri.path == '/resolve_cf') {
          _handleResolveCf(request);
        } else if (request.method == 'POST' &&
            request.uri.path == '/evaluateJavascriptViaWebview') {
          _evaluateJavascriptViaWebview(request);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('Not Found')
            ..close();
        }
      },
      onError: (e, st) {
        if (kDebugMode) {
          debugPrint("CF server listener error: $e\n$st");
        }
      },
      cancelOnError: false,
    );
  } catch (e, st) {
    if (kDebugMode) {
      debugPrint(
        "Couldn't start Cloudflare Resolution Webview Server: $e\n$st",
      );
    }
    botToast(
      localizedMessage(
        (l10n) => l10n.cloudflare_resolution_webview_server_start_failed,
      ),
    );
  }
}

Future<void> stopwebviewServer() async {
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
  bool solved = false;
  try {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final url = data['url'] as String?;

    if (url == null) {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(jsonEncode({'error': 'Missing url parameter'}))
        ..close();
      return;
    }

    final webUri = flutter_inappwebview.WebUri(url);

    // Whether the challenge actually passed is determined by Cloudflare's
    // own cf_clearance cookie, which it only sets once the challenge is
    // solved. The previous check (a string search for '#challenge-success-
    // text' in document.head.innerHTML) is unreliable: Cloudflare's
    // challenge template references that id in a <style> block in <head>
    // from the very first load, pass or fail, so the search was true
    // immediately and the resolver silently ran out the clock without ever
    // saving cookies.
    Future<bool> hasClearanceCookie(
      flutter_inappwebview.InAppWebViewController? controller,
    ) async {
      try {
        final cookies = await flutter_inappwebview.CookieManager.instance(
          webViewEnvironment: webViewEnvironment,
        ).getCookies(url: webUri, webViewController: controller);
        return cookies.any((c) => c.name == 'cf_clearance');
      } catch (_) {
        return false;
      }
    }

    flutter_inappwebview.HeadlessInAppWebView? headlessWebView;
    headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialUrlRequest: flutter_inappwebview.URLRequest(url: webUri),
      onLoadStop: (controller, url) async {
        solved = await hasClearanceCookie(controller);

        await Future.doWhile(() async {
          if (!timeOut && !solved) {
            solved = await hasClearanceCookie(controller);
          }
          if (!solved) {
            await Future.delayed(const Duration(milliseconds: 300));
          }
          return !solved && !timeOut;
        });

        if (solved) {
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
      if (solved || timeOut) {
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
      ..write(jsonEncode({'result': solved}))
      ..close();
  } catch (e) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'error': 'Invalid JSON'}))
      ..close();
  }
}

Future<void> _evaluateJavascriptViaWebview(HttpRequest request) async {
  try {
    final body = await utf8.decoder.bind(request).join();
    final data = jsonDecode(body) as Map<String, dynamic>;
    final url = data['url'] as String;
    final headers =
        (data['headers'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, value.toString()),
        ) ??
        {};
    final scripts =
        (data['scripts'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];
    final time = data['time'] as int? ?? 30;

    int t = 0;
    bool timeOut = false;
    bool isOk = false;
    String response = "";
    flutter_inappwebview.HeadlessInAppWebView? headlessWebView;
    try {
      headlessWebView = flutter_inappwebview.HeadlessInAppWebView(
        webViewEnvironment: webViewEnvironment,
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'setResponse',
            callback: (args) {
              response = args[0] as String;
              isOk = true;
            },
          );
        },
        initialUrlRequest: flutter_inappwebview.URLRequest(
          url: flutter_inappwebview.WebUri(url),
          headers: headers,
        ),
        onLoadStop: (controller, url) async {
          for (var script in scripts) {
            await controller.platform.evaluateJavascript(source: script);
          }
        },
      );

      await headlessWebView.run();

      await Future.doWhile(() async {
        timeOut = time == t;
        if (timeOut || isOk) {
          return false;
        }
        await Future.delayed(const Duration(seconds: 1));
        t++;
        return true;
      });
    } finally {
      try {
        await headlessWebView?.dispose();
      } catch (_) {}
    }
    request.response
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'result': response}))
      ..close();
  } catch (_) {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'error': 'Invalid JSON'}))
      ..close();
  }
}
