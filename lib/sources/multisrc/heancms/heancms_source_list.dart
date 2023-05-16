import 'package:mangayomi/models/source.dart';

List<Source> get heanCmsSourcesList => _heanCmsSourcesList;
List<Source> _heanCmsSourcesList = [
  Source(
      sourceName: "YugenMangas",
      baseUrl: "https://yugenmangas.com",
      apiUrl: "https://api.yugenmangas.com/",
      lang: "es",
      typeSource: TypeSource.heancms,
      isNsfw: true,
      logoUrl: '',
      dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
      dateFormatLocale: "en"),
  Source(
      sourceName: "OmegaScans",
      baseUrl: "https://omegascans.org",
      apiUrl: "https://api.omegascans.org/",
      lang: "en",
      typeSource: TypeSource.heancms,
      isNsfw: true,
      logoUrl: '',
      dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
      dateFormatLocale: "en"),
  // Source(
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
