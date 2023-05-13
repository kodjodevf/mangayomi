import 'package:mangayomi/models/source_model.dart';

SourceModel get mangakawaiiSource => _mangakawaiiSource;
SourceModel _mangakawaiiSource = SourceModel(
    sourceName: "MangaKawaii",
    baseUrl: "https://www.mangakawaii.io",
    lang: "fr",
    typeSource: TypeSource.single,
    logoUrl: 'https://www.mangakawaii.io/assets/img/logo.png',
    dateFormat: "dd.MM.yyyy",
    dateFormatLocale: "en_US");
