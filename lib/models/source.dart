import 'package:isar/isar.dart';
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
    name = json['name'];
    id = json['id'];
    baseUrl = json['baseUrl'];
    lang = json['lang'];
    typeSource = json['typeSource'];
    iconUrl = json['iconUrl'];
    dateFormat = json['dateFormat'];
    dateFormatLocale = json['dateFormatLocale'];
    isNsfw = json['isNsfw'];
    hasCloudflare = json['hasCloudflare'];
    sourceCodeUrl = json['sourceCodeUrl'];
    apiUrl = json['apiUrl'];
    version = json['version'];
    isManga = json['isManga'] ?? true;
    isFullData = json['isFullData'] ?? false;
    appMinVerReq = json['appMinVerReq'];
  }
}
