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
  String? description = '';

  @HiveField(4)
  String? author = '';

  @HiveField(5)
  String? status = '';

  @HiveField(6)
  List<String>? genre;

  @HiveField(7)
  bool favorite = false;

  @HiveField(8)
  List<String>? chapterTitle;

  @HiveField(9)
  List<String>? chapterUrl;

  @HiveField(10)
  List<String>? chapterDate;

  @HiveField(11)
  String? source;

  @HiveField(12)
  String? lang;

  ModelManga(
      {required this.chapterDate,
      required this.source,
      required this.chapterTitle,
      required this.chapterUrl,
      required this.author,
      required this.favorite,
      required this.genre,
      required this.imageUrl,
      required this.lang,
      required this.link,
      required this.name,
      required this.status,
      required this.description});
}
