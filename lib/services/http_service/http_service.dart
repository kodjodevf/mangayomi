// import 'package:html/dom.dart';
// import 'package:mangayomi/services/http_service/cloudflare/cloudflare_bypass.dart';
// import 'package:http/http.dart' as http;
// import 'package:mangayomi/sources/utils/utils.dart';
// import 'package:mangayomi/utils/headers.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// part 'http_service.g.dart';

// @riverpod
// Future<dynamic> httpGet(HttpGetRef ref,
//     {required String url,
//     required String source,
//     required String lang,
//     required bool resDom,
//     Map<String, String>? headers,
//     bool useUserAgent = false}) async {
//   bool hasCloudflaree = hasCloudflare(source);
//   if (resDom) {
//     Document? dom;
//     if (hasCloudflaree) {
//       dom = await ref.read(cloudflareBypassDomProvider(
//               url: url, source: source, useUserAgent: useUserAgent)
//           .future);
//     } else {
//       dom = await httpResToDom(
//           url: url,
//           headers: headers ??
//               ref.watch(headersProvider(source: source, lang: lang)));
//     }
//     return dom;
//   } else {
//     String? resHtml;
//     if (hasCloudflaree) {
//       resHtml = await ref.read(cloudflareBypassHtmlProvider(
//               url: url, source: source, useUserAgent: useUserAgent)
//           .future);
//     } else {
//       try {
//         final response = await http.get(Uri.parse(url),
//             headers: headers ??
//                 ref.watch(headersProvider(source: source, lang: lang)));
//         resHtml = response.body;
//       } catch (e) {
//         rethrow;
//       }
//     }
//     return resHtml;
//   }
// }

// Future<Document> httpResToDom(
//     {required String url, required Map<String, String>? headers}) async {
//   final response = await http.get(Uri.parse(url), headers: headers);
//   return Document.html(response.body);
// }
