import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'history.g.dart';

@collection
@Name("History")
class History {
  Id? id;

  int? mangaId;

  int? chapterId;

  bool? isManga;

  final chapter = IsarLink<Chapter>();

  String? date;

  History({
    this.id = Isar.autoIncrement,
    required this.isManga,
    required this.chapterId,
    required this.mangaId,
    required this.date,
  });

  History.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    date = json['date'];
    id = json['id'];
    isManga = json['isManga'];
    mangaId = json['mangaId'];
  }

  Map<String, dynamic> toJson() =>
      {'chapterId': chapterId, 'date': date, 'id': id, 'isManga': isManga, 'mangaId': mangaId};
}
