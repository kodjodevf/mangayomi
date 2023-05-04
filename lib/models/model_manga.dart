import 'package:isar/isar.dart';
part 'model_manga.g.dart';

@collection
@Name("Manga")
class ModelManga {
  Id? id;

  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  String? status;

  List<String>? genre;

  bool favorite;

  String? source;

  String? lang;

  int? dateAdded;

  int? lastUpdate;

  String? lastRead;

  List<int>? categories;
  @Backlink(to: "manga")
  final chapters = IsarLinks<ModelChapters>();

  ModelManga({
    this.id = Isar.autoIncrement,
    required this.source,
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
    required this.categories,
    required this.lastRead,
  });
}

@collection
@Name("Chapters")
class ModelChapters {
  Id? id;

  int? mangaId;

  String? name;

  String? url;

  String? dateUpload;

  String? scanlator;

  bool? isBookmarked;

  bool? isRead;

  String? lastPageRead;

  final manga = IsarLink<ModelManga>();

  ModelChapters(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required this.name,
      required this.url,
      required this.dateUpload,
      required this.isBookmarked,
      required this.scanlator,
      required this.isRead,
      required this.lastPageRead});
}
