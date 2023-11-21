import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_source.dart';
part 'source.g.dart';

@collection
@Name("Sources")
class Source {
  Id? id;

  String? name;

  String? baseUrl;

  String? lang;

  bool? isActive;

  bool? isAdded;

  bool? isPinned;

  bool? isNsfw;

  String? sourceCode;

  String? sourceCodeUrl;

  String? typeSource;

  String? iconUrl;

  bool? isFullData;

  bool? hasCloudflare;

  bool? lastUsed;

  String? dateFormat;

  String? dateFormatLocale;

  String? apiUrl;

  String? version;

  String? versionLast;

  String? headers;

  bool? isManga;

  String? appMinVerReq;

  Source(
      {this.id = 0,
      this.name = '',
      this.baseUrl = '',
      this.lang = '',
      this.typeSource = '',
      this.iconUrl = '',
      this.dateFormat = '',
      this.dateFormatLocale = '',
      this.isActive = true,
      this.isAdded = false,
      this.isNsfw = false,
      this.isFullData = false,
      this.hasCloudflare = false,
      this.isPinned = false,
      this.lastUsed = false,
      this.apiUrl = "",
      this.sourceCodeUrl = "",
      this.version = "",
      this.versionLast = "",
      this.sourceCode = '',
      this.headers = '',
      this.isManga = true,
      this.appMinVerReq = ""});

  Source.fromJson(Map<String, dynamic> json) {
    apiUrl = json['apiUrl'];
    appMinVerReq = json['appMinVerReq'];
    baseUrl = json['baseUrl'];
    dateFormat = json['dateFormat'];
    dateFormatLocale = json['dateFormatLocale'];
    hasCloudflare = json['hasCloudflare'];
    headers = json['headers'];
    iconUrl = json['iconUrl'];
    id = json['id'];
    isActive = json['isActive'];
    isAdded = json['isAdded'];
    isFullData = json['isFullData'];
    isManga = json['isManga'];
    isNsfw = json['isNsfw'];
    isPinned = json['isPinned'];
    lang = json['lang'];
    lastUsed = json['lastUsed'];
    name = json['name'];
    sourceCode = json['sourceCode'];
    sourceCodeUrl = json['sourceCodeUrl'];
    typeSource = json['typeSource'];
    version = json['version'];
    versionLast = json['versionLast'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['apiUrl'] = apiUrl;
    data['appMinVerReq'] = appMinVerReq;
    data['baseUrl'] = baseUrl;
    data['dateFormat'] = dateFormat;
    data['dateFormatLocale'] = dateFormatLocale;
    data['hasCloudflare'] = hasCloudflare;
    data['headers'] = headers;
    data['iconUrl'] = iconUrl;
    data['id'] = id;
    data['isActive'] = isActive;
    data['isAdded'] = isAdded;
    data['isFullData'] = isFullData;
    data['isManga'] = isManga;
    data['isNsfw'] = isNsfw;
    data['isPinned'] = isPinned;
    data['lang'] = lang;
    data['lastUsed'] = lastUsed;
    data['name'] = name;
    data['sourceCode'] = sourceCode;
    data['sourceCodeUrl'] = sourceCodeUrl;
    data['typeSource'] = typeSource;
    data['version'] = version;
    data['versionLast'] = versionLast;
    return data;
  }

  MSource toMSource() {
    return MSource(
        id: id,
        name: name,
        hasCloudflare: hasCloudflare,
        isFullData: isFullData,
        lang: lang,
        baseUrl: baseUrl,
        apiUrl: apiUrl,
        dateFormat: dateFormat,
        dateFormatLocale: dateFormatLocale);
  }
}
