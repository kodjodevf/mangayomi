import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'source_model.g.dart';

@HiveType(typeId: 3)
class SourceModel extends HiveObject {
  @HiveField(0)
  final String sourceName;
  @HiveField(1)
  final String baseUrl;
  @HiveField(2)
  final String lang;
  @HiveField(3, defaultValue: true)
  final bool isActive;
  @HiveField(4, defaultValue: false)
  final bool isAdded;
  @HiveField(5, defaultValue: false)
  final bool isNsfw;
  @HiveField(6)
  final TypeSource typeSource;
  @HiveField(7)
  final String logoUrl;
  @HiveField(8, defaultValue: false)
  final bool isFullData;
  @HiveField(9, defaultValue: false)
  final bool isCloudflare;
  @HiveField(10)
  final String dateFormat;
  @HiveField(11)
  final String dateFormatLocale;
  @HiveField(12)
  final String apiUrl;
  SourceModel({
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

@HiveType(typeId: 4)
enum TypeSource {
  @HiveField(1)
  single,
  @HiveField(2)
  mangathemesia,
  @HiveField(3)
  comick,
  @HiveField(4)
  mmrcms,
  @HiveField(5)
  heancms
}
