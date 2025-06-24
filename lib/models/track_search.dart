import 'package:hive/hive.dart';
part 'track_search.g.dart';

@HiveType(typeId: 0, adapterName: "TrackSearchAdapter")
class TrackSearch {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? libraryId;

  @HiveField(2)
  int? mediaId;

  @HiveField(3)
  int? syncId;

  @HiveField(4)
  String? title;

  @HiveField(5)
  int? lastChapterRead;

  @HiveField(6)
  int? totalChapter;

  @HiveField(7)
  double? score;

  @HiveField(8)
  String? status;

  @HiveField(9)
  int? startedReadingDate;

  @HiveField(10)
  int? finishedReadingDate;

  @HiveField(11)
  String? trackingUrl;

  @HiveField(12)
  String? coverUrl;

  @HiveField(13)
  String? summary;

  @HiveField(14)
  String? publishingStatus;

  @HiveField(15)
  String? publishingType;

  @HiveField(16)
  String? startDate;

  TrackSearch({
    this.id,
    this.libraryId,
    this.mediaId,
    this.syncId,
    this.title,
    this.lastChapterRead,
    this.totalChapter,
    this.score,
    this.status = '',
    this.startedReadingDate,
    this.finishedReadingDate,
    this.trackingUrl,
    this.coverUrl = '',
    this.publishingStatus = '',
    this.publishingType = '',
    this.startDate = '',
    this.summary = '',
  });

  TrackSearch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libraryId = json['libraryId'];
    mediaId = json['mediaId'];
    syncId = json['syncId'];
    title = json['title'];
    lastChapterRead = json['lastChapterRead'];
    totalChapter = json['totalChapter'];
    score = json['score'];
    status = json['status'];
    startedReadingDate = json['startedReadingDate'];
    finishedReadingDate = json['finishedReadingDate'];
    trackingUrl = json['trackingUrl'];
    coverUrl = json['coverUrl'];
    publishingStatus = json['publishingStatus'];
  }

  Map<String, dynamic> toJson() => {
    'id': id, 
    'libraryId': libraryId,
    'mediaId': mediaId,
    'syncId': syncId,
    'title': title,
    'lastChapterRead': lastChapterRead,
    'totalChapter': totalChapter,
    'score': score,
    'status': status,
    'startedReadingDate': startedReadingDate,
    'finishedReadingDate': finishedReadingDate,
    'trackingUrl': trackingUrl,
    'coverUrl': coverUrl,
    'publishingStatus': publishingStatus,
  };
}
