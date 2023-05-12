import 'package:html/dom.dart';
import 'package:mangayomi/services/http_service/cloudflare/cloudflare_bypass.dart';
import 'package:mangayomi/services/http_service/http_res_to_dom_html.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/utils/headers.dart';

Future<dynamic> httpGet(
    {required String url,
    required String source,
    required bool resDom,
    bool useUserAgent = false}) async {
  bool isCloudflaree = isCloudflare(source);
  if (resDom) {
    Document? dom;
    if (isCloudflaree) {
      dom = await cloudflareBypassDom(
          url: url, source: source, useUserAgent: useUserAgent);
    } else {
      dom = await httpResToDom(url: url, headers: headers(source));
    }
    return dom;
  } else {
    String? resHtml;
    if (isCloudflaree) {
      resHtml = await cloudflareBypassHtml(
        url: url,
        source: source,
        useUserAgent: useUserAgent,
      );
    } else {
      try {
        final response =
            await http.get(Uri.parse(url), headers: headers(source));
        resHtml = response.body;
      } catch (e) {
        rethrow;
      }
    }
    return resHtml;
  }
}
