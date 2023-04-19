import 'package:hive/hive.dart';

part 'model_manga.g.dart';

@HiveType(typeId: 0)
class ModelManga extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? link;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? author;

  @HiveField(5)
  String? status;

  @HiveField(6)
  List<String>? genre;

  @HiveField(7)
  bool favorite;

  @HiveField(8)
  String? source;

  @HiveField(9)
  String? lang;

  @HiveField(10)
  int? dateAdded;

  @HiveField(11)
  int? lastUpdate;

  @HiveField(12)
  List<ModelChapters>? chapters;

  @HiveField(13)
  String? lastRead;

  @HiveField(14)
  int? category;

  ModelManga(
      {required this.source,
      required this.author,
      required this.favorite,
      required this.genre,
      required this.imageUrl,
      required this.lang,
      required this.link,
      required this.name,
      required this.status,
      required this.description,
      required this.dateAdded,
      required this.lastUpdate,
      required this.category,
      required this.lastRead,
      required this.chapters});
}

@HiveType(typeId: 7)
class ModelChapters extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? url;

  @HiveField(2)
  String? dateUpload;

  @HiveField(3)
  String? scanlator;

  @HiveField(4)
  bool isBookmarked;

  @HiveField(5)
  bool isRead;

  @HiveField(6)
  String lastPageRead;

  ModelChapters(
      {required this.name,
      required this.url,
      required this.dateUpload,
      required this.isBookmarked,
      required this.scanlator,
      required this.isRead,
      required this.lastPageRead});
}
