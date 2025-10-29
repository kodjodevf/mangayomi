class ChapterItem {
  String name;
  String path;
  String? releaseTime;
  int? chapterNumber;
  String? page;

  ChapterItem({
    required this.name,
    required this.path,
    this.releaseTime,
    this.chapterNumber,
    this.page,
  });

  factory ChapterItem.fromJson(Map<String, dynamic> json) {
    return ChapterItem(
      name: json['name'],
      path: json['path'],
      releaseTime: json['releaseTime'],
      chapterNumber: json['chapterNumber'] != null
          ? (json['chapterNumber'] as num?)?.toInt() ??
                int.tryParse(json['chapterNumber'])
          : null,
      page: json['page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'releaseTime': releaseTime,
      'chapterNumber': chapterNumber,
      'page': page,
    };
  }
}

class NovelItem {
  String name;
  String path;
  String? cover;

  NovelItem({required this.name, required this.path, this.cover});

  factory NovelItem.fromJson(Map<String, dynamic> json) {
    return NovelItem(
      name: json['name'],
      path: json['path'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'path': path, 'cover': cover};
  }
}

class SourceNovel extends NovelItem {
  String? genres;
  String? summary;
  String? author;
  String? artist;
  String? status;
  double? rating;
  List<ChapterItem>? chapters;

  SourceNovel({
    required super.name,
    required super.path,
    super.cover,
    this.genres,
    this.summary,
    this.author,
    this.artist,
    this.status,
    this.rating,
    this.chapters,
  });

  factory SourceNovel.fromJson(Map<String, dynamic> json) {
    if (json['path'] == null) {
      throw 'path is null';
    }
    return SourceNovel(
      name: json['name'] ?? '',
      path: json['path'],
      cover: json['cover'],
      genres: json['genres'],
      summary: json['summary'],
      author: json['author'],
      artist: json['artist'],
      status: json['status'],
      rating: json['rating'] is double
          ? json['rating']
          : json['rating']?.toDouble(),
      chapters: (json['chapters'] as List<dynamic>?)
          ?.map((item) => ChapterItem.fromJson(item))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'cover': cover,
      'genres': genres,
      'summary': summary,
      'author': author,
      'artist': artist,
      'status': status,
      'rating': rating,
      'chapters': chapters?.map((item) => item.toJson()).toList(),
    };
  }
}

class SourcePage {
  List<ChapterItem> chapters;

  SourcePage({required this.chapters});

  factory SourcePage.fromJson(Map<String, dynamic> json) {
    return SourcePage(
      chapters:
          (json['chapters'] as List<dynamic>?)
              ?.map((item) => ChapterItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'chapters': chapters.map((item) => item.toJson()).toList()};
  }
}
