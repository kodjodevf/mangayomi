import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'feed.g.dart';

@collection
@Name("Feed")
class Feed {
  Id? id;

  int? mangaId;

  final chapter = IsarLink<Chapter>();

  String? date;

  Feed({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    required this.date,
  });

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mangaId = json['mangaId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mangaId': mangaId,
        'date': date,
      };
}
