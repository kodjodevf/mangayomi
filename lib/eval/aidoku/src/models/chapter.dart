import '../postcard/postcard_reader.dart';
import '../postcard/postcard_writer.dart';

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

  factory Chapter.fromPostcard(PostcardReader reader) {
    final key = reader.readString();
    final title = reader.readOption((r) => r.readString());
    final chapterNumber = reader.readOption((r) => r.readF32());
    final volumeNumber = reader.readOption((r) => r.readF32());
    final dateSec = reader.readOption((r) => r.readI64());
    final scanlators = reader.readOption((r) => r.readList((r2) => r2.readString()));
    final url = reader.readOption((r) => r.readString());
    final language = reader.readOption((r) => r.readString());
    final thumbnail = reader.readOption((r) => r.readString());
    final locked = reader.readBool();

    return Chapter(
      key: key,
      title: title,
      chapterNumber: chapterNumber,
      volumeNumber: volumeNumber,
      dateUploaded: dateSec != null
          ? DateTime.fromMillisecondsSinceEpoch(dateSec * 1000, isUtc: true)
          : null,
      scanlators: scanlators,
      url: url,
      language: language,
      thumbnail: thumbnail,
      locked: locked,
    );
  }

  void toPostcard(PostcardWriter writer) {
    writer.writeString(key);
    writer.writeOption(title, (w, v) => w.writeString(v));
    writer.writeOption(chapterNumber, (w, v) => w.writeF32(v));
    writer.writeOption(volumeNumber, (w, v) => w.writeF32(v));
    writer.writeOption(
      dateUploaded != null ? dateUploaded!.millisecondsSinceEpoch ~/ 1000 : null,
      (w, v) => w.writeI64(v),
    );
    writer.writeOption(
      scanlators,
      (w, list) => w.writeList(list, (w2, s) => w2.writeString(s)),
    );
    writer.writeOption(url, (w, v) => w.writeString(v));
    writer.writeOption(language, (w, v) => w.writeString(v));
    writer.writeOption(thumbnail, (w, v) => w.writeString(v));
    writer.writeBool(locked);
  }

  @override
  String toString() =>
      'Chapter(key: $key, title: $title, ch: $chapterNumber, vol: $volumeNumber, locked: $locked)';
}
