import 'package:isar/isar.dart';
import 'package:mangayomi/models/model_manga.dart';
part 'chapter_filter.g.dart';

@collection
@Name("ChaptersFilter")
class ChaptersFilter {
  Id? id;

  int? downloaded;

  int? unread;

  int? bookmarked;

  final manga = IsarLink<ModelManga>();

  ChaptersFilter({
    this.id = Isar.autoIncrement,
    this.downloaded = 0,
    this.unread = 0,
    this.bookmarked = 0,
  });
}
