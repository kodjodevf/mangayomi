import 'package:mangayomi/models/source.dart';

Source get mangakawaiiSource => _mangakawaiiSource;
Source _mangakawaiiSource = Source(
    sourceName: "MangaKawaii",
    baseUrl: "https://www.mangakawaii.io",
    lang: "fr",
    typeSource: TypeSource.single,
    logoUrl: 'https://www.mangakawaii.io/assets/img/logo.png',
    dateFormat: "dd.MM.yyyy",
    dateFormatLocale: "en_US");
