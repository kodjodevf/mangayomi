import 'chapter.dart';

enum PublishingStatus {
  unknown(0),
  ongoing(1),
  completed(2),
  cancelled(3),
  hiatus(4);

  const PublishingStatus(this.value);
  final int value;

  static PublishingStatus fromValue(int val) {
    for (final status in values) {
      if (status.value == val) return status;
    }
    return PublishingStatus.unknown;
  }
}

enum ContentRating {
  unknown(0),
  safe(1),
  suggestive(2),
  nsfw(3);

  const ContentRating(this.value);
  final int value;

  static ContentRating fromValue(int val) {
    for (final rating in values) {
      if (rating.value == val) return rating;
    }
    return ContentRating.unknown;
  }
}

enum Viewer {
  unknown(0),
  leftToRight(1),
  rightToLeft(2),
  vertical(3),
  webtoon(4);

  const Viewer(this.value);
  final int value;

  static Viewer fromValue(int val) {
    for (final viewer in values) {
      if (viewer.value == val) return viewer;
    }
    return Viewer.unknown;
  }
}

enum UpdateStrategy {
  always(0),
  never(1);

  const UpdateStrategy(this.value);
  final int value;

  static UpdateStrategy fromValue(int val) {
    for (final strategy in values) {
      if (strategy.value == val) return strategy;
    }
    return UpdateStrategy.always;
  }
}

/// Represents a manga entry.
class Manga {
  Manga({
    required this.key,
    required this.title,
    this.cover,
    this.artists,
    this.authors,
    this.description,
    this.url,
    this.tags,
    this.status = PublishingStatus.unknown,
    this.contentRating = ContentRating.safe,
    this.viewer = Viewer.unknown,
    this.updateStrategy = UpdateStrategy.always,
    this.nextUpdateTime,
    this.chapters,
  });

  /// Unique identifier for the manga.
  String key;

  /// Title of the manga.
  String title;

  /// Optional url to the cover image of the manga.
  String? cover;

  /// Optional list of artists for the manga.
  List<String>? artists;

  /// Optional list of authors for the manga.
  List<String>? authors;

  /// Optional description for the manga.
  String? description;

  /// Link to the manga on the source website.
  String? url;

  /// Optional list of tags or categories for the manga.
  List<String>? tags;

  /// The publishing status of the manga.
  PublishingStatus status;

  /// The content rating of the manga.
  ContentRating contentRating;

  /// The default reading mode of the manga.
  Viewer viewer;

  /// The update strategy for the manga.
  UpdateStrategy updateStrategy;

  /// The next estimated update time for the manga (epoch seconds).
  int? nextUpdateTime;

  /// Optional list of chapters for the manga.
  List<Chapter>? chapters;

  /// Source key (used internally to identify source).
  String? sourceKey;

  Manga copyWith({
    String? key,
    String? title,
    String? cover,
    List<String>? artists,
    List<String>? authors,
    String? description,
    String? url,
    List<String>? tags,
    PublishingStatus? status,
    ContentRating? contentRating,
    Viewer? viewer,
    UpdateStrategy? updateStrategy,
    int? nextUpdateTime,
    List<Chapter>? chapters,
  }) {
    return Manga(
      key: key ?? this.key,
      title: title ?? this.title,
      cover: cover ?? this.cover,
      artists: artists ?? this.artists,
      authors: authors ?? this.authors,
      description: description ?? this.description,
      url: url ?? this.url,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      contentRating: contentRating ?? this.contentRating,
      viewer: viewer ?? this.viewer,
      updateStrategy: updateStrategy ?? this.updateStrategy,
      nextUpdateTime: nextUpdateTime ?? this.nextUpdateTime,
      chapters: chapters ?? this.chapters,
    );
  }

  @override
  String toString() => 'Manga(key: $key, title: $title, status: $status)';
}

/// Represents the paginated result of a manga list query.
class MangaPageResult {
  MangaPageResult({required this.entries, required this.hasNextPage});

  List<Manga> entries;
  bool hasNextPage;

  void setSourceKey(String sourceKey) {
    for (final manga in entries) {
      manga.sourceKey = sourceKey;
    }
  }
}
