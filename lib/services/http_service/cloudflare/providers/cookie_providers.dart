import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'cookie_providers.g.dart';

@riverpod
class CookieState extends _$CookieState {
  @override
  String build(String idSource) {
    final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
    final cookieList =
        cookiesList.where((element) => element.idSource == idSource).toList();
    String cookie = "";
    if (cookieList.isNotEmpty) {
      cookie = cookieList.first.cookie!.toString();
    }

    return cookie;
  }

  void setCookie(String newCookie) {
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
    isar.writeTxnSync(
        () => isar.settings.putSync(settings..cookiesList = cookieList));
  }
}

void setCookieB(String newCookie, String idSource) {
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
  isar.writeTxnSync(
      () => isar.settings.putSync(settings..cookiesList = cookieList));
}

String getCookie(String idSource) {
  final cookiesList = isar.settings.getSync(227)!.cookiesList ?? [];
  final cookieList =
      cookiesList.where((element) => element.idSource == idSource).toList();
  String cookie = "";
  if (cookieList.isNotEmpty) {
    cookie = cookieList.first.cookie!.toString();
  }
  return cookie;
}
