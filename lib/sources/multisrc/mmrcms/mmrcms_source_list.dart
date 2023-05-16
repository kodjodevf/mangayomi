import 'package:mangayomi/models/source.dart';

List<Source> get mmrcmsSourcesList => _mmrcmsSourcesList;
List<Source> _mmrcmsSourcesList = [
  // Source(
  //     sourceName: "Fallen Angels",
  //     baseUrl: "https://manga.fascans.com",
  //     lang: "en",
  //     typeSource: TypeSource.mmrcms,
  //     logoUrl: '',
  //     dateFormat: "d MMM. yyyy",
  //     dateFormatLocale: "en_US"),
  Source(
      sourceName: "Scan FR",
      baseUrl: "https://www.scan-fr.org",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  Source(
      sourceName: "Scan VF",
      baseUrl: "https://www.scan-vf.net",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"), //
  Source(
      sourceName: "Komikid",
      baseUrl: "https://www.komikid.com",
      lang: "id",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  // Source(
  //     sourceName: "MangaHanta",
  //     baseUrl: "http://mangahanta.com",
  //     lang: "tr",
  //     typeSource: TypeSource.mmrcms,
  //     logoUrl: '',
  //     dateFormat: "d MMM. yyyy",
  //     dateFormatLocale: "en_US"),
  Source(
      sourceName: "MangaID",
      baseUrl: "https://mangaid.click",
      lang: "id",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  Source(
      sourceName: "Jpmangas",
      baseUrl: "https://jpmangas.cc",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
];
