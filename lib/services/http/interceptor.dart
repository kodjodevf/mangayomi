import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart' as cookie_jar;
import 'package:mangayomi/eval/model/m_source.dart';
import 'package:mangayomi/main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;
import 'package:mangayomi/models/settings.dart';

class MInterceptor {
  static final _cookieJar = cookie_jar.PersistCookieJar(
      ignoreExpires: true,
      storage: cookie_jar.FileStorage(
          "${isar.settings.getSync(227)!.defaultAppStoragePath}.cookies/"));
  static final flutter_inappwebview.CookieManager _cookieManager =
      flutter_inappwebview.CookieManager.instance();

  MInterceptor();

  static InterceptedClient init(
      {MSource? source, Map<String, dynamic>? reqcopyWith}) {
    return InterceptedClient.build(interceptors: [
      MCookieManager(_cookieJar, reqcopyWith),
      LoggerInterceptor()
    ]);
  }

  static Map<String, String> getCookiesPref(String url) {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    if (cookiesList.isEmpty) return {};
    final cookies = cookiesList
        .firstWhere(
          (element) => element.host == Uri.parse(url).host,
          orElse: () => MCookie(cookie: ""),
        )
        .cookie!;
    if (cookies.isEmpty) return {};
    return {HttpHeaders.cookieHeader: cookies};
  }

  static Future<void> setCookiesPref(String url) async {
    final host = Uri.parse(url).host;
    final newCookie = (await _cookieJar.loadForRequest(Uri.parse(url)))
        .map((e) => e.toString())
        .join(";");
    final settings = isar.settings.getSync(227);
    List<MCookie>? cookieList = [];
    for (var cookie in settings!.cookiesList ?? []) {
      if (cookie.host != host) {
        cookieList.add(cookie);
      }
    }
    cookieList.add(MCookie()
      ..host = host
      ..cookie = newCookie);
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..cookiesList = cookieList));
  }

  static Future<void> setCookie(String url, String ua, {String? cookie}) async {
    List<String> cookies = [];
    if (Platform.isWindows || Platform.isLinux) {
      cookies = cookie
              ?.split(RegExp('(?<=)(,)(?=[^;]+?=)'))
              .where((cookie) => cookie.isNotEmpty)
              .toList() ??
          [];
    } else {
      cookies = (await _cookieManager.getCookies(url: Uri.parse(url)))
          .map((e) => "${e.name}=${e.value}")
          .toList();
    }

    if (cookies.isNotEmpty) {
      for (final cookie in cookies) {
        await _cookieJar.saveFromResponse(
          Uri.parse(url),
          [Cookie.fromSetCookieValue(cookie)],
        );
      }
      await setCookiesPref(url);
    }
    if (ua.isNotEmpty) {
      final settings = isar.settings.getSync(227);
      isar.writeTxnSync(() => isar.settings.putSync(settings!..userAgent = ua));
    }
  }
}

class MCookieManager extends InterceptorContract {
  MCookieManager(this.cookieJar, this.reqcopyWith);
  Map<String, dynamic>? reqcopyWith;
  final cookie_jar.CookieJar cookieJar;

  static String getCookies(List<Cookie> cookies) {
    cookies.sort((a, b) {
      if (a.path == null && b.path == null) {
        return 0;
      } else if (a.path == null) {
        return -1;
      } else if (b.path == null) {
        return 1;
      } else {
        return b.path!.length.compareTo(a.path!.length);
      }
    });
    return cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  }

  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    final cookies = await cookieJar.loadForRequest(request.url);
    final previousCookies = request.headers[HttpHeaders.cookieHeader];
    final userAgent = isar.settings.getSync(227)!.userAgent!;
    final newCookies = getCookies([
      ...?previousCookies
          ?.split(';')
          .where((e) => e.isNotEmpty)
          .map((c) => Cookie.fromSetCookieValue(c)),
      ...cookies,
    ]);
    request.headers[HttpHeaders.cookieHeader] =
        newCookies.isNotEmpty ? newCookies : "";
    request.headers[HttpHeaders.userAgentHeader] = userAgent;
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
    await _saveCookies(response);
    return response;
  }

  Future<void> _saveCookies(BaseResponse response) async {
    final setCookies = response.headers[HttpHeaders.setCookieHeader];
    if (setCookies == null || setCookies.isEmpty) {
      return;
    }
    try {
      final List<Cookie> cookies = setCookies
          .split(RegExp('(?<=)(,)(?=[^;]+?=)'))
          .where((cookie) => cookie.isNotEmpty)
          .map((str) => Cookie.fromSetCookieValue(str))
          .toList();
      final statusCode = response.statusCode;
      final isRedirectRequest = statusCode >= 300 && statusCode < 400;
      final location = response.headers[HttpHeaders.locationHeader] ?? "";
      final originalUri = response.request!.url;
      final realUri = originalUri
          .resolveUri(isRedirectRequest ? Uri.parse(location) : originalUri);
      await cookieJar.saveFromResponse(realUri, cookies);
      await MInterceptor.setCookiesPref(realUri.toString());

      if (isRedirectRequest && location.isNotEmpty) {
        await Future.wait(
          [cookieJar.saveFromResponse(originalUri.resolve(location), cookies)],
        );

        await MInterceptor.setCookiesPref(
            originalUri.resolve(location).toString());
      }
    } catch (_) {}
  }
}

class LoggerInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    if (kDebugMode) {
      print('----- Request -----');
      print(request.toString());
      print(request.headers.toString());
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    final cloudflare = [403, 503].contains(response.statusCode) &&
        ["cloudflare-nginx", "cloudflare"].contains(response.headers["server"]);
    if (kDebugMode) {
      print('----- Response -----');
      print(
          "${response.request?.method}: ${response.request?.url}, statusCode: ${response.statusCode} ${cloudflare ? "Failed to bypass Cloudflare" : ""}");
    }
    if (cloudflare) {
      botToast("${response.statusCode} Failed to bypass Cloudflare");
    }
    return response;
  }
}
