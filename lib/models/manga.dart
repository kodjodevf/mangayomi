import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'manga.g.dart';

@collection
@Name("Manga")
class Manga {
  Id? id;

  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  @enumerated
  Status status;

  bool? isManga;

  List<String>? genre;

  bool favorite;

  String? source;

  String? lang;

  int? dateAdded;

  int? lastUpdate;

  int? lastRead;

  List<int>? categories;

  bool? isLocalArchive;

  List<byte>? customCoverImage;

  @Backlink(to: "manga")
  final chapters = IsarLinks<Chapter>();

  Manga(
      {this.id = Isar.autoIncrement,
      required this.source,
      required this.author,
      this.favorite = false,
      required this.genre,
      required this.imageUrl,
      required this.lang,
      required this.link,
      required this.name,
      required this.status,
      required this.description,
      this.isManga = true,
      this.dateAdded,
      this.lastUpdate,
      this.categories,
      this.lastRead = 0,
      this.isLocalArchive = false,
      this.customCoverImage});
}

enum Status {
  ongoing,
  completed,
  canceled,
  unknown,
  onHiatus,
  publishingFinished
}

