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
  late TrackStatus status;

  int? startedReadingDate;

  int? finishedReadingDate;

  String? trackingUrl;

  bool? isManga;

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
      this.trackingUrl,
      this.isManga});
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['finishedReadingDate'] = finishedReadingDate;
    data['id'] = id;
    data['lastChapterRead'] = lastChapterRead;
    data['libraryId'] = libraryId;
    data['mangaId'] = mangaId;
    data['mediaId'] = mediaId;
    data['score'] = score;
    data['startedReadingDate'] = startedReadingDate;
    data['status'] = status.index;
    data['syncId'] = syncId;
    data['title'] = title;
    data['totalChapter'] = totalChapter;
    data['trackingUrl'] = trackingUrl;
    data['isManga'] = isManga;
    return data;
  }
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
