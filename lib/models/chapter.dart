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

  ///Only for local archive Comic
  String? archivePath;

  final manga = IsarLink<Manga>();

  Chapter(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required this.name,
      this.url = '',
      this.dateUpload = '',
      this.isBookmarked = false,
      this.scanlator = '',
      this.isRead = false,
      this.lastPageRead = '',
      this.archivePath = ''});

  Chapter.fromJson(Map<String, dynamic> json) {
    archivePath = json['archivePath'];
    dateUpload = json['dateUpload'];
    id = json['id'];
    isBookmarked = json['isBookmarked'];
    isRead = json['isRead'];
    lastPageRead = json['lastPageRead'];
    mangaId = json['mangaId'];
    name = json['name'];
    scanlator = json['scanlator'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() => {
        'archivePath': archivePath,
        'dateUpload': dateUpload,
        'id': id,
        'isBookmarked': isBookmarked,
        'isRead': isRead,
        'lastPageRead': lastPageRead,
        'mangaId': mangaId,
        'name': name,
        'scanlator': scanlator,
        'url': url
      };
}
