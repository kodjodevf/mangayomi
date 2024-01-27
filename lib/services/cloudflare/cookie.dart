import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'
    as flutter_inappwebview;

class CookieState {
  String? idSource;
  CookieState({required String idSource});

  String get() {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    return cookiesList
        .firstWhere(
          (element) => element.idSource == idSource,
          orElse: () => Cookie(cookie: ""),
        )
        .cookie!;
  }

  void set(String newCookie, String ua) {
    final settings = isar.settings.getSync(227);
    List<Cookie>? cookieList = [];
    for (var cookie in settings!.cookiesList ?? []) {
      if (cookie.idSource != idSource) {
        cookieList.add(cookie);
      }
    }

    cookieList.add(Cookie()
      ..idSource = idSource
      ..cookie = newCookie);
    isar.writeTxnSync(() => isar.settings.putSync(settings
      ..cookiesList = cookieList
      ..userAgent = ua));
  }
}

Future<void> addCookie(String sourceId, String url, String ua) async {
  flutter_inappwebview.CookieManager cookieManager =
      flutter_inappwebview.CookieManager.instance();

  final cookie = (await cookieManager.getCookie(
      url: flutter_inappwebview.WebUri(url), name: "cf_clearance"));
  if (cookie != null) {
    final newCookie = "${cookie.name}=${cookie.value}";

    CookieState(idSource: sourceId).set(newCookie, ua);
  }
}
