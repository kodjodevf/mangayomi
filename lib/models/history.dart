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

  int? updatedAt;

  History({
    this.id = Isar.autoIncrement,
    this.isManga,
    required this.itemType,
    required this.chapterId,
    required this.mangaId,
    required this.date,
    this.updatedAt = 0,
  });

  History.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    date = json['date'];
    id = json['id'];
    isManga = json['isManga'];
    itemType = ItemType.values[json['itemType'] ?? 0];
    mangaId = json['mangaId'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
    'chapterId': chapterId,
    'date': date,
    'id': id,
    'itemType': itemType.index,
    'mangaId': mangaId,
    'updatedAt': updatedAt,
  };
}
