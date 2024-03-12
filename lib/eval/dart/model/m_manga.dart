import 'package:mangayomi/eval/dart/model/m_chapter.dart';
import 'package:mangayomi/models/manga.dart';

class MManga {
  String? name;

  String? link;

  String? imageUrl;

  String? description;

  String? author;

  String? artist;

  Status? status;

  List<String>? genre;

  List<MChapter>? chapters;

  MManga(
      {this.author,
      this.artist,
      this.genre,
      this.imageUrl,
      this.link,
      this.name,
      this.status = Status.unknown,
      this.description,
      this.chapters});

  factory MManga.fromJson(Map<String, dynamic> json) {
    return MManga(
        name: json['name'],
        link: json['link'],
        imageUrl: json['imageUrl'],
        description: json['description'],
        author: json['author'],
        artist: json['artist'],
        status: json['status'],
        genre: json['genre'] ?? [],
        chapters: json['chapters'] != null
            ? (json['chapters'] as List)
                .map((e) => MChapter.fromJson(e))
                .toList()
            : []);
  }
}
