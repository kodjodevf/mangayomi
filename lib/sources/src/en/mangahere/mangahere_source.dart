import 'package:mangayomi/models/source_model.dart';

SourceModel get mangahereSource => _mangahereSource;

SourceModel _mangahereSource = SourceModel(
  sourceName: "MangaHere",
  baseUrl: "http://www.mangahere.cc",
  lang: "en",
  typeSource: TypeSource.single,
  logoUrl: 'http://static.mangahere.cc/v20210106/mangahere/images/logo.png',
  isFullData: true,
  dateFormat: "MMM dd,yyyy",
  dateFormatLocale: "en",
);
