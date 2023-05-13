import 'package:mangayomi/models/source_model.dart';

List<SourceModel> get heanCmsSourcesList => _heanCmsSourcesList;
List<SourceModel> _heanCmsSourcesList = [
  SourceModel(
      sourceName: "YugenMangas",
      baseUrl: "https://yugenmangas.com",
      apiUrl: "https://api.yugenmangas.com/",
      lang: "es",
      typeSource: TypeSource.heancms,
      isNsfw: true,
      logoUrl: '',
      dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
      dateFormatLocale: "en"),
  SourceModel(
      sourceName: "OmegaScans",
      baseUrl: "https://omegascans.org",
      apiUrl: "https://api.omegascans.org/",
      lang: "en",
      typeSource: TypeSource.heancms,
      isNsfw: true,
      logoUrl: '',
      dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
      dateFormatLocale: "en"),
  // SourceModel(
  //   sourceName: "ReaperScans",
  //   baseUrl: "https://reaperscans.net",
  //   apiUrl: "https://api.reaperscans.net/",
  //   lang: "pt-br",
  //   typeSource: TypeSource.heancms,
  //   isNsfw: true,
  //   logoUrl: 'https://reaperscans.net/images/webicon.png',
  //   dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
  //   dateFormatLocale: "pt-BR",
  // ),
];
