import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'chapter.g.dart';

@collection
@Name("Chapter")
class Chapter {
  Id? id;

  int? mangaId;

  String? name;

  String? url;

  String? dateUpload;

  String? scanlator;

  bool? isBookmarked;

  bool? isRead;

  String? lastPageRead;

  final manga = IsarLink<Manga>();

  Chapter(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required this.name,
      required this.url,
      required this.dateUpload,
      this.isBookmarked = false,
      required this.scanlator,
      this.isRead = false,
      this.lastPageRead = ''});
}
