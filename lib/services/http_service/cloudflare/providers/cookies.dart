// import 'dart:developer';
// import 'dart:io';
// import 'package:cookie_jar/cookie_jar.dart';
// import 'package:dio/dio.dart';
// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:mangayomi/utils/constant.dart';
// import 'package:path_provider/path_provider.dart';

// class SetCookie {
//   static onSet(List cookiesList, String url) async {
//     final dio = Dio();
//     List<Cookie> jarCookies = [];
//     if (cookiesList.isNotEmpty) {
//       for (var i in cookiesList) {
//         if (i.name == 'cf_clearance') {
//           Cookie jarCookie = Cookie(i.name, i.value);
//           log(i.value);
//           jarCookies.add(jarCookie);
//         }
//       }
//     }
//     final cookieJar = CookieJar();
//     await cookieJar.saveFromResponse(Uri.parse(url), jarCookies);

//     dio.interceptors.add(CookieManager(cookieJar));

//     final tt = await dio.get(url,
//         options: Options(headers: {'User-Agent': defaultUserAgent}));
//     print(tt.statusCode);

//     return true;
//   }
// }

