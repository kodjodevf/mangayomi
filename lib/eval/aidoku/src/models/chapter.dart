/// Represents a chapter of a manga.
class Chapter {
  Chapter({
    required this.key,
    this.title,
    this.chapterNumber,
    this.volumeNumber,
    this.dateUploaded,
    this.scanlators,
    this.url,
    this.language,
    this.thumbnail,
    this.locked = false,
  });

  /// Unique identifier for the chapter.
  String key;

  /// Title of the chapter (excluding volume and chapter number).
  String? title;

  /// Chapter number.
  double? chapterNumber;

  /// Volume number.
  double? volumeNumber;

  /// Date the chapter was uploaded (epoch seconds).
  DateTime? dateUploaded;

  /// Optional list of groups that scanlated or published the chapter.
  List<String>? scanlators;

  /// Link to the chapter on the source website.
  String? url;

  /// Language of the chapter.
  String? language;

  /// Optional thumbnail image url for the chapter.
  String? thumbnail;

  /// Boolean indicating if the chapter is locked.
  bool locked;

  @override
  String toString() =>
      'Chapter(key: $key, title: $title, ch: $chapterNumber, vol: $volumeNumber, locked: $locked)';
}
