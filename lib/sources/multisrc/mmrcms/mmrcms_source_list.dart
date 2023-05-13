import 'package:mangayomi/models/source_model.dart';

List<SourceModel> get mmrcmsSourcesList => _mmrcmsSourcesList;
List<SourceModel> _mmrcmsSourcesList = [
  // SourceModel(
  //     sourceName: "Fallen Angels",
  //     baseUrl: "https://manga.fascans.com",
  //     lang: "en",
  //     typeSource: TypeSource.mmrcms,
  //     logoUrl: '',
  //     dateFormat: "d MMM. yyyy",
  //     dateFormatLocale: "en_US"),
  SourceModel(
      sourceName: "Scan FR",
      baseUrl: "https://www.scan-fr.org",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  SourceModel(
      sourceName: "Scan VF",
      baseUrl: "https://www.scan-vf.net",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"), //
  SourceModel(
      sourceName: "Komikid",
      baseUrl: "https://www.komikid.com",
      lang: "id",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  // SourceModel(
  //     sourceName: "MangaHanta",
  //     baseUrl: "http://mangahanta.com",
  //     lang: "tr",
  //     typeSource: TypeSource.mmrcms,
  //     logoUrl: '',
  //     dateFormat: "d MMM. yyyy",
  //     dateFormatLocale: "en_US"),
  SourceModel(
      sourceName: "MangaID",
      baseUrl: "https://mangaid.click",
      lang: "id",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
  SourceModel(
      sourceName: "Jpmangas",
      baseUrl: "https://jpmangas.cc",
      lang: "fr",
      typeSource: TypeSource.mmrcms,
      logoUrl: '',
      dateFormat: "d MMM. yyyy",
      dateFormatLocale: "en_US"),
];
