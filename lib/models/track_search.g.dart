// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
