import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dart_eval/dart_eval.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:js_packer/js_packer.dart';
import 'package:json_path/json_path.dart';
import 'package:mangayomi/eval/bridge_class/model.dart';
import 'package:mangayomi/eval/bridge_class/video_model.dart';
import 'package:mangayomi/services/anime_extractors/dood_extractor.dart';
import 'package:mangayomi/services/anime_extractors/filemoon.dart';
import 'package:mangayomi/services/anime_extractors/gogocdn_extractor.dart';
import 'package:mangayomi/services/anime_extractors/mp4upload_extractor.dart';
import 'package:mangayomi/services/anime_extractors/mytv_extractor.dart';
import 'package:mangayomi/services/anime_extractors/okru_extractor.dart';
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
import 'package:mangayomi/utils/extensions.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/utils/xpath_selector.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as hp;

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
  static String querySelector(
    String html,
    String selector,
    int typeElement,
    String attributes,
  ) {
    try {
      var parse = parser.parse(html);

      if (typeElement == 0) {
        return parse
            .querySelector(selector)!
            .text
            .trim()
            .trimLeft()
            .trimRight();
      } else if (typeElement == 1) {
        return parse
            .querySelector(selector)!
            .innerHtml
            .trim()
            .trimLeft()
            .trimRight();
      } else if (typeElement == 2) {
        return parse
            .querySelector(selector)!
            .outerHtml
            .trim()
            .trimLeft()
            .trimRight();
      }
      return parse
          .querySelector(selector)!
          .attributes[attributes]!
          .trim()
          .trimLeft()
          .trimRight();
    } catch (e) {
      _botToast(e.toString());
      throw Exception(e);
    }
  }

  static String querySelectorAll(String html, String selector, int typeElement,
      String attributes, int typeRegExp, int position, String join) {
    try {
      var parse = parser.parse(html);
      final a = parse.querySelectorAll(selector);

      List<dynamic> res = [];
      for (var element in a) {
        if (typeElement == 0) {
          res.add(element.text.trim().trimLeft().trimRight());
        } else if (typeElement == 1) {
          res.add(element.innerHtml.trim().trimLeft().trimRight());
        } else if (typeElement == 2) {
          res.add(element.outerHtml.trim().trimLeft().trimRight());
        } else if (typeElement == 3) {
          res.add(
              element.attributes[attributes]!.trim().trimLeft().trimRight());
        }
      }

      if (typeRegExp == 0) {
        if (position == 0) {
          return res.join(join);
        } else if (position == 1) {
          return res.first;
        }
        return res.last;
      }
      List<dynamic> resRegExp = [];
      for (var element in res) {
        if (typeRegExp == 1) {
          resRegExp.add(regHrefMatcher(element.trim().trimLeft().trimRight()));
        } else if (typeRegExp == 2) {
          resRegExp.add(regSrcMatcher(element.trim().trimLeft().trimRight()));
        } else if (typeRegExp == 3) {
          resRegExp
              .add(regDataSrcMatcher(element.trim().trimLeft().trimRight()));
        } else if (typeRegExp == 4) {
          resRegExp.add(regImgMatcher(element.trim().trimLeft().trimRight()));
        } else if (typeRegExp == 5) {
          resRegExp.add(regImgMatcher(element.trim().trimLeft().trimRight()));
        }
      }
      if (position == 0) {
        return resRegExp.join(join);
      } else if (position == 1) {
        return resRegExp.first.trim().trimLeft().trimRight();
      }

      return resRegExp.last.trim().trimLeft().trimRight();
    } catch (e) {
      _botToast(e.toString());
      throw Exception(e);
    }
  }

  static String xpath(String html, String xpath, String join) {
    try {
      List<String?> attrs = [];
      var htmlXPath = HtmlXPath.html(html);
      var query = htmlXPath.query(xpath);
      if (query.nodes.length > 1) {
        for (var element in query.attrs) {
          attrs.add(element!.trim().trimLeft().trimRight());
        }
        return attrs.join(join);
      } else {
        String? attr =
            query.attr != null ? query.attr!.trim().trimLeft().trimRight() : "";
        return attr;
      }
    } catch (e) {
      // _botToast(e.toString());
      return "";
    }
  }

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
        await Future.delayed(const Duration(seconds: 10));
        html = await decodeHtml(webview);
        if (xpathSelector(html!).query(rule).attrs.isEmpty) {
          html = await decodeHtml(webview);
          return true;
        }
        return false;
      });
      html = await decodeHtml(webview);
      isOk = true;
      await Future.doWhile(() async {
        await Future.delayed(const Duration(seconds: 1));
        if (isOk == true) {
          return false;
        }
        return true;
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

  static List<dynamic> jsonDecodeToList(String source, int type) {
    return type == 0
        ? jsonDecode(source) as List
        : (jsonDecode(source) as List).map((e) => jsonEncode(e)).toList();
  }

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
      _botToast(e.toString());
      throw Exception(e);
    }
  }

  static List<String> jsonPathToList(
      String source, String expression, int type) {
    try {
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
          if (type == 0) {
            val = jsonRes.first.value.toString();
          } else {
            val = jsonEncode(jsonRes.first.value);
          }
          list.add(val);
        }
        return list;
      } else {
        var map = json.decode(source);
        var values = JsonPath(expression).readValues(map);
        return values.map((e) {
          return e == null ? "{}" : json.encode(e);
        }).toList();
      }
    } catch (e) {
      _botToast(e.toString());
      throw Exception(e);
    }
  }

  static String getMapValue(String source, String attr, int type) {
    try {
      var map = json.decode(source) as Map<String, dynamic>;
      if (type == 0) {
        return map[attr] != null ? map[attr].toString() : "";
      }
      return map[attr] != null ? jsonEncode(map[attr]) : "";
    } catch (_) {
      return "";
    }
  }

  static String jsonPathToString(
      String source, String expression, String join) {
    try {
      List<dynamic> values = [];

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
      } else {
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
        listRg.add(list.join(join));
      }
      return listRg.first;
    } catch (e) {
      _botToast(e.toString());
      throw Exception(e);
    }
  }

  static Map jsonPathToMap(String source) {
    final mMap = jsonDecode(source) as Map?;
    Map<String, dynamic> map = {};
    if (mMap != null) {
      map = mMap.map((key, value) => MapEntry(key.toString(), value));
    }
    return map;
  }

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

  static String stringParse(String value, int type) {
    if (type == 0) {
      return value;
    } else if (type == 1) {
      return String.fromCharCode(int.parse(value));
    }
    return String.fromCharCodes(
        value.split('.-').map((e) => int.parse(e)).toList());
  }

  static dynamic stringParseValue(dynamic value) {
    return value;
  }

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

  static int intParse(String value) {
    return int.parse(value);
  }

  static bool listContain(List value, String element) {
    List<dynamic> val = [];
    for (var element in value) {
      val.add(element.$reified);
    }
    return val.contains(element);
  }

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
          Uri.parse(jsonDecode(url)["url"]));
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
      _botToast(e.toString());
      return "";
    }
  }

  static Future<String> http(String url, int method) async {
    try {
      hp.StreamedResponse? res;
      String result = "";
      final headersMap = jsonDecode(url)["headers"] as Map?;
      final sourceId = jsonDecode(url)["sourceId"] as int?;

      final bodyMap = jsonDecode(url)["body"] as Map?;
      Map<String, dynamic> body = {};
      if (bodyMap != null) {
        body = bodyMap.map((key, value) => MapEntry(key.toString(), value));
      }
      Map<String, String> headers = {};
      if (headersMap != null) {
        headers = headersMap
            .map((key, value) => MapEntry(key.toString(), value.toString()));
      }
      final source = sourceId != null ? isar.sources.getSync(sourceId) : null;
      if (source != null && source.hasCloudflare!) {
        final res = await cloudflareBypass(
            url: jsonDecode(url)["url"],
            sourceId: source.id.toString(),
            method: method);
        return res;
      }
      var request = hp.Request(
          method == 0
              ? 'GET'
              : method == 1
                  ? 'POST'
                  : method == 2
                      ? 'PUT'
                      : 'DELETE',
          Uri.parse(jsonDecode(url)["url"]));
      if (bodyMap != null) {
        request.body = json.encode(body);
      }

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
      _botToast(e.toString());
      return "";
    }
  }

  static Future<List<Video>> gogoCdnExtractor(String url) async {
    return await GogoCdnExtractor().videosFromUrl(
      url,
    );
  }

  static Future<List<Video>> doodExtractor(String url) async {
    return await DoodExtractor().videosFromUrl(
      url,
    );
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

  static Future<List<Video>> streamTapeExtractor(String url) async {
    return await StreamTapeExtractor().videosFromUrl(
      url,
    );
  }

  static String subString(String text, String pattern, int type) {
    String result = "";
    if (type == 0) {
      result = text.substringBefore(pattern);
    } else if (type == 1) {
      result = text.split(pattern).last;
    } else if (type == 2) {
      result = text.substringAfter(pattern);
    }
    return result;
  }

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
      } else if (WordSet(["detik", "segundo", "second", "วินาที"])
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
      _botToast(e.toString());
      throw Exception(e);
    }
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

  static String bAse64(String text, int type) {
    return utf8.decode(base64.decode(text));
  }

  static Video toVideo(
      String url, String quality, String originalUrl, String? headers) {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map)
          .map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return Video(url, quality, originalUrl, headers: newHeaders);
  }

  static bool isEmptyOrIsNotEmpty(dynamic value, int type) {
    if (value is List) {
      return type == 0 ? value.isEmpty : value.isNotEmpty;
    }
    if (value is String) {
      return type == 0 ? value.isEmpty : value.isNotEmpty;
    }

    return type == 0 ? value.isEmpty : value.isNotEmpty;
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

class $MBridge extends MBridge with $Bridge {
  static const $type = BridgeTypeRef(
      BridgeTypeSpec('package:bridge_lib/bridge_lib.dart', 'MBridge'));

  static const $declaration = BridgeClassDef(BridgeClassType($type),
      constructors: {
        '': BridgeConstructorDef(BridgeFunctionDef(
            returns: BridgeTypeAnnotation($type), params: [], namedParams: []))
      },
      methods: {
        'bAse64': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'isEmptyOrIsNotEmpty': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.boolType)),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.dynamicType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'sibnetExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'myTvExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'okruExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'voeExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'vidBomExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'streamlareExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'suffix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'sendVidExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'yourUploadExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'name',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'subString': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'text',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'pattern',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listParse': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'toVideo': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.dynamicType)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'quality',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'originalUrl',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      true),
                ],
                namedParams: []),
            isStatic: true),
        'jsonPathToString': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'join',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getMapValue': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'attr',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'jsonPathToList': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'jsonDecodeToList': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'jsonPathToMap': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.mapType)),
                params: [
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'parseStatus': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.intType)),
                params: [
                  BridgeParameter(
                      'status',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'statusList',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listParseDateTime': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'dateFormat',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormatLocale',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'listContain': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.boolType)),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.list,
                          [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                      false),
                  BridgeParameter(
                      'element',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'querySelector': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'selector',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeElement',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'attributes',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'parseChapterDate': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'date',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormat',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'dateFormatLocale',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'querySelectorAll': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'selector',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeElement',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'attributes',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'typeRegExp',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'position',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'join',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'xpath': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'html',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'xpath',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'join',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'http': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'method',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'httpMultiparFormData': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'method',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'gogoCdnExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'doodExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'streamTapeExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'mp4UploadExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'headers',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'suffix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'streamWishExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'filemoonExtractor': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.dynamicType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'prefix',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType),
                          nullable: true),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'getHtmlViaWebview': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(BridgeTypeRef(CoreTypes.future,
                    [BridgeTypeRef.type(RuntimeTypes.stringType)])),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'rule',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'stringParse': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'evalJs': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'code',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'stringParseValue': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.dynamicType)),
                params: [
                  BridgeParameter(
                      'value',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.dynamicType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'regExp': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.stringType)),
                params: [
                  BridgeParameter(
                      'expression',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'source',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'replace',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                  BridgeParameter(
                      'type',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                  BridgeParameter(
                      'group',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.intType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
        'intParse': BridgeMethodDef(
            BridgeFunctionDef(
                returns: BridgeTypeAnnotation(
                    BridgeTypeRef.type(RuntimeTypes.intType)),
                params: [
                  BridgeParameter(
                      'url',
                      BridgeTypeAnnotation(
                          BridgeTypeRef.type(RuntimeTypes.stringType)),
                      false),
                ],
                namedParams: []),
            isStatic: true),
      },
      getters: {},
      setters: {},
      fields: {},
      bridge: true);

  static $MBridge $construct(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $MBridge();

  static $String $xpath(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.xpath(args[0]!.$value, args[1]!.$value, args[2]!.$value));

  static $List $listParse(Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.listParse(
      args[0]!.$value,
      args[1]!.$value,
    ).map((e) => $String(e)).toList());
  }

  static $int $parseStatus(
      Runtime runtime, $Value? target, List<$Value?> args) {
    List<dynamic> argss2 = [];

    if (args[1]!.$value is List<$Value>) {
      argss2 = args[1]!.$value as List<$Value>;
    } else {
      argss2 = args[1]!.$value as List<dynamic>;
    }

    return $int(MBridge.parseStatus(args[0]!.$value, argss2));
  }

  static $List $listParseDateTime(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.listParseDateTime(
            args[0]!.$value, args[1]!.$value, args[2]!.$value)
        .map((e) => $String(e))
        .toList());
  }

  static $VideoModel $toVideo(
      Runtime runtime, $Value? target, List<$Value?> args) {
    final value = MBridge.toVideo(
        args[0]!.$value, args[1]!.$value, args[2]!.$value, args[3]!.$value);

    return _toVideoModel(value);
  }

  static $String $jsonPathToString(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.jsonPathToString(
      args[0]!.$value,
      args[1]!.$value,
      args[2]!.$value,
    ));
  }

  static $String $subString(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.subString(
      args[0]!.$value,
      args[1]!.$value,
      args[2]!.$value,
    ));
  }

  static $String $getMapValue(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $String(MBridge.getMapValue(
      args[0]!.$value,
      args[1]!.$value,
      args[2]!.$value,
    ));
  }

  static $List<$String> $jsonPathToList(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.jsonPathToList(
      args[0]!.$value,
      args[1]!.$value,
      args[2]!.$value,
    ).map((e) => $String(e)).toList());
  }

  static $List<$String> $jsonDecodeToList(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $List.wrap(MBridge.jsonDecodeToList(
      args[0]!.$value,
      args[1]!.$value,
    ).map((e) => $String(e.toString())).toList());
  }

  static $Map $jsonPathToMap(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $Map.wrap(MBridge.jsonPathToMap(args[0]!.$value));
  }

  static $String $stringParse(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.stringParse(args[0]!.$value, args[1]!.$value));

  static $String $bAse64(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.bAse64(args[0]!.$value, args[1]!.$value));

  static $String $evalJs(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.evalJs(
        args[0]!.$value,
      ));

  static $String $stringParseValue(
      Runtime runtime, $Value? target, List<$Value?> args) {
    final value = args[0]!.$value;
    String fVal = "";
    if (value is List) {
      fVal = value.toString();
    } else {
      fVal = value.toString();
    }
    return $String(MBridge.stringParseValue(
      fVal,
    ));
  }

  static $String $regExp(Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.regExp(
        args[0]!.$value,
        args[1]!.$value,
        args[2]!.$value,
        args[3]!.$value,
        args[4]!.$value,
      ));

  static $int $intParse(Runtime runtime, $Value? target, List<$Value?> args) =>
      $int(MBridge.intParse(
        args[0]!.$value,
      ));

  static $bool $listContain(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $bool(MBridge.listContain(
          args[0]!.$value as List<$Value>, args[1]!.$value));

  static $String $querySelector(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.querySelector(
          args[0]!.$value, args[1]!.$value, args[2]!.$value, args[3]!.$value));

  static $String $parseChapterDate(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.parseChapterDate(
          args[0]!.$value, args[1]!.$value, args[2]!.$value));

  static $String $querySelectorAll(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $String(MBridge.querySelectorAll(
          args[0]!.$value,
          args[1]!.$value,
          args[2]!.$value,
          args[3]!.$value,
          args[4]!.$value,
          args[5]!.$value,
          args[6]!.$value));
  static $Future $http(Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.http(args[0]!.$value, args[1]!.$value)
          .then((value) => $String(value)));

  static $Future $httpMultiparFormData(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(
          MBridge.httpMultiparFormData(args[0]!.$value, args[1]!.$value)
              .then((value) => $String(value)));

  static $Future $getHtmlViaWebview(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.getHtmlViaWebview(args[0]!.$value, args[1]!.$value)
          .then((value) => $String(value)));

  static $Future $gogoCdnExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.gogoCdnExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $doodExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.doodExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $streamTapeExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamTapeExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $mp4UploadExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.mp4UploadExtractor(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $streamWishExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamWishExtractor(args[0]!.$value, args[1]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $filemoonExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.filemoonExtractor(args[0]!.$value, args[1]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $sendVidExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.sendVidExtractor(
              args[0]!.$value, args[1]!.$value, args[2]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $yourUploadExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.yourUploadExtractor(args[0]!.$value, args[1]!.$value,
              args[2]!.$value, args[3]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $sibnetExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.sibnetExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $myTvExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.myTvExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $okruExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.okruExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $voeExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.voeExtractor(args[0]!.$value, args[1]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $vidBomExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.vidBomExtractor(args[0]!.$value).then(
          (value) => $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $Future $streamlareExtractor(
          Runtime runtime, $Value? target, List<$Value?> args) =>
      $Future.wrap(MBridge.streamlareExtractor(
              args[0]!.$value, args[1]!.$value, args[2]!.$value)
          .then((value) =>
              $List.wrap(value.map((e) => _toVideoModel(e)).toList())));

  static $bool $isEmptyOrIsNotEmpty(
      Runtime runtime, $Value? target, List<$Value?> args) {
    return $bool(MBridge.isEmptyOrIsNotEmpty(
      args[0]!.$value,
      args[1]!.$value,
    ));
  }

  @override
  $Value? $bridgeGet(String identifier) {
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(String identifier, $Value value) {}
}

void _botToast(String title) {
  BotToast.showSimpleNotification(
      onlyOne: true,
      dismissDirections: [DismissDirection.horizontal, DismissDirection.down],
      align: const Alignment(0, 0.99),
      duration: const Duration(seconds: 5),
      title: title);
}

$VideoModel _toVideoModel(Video e) => $VideoModel.wrap(VideoModel()
  ..headers = e.headers
  ..originalUrl = e.originalUrl
  ..quality = e.quality
  ..url = e.url);
