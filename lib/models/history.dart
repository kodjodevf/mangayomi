import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';
part 'history.g.dart';

@collection
@Name("History")
class History {
  Id? id;
  int? mangaId;
  final chapter = IsarLink<Chapter>();
  String? date;
  History({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    required this.date,
  });
}
