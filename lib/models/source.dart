import 'package:isar/isar.dart';
part 'source.g.dart';

@collection
@Name("Sources")
class Source {
  Id? id;

  String? sourceName;

  String? baseUrl;

  String? lang;

  bool? isActive;

  bool? isAdded;

  bool? isNsfw;

  @enumerated
  TypeSource typeSource;

  String? logoUrl;

  bool? isFullData;

  bool? isCloudflare;

  String? dateFormat;

  String? dateFormatLocale;

  String? apiUrl;

  Source({
    this.id = Isar.autoIncrement,
    required this.sourceName,
    required this.baseUrl,
    required this.lang,
    required this.typeSource,
    required this.logoUrl,
    required this.dateFormat,
    required this.dateFormatLocale,
    this.isActive = true,
    this.isAdded = false,
    this.isNsfw = false,
    this.isFullData = false,
    this.isCloudflare = false,
    this.apiUrl = "",
  });
}

enum TypeSource {
  single,

  mangathemesia,

  comick,

  mmrcms,

  heancms
}
