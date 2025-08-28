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

  String? artist;

  @enumerated
  late Status status;

  bool? isManga;

  @enumerated
  late ItemType itemType;

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

  String? customCoverFromTracker;

  /// only update X days after `lastUpdate`
  int? smartUpdateDays;

  int? updatedAt;

  int? sourceId;

  @Backlink(to: "manga")
  final chapters = IsarLinks<Chapter>();

  Manga({
    this.id = Isar.autoIncrement,
    required this.source,
    required this.author,
    required this.artist,
    this.favorite = false,
    required this.genre,
    required this.imageUrl,
    required this.lang,
    required this.link,
    required this.name,
    required this.status,
    required this.description,
    required this.sourceId,
    this.isManga,
    this.itemType = ItemType.manga,
    this.dateAdded,
    this.lastUpdate,
    this.categories,
    this.lastRead = 0,
    this.isLocalArchive = false,
    this.customCoverImage,
    this.customCoverFromTracker,
    this.smartUpdateDays,
    this.updatedAt = 0,
  });

  Manga.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    artist = json['artist'];
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
    itemType = ItemType.values[json['itemType'] ?? 0];
    lang = json['lang'];
    lastRead = json['lastRead'];
    lastUpdate = json['lastUpdate'];
    link = json['link'];
    name = json['name'];
    source = json['source'];
    status = Status.values[json['status']];
    customCoverFromTracker = json['customCoverFromTracker'];
    smartUpdateDays = json['smartUpdateDays'];
    updatedAt = json['updatedAt'];
    sourceId = json['sourceId'];
  }

  Map<String, dynamic> toJson() => {
    'author': author,
    'artist': artist,
    'categories': categories,
    'customCoverImage': customCoverImage,
    'dateAdded': dateAdded,
    'description': description,
    'favorite': favorite,
    'genre': genre,
    'id': id,
    'imageUrl': imageUrl,
    'isLocalArchive': isLocalArchive,
    'itemType': itemType.index,
    'lang': lang,
    'lastRead': lastRead,
    'lastUpdate': lastUpdate,
    'link': link,
    'name': name,
    'source': source,
    'status': status.index,
    'customCoverFromTracker': customCoverFromTracker,
    'smartUpdateDays': smartUpdateDays,
    'updatedAt': updatedAt ?? 0,
    'sourceId': sourceId,
  };
}

enum Status {
  ongoing,
  completed,
  canceled,
  unknown,
  onHiatus,
  publishingFinished,
}

enum ItemType { manga, anime, novel }
