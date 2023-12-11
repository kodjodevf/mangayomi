import 'package:mangayomi/eval/model/m_chapter.dart';
import 'package:mangayomi/models/manga.dart';

class MManga {
  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  Status? status;

  List<String>? genre;

  List<MChapter>? chapters;

  MManga(
      {this.author,
      this.genre,
      this.imageUrl,
      this.link,
      this.name,
      this.status = Status.unknown,
      this.description,
      this.chapters});
}
