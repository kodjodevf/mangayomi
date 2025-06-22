class TrackSearch {
  int? id;

  int? libraryId;

  int? mediaId;

  int? syncId;

  String? title;

  int? lastChapterRead;

  int? totalChapter;

  double? score;

  String? status;

  int? startedReadingDate;

  int? finishedReadingDate;

  String? trackingUrl;

  String? coverUrl;

  String? summary;

  String? publishingStatus;

  String? publishingType;

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
