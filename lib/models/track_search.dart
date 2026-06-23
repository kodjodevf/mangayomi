import 'package:hive/hive.dart';
// part 'track_search.g.dart';

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

class TrackSearchAdapter extends TypeAdapter<TrackSearch> {
  @override
  final int typeId = 0;

  @override
  TrackSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackSearch(
      id: fields[0] as int?,
      libraryId: fields[1] as int?,
      mediaId: fields[2] as int?,
      syncId: fields[3] as int?,
      title: fields[4] as String?,
      lastChapterRead: fields[5] as int?,
      totalChapter: fields[6] as int?,
      score: fields[7] as double?,
      status: fields[8] as String?,
      startedReadingDate: fields[9] as int?,
      finishedReadingDate: fields[10] as int?,
      trackingUrl: fields[11] as String?,
      coverUrl: fields[12] as String?,
      publishingStatus: fields[14] as String?,
      publishingType: fields[15] as String?,
      startDate: fields[16] as String?,
      summary: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TrackSearch obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.libraryId)
      ..writeByte(2)
      ..write(obj.mediaId)
      ..writeByte(3)
      ..write(obj.syncId)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.lastChapterRead)
      ..writeByte(6)
      ..write(obj.totalChapter)
      ..writeByte(7)
      ..write(obj.score)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.startedReadingDate)
      ..writeByte(10)
      ..write(obj.finishedReadingDate)
      ..writeByte(11)
      ..write(obj.trackingUrl)
      ..writeByte(12)
      ..write(obj.coverUrl)
      ..writeByte(13)
      ..write(obj.summary)
      ..writeByte(14)
      ..write(obj.publishingStatus)
      ..writeByte(15)
      ..write(obj.publishingType)
      ..writeByte(16)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
