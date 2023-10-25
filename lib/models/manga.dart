import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_manga.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/source.dart';
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

  MManga toMManga(Source source) {
    return MManga(
        name: name,
        link: link,
        genre: genre,
        author: author,
        status: switch (status) {
          Status.ongoing => 0,
          Status.completed => 1,
          Status.onHiatus => 2,
          Status.canceled => 3,
          Status.publishingFinished => 4,
          _ => 5,
        },
        description: description,
        imageUrl: imageUrl,
        baseUrl: source.baseUrl,
        apiUrl: source.apiUrl,
        lang: lang,
        dateFormat: source.dateFormat,
        source: source.name,
        dateFormatLocale: source.dateFormatLocale);
  }
}

enum Status {
  ongoing,
  completed,
  canceled,
  unknown,
  onHiatus,
  publishingFinished
}
