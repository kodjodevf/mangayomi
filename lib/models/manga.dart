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
  late Status status;

  bool? isManga;

  List<String>? genre;

  bool? favorite;

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

  Manga.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    categories = json['categories']?.cast<int>();
    customCoverImage = json['customCoverImage']?.cast<int>();
    dateAdded = json['dateAdded'];
    description = json['description'];
    favorite = json['favorite']!;
    genre = json['genre']?.cast<String>();
    id = json['id'];
    imageUrl = json['imageUrl'];
    isLocalArchive = json['isLocalArchive'];
    isManga = json['isManga'];
    lang = json['lang'];
    lastRead = json['lastRead'];
    lastUpdate = json['lastUpdate'];
    link = json['link'];
    name = json['name'];
    source = json['source'];
    status = Status.values[json['status']];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['categories'] = categories;
    data['customCoverImage'] = customCoverImage;
    data['dateAdded'] = dateAdded;
    data['description'] = description;
    data['favorite'] = favorite;
    data['genre'] = genre;
    data['id'] = id;
    data['imageUrl'] = imageUrl;
    data['isLocalArchive'] = isLocalArchive;
    data['isManga'] = isManga;
    data['lang'] = lang;
    data['lastRead'] = lastRead;
    data['lastUpdate'] = lastUpdate;
    data['link'] = link;
    data['name'] = name;
    data['source'] = source;
    data['status'] = status.index;
    return data;
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
