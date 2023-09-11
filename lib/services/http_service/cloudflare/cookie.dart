import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/services/http_service/cloudflare/providers/cookie_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cookie.g.dart';

@riverpod
Future setCookie(SetCookieRef ref, String sourceId, String url) async {
  CookieManager cookie = CookieManager.instance();

  final cookies = await cookie.getCookies(url: Uri.parse(url.toString()));
  final newCookie =
      cookies.where((element) => element.name == "cf_clearance").toList();
  if (newCookie.isNotEmpty) {
    ref
        .read(cookieStateProvider(sourceId).notifier)
        .setCookie("cf_clearance=${newCookie.first.value};");
  }
}

Future setCookieB(String sourceId, String url) async {
  CookieManager cookie = CookieManager.instance();

  final cookies = await cookie.getCookies(url: Uri.parse(url.toString()));
  final newCookie =
      cookies.where((element) => element.name == "cf_clearance").toList();
  if (newCookie.isNotEmpty) {
    setCookieB("cf_clearance=${newCookie.first.value};", sourceId);
  }
}
