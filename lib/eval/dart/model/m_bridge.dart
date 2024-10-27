import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:dart_eval/stdlib/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart' hide Text;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:js_packer/js_packer.dart';
import 'package:json_path/json_path.dart';
import 'package:mangayomi/eval/dart/model/document.dart';
import 'package:mangayomi/eval/javascript/http.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/router/router.dart';
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
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/anime_extractors/streamwish_extractor.dart';
import 'package:mangayomi/services/anime_extractors/vidbom_extractor.dart';
import 'package:mangayomi/services/anime_extractors/voe_extractor.dart';
import 'package:mangayomi/services/anime_extractors/your_upload_extractor.dart';
import 'package:mangayomi/utils/cryptoaes/crypto_aes.dart';
import 'package:mangayomi/utils/cryptoaes/deobfuscator.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:mangayomi/services/anime_extractors/quarkuc_extractor.dart';
import 'package:mangayomi/services/torrent_server.dart';

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
  static MDocument parsHtml(String html) {
    return MDocument(Document.html(html));
  }

  ///Create query by html string
  static const $Function xpath = $Function(_xpath);

  static $Value? _xpath(_, __, List<$Value?> args) {
    String html = args[0]!.$reified;
    String xpath = args[1]!.$reified;
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
      return $List.wrap(attrs.map((e) => $String(e)).toList());
    } catch (_) {
      return $List.wrap([]);
    }
  }

  ///Convert serie status to int
  ///[status] contains the current status of the serie
  ///[statusList] contains a list of map of many static status
  static Status parseStatus(String status, List statusList) {
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
          return switch (element.value as int) {
            0 => Status.ongoing,
            1 => Status.completed,
            2 => Status.onHiatus,
            3 => Status.canceled,
            4 => Status.publishingFinished,
            _ => Status.unknown,
          };
        }
      }
    }
    return Status.unknown;
  }

  ///Unpack a JS code
  static const $Function unpackJs = $Function(_unpackJs);

  static $Value? _unpackJs(_, __, List<$Value?> args) {
    String code = args[0]!.$reified;
    try {
      final jsPacker = JSPacker(code);
      return $String(jsPacker.unpack() ?? "");
    } catch (_) {
      return $String("");
    }
  }

  ///Unpack a JS code
  static const $Function unpackJsAndCombine = $Function(_unpackJsAndCombine);

  static $Value? _unpackJsAndCombine(_, __, List<$Value?> args) {
    String code = args[0]!.$reified;
    try {
      return $String(JsUnpacker.unpackAndCombine(code) ?? "");
    } catch (_) {
      return $String("");
    }
  }

  ///Read values in parsed JSON object and return resut to List<String>
  static const $Function jsonPathToList = $Function(_jsonPathToList);

  static $Value? _jsonPathToList(_, __, List<$Value?> args) {
    String source = args[0]!.$reified;
    String expression = args[1]!.$reified;
    int type = args[2]!.$reified;
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
        return $List.wrap(list.map((e) => $String(e)).toList());
      }

      // else jsonDecode(source) is Map value
      else {
        var map = json.decode(source);
        var values = JsonPath(expression).readValues(map);
        return $List.wrap(values.map((e) {
          return $String(e == null ? "{}" : json.encode(e));
        }).toList());
      }
    } catch (_) {
      return $List.wrap([]);
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
  static const $Function jsonPathToString = $Function(_jsonPathToString);

  static $Value? _jsonPathToString(_, __, List<$Value?> args) {
    String source = args[0]!.$reified;
    String expression = args[1]!.$reified;
    String join = args[2]!.$reified;
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
      return $String(listRg.first);
    } catch (_) {
      return $String("");
    }
  }

  //Parse a list of dates to millisecondsSinceEpoch
  static List parseDates(
      List value, String dateFormat, String dateFormatLocale) {
    List<dynamic> val = [];
    for (var element in value) {
      if (element is $Value) {
        val.add(element.$reified.toString());
      } else {
        val.add(element);
      }
    }
    bool error = false;
    List<dynamic> valD = [];
    for (var date in val) {
      if (date.toString().isNotEmpty) {
        String dateStr = "";
        if (error) {
          dateStr = DateTime.now().millisecondsSinceEpoch.toString();
        } else {
          dateStr = parseChapterDate(
            date,
            dateFormat,
            dateFormatLocale,
            (val) {
              dateFormat = val.$1;
              dateFormatLocale = val.$2;
              error = val.$3;
            },
          );
        }
        valD.add(dateStr);
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
      String expression, String source, String replace, int type, int group) {
    if (type == 0) {
      return expression.replaceAll(RegExp(source), replace);
    }
    return regCustomMatcher(expression, source, group);
  }

  static Future<List<Video>> gogoCdnExtractor(String url) async {
    return await GogoCdnExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> doodExtractor(String url, String? quality) async {
    return await DoodExtractor().videosFromUrl(url, quality: quality);
  }

  static Future<List<Video>> streamWishExtractor(
      String url, String prefix) async {
    return await StreamWishExtractor().videosFromUrl(url, prefix);
  }

  static Future<List<Video>> filemoonExtractor(
      String url, String prefix, String suffix) async {
    return await FilemoonExtractor().videosFromUrl(url, prefix, suffix);
  }

  static Future<List<Video>> mp4UploadExtractor(
      String url, String? headers, String prefix, String suffix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map).toMapStringString!;
    }
    return await Mp4uploadExtractor()
        .videosFromUrl(url, newHeaders, prefix: prefix, suffix: suffix);
  }

  static final Map<CloudDriveType, QuarkUcExtractor> _extractorCache = {};

  static QuarkUcExtractor _getExtractor(String cookie, CloudDriveType type) {
    if (!_extractorCache.containsKey(type)) {
      QuarkUcExtractor extractor = QuarkUcExtractor();
      extractor.initCloudDrive(cookie, type);
      _extractorCache[type] = extractor;
    }
    return _extractorCache[type]!;
  }

  static Future<List<Map<String, String>>> quarkFilesExtractor(
      List<String> url, String cookie) async {
    var quark = _getExtractor(cookie, CloudDriveType.quark);
    return await quark.videoFilesFromUrl(url);
  }

  static Future<List<Video>> quarkVideosExtractor(
      String url, String cookie) async {
    var quark = _getExtractor(cookie, CloudDriveType.quark);
    return await quark.videosFromUrl(url);
  }

  static Future<List<Map<String, String>>> ucFilesExtractor(
      List<String> url, String cookie) async {
    var uc = _getExtractor(cookie, CloudDriveType.uc);
    return await uc.videoFilesFromUrl(url);
  }

  static Future<List<Video>> ucVideosExtractor(
      String url, String cookie) async {
    var uc = _getExtractor(cookie, CloudDriveType.uc);
    return await uc.videosFromUrl(url);
  }

  static Future<String> getProxyUrl() async {
    await MTorrentServer().ensureRunning();
    return MTorrentServer().getBaseUrl();
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
  static String parseChapterDate(String date, String dateFormat,
      String dateFormatLocale, Function((String, String, bool)) newLocale) {
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
          newLocale((dateFormat, locale, false));
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
      newLocale((dateFormat, dateFormatLocale, true));
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  static String deobfuscateJsPassword(String inputString) {
    return Deobfuscator.deobfuscateJsPassword(inputString);
  }

  static Future<List<Video>> sibnetExtractor(String url, String prefix) async {
    return await SibnetExtractor().videosFromUrl(url, prefix: prefix);
  }

  static Future<List<Video>> sendVidExtractor(
      String url, String? headers, String prefix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map).toMapStringString!;
    }

    return await SendvidExtractor(newHeaders)
        .videosFromUrl(url, prefix: prefix);
  }

  static Future<List<Video>> myTvExtractor(String url) async {
    return await MytvExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> okruExtractor(String url) async {
    return await OkruExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> yourUploadExtractor(
      String url, String? headers, String? name, String prefix) async {
    Map<String, String> newHeaders = {};
    if (headers != null) {
      newHeaders = (jsonDecode(headers) as Map).toMapStringString!;
    }
    return await YourUploadExtractor().videosFromUrl(url, newHeaders,
        prefix: prefix, name: name ?? "YourUpload");
  }

  static Future<List<Video>> voeExtractor(String url, String? quality) async {
    return await VoeExtractor().videosFromUrl(url, quality);
  }

  static Future<List<Video>> vidBomExtractor(String url) async {
    return await VidBomExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> streamlareExtractor(
      String url, String prefix, String suffix) async {
    return await StreamlareExtractor()
        .videosFromUrl(url, prefix: prefix, suffix: suffix);
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
      newHeaders = (jsonDecode(headers) as Map).toMapStringString!;
    }
    return Video(url, quality, originalUrl,
        headers: newHeaders, subtitles: subtitles ?? [], audios: audios ?? []);
  }

  static String cryptoHandler(
      String text, String iv, String secretKeyString, bool encrypt) {
    try {
      if (encrypt) {
        final encryptt = _encrypt(secretKeyString, iv);
        final en = encryptt.$1.encrypt(text, iv: encryptt.$2);
        return en.base64;
      } else {
        final encryptt = _encrypt(secretKeyString, iv);
        final en = encryptt.$1.decrypt64(text, iv: encryptt.$2);
        return en;
      }
    } catch (_) {
      return text;
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

void botToast(String title,
    {int second = 10,
    double? fontSize,
    double alignX = 0,
    double alignY = 0.99,
    bool hasCloudFlare = false,
    String? url}) {
  final context = navigatorKey.currentState?.context;
  final assets = [
    'assets/app_icons/icon-black.png',
    'assets/app_icons/icon-red.png'
  ];
  BotToast.showNotification(
    onlyOne: true,
    dismissDirections: [DismissDirection.horizontal, DismissDirection.down],
    align: Alignment(alignX, alignY),
    duration: Duration(seconds: second),
    animationDuration: const Duration(milliseconds: 200),
    animationReverseDuration: const Duration(milliseconds: 200),
    leading: (_) => Image.asset((assets..shuffle()).first, height: 25),
    title: (_) => Text(title, style: TextStyle(fontSize: fontSize)),
    trailing: hasCloudFlare
        ? (_) => OutlinedButton.icon(
              style: OutlinedButton.styleFrom(elevation: 10),
              onPressed: () {
                context
                    ?.push("/mangawebview", extra: {'url': url, 'title': ''});
              },
              label: Text("Resolve Cloudflare challenge",
                  style: TextStyle(color: context?.secondaryColor)),
              icon: const Icon(Icons.public),
            )
        : null,
  );
}

(encrypt.Encrypter, encrypt.IV) _encrypt(String keyy, String ivv) {
  final key = encrypt.Key.fromUtf8(keyy);
  final iv = encrypt.IV.fromUtf8(ivv);
  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  return (encrypter, iv);
}
