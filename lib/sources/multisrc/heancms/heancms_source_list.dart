import 'package:mangayomi/models/source_model.dart';

List<SourceModel> get heanCmsSourcesList => _heanCmsSourcesList;
List<SourceModel> _heanCmsSourcesList = [
  SourceModel(
      sourceName: "Yugenmangas",
      baseUrl: "https://yugenmangas.com",
      apiUrl: "https://api.yugenmangas.com/",
      lang: "es",
      typeSource: TypeSource.heancms,
      isNsfw: true,
      logoUrl: '',
      dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
      dateFormatLocale: "en"),
];
