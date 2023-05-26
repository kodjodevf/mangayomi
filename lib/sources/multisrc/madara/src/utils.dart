import 'package:intl/intl.dart';
import 'package:mangayomi/sources/utils/utils.dart';

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

int parseChapterDate(String? date, String source) {
  date ??= '';

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
      return cal.subtract(Duration(days: number * 365)).millisecondsSinceEpoch;
    } else {
      return 0;
    }
  }

  if (WordSet(["yesterday", "يوم واحد"]).startsWith(date)) {
    DateTime cal = DateTime.now().subtract(const Duration(days: 1));
    cal = DateTime(cal.year, cal.month, cal.day);
    return cal.millisecondsSinceEpoch;
  } else if (WordSet(["today"]).startsWith(date)) {
    DateTime cal = DateTime.now();
    cal = DateTime(cal.year, cal.month, cal.day);
    return cal.millisecondsSinceEpoch;
  } else if (WordSet(["يومين"]).startsWith(date)) {
    DateTime cal = DateTime.now().subtract(const Duration(days: 2));
    cal = DateTime(cal.year, cal.month, cal.day);
    return cal.millisecondsSinceEpoch;
  } else if (WordSet(["ago", "atrás", "önce", "قبل"]).endsWith(date)) {
    return parseRelativeDate(date);
  } else if (WordSet(["hace"]).startsWith(date)) {
    return parseRelativeDate(date);
  } else if (date.contains(RegExp(r"\d(st|nd|rd|th)"))) {
    final cleanedDate = date
        .split(" ")
        .map((it) => it.contains(RegExp(r"\d\D\D"))
            ? it.replaceAll(RegExp(r"\D"), "")
            : it)
        .join(" ");
    return DateFormat(getFormatDate(source), getFormatDateLocale(source))
        .parse(cleanedDate)
        .millisecondsSinceEpoch;
  } else {
    return DateFormat(getFormatDate(source), getFormatDateLocale(source))
        .parse(date)
        .millisecondsSinceEpoch;
  }
}
