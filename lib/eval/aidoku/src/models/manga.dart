import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';
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
    for (final v in values) {
      if (v.value == val) return v;
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
    for (final s in values) {
      if (s.value == val) return s;
    }
    return UpdateStrategy.always;
  }
}

/// Represents a Manga.
class Manga {
  Manga({
    this.sourceKey = '',
    required this.key,
    required this.title,
    this.cover,
    this.artists,
    this.authors,
    this.description,
    this.url,
    this.tags,
    this.status = PublishingStatus.unknown,
    this.contentRating = ContentRating.unknown,
    this.viewer = Viewer.unknown,
    this.updateStrategy = UpdateStrategy.always,
    this.nextUpdateTime,
    this.chapters,
  });

  /// Unique identifier of the manga's source (excluded from binary coding).
  String sourceKey;

  /// Unique identifier for the manga.
  String key;

  /// Title of the manga.
  String title;

  /// Link to the manga cover image.
  String? cover;

  /// Optional list of artists.
  List<String>? artists;

  /// Optional list of authors.
  List<String>? authors;

  /// Description of the manga.
  String? description;

  /// Link to the manga on the source website.
  String? url;

  /// Optional list of genres or tags.
  List<String>? tags;

  /// Publishing status of the manga.
  PublishingStatus status;

  /// Content rating of the manga.
  ContentRating contentRating;

  /// Preferred viewer type of the manga.
  Viewer viewer;

  /// Ideal update strategy for the manga.
  UpdateStrategy updateStrategy;

  /// Optional date (in epoch seconds) for when the manga should next be updated.
  int? nextUpdateTime;

  /// List of chapters.
  List<Chapter>? chapters;

  Manga copyWith({
    String? sourceKey,
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
      sourceKey: sourceKey ?? this.sourceKey,
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

  factory Manga.fromPostcard(PostcardReader reader) {
    final key = reader.readString();
    final title = reader.readString();
    final cover = reader.readOption((r) => r.readString());
    final artists = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final authors = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final description = reader.readOption((r) => r.readString());
    final url = reader.readOption((r) => r.readString());
    final tags = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final status = PublishingStatus.fromValue(reader.readU8());
    final contentRating = ContentRating.fromValue(reader.readU8());
    final viewer = Viewer.fromValue(reader.readU8());
    final updateStrategy = UpdateStrategy.fromValue(reader.readU8());
    final nextUpdateTime = reader.readOption((r) => r.readI64());
    final chapters = reader.readOption((r) => r.readList((r2) => Chapter.fromPostcard(r2)));

    return Manga(
      key: key,
      title: title,
      cover: cover,
      artists: artists,
      authors: authors,
      description: description,
      url: url,
      tags: tags,
      status: status,
      contentRating: contentRating,
      viewer: viewer,
      updateStrategy: updateStrategy,
      nextUpdateTime: nextUpdateTime,
      chapters: chapters,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(key);
    writer.writeString(title);
    writer.writeOption(cover, (w, s) => w.writeString(s));
    writer.writeOption(artists, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(authors, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeOption(description, (w, s) => w.writeString(s));
    writer.writeOption(url, (w, s) => w.writeString(s));
    writer.writeOption(tags, (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)));
    writer.writeU8(status.value);
    writer.writeU8(contentRating.value);
    writer.writeU8(viewer.value);
    writer.writeU8(updateStrategy.value);
    writer.writeOption(nextUpdateTime, (w, v) => w.writeI64(v));
    writer.writeOption(
      chapters,
      (w, list) => w.writeList(list, (w2, ch) => ch.toPostcard(w2)),
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

  factory MangaPageResult.fromPostcard(PostcardReader reader) {
    final entries = reader.readList((r) => Manga.fromPostcard(r));
    final hasNextPage = reader.readBool();
    return MangaPageResult(entries: entries, hasNextPage: hasNextPage);
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeList(entries, (w, manga) => manga.toPostcard(w));
    writer.writeBool(hasNextPage);
  }

  void setSourceKey(String sourceKey) {
    for (final manga in entries) {
      manga.sourceKey = sourceKey;
    }
  }
}
