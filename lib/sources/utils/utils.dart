import 'package:intl/intl.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/sources/source_list.dart';

String getMangaBaseUrl(String source) {
  String url = "";
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      url = sourcesList[i].baseUrl!;
    }
  }
  return url;
}

String getMangaAPIUrl(String source) {
  String url = "";
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      url = sourcesList[i].apiUrl!;
    }
  }
  return url;
}

String getMangaLang(String source) {

  String lang = "";
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      lang = sourcesList[i].lang!;
    }
  }
  return lang;
}

TypeSource getMangaTypeSource(String source) {
  TypeSource? typeSource;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      typeSource = sourcesList[i].typeSource;
    }
  }
  return typeSource!;
}

String getFormatDate(String source) {
  String? dateFormat;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      dateFormat = sourcesList[i].dateFormat;
    }
  }
  return dateFormat!;
}

String getFormatDateLocale(String source) {
  String? dateFormatLocale;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      dateFormatLocale = sourcesList[i].dateFormatLocale;
    }
  }
  return dateFormatLocale!;
}

bool isCloudflare(String source) {
  bool? isCloudflare;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName!.toLowerCase() == source.toLowerCase()) {
      isCloudflare = sourcesList[i].isCloudflare;
    }
  }
  return isCloudflare!;
}

String utilDate(String data) {
  DateTime date = DateTime.parse(data);
  return date.millisecondsSinceEpoch.toString();
}

parseDate(String data, String source) {
  source = source.toLowerCase();
  final now = DateTime.now();
  DateTime? date;
  if (data.toLowerCase() == "yesterday") {
    date = DateTime(now.year, now.month, now.day - 1);
  } else if (data.toLowerCase().contains("hour ago")) {
    date = now;
  } else {
    date = DateFormat(getFormatDate(source), getFormatDateLocale(source))
        .parse(data);
  }
  return date.millisecondsSinceEpoch.toString();
}
