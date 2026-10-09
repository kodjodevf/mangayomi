import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html/dom.dart' hide Text;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:js_packer/js_packer.dart';
import 'package:mangayomi/eval/model/document.dart';
import 'package:mangayomi/eval/http_response_extensions.dart';
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
import 'package:mangayomi/modules/widgets/toast_notification_content.dart';
import 'package:mangayomi/services/anime_extractors/streamwish_extractor.dart';
import 'package:mangayomi/services/anime_extractors/vidbom_extractor.dart';
import 'package:mangayomi/services/anime_extractors/voe_extractor.dart';
import 'package:mangayomi/services/anime_extractors/your_upload_extractor.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/cryptoaes/crypto_aes.dart';
import 'package:mangayomi/utils/cryptoaes/deobfuscator.dart';
import 'package:mangayomi/utils/cryptoaes/js_unpacker.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:convert/convert.dart' show hex;
import 'package:mangayomi/services/anime_extractors/quarkuc_extractor.dart';

class WordSet {
  final List<String> words;
  late final List<String> _lowerWords;

  WordSet(this.words) {
    _lowerWords = words.map((w) => w.toLowerCase()).toList();
  }

  bool anyWordIn(String dateString) {
    final lower = dateString.toLowerCase();
    for (final word in _lowerWords) {
      if (lower.contains(word)) return true;
    }
    return false;
  }

  bool startsWith(String dateString) {
    final lower = dateString.toLowerCase();
    for (final word in _lowerWords) {
      if (lower.startsWith(word)) return true;
    }
    return false;
  }

  bool endsWith(String dateString) {
    final lower = dateString.toLowerCase();
    for (final word in _lowerWords) {
      if (lower.endsWith(word)) return true;
    }
    return false;
  }
}

class MBridge {
  static MDocument parsHtml(String html) {
    return MDocument(Document.html(html));
  }

  ///Create query by html string

  static List<String>? xpath(String html, String xpath) {
    List<String> attrs = [];
    try {
      var htmlXPath = HtmlXPath.html(html);
      var query = htmlXPath.query(xpath);
      if (query.nodes.length > 1) {
        for (var element in query.attrs) {
          attrs.add(element!.trim());
        }
      }
      //Return one attr
      else if (query.nodes.length == 1) {
        String attr = query.attr != null ? query.attr!.trim() : "";
        if (attr.isNotEmpty) {
          attrs = [attr];
        }
      }
      return attrs;
    } catch (_) {
      return [];
    }
  }

  ///Convert serie status to int
  ///[status] contains the current status of the serie
  ///[statusList] contains a list of map of many static status
  static Status parseStatus(String status, List statusList) {
    for (var element in statusList) {
      Map statusMap = {};
      statusMap = element;
      for (var element in statusMap.entries) {
        if (element.key.toString().toLowerCase().contains(
          status.toLowerCase().trim(),
        )) {
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

  static String? unpackJs(String code) {
    try {
      final jsPacker = JSPacker(code);
      return jsPacker.unpack() ?? "";
    } catch (_) {
      return "";
    }
  }

  ///Unpack a JS code
  static String? unpackJsAndCombine(String code) {
    try {
      return JsUnpacker.unpackAndCombine(code) ?? "";
    } catch (_) {
      return "";
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

  //Parse a list of dates to millisecondsSinceEpoch
  static List parseDates(
    List value,
    String dateFormat,
    String dateFormatLocale,
  ) {
    final val = <String>[];
    for (final element in value) {
      if (element != null) {
        final str = element.toString().trim();
        if (str.isNotEmpty) {
          val.add(str);
        }
      }
    }
    if (val.isEmpty) return [];

    bool error = false;
    final valD = <String>[];
    final fallbackNow = DateTime.now().millisecondsSinceEpoch.toString();

    for (final date in val) {
      String dateStr = "";
      if (error) {
        dateStr = fallbackNow;
      } else {
        dateStr = parseChapterDate(date, dateFormat, dateFormatLocale, (v) {
          dateFormat = v.$1;
          dateFormatLocale = v.$2;
          error = v.$3;
        });
      }
      valD.add(dateStr);
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
    String expression,
    String source,
    String replace,
    int type,
    int group,
  ) {
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
    String url,
    String prefix,
  ) async {
    return await StreamWishExtractor().videosFromUrl(url, prefix);
  }

  static Future<List<Video>> filemoonExtractor(
    String url,
    String prefix,
    String suffix,
  ) async {
    return await FilemoonExtractor().videosFromUrl(url, prefix, suffix);
  }

  static Map<String, String> decodeHeaders(String? headers) =>
      headers == null ? {} : (jsonDecode(headers) as Map).toMapStringString!;

  static Future<List<Video>> mp4UploadExtractor(
    String url,
    String? headers,
    String prefix,
    String suffix,
  ) async {
    return await Mp4uploadExtractor().videosFromUrl(
      url,
      decodeHeaders(headers),
      prefix: prefix,
      suffix: suffix,
    );
  }

  static final Map<CloudDriveType, QuarkUcExtractor> _extractorCache = {};
  static final Set<String> _initializedLocales = {};

  static QuarkUcExtractor _getExtractor(String cookie, CloudDriveType type) {
    if (!_extractorCache.containsKey(type)) {
      QuarkUcExtractor extractor = QuarkUcExtractor();
      extractor.initCloudDrive(cookie, type);
      _extractorCache[type] = extractor;
    }
    return _extractorCache[type]!;
  }

  static Future<List<Map<String, String>>> quarkFilesExtractor(
    List<String> url,
    String cookie,
  ) async {
    var quark = _getExtractor(cookie, CloudDriveType.quark);
    return await quark.videoFilesFromUrl(url);
  }

  static Future<List<Video>> quarkVideosExtractor(
    String url,
    String cookie,
  ) async {
    var quark = _getExtractor(cookie, CloudDriveType.quark);
    return await quark.videosFromUrl(url);
  }

  static Future<List<Map<String, String>>> ucFilesExtractor(
    List<String> url,
    String cookie,
  ) async {
    var uc = _getExtractor(cookie, CloudDriveType.uc);
    return await uc.videoFilesFromUrl(url);
  }

  static Future<List<Video>> ucVideosExtractor(
    String url,
    String cookie,
  ) async {
    var uc = _getExtractor(cookie, CloudDriveType.uc);
    return await uc.videosFromUrl(url);
  }

  static Future<List<Video>> streamTapeExtractor(
    String url,
    String? quality,
  ) async {
    return await StreamTapeExtractor().videosFromUrl(
      url,
      quality: quality ?? "StreamTape",
    );
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

  static final RegExp _digitsOnlyRegExp = RegExp(r'^\d+$');
  static final RegExp _digitsRegExp = RegExp(r'\d+');
  static final RegExp _ordinalRegExp = RegExp(
    r'(\d+)(st|nd|rd|th)\b',
    caseSensitive: false,
  );
  static final RegExp _hasLettersRegExp = RegExp(r'\p{L}', unicode: true);

  static final WordSet _yesterdayWords = WordSet([
    'yesterday',
    'ayer',
    'hier',
    'ieri',
    'gestern',
    'dün',
    'kemarin',
    'يوم واحد',
    'أمس',
    '昨天',
    'hôm qua',
  ]);
  static final WordSet _todayWords = WordSet([
    'today',
    'hoy',
    "aujourd'hui",
    'oggi',
    'heute',
    'bugün',
    'hari ini',
    'اليوم',
    '今天',
    'hôm nay',
  ]);
  static final WordSet _twoDaysAgoWords = WordSet([
    'يومين',
    'anteayer',
    'avant-hier',
    "l'altro ieri",
    'vorgestern',
    '前天',
    'hôm kia',
  ]);
  static final WordSet _agoSuffixWords = WordSet([
    'ago',
    'atrás',
    'önce',
    'قبل',
    'fa',
    'vor',
    'trước',
  ]);
  static final WordSet _agoPrefixWords = WordSet(['hace', 'il y a', 'vor']);

  static final WordSet _daysWords = WordSet([
    'hari',
    'gün',
    'jour',
    'día',
    'dia',
    'day',
    'วัน',
    'ngày',
    'giorni',
    'أيام',
    '天',
    'd',
    'tage',
    'tag',
  ]);
  static final WordSet _hoursWords = WordSet([
    'jam',
    'saat',
    'heure',
    'hora',
    'hour',
    'ชั่วโมง',
    'giờ',
    'ore',
    'ساعة',
    '小时',
    'h',
    'stunden',
    'stunde',
  ]);
  static final WordSet _minutesWords = WordSet([
    'menit',
    'dakika',
    'min',
    'minute',
    'minuto',
    'นาที',
    'دقائق',
    'm',
    'minuten',
  ]);
  static final WordSet _secondsWords = WordSet([
    'detik',
    'segundo',
    'second',
    'วินาที',
    'sec',
    's',
    'sekunden',
  ]);
  static final WordSet _weeksWords = WordSet([
    'week',
    'semana',
    'semaine',
    'woche',
    'settimana',
    'tuần',
    'w',
  ]);
  static final WordSet _monthsWords = WordSet([
    'month',
    'mes',
    'mois',
    'monat',
    'mese',
    'tháng',
    'mês',
  ]);
  static final WordSet _yearsWords = WordSet([
    'year',
    'año',
    'an',
    'jahr',
    'anno',
    'năm',
    'ano',
  ]);

  static final Map<String, DateFormat> _dateFormatCache = {};

  static DateFormat? _tryGetDateFormat(String pattern, String locale) {
    final key = '$pattern|$locale';
    final cached = _dateFormatCache[key];
    if (cached != null) return cached;
    try {
      if (locale.isNotEmpty && !_initializedLocales.contains(locale)) {
        try {
          initializeDateFormatting(locale);
        } catch (_) {}
        _initializedLocales.add(locale);
      }
      final format = DateFormat(pattern, locale.isEmpty ? null : locale);
      if (_dateFormatCache.length > 500) {
        _dateFormatCache.clear();
      }
      _dateFormatCache[key] = format;
      return format;
    } catch (_) {
      return null;
    }
  }

  static int _parseRelativeDate(String date, String lowerDate) {
    final match = _digitsRegExp.firstMatch(date);
    if (match == null) return 0;
    final number = int.tryParse(match.group(0)!);
    if (number == null) return 0;
    final cal = DateTime.now();

    if (_daysWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(days: number)).millisecondsSinceEpoch;
    } else if (_hoursWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(hours: number)).millisecondsSinceEpoch;
    } else if (_minutesWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(minutes: number)).millisecondsSinceEpoch;
    } else if (_secondsWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(seconds: number)).millisecondsSinceEpoch;
    } else if (_weeksWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(days: number * 7)).millisecondsSinceEpoch;
    } else if (_monthsWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(days: number * 30)).millisecondsSinceEpoch;
    } else if (_yearsWords.anyWordIn(lowerDate)) {
      return cal.subtract(Duration(days: number * 365)).millisecondsSinceEpoch;
    } else {
      return 0;
    }
  }

  //Parse a chapter date to millisecondsSinceEpoch
  static String parseChapterDate(
    String date,
    String dateFormat,
    String dateFormatLocale,
    Function((String, String, bool)) newLocale,
  ) {
    final trimmedDate = date.trim();
    if (trimmedDate.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }

    // 1. Direct timestamp check (Unix epoch in seconds or milliseconds)
    if (_digitsOnlyRegExp.hasMatch(trimmedDate)) {
      final timestamp = int.tryParse(trimmedDate);
      if (timestamp != null) {
        if (trimmedDate.length == 10) {
          return (timestamp * 1000).toString();
        } else if (trimmedDate.length >= 12 && trimmedDate.length <= 14) {
          return timestamp.toString();
        }
      }
    }

    // 2. Direct ISO-8601 with time check (e.g. 2023-10-15T12:00:00Z)
    if (trimmedDate.contains('T')) {
      final isoDate = DateTime.tryParse(trimmedDate);
      if (isoDate != null) {
        return isoDate.millisecondsSinceEpoch.toString();
      }
    }

    final lowerDate = trimmedDate.toLowerCase();

    // 3. Fast relative dates
    if (_todayWords.startsWith(lowerDate)) {
      final cal = DateTime.now();
      return DateTime(
        cal.year,
        cal.month,
        cal.day,
      ).millisecondsSinceEpoch.toString();
    }
    if (_yesterdayWords.startsWith(lowerDate)) {
      final cal = DateTime.now().subtract(const Duration(days: 1));
      return DateTime(
        cal.year,
        cal.month,
        cal.day,
      ).millisecondsSinceEpoch.toString();
    }
    if (_twoDaysAgoWords.startsWith(lowerDate)) {
      final cal = DateTime.now().subtract(const Duration(days: 2));
      return DateTime(
        cal.year,
        cal.month,
        cal.day,
      ).millisecondsSinceEpoch.toString();
    }
    if (_agoSuffixWords.endsWith(lowerDate) ||
        _agoPrefixWords.startsWith(lowerDate)) {
      final rel = _parseRelativeDate(trimmedDate, lowerDate);
      if (rel > 0) return rel.toString();
    }

    // 4. Clean ordinal suffixes (1st, 2nd, 3rd, 4th, etc.)
    final cleanedDate = _ordinalRegExp.hasMatch(trimmedDate)
        ? trimmedDate.replaceAllMapped(_ordinalRegExp, (m) => m.group(1)!)
        : trimmedDate;

    // 5. If dateFormat is specified and non-empty, try it first
    if (dateFormat.isNotEmpty) {
      final formatter = _tryGetDateFormat(dateFormat, dateFormatLocale);
      if (formatter != null) {
        try {
          return formatter.parse(cleanedDate).millisecondsSinceEpoch.toString();
        } catch (_) {}
      }
    }

    // 6. Fast fallback format detection
    final hasLetters = _hasLettersRegExp.hasMatch(cleanedDate);

    if (!hasLetters) {
      // Pure numeric date with separators (e.g. "12/10/2023", "2023-10-12")
      // Digits and separators are locale-independent. Test on 'en' only.
      for (final format in _numericDateFormats) {
        final formatter = _tryGetDateFormat(format, 'en');
        if (formatter != null) {
          try {
            final ms = formatter
                .parse(cleanedDate)
                .millisecondsSinceEpoch
                .toString();
            newLocale((format, 'en', false));
            return ms;
          } catch (_) {}
        }
      }
    } else {
      // Contains letters (month names). Test common extension locales first.
      final targetLocales = <String>[
        if (dateFormatLocale.isNotEmpty) dateFormatLocale,
        ..._commonLocales,
      ];
      final seenLocales = <String>{};

      for (final locale in targetLocales) {
        if (!seenLocales.add(locale)) continue;
        for (final format in _textualDateFormats) {
          final formatter = _tryGetDateFormat(format, locale);
          if (formatter != null) {
            try {
              final ms = formatter
                  .parse(cleanedDate)
                  .millisecondsSinceEpoch
                  .toString();
              newLocale((format, locale, false));
              return ms;
            } catch (_) {}
          }
        }
      }

      // If common locales failed, test remaining locales as last resort
      final allLocales = DateFormat.allLocalesWithSymbols();
      for (final locale in allLocales) {
        if (seenLocales.contains(locale)) continue;
        seenLocales.add(locale);
        for (final format in _textualDateFormats) {
          final formatter = _tryGetDateFormat(format, locale);
          if (formatter != null) {
            try {
              final ms = formatter
                  .parse(cleanedDate)
                  .millisecondsSinceEpoch
                  .toString();
              newLocale((format, locale, false));
              return ms;
            } catch (_) {}
          }
        }
      }
    }

    // 7. Fallback to relative date if relative keywords were somewhere inside the string
    final rel = _parseRelativeDate(trimmedDate, lowerDate);
    if (rel > 0) return rel.toString();

    // 8. Fallback to ISO-8601 parsing
    final isoDate = DateTime.tryParse(trimmedDate);
    if (isoDate != null) {
      return isoDate.millisecondsSinceEpoch.toString();
    }

    // 9. All parsing attempts failed
    newLocale((dateFormat, dateFormatLocale, true));
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static String deobfuscateJsPassword(String inputString) {
    return Deobfuscator.deobfuscateJsPassword(inputString);
  }

  static Future<List<Video>> sibnetExtractor(String url, String prefix) async {
    return await SibnetExtractor().videosFromUrl(url, prefix: prefix);
  }

  static Future<List<Video>> sendVidExtractor(
    String url,
    String? headers,
    String prefix,
  ) async {
    return await SendvidExtractor(decodeHeaders(headers))
        .videosFromUrl(url, prefix: prefix);
  }

  static Future<List<Video>> myTvExtractor(String url) async {
    return await MytvExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> okruExtractor(String url) async {
    return await OkruExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> yourUploadExtractor(
    String url,
    String? headers,
    String? name,
    String prefix,
  ) async {
    return await YourUploadExtractor().videosFromUrl(
      url,
      decodeHeaders(headers),
      prefix: prefix,
      name: name ?? "YourUpload",
    );
  }

  static Future<List<Video>> voeExtractor(String url, String? quality) async {
    return await VoeExtractor().videosFromUrl(url, quality);
  }

  static Future<List<Video>> vidBomExtractor(String url) async {
    return await VidBomExtractor().videosFromUrl(url);
  }

  static Future<List<Video>> streamlareExtractor(
    String url,
    String prefix,
    String suffix,
  ) async {
    return await StreamlareExtractor().videosFromUrl(
      url,
      prefix: prefix,
      suffix: suffix,
    );
  }

  static String encryptAESCryptoJS(String plainText, String passphrase) {
    return CryptoAES.encryptAESCryptoJS(plainText, passphrase);
  }

  static String decryptAESCryptoJS(String encrypted, String passphrase) {
    return CryptoAES.decryptAESCryptoJS(encrypted, passphrase);
  }

  static Video toVideo(
    String url,
    String quality,
    String originalUrl,
    String? headers,
    List<Track>? subtitles,
    List<Track>? audios,
  ) {
    return Video(
      url,
      quality,
      originalUrl,
      headers: decodeHeaders(headers),
      subtitles: subtitles ?? [],
      audios: audios ?? [],
    );
  }

  /// AES-GCM decryption for extensions (parity with Java's
  /// `Cipher.getInstance("AES/GCM/NoPadding")`).
  ///
  /// - [encrypted] : base64 ciphertext. If the 16-byte GCM auth tag is already
  ///                 appended to it (as Java's `Cipher.doFinal` produces),
  ///                 pass an empty [tagHex].
  /// - [keyHex]    : hex-encoded key (16/24/32 bytes → AES-128/192/256)
  /// - [ivHex]     : hex-encoded IV / nonce (typically 12 bytes for GCM)
  /// - [tagHex]    : hex-encoded auth tag (usually 16 bytes), appended to the
  ///                 ciphertext before decryption; empty if already appended
  ///
  /// Returns the decrypted UTF-8 string, or the original [encrypted] input if
  /// decryption/authentication fails (mirrors [cryptoHandler]'s behavior).
  static String decryptAESGCM(
    String encrypted,
    String keyHex,
    String ivHex,
    String tagHex,
  ) {
    try {
      final key = encrypt.Key(Uint8List.fromList(hex.decode(keyHex)));
      final iv = encrypt.IV(Uint8List.fromList(hex.decode(ivHex)));
      // PointyCastle's GCM (and Java's AES/GCM/NoPadding) expect the 128-bit
      // auth tag appended to the ciphertext, so concatenate the two.
      final dataWithTag = Uint8List.fromList([
        ...base64.decode(encrypted),
        ...hex.decode(tagHex),
      ]);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.gcm),
      );
      return encrypter.decrypt(encrypt.Encrypted(dataWithTag), iv: iv);
    } catch (_) {
      return encrypted;
    }
  }

  static String cryptoHandler(
    String text,
    String iv,
    String secretKeyString,
    bool encrypt,
  ) {
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

const List<String> _commonLocales = [
  'en',
  'en_US',
  'es',
  'fr',
  'pt',
  'pt_BR',
  'id',
  'it',
  'ru',
  'de',
  'tr',
  'vi',
  'ar',
  'ja',
  'ko',
  'zh',
  'th',
  'pl',
];

const List<String> _numericDateFormats = [
  'yyyy-MM-dd',
  'dd/MM/yyyy',
  'MM/dd/yyyy',
  'yyyy/MM/dd',
  'dd-MM-yyyy',
  'MM-dd-yyyy',
  'dd.MM.yyyy',
  'MM.dd.yyyy',
  'yyyy.MM.dd',
  'd/M/yyyy',
  'M/d/yyyy',
  'yyyy/M/d',
  'd-M-yyyy',
  'M-d-yyyy',
  'yyyy-M-d',
  'd.M.yyyy',
  'M.d.yyyy',
  'yyyy.M.d',
  'dd/mm/yyyy',
];

const List<String> _textualDateFormats = [
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
  'MMMMM dd, yyyy',
  'MMM d, yyy',
  'MMM d, yyyy',
  'd MMMM yyyy',
  "dd 'de' MMMM 'de' yyyy",
  "d MMMM'،' yyyy",
  "yyyy'年'M'月'd",
  'd MMMM, yyyy',
  "dd 'de' MMMMM 'de' yyyy",
  'dd MMMMM, yyyy',
  'MMMM d, yyyy',
  'MMM dd,yyyy',
];

void Function() botToast(
  String title, {
  int second = 10,
  double? fontSize,
  double alignX = 0,
  double alignY = 0.99,
  bool hasCloudFlare = false,
  String? url,
  int animationDuration = 200,
  List<DismissDirection> dismissDirections = const [
    DismissDirection.horizontal,
    DismissDirection.down,
  ],
  bool onlyOne = true,
  bool? themeDark,
  bool showIcon = true,
  int maxLines = 6,
  VoidCallback? onDetails,
  String? detailsLabel,
}) {
  final context = navigatorKey.currentState?.context;
  return BotToast.showNotification(
    onlyOne: onlyOne,
    dismissDirections: dismissDirections,
    align: Alignment(alignX, alignY),
    duration: Duration(seconds: second),
    animationDuration: Duration(milliseconds: animationDuration),
    animationReverseDuration: Duration(milliseconds: animationDuration),
    leading: showIcon
        ? (_) => Image.asset(
            (themeDark == null
                ? appIconAssets[Random().nextInt(2)]
                : appIconAssets[themeDark ? 0 : 1]),
            height: 25,
          )
        : null,
    // ListTile gives a trailing action its full intrinsic width before laying
    // out the title. A labelled action there can squeeze an error down to one
    // or two characters per line on a phone, so actions live below the message
    // inside the title column instead.
    title: (cancel) {
      void resolveChallenge() {
        cancel();
        context?.push("/mangawebview", extra: {'url': url, 'title': ''});
      }

      return ToastNotificationContent(
        message: title,
        fontSize: fontSize,
        maxLines: maxLines,
        action: hasCloudFlare
            ? Semantics(
                button: true,
                label: 'Resolve Cloudflare challenge',
                excludeSemantics: true,
                onTap: resolveChallenge,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context?.secondaryColor,
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: resolveChallenge,
                  label: const Text('Resolve challenge'),
                  icon: const Icon(Icons.public, size: 18),
                ),
              )
            : onDetails == null
            ? null
            : TextButton(
                onPressed: () {
                  cancel();
                  onDetails();
                },
                child: Text(detailsLabel ?? 'Details'),
              ),
      );
    },
    trailing: null,
  );
}

(encrypt.Encrypter, encrypt.IV) _encrypt(String keyy, String ivv) {
  final key = encrypt.Key.fromUtf8(keyy);
  final iv = encrypt.IV.fromUtf8(ivv);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
  );
  return (encrypter, iv);
}
