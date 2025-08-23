import 'package:mangayomi/models/manga.dart';

class MangaPages {
  List<SManga> list;
  bool hasNextPage;
  MangaPages({required this.list, this.hasNextPage = false});

  factory MangaPages.fromJson(Map<String, dynamic> json, ItemType itemType) {
    final name = itemType == ItemType.anime ? "animes" : "mangas";
    return MangaPages(
      list: json[name] != null
          ? (json[name] as List).map((e) => SManga.fromJson(e)).toList()
          : [],
      hasNextPage: json['hasNextPage'],
    );
  }

  Map<String, dynamic> toJson(ItemType itemType) => {
    itemType == ItemType.anime ? "animes" : "mangas": list
        .map((v) => v.toJson())
        .toList(),
    'hasNextPage': hasNextPage,
  };
}

class SManga {
  String? url;

  String? title;

  String? artist;

  String? author;

  String? description;

  List<String>? genre;

  Status? status;

  String? thumbnailUrl;

  SManga({
    this.url,
    this.title,
    this.artist,
    this.author,
    this.description,
    this.genre,
    this.status = Status.unknown,
    this.thumbnailUrl,
  });

  factory SManga.fromJson(Map<String, dynamic> json) {
    return SManga(
      url: json['url'],
      title: json['title'],
      artist: json['artist'],
      author: json['author'],
      description: json['description'],
      genre: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? [],
      status: switch (json['status'] as int?) {
        1 => Status.ongoing,
        2 => Status.completed,
        4 => Status.publishingFinished,
        5 => Status.canceled,
        6 => Status.onHiatus,
        _ => Status.unknown,
      },
      thumbnailUrl: json['thumbnail_url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'artist': artist,
      'author': author,
      'description': description,
      'genre': genre?.join(", "),
      'status': status,
      'thumbnail_url': thumbnailUrl,
    };
  }
}
