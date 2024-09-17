import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'update.g.dart';

@collection
@Name("Update")
class Update {
  Id? id;

  int? mangaId;

  String? chapterName;

  final chapter = IsarLink<Chapter>();

  String? date;

  Update({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    required this.chapterName,
    required this.date,
  });

  Update.fromJson(Map<String, dynamic> json) {
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
