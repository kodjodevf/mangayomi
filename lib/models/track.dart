import 'package:isar/isar.dart';
import 'package:mangayomi/models/manga.dart';
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
  late TrackStatus status;

  int? startedReadingDate;

  int? finishedReadingDate;

  String? trackingUrl;

  bool? isManga;

  @enumerated
  late ItemType itemType;

  int? updatedAt;

  Track({
    this.id = Isar.autoIncrement,
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
    this.trackingUrl,
    this.isManga,
    this.itemType = ItemType.manga,
    this.updatedAt = 0,
  });
  Track.fromJson(Map<String, dynamic> json) {
    finishedReadingDate = json['finishedReadingDate'];
    id = json['id'];
    lastChapterRead = json['lastChapterRead'];
    libraryId = json['libraryId'];
    mangaId = json['mangaId'];
    mediaId = json['mediaId'];
    score = json['score'];
    startedReadingDate = json['startedReadingDate'];
    status = TrackStatus.values[json['status']];
    syncId = json['syncId'];
    title = json['title'];
    totalChapter = json['totalChapter'];
    trackingUrl = json['trackingUrl'];
    isManga = json['isManga'];
    if (json['itemType'] != null || isManga != null) {
      itemType = ItemType.values[json['itemType'] ?? (isManga! ? 0 : 1)];
    }
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
    'finishedReadingDate': finishedReadingDate,
    'id': id,
    'lastChapterRead': lastChapterRead,
    'libraryId': libraryId,
    'mangaId': mangaId,
    'mediaId': mediaId,
    'score': score,
    'startedReadingDate': startedReadingDate,
    'status': status.index,
    'syncId': syncId,
    'title': title,
    'totalChapter': totalChapter,
    'trackingUrl': trackingUrl,
    'isManga': isManga,
    'itemType': itemType.index,
    'updatedAt': updatedAt ?? 0,
  };
}

enum TrackStatus {
  reading,
  completed,
  onHold,
  dropped,
  planToRead,
  reReading,
  watching,
  planToWatch,
  reWatching,
}
