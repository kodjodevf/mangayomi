import 'package:intl/intl.dart';
import 'package:mangayomi/models/source_model.dart';
import 'package:mangayomi/sources/source_list.dart';

String getWpMangaUrl(String source) {
  String url = "";
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      url = sourcesList[i].url;
    }
  }
  return url;
}

TypeSource getWpMangTypeSource(String source) {
  TypeSource? typeSource;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      typeSource = sourcesList[i].typeSource;
    }
  }
  return typeSource!;
}

String getFormatDate(String source) {
  String? dateFormat;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      dateFormat = sourcesList[i].dateFormat;
    }
  }
  return dateFormat!;
}

String getFormatDateLocale(String source) {
  String? dateFormatLocale;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
      dateFormatLocale = sourcesList[i].dateFormatLocale;
    }
  }
  return dateFormatLocale!;
}

bool isCloudflare(String source) {
  bool? isCloudflare;
  for (var i = 0; i < sourcesList.length; i++) {
    if (sourcesList[i].sourceName.toLowerCase() == source.toLowerCase()) {
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
  DateTime date = DateFormat(getFormatDate(source), getFormatDateLocale(source))
      .parse(data);
  return date.millisecondsSinceEpoch.toString();
}
