import 'dart:developer';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/utils/constant.dart';

setCookie(String source, String url) async {
  source = source.toLowerCase();
  final hiveSetting = Hive.box(HiveConstant.hiveBoxAppSettings);
  List<Cookie> cookies = [];
  CookieManager cookie = CookieManager.instance();
  cookies = await cookie.getCookies(url: WebUri.uri(Uri.parse(url.toString())));
  final cf_clearance =
      cookies.where((element) => element.name == "cf_clearance").toList();
  String newCookie = "";
  if (cf_clearance.isNotEmpty &&
      cf_clearance.first.name !=
          hiveSetting.get("$source-cookie", defaultValue: "")) {
    for (var i = 0; i < cookies.length; i++) {
      newCookie = "$newCookie ${cookies[i].name}=${cookies[i].value};";
    }
    hiveSetting.put("$source-cookie", newCookie);
  }
}
