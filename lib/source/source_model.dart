import 'package:hive/hive.dart';
part 'source_model.g.dart';

@HiveType(typeId: 3)
class SourceModel extends HiveObject {
  @HiveField(0)
  final String sourceName;
  @HiveField(1)
  final String url;
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
  SourceModel({
    required this.sourceName,
    required this.url,
    required this.lang,
    required this.typeSource,
    this.isActive = true,
    this.isAdded = false,
    this.isNsfw = false,
  });
}

@HiveType(typeId: 4)
enum TypeSource {
  @HiveField(1)
  single,
  @HiveField(2)
  mangathemesia,
  @HiveField(3)
  comick
}

// @HiveType(typeId: 3)
// class SourceModel {
//   @HiveField(0, defaultValue: true)
//   final bool isActive;
//   @HiveField(1)
//   final Source source;
//   @HiveField(2)
//   SourceModel(
//     this.source, {
//     this.isActive = true,
//   });
// }

// @HiveType(typeId: 4)
// class Source {
//   @HiveField(0)
//   final String sourceName;
//   @HiveField(1)
//   final String url;
//   @HiveField(2)
//   final String lang;
//   @HiveField(3, defaultValue: true)
//   final bool isActive;
//   @HiveField(4, defaultValue: false)
//   final bool isAdded;
//   @HiveField(5, defaultValue: false)
//   final bool isNsfw;
//   final TypeSource typeSource;
//   Source(
//     this.sourceName,
//     this.url,
//     this.lang,
//     this.typeSource, {
//     this.isActive = true,
//     this.isAdded = false,
//     this.isNsfw = false,
//   });
// }
