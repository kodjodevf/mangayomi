import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
part 'history.g.dart';

@collection
@Name("History")
class History {
  Id? id;

  int? mangaId;

  int? chapterId;

  bool? isManga;

  @enumerated
  late ItemType itemType;

  final chapter = IsarLink<Chapter>();

  String? date;

  History({
    this.id = Isar.autoIncrement,
    this.isManga = true,
    required this.itemType,
    required this.chapterId,
    required this.mangaId,
    required this.date,
  });

  History.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    date = json['date'];
    id = json['id'];
    itemType = ItemType.values[json['itemType'] ?? 0];
    mangaId = json['mangaId'];
  }

  History.fromJsonV1(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    date = json['date'];
    id = json['id'];
    itemType = json['isManga'] is bool
        ? json['isManga'] == true
            ? ItemType.manga
            : ItemType.anime
        : ItemType.manga;
    mangaId = json['mangaId'];
  }

  Map<String, dynamic> toJson() => {
        'chapterId': chapterId,
        'date': date,
        'id': id,
        'itemType': itemType.index,
        'mangaId': mangaId
      };
}
