import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:js_packer/js_packer.dart';
import 'package:json_path/json_path.dart';
import 'package:mangayomi/eval/model/m_http_response.dart';
import 'package:mangayomi/services/anime_extractors/dood_extractor.dart';
import 'package:mangayomi/services/anime_extractors/filemoon.dart';
import 'package:mangayomi/services/anime_extractors/gogocdn_extractor.dart';
import 'package:mangayomi/services/anime_extractors/mp4upload_extractor.dart';
import 'package:mangayomi/services/anime_extractors/mytv_extractor.dart';
import 'package:mangayomi/services/anime_extractors/okru_extractor.dart';
import 'package:mangayomi/services/anime_extractors/rapidcloud_extractor.dart';
import 'package:mangayomi/services/anime_extractors/sendvid_extractor.dart';
import 'package:mangayomi/services/anime_extractors/sibnet_extractor.dart';
import 'package:mangayomi/services/anime_extractors/streamlare_extractor.dart';
import 'package:mangayomi/services/anime_extractors/streamtape_extractor.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/modules/webview/webview.dart';
import 'package:mangayomi/services/anime_extractors/streamwish_extractor.dart';
import 'package:mangayomi/services/anime_extractors/vidbom_extractor.dart';
import 'package:mangayomi/services/anime_extractors/voe_extractor.dart';
import 'package:mangayomi/services/anime_extractors/your_upload_extractor.dart';
import 'package:mangayomi/services/http_service/cloudflare/cloudflare_bypass.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/cryptoaes/crypto_aes.dart';
import 'package:mangayomi/utils/cryptoaes/deobfuscator.dart';
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/xpath_selector.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as hp;
import 'package:encrypt/encrypt.dart' as encrypt;

class WordSet {
  final List<String> words;

  WordSet(this.words);

  bool anyWordIn(String dateString) {
    return words
        .any((word) => dateString.toLowerCase().contains(word.toLowerCase()));
  }

  bool startsWith(String dateString) {
    return words
        .any((word) => dateString.toLowerCase().startsWith(word.toLowerCase()));
  }

  bool endsWith(String dateString) {
    return words
        .any((word) => dateString.toLowerCase().endsWith(word.toLowerCase()));
  }
}

class MBridge {
  ///Seaches for the first descendant node matching the given selectors, using a preorder traversal.
  static String querySelector(
    String html,
    String selector,
    int typeElement,
    String attributes,
  ) {
    try {
      var parse = parser.parse(html);

      // return querySelector text
      if (typeElement == 0) {
        return parse
            .querySelector(selector)!
            .text
            .trim()
            .trimLeft()
            .trimRight();

        // return querySelector innerHtml
      } else if (typeElement == 1) {
        return parse
            .querySelector(selector)!
            .innerHtml
            .trim()
            .trimLeft()
            .trimRight();

        // return querySelector outerHtml
      } else if (typeElement == 2) {
        return parse
            .querySelector(selector)!
            .outerHtml
            .trim()
            .trimLeft()
            .trimRight();
      }
      // return querySelector attributes
      return parse
          .querySelector(selector)!
          .attributes[attributes]!
          .trim()
          .trimLeft()
          .trimRight();
    } catch (e) {
      botToast(e.toString());
      throw Exception(e);
    }
  }

  ///Returns all descendant nodes matching the given selectors, using a preorder traversal.
  static List<String> querySelectorAll(String html, String selector,
      int typeElement, String attributes, int typeRegExp) {
    try {
      var parse = parser.parse(html);
      final a = parse.querySelectorAll(selector);

      List<String> res = [];
      for (var element in a) {
        //text
        if (typeElement == 0) {
          res.add(element.text.trim().trimLeft().trimRight());
        }

        //innerHtml
        else if (typeElement == 1) {
          res.add(element.innerHtml.trim().trimLeft().trimRight());
        }

        //outerHtml
        else if (typeElement == 2) {
          res.add(element.outerHtml.trim().trimLeft().trimRight());
        }

        //attributes
        else if (typeElement == 3) {
          res.add(
              element.attributes[attributes]!.trim().trimLeft().trimRight());
        }
      }
      // if (typeRegExp == 0) is the default parameter
      if (typeRegExp == 0) {
        return res;
      }

      List<String> resRegExp = [];
      for (var element in res) {
        //get first element of href that match
        if (typeRegExp == 1) {
          resRegExp.add(regHrefMatcher(element.trim().trimLeft().trimRight()));
        }

        //get first element of src that match
        else if (typeRegExp == 2) {
          resRegExp.add(regSrcMatcher(element.trim().trimLeft().trimRight()));
        }

        //get first element of datasrc that match
        else if (typeRegExp == 3) {
          resRegExp
              .add(regDataSrcMatcher(element.trim().trimLeft().trimRight()));
        }

        //get first element of img that match
        else if (typeRegExp == 4) {
          resRegExp.add(regImgMatcher(element.trim().trimLeft().trimRight()));
        }
      }
      return resRegExp;
    } catch (e) {
      botToast(e.toString());
      throw Exception(e);
    }
  }

  ///Create query by html string
  static List<String> xpath(String html, String xpath) {
    List<String> attrs = [];
    try {
      var htmlXPath = HtmlXPath.html(html);
      var query = htmlXPath.query(xpath);
      if (query.nodes.length > 1) {
        for (var element in query.attrs) {
          attrs.add(element!.trim().trimLeft().trimRight());
        }
      }

      //Return one attr
      else if (query.nodes.length == 1) {
        String attr =
            query.attr != null ? query.attr!.trim().trimLeft().trimRight() : "";
        if (attr.isNotEmpty) {
          attrs = [attr];
        }
      }
      return attrs;
    } catch (e) {
      // botToast(e.toString());
      return attrs;
    }
  }

  ///A list utility function
  static List listParse(List value, int type) {
    List<dynamic> val = [];
    for (var element in value) {
      if (element is $Value) {
        val.add(element.$reified.toString());
      } else {
        val.add(element);
      }
    }
    if (type == 3) {
      return val.toSet().toList();
    } else if (type == 1) {
      return [val.first];
    } else if (type == 2) {
      return [val.last];
    } else if (type == 4) {
      return val.where((element) => element.toString().isNotEmpty).toList();
    } else if (type == 5) {
      return val.reversed.toList();
    } else if (type == 6) {
      return [val.join()];
    }
    return val;
  }

  ///Convert serie status to int
  ///[status] contains the current status of the serie
  ///[statusList] contains a list of map of many static status
  static int parseStatus(String status, List statusList) {
    for (var element in statusList) {
      Map statusMap = {};
      if (element is $Map<$Value, $Value>) {
        statusMap = element.$reified;
      } else {
        statusMap = element;
      }
      for (var element in statusMap.entries) {
        if (element.key
            .toString()
            .toLowerCase()
            .contains(status.toLowerCase().trim().trimLeft().trimRight())) {
          return element.value as int;
        }
      }
    }
    return 5;
  }

  ///Get Html content via webview when http request not working
  static Future<String> getHtmlViaWebview(String url, String rule) async {
    bool isOk = false;
    String? html;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowHeight: 500,
          windowWidth: 500,
          userDataFolderWindows: await getWebViewPath(),
        ),
      );
      webview
        ..setApplicationNameForUserAgent(defaultUserAgent)
        ..launch(url);
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 3));
        html = await decodeHtml(
          webview,
        );
        if (html == null || xpathSelector(html!).query(rule).attrs.isEmpty) {
          html = await decodeHtml(webview);
          return true;
        }
        return false;
      });
      html = await decodeHtml(webview);
      webview.close();
    } else {
      HeadlessInAppWebView? headlessWebView;
      headlessWebView = HeadlessInAppWebView(
        onLoadStop: (controller, u) async {
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          await Future.doWhile(() async {
            html = await controller.evaluateJavascript(
                source:
                    "window.document.getElementsByTagName('html')[0].outerHTML;");
            if (xpathSelector(html!).query(rule).attrs.isEmpty) {
              html = await controller.evaluateJavascript(
                  source:
                      "window.document.getElementsByTagName('html')[0].outerHTML;");
              return true;
            }
            return false;
          });
          html = await controller.evaluateJavascript(
              source:
                  "window.document.getElementsByTagName('html')[0].outerHTML;");
          isOk = true;
          headlessWebView!.dispose();
        },
        initialUrlRequest: URLRequest(
          url: Uri.parse(url),
        ),
      );
      headlessWebView.run();
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (isOk == true) {
          return false;
        }
        return true;
      });
    }
    return html!;
  }

  ///Utility to decode json to List
  static List<dynamic> jsonDecodeToList(String source, int type) {
    return type == 0
        ? jsonDecode(source) as List
        : (jsonDecode(source) as List).map((e) => jsonEncode(e)).toList();
  }

  ///Deobfuscate a JS code
  static String evalJs(String code) {
    try {
      //  JavascriptRuntime? flutterJs;
      // flutterJs = getJavascriptRuntime();
      // final res = flutterJs.evaluate(code).stringResult;
      // flutterJs.dispose();
      // return res;
      final jsPacker = JSPacker(code);
      return jsPacker.unpack() ?? "";
    } catch (e) {
      botToast(e.toString());
      throw Exception(e);
    }
  }

  ///Read values in parsed JSON object and return resut to List<String>
  static List<String> jsonPathToList(
      String source, String expression, int type) {
    try {
      //Check jsonDecode(source) is list value
      if (jsonDecode(source) is List) {
        List<dynamic> values = [];
        final val = jsonDecode(source) as List;
        for (var element in val) {
          final mMap = element as Map?;
          Map<String, dynamic> map = {};
          if (mMap != null) {
            map = mMap.map((key, value) => MapEntry(key.toString(), value));
          }
          values.add(map);
        }
        List<String> list = [];
        for (var data in values) {
          final jsonRes = JsonPath(expression).read(data);
          String val = "";

          //Get jsonRes first string value
          if (type == 0) {
            val = jsonRes.first.value.toString();
          }

          //Decode jsonRes first map value
          else {
            val = jsonEncode(jsonRes.first.value);
          }
          list.add(val);
        }
        return list;
      }

      // else jsonDecode(source) is Map value
      else {
        var map = json.decode(source);
        var values = JsonPath(expression).readValues(map);
        return values.map((e) {
          return e == null ? "{}" : json.encode(e);
        }).toList();
      }
    } catch (e) {
      botToast(e.toString());
      throw Exception(e);
    }
  }

  ///GetMapValue
  static String getMapValue(String source, String attr, bool encode) {
    try {
      var map = json.decode(source) as Map<String, dynamic>;
      if (!encode) {
        return map[attr] != null ? map[attr].toString() : "";
      }
      return map[attr] != null ? jsonEncode(map[attr]) : "";
    } catch (_) {
      return "";
    }
  }

  ///Read values in parsed JSON object and return resut to String
  static String jsonPathToString(
      String source, String expression, String join) {
    try {
      List<dynamic> values = [];

      //Check jsonDecode(source) is list value
      if (jsonDecode(source) is List) {
        final val = jsonDecode(source) as List;
        for (var element in val) {
          final mMap = element as Map?;
          Map<String, dynamic> map = {};
          if (mMap != null) {
            map = mMap.map((key, value) => MapEntry(key.toString(), value));
          }
          values.add(map);
        }
      }

      // else jsonDecode(source) is Map value
      else {
        final mMap = jsonDecode(source) as Map?;
        Map<String, dynamic> map = {};
        if (mMap != null) {
          map = mMap.map((key, value) => MapEntry(key.toString(), value));
        }
        values.add(map);
      }

      List<String> listRg = [];

      for (var data in values) {
        final jsonRes = JsonPath(expression).readValues(data);
        List list = [];

        for (var element in jsonRes) {
          list.add(element);
        }
        //join the list into listRg
        listRg.add(list.join(join));
      }
      return listRg.first;
    } catch (e) {
      botToast(e.toString());
      throw Exception(e);
    }
  }

  //Utility to decode json values as Map<String,dynamic>
  static Map jsonPathToMap(String source) {
    final mMap = jsonDecode(source) as Map?;
    Map<String, dynamic> map = {};
    if (mMap != null) {
      map = mMap.map((key, value) => MapEntry(key.toString(), value));
    }
    return map;
  }

  //Parse a list of dates to millisecondsSinceEpoch
  static List listParseDateTime(
      List value, String dateFormat, String dateFormatLocale) {
    List<dynamic> val = [];
    for (var element in value) {
      if (element is $Value) {
        val.add(element.$reified.toString());
      } else {
        val.add(element);
      }
    }

    List<dynamic> valD = [];
    for (var date in val) {
      if (date.toString().isNotEmpty) {
        valD.add(parseChapterDate(date, dateFormat, dateFormatLocale));
      }
    }
    return valD;
  }

  static List sortMapList(List list, String value, int type) {
    if (type == 0) {
      list.sort((a, b) => a[value].compareTo(b[value]));
    } else if (type == 1) {
      list.sort((a, b) => b[value].compareTo(a[value]));
    }

    return list;
  }

  //Utility to use RegExp
  static String regExp(
      //RegExp(r'\[a\]'), "[123]")
      String expression,
      String source,
      String replace,
      int type,
      int group) {
    if (type == 0) {
      return expression.replaceAll(RegExp(source), replace);
    }
    return regCustomMatcher(expression, source, group);
  }

  //Utility to parse $int to int
  static int intParse(String value) {
    return int.parse(value);
  }

  //Utility to check if list contains a value
  static bool listContain(List value, String element) {
    List<dynamic> val = [];
    for (var element in value) {
      val.add(element.$reified);
    }
    return val.contains(element);
  }

  //Http request for MultiparFormData
  static Future<String> httpMultiparFormData(String url, int method) async {
    try {
      hp.StreamedResponse? res;
      String result = "";
      final headersMap = jsonDecode(url)["headers"] as Map?;

      final fieldsMap = jsonDecode(url)["fields"] as Map?;
      Map<String, String> fields = {};
      if (fieldsMap != null) {
        fields = fieldsMap
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }
      Map<String, String> headers = {};
      if (headersMap != null) {
        headers = headersMap
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }

      var request = hp.MultipartRequest(
          method == 0
              ? 'GET'
              : method == 1
                  ? 'POST'
                  : method == 2
                      ? 'PUT'
                      : 'DELETE',
          Uri.parse(url));
      request.fields.addAll(fields);

      request.headers.addAll(headers);

      res = await request.send();

      if (res.statusCode != 200) {
        result = "400";
      } else if (res.statusCode == 200) {
        result = await res.stream.bytesToString();
      } else {
        result = res.reasonPhrase!;
      }

      return result;
    } catch (e) {
      botToast(e.toString());
      return "";
    }
  }

  //http request and also webview
  static Future<MHttpResponse> http(String method, String datas) async {
    try {
      hp.StreamedResponse? res;

      //Get headers
      final headersMap = jsonDecode(datas)["headers"] as Map?;

      //Get sourceId
      final sourceId = jsonDecode(datas)["sourceId"] as int?;

      //Get body
      final bodyMap = jsonDecode(datas)["body"] as Map?;

      final url = jsonDecode(datas)["url"] as String;
      //Convert body Map<dynamic,dynamic> to Map<String,String>
      Map<String, dynamic> body = {};
      if (bodyMap != null) {
        body = bodyMap.map((key, value) => MapEntry(key.toString(), value));
      }

      //Convert headers Map<dynamic,dynamic> to Map<String,String>
      Map<String, String> headers = {};
      if (headersMap != null) {
        headers = headersMap
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }

      //Get the serie source
      final source = sourceId != null ? isar.sources.getSync(sourceId) : null;

      //Do the http request if the serie hasn't cloudflare
      var request = hp.Request(method, Uri.parse(url));

      if (bodyMap != null) {
        request.body = json.encode(body);
      }

      request.headers.addAll(headers);

      res = await request.send();
      MHttpResponse httpResponse = MHttpResponse();
      if (res.statusCode != 200 && (source?.hasCloudflare ?? false)) {
        final result = await cloudflareBypass(
            url: url, sourceId: source!.id.toString(), method: 0);
        httpResponse =
            MHttpResponse(body: result, statusCode: 200, hasError: false);
      } else {
        httpResponse = MHttpResponse(
            body: res.statusCode == 200
                ? await res.stream.bytesToString()
                : res.reasonPhrase,
            statusCode: res.statusCode,
            hasError: res.statusCode != 200);
      }

      return httpResponse;
    } catch (e) {
      botToast(e.toString());
      return MHttpResponse(body: e.toString(), statusCode: 0, hasError: true);
    }
  }

  static Future<List<Video>> gogoCdnExtractor(String url) async {
    return await GogoCdnExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> doodExtractor(String url, String? quality) async {
    return await DoodExtractor().videosFromUrl(url, quality: quality);
  }

  static Future<List<Video>> streamWishExtractor(
      String url, String prefix) async {
    return await StreamWishExtractor().videosFromUrl(url, prefix);
  }

  static Future<List<Video>> filemoonExtractor(
      String url, String prefix) async {
    return await FilemoonExtractor().videosFromUrl(url, prefix);
  }

  static Future<List<Video>> mp4UploadExtractor(
      String url, String? headers, String prefix, String suffix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return await Mp4uploadExtractor()
        .videosFromUrl(url, newHeaders, prefix: prefix, suffix: suffix);
  }

  static Future<List<Video>> streamTapeExtractor(
      String url, String? quality) async {
    return await StreamTapeExtractor()
        .videosFromUrl(url, quality: quality ?? "StreamTape");
  }

  //Utility to use substring
  static String substringAfter(String text, String pattern) {
    return text.substringAfter(pattern);
  }

  //Utility to use substring
  static String substringBefore(String text, String pattern) {
    return text.substringBefore(pattern);
  }

  //Utility to use substring
  static String substringBeforeLast(String text, String pattern) {
    return text.substringBeforeLast(pattern);
  }

  static String substringAfterLast(String text, String pattern) {
    return text.split(pattern).last;
  }

  //Parse a chapter date to millisecondsSinceEpoch
  static String parseChapterDate(
      String date, String dateFormat, String dateFormatLocale) {
    int parseRelativeDate(String date) {
      final number = int.tryParse(RegExp(r"(\d+)").firstMatch(date)!.group(0)!);
      if (number == null) return 0;
      final cal = DateTime.now();

      if (WordSet([
        "hari",
        "gün",
        "jour",
        "día",
        "dia",
        "day",
        "วัน",
        "ngày",
        "giorni",
        "أيام",
        "天"
      ]).anyWordIn(date)) {
        return cal.subtract(Duration(days: number)).millisecondsSinceEpoch;
      } else if (WordSet([
        "jam",
        "saat",
        "heure",
        "hora",
        "hour",
        "ชั่วโมง",
        "giờ",
        "ore",
        "ساعة",
        "小时"
      ]).anyWordIn(date)) {
        return cal.subtract(Duration(hours: number)).millisecondsSinceEpoch;
      } else if (WordSet(
              ["menit", "dakika", "min", "minute", "minuto", "นาที", "دقائق"])
          .anyWordIn(date)) {
        return cal.subtract(Duration(minutes: number)).millisecondsSinceEpoch;
      } else if (WordSet(["detik", "segundo", "second", "วินาที", "sec"])
          .anyWordIn(date)) {
        return cal.subtract(Duration(seconds: number)).millisecondsSinceEpoch;
      } else if (WordSet(["week", "semana"]).anyWordIn(date)) {
        return cal.subtract(Duration(days: number * 7)).millisecondsSinceEpoch;
      } else if (WordSet(["month", "mes"]).anyWordIn(date)) {
        return cal.subtract(Duration(days: number * 30)).millisecondsSinceEpoch;
      } else if (WordSet(["year", "año"]).anyWordIn(date)) {
        return cal
            .subtract(Duration(days: number * 365))
            .millisecondsSinceEpoch;
      } else {
        return 0;
      }
    }

    try {
      if (WordSet(["yesterday", "يوم واحد"]).startsWith(date)) {
        DateTime cal = DateTime.now().subtract(const Duration(days: 1));
        cal = DateTime(cal.year, cal.month, cal.day);
        return cal.millisecondsSinceEpoch.toString();
      } else if (WordSet(["today"]).startsWith(date)) {
        DateTime cal = DateTime.now();
        cal = DateTime(cal.year, cal.month, cal.day);
        return cal.millisecondsSinceEpoch.toString();
      } else if (WordSet(["يومين"]).startsWith(date)) {
        DateTime cal = DateTime.now().subtract(const Duration(days: 2));
        cal = DateTime(cal.year, cal.month, cal.day);
        return cal.millisecondsSinceEpoch.toString();
      } else if (WordSet(["ago", "atrás", "önce", "قبل"]).endsWith(date)) {
        return parseRelativeDate(date).toString();
      } else if (WordSet(["hace"]).startsWith(date)) {
        return parseRelativeDate(date).toString();
      } else if (date.contains(RegExp(r"\d(st|nd|rd|th)"))) {
        final cleanedDate = date
            .split(" ")
            .map((it) => it.contains(RegExp(r"\d\D\D"))
                ? it.replaceAll(RegExp(r"\D"), "")
                : it)
            .join(" ");
        return DateFormat(dateFormat, dateFormatLocale)
            .parse(cleanedDate)
            .millisecondsSinceEpoch
            .toString();
      } else {
        return DateFormat(dateFormat, dateFormatLocale)
            .parse(date)
            .millisecondsSinceEpoch
            .toString();
      }
    } catch (e) {
      final supportedLocales = DateFormat.allLocalesWithSymbols();

      for (var locale in supportedLocales) {
        for (var dateFormat in _dateFormats) {
          try {
            initializeDateFormatting(locale);
            if (WordSet(["yesterday", "يوم واحد"]).startsWith(date)) {
              DateTime cal = DateTime.now().subtract(const Duration(days: 1));
              cal = DateTime(cal.year, cal.month, cal.day);
              return cal.millisecondsSinceEpoch.toString();
            } else if (WordSet(["today"]).startsWith(date)) {
              DateTime cal = DateTime.now();
              cal = DateTime(cal.year, cal.month, cal.day);
              return cal.millisecondsSinceEpoch.toString();
            } else if (WordSet(["يومين"]).startsWith(date)) {
              DateTime cal = DateTime.now().subtract(const Duration(days: 2));
              cal = DateTime(cal.year, cal.month, cal.day);
              return cal.millisecondsSinceEpoch.toString();
            } else if (WordSet(["ago", "atrás", "önce", "قبل"])
                .endsWith(date)) {
              return parseRelativeDate(date).toString();
            } else if (WordSet(["hace"]).startsWith(date)) {
              return parseRelativeDate(date).toString();
            } else if (date.contains(RegExp(r"\d(st|nd|rd|th)"))) {
              final cleanedDate = date
                  .split(" ")
                  .map((it) => it.contains(RegExp(r"\d\D\D"))
                      ? it.replaceAll(RegExp(r"\D"), "")
                      : it)
                  .join(" ");
              return DateFormat(dateFormat, locale)
                  .parse(cleanedDate)
                  .millisecondsSinceEpoch
                  .toString();
            } else {
              return DateFormat(dateFormat, locale)
                  .parse(date)
                  .millisecondsSinceEpoch
                  .toString();
            }
          } catch (_) {}
        }
      }
      botToast(e.toString());
      throw Exception(e);
    }
  }

  static String deobfuscateJsPassword(String inputString) {
    return Deobfuscator.deobfuscateJsPassword(inputString);
  }

  static Future<List<Video>> sibnetExtractor(String url) async {
    return await SibnetExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> sendVidExtractor(
      String url, String? headers, String prefix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }

    return await SendvidExtractor(newHeaders)
        .videosFromUrl(url, prefix: prefix);
  }

  static Future<List<Video>> myTvExtractor(String url) async {
    return await MytvExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> okruExtractor(String url) async {
    return await OkruExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> yourUploadExtractor(
      String url, String? headers, String? name, String prefix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return await YourUploadExtractor().videosFromUrl(url, newHeaders,
        prefix: prefix, name: name ?? "YourUpload");
  }

  static Future<List<Video>> voeExtractor(String url, String? quality) async {
    return await VoeExtractor().videosFromUrl(url, quality);
  }

  static Future<List<Video>> vidBomExtractor(String url) async {
    return await VidBomExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> streamlareExtractor(
      String url, String prefix, String suffix) async {
    return await StreamlareExtractor()
        .videosFromUrl(url, prefix: prefix, suffix: suffix);
  }

  static Future<List<Video>> rapidCloudExtractor(
      String url, String prefix) async {
    return await RapidCloudExtractor().videosFromUrl(url, prefix);
  }

  static String encryptAESCryptoJS(String plainText, String passphrase) {
    return CryptoAES.encryptAESCryptoJS(plainText, passphrase);
  }

  static String decryptAESCryptoJS(String encrypted, String passphrase) {
    return CryptoAES.decryptAESCryptoJS(encrypted, passphrase);
  }

  static Video toVideo(String url, String quality, String originalUrl,
      String? headers, List<Track>? subtitles, List<Track>? audios) {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return Video(url, quality, originalUrl,
        headers: newHeaders, subtitles: subtitles ?? [], audios: audios ?? []);
  }

  static String cryptoHandler(
      String text, String iv, String secretKeyString, bool encrypt) {
    if (encrypt) {
      final encryptt = _encrypt(secretKeyString, iv);
      final en = encryptt.$1.encrypt(text, iv: encryptt.$2);
      return en.base64;
    } else {
      final encryptt = _encrypt(secretKeyString, iv);
      final en = encryptt.$1.decrypt64(text, iv: encryptt.$2);
      return en;
    }
  }
}

final List<String> _dateFormats = [
  'dd/MM/yyyy',
  'MM/dd/yyyy',
  'yyyy/MM/dd',
  'dd-MM-yyyy',
  'MM-dd-yyyy',
  'yyyy-MM-dd',
  'dd.MM.yyyy',
  'MM.dd.yyyy',
  'yyyy.MM.dd',
  'dd MMMM yyyy',
  'MMMM dd, yyyy',
  'yyyy MMMM dd',
  'dd MMM yyyy',
  'MMM dd yyyy',
  'yyyy MMM dd',
  'dd MMMM, yyyy',
  'yyyy, MMMM dd',
  'MMMM dd yyyy',
  'MMM dd, yyyy',
  'dd LLLL yyyy',
  'LLLL dd, yyyy',
  'yyyy LLLL dd',
  'LLLL dd yyyy',
  "MMMMM dd, yyyy",
  "MMM d, yyy",
  "MMM d, yyyy",
  "dd/mm/yyyy",
  "d MMMM yyyy",
  "dd 'de' MMMM 'de' yyyy",
  "d MMMM'،' yyyy",
  "yyyy'年'M'月'd",
  "d MMMM, yyyy",
  "dd 'de' MMMMM 'de' yyyy",
  "dd MMMMM, yyyy",
  "MMMM d, yyyy",
  "MMM dd,yyyy"
];
void botToast(String title) {
  BotToast.showSimpleNotification(
      onlyOne: true,
      dismissDirections: [DismissDirection.horizontal, DismissDirection.down],
      align: const Alignment(0, 0.99),
      duration: const Duration(seconds: 10),
      title: title);
}

(encrypt.Encrypter, encrypt.IV) _encrypt(String keyy, String ivv) {
  final key = encrypt.Key.fromUtf8(keyy);
  final iv = encrypt.IV.fromUtf8(ivv);
  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  return (encrypter, iv);
}
