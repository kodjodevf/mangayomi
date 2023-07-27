import 'package:isar/isar.dart';
part 'track.g.dart';

@collection
@Name("Track")
class Track {
  Id? id;

  int? libraryId;

  int? mediaId;

  int? mangaId;

  int? syncId;

  String? title;

  int? lastChapterRead;

  int? totalChapter;

  int? score;

  @enumerated
  TrackStatus status;

  int? startedReadingDate;

  int? finishedReadingDate;

  String? trackingUrl;

  Track(
      {this.id = Isar.autoIncrement,
      this.libraryId,
      this.mediaId,
      this.mangaId,
      this.syncId,
      this.title,
      this.lastChapterRead,
      this.totalChapter,
      this.score,
      required this.status,
      this.startedReadingDate,
      this.finishedReadingDate,
      this.trackingUrl});
}

enum TrackStatus {
  reading,
  completed,
  onHold,
  dropped,
  planToRead,
  rereading,
  watching,
  planToWatch,
  reWatching
}
