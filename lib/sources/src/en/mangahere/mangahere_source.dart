import 'package:mangayomi/models/source.dart';

Source get mangahereSource => _mangahereSource;

Source _mangahereSource = Source(
  sourceName: "MangaHere",
  baseUrl: "http://www.mangahere.cc",
  lang: "en",
  typeSource: TypeSource.single,
  logoUrl: 'http://static.mangahere.cc/v20210106/mangahere/images/logo.png',
  dateFormat: "MMM dd,yyyy",
  dateFormatLocale: "en",
);
