import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'feed.g.dart';

@collection
@Name("Feed")
class Feed {
  Id? id;

  int? mangaId;

  String? chapterName;

  final chapter = IsarLink<Chapter>();

  String? date;

  Feed({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    required this.chapterName,
    required this.date,
  });

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mangaId = json['mangaId'];
    chapterName = json['chapterName'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mangaId': mangaId,
        'chapterName': chapterName,
        'date': date,
      };
}
