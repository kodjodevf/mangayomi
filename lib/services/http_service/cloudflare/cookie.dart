import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mangayomi/services/http_service/cloudflare/providers/cookie_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cookie.g.dart';

@riverpod
Future setCookie(SetCookieRef ref, String source, String url) async {
  source = source.toLowerCase();
  final cookieS = ref.watch(cookieStateProvider(source));

  List<Cookie> cookies = [];
  CookieManager cookie = CookieManager.instance();
  cookies = await cookie.getCookies(url: WebUri.uri(Uri.parse(url.toString())));
  final cfClearance =
      cookies.where((element) => element.name == "cf_clearance").toList();
  String newCookie = "";
  if (cfClearance.isNotEmpty && cfClearance.first.name != cookieS) {
    for (var i = 0; i < cookies.length; i++) {
      newCookie = "$newCookie ${cookies[i].name}=${cookies[i].value};";
    }
    ref.read(cookieStateProvider(source).notifier).setCookie(newCookie);
  }
}
