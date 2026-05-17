// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_search.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackSearchAdapter extends TypeAdapter<TrackSearch> {
  @override
  final int typeId = 15;

  @override
  TrackSearch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackSearch(
      mediaId: fields[0] as int,
      title: fields[1] as String,
      totalChapter: fields[2] as int,
      coverUrl: fields[3] as String,
      summary: fields[4] as String,
      trackingUrl: fields[5] as String,
      publishingStatus: fields[6] as String,
      publishingType: fields[7] as String,
      startDate: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TrackSearch obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.mediaId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.totalChapter)
      ..writeByte(3)
      ..write(obj.coverUrl)
      ..writeByte(4)
      ..write(obj.summary)
      ..writeByte(5)
      ..write(obj.trackingUrl)
      ..writeByte(6)
      ..write(obj.publishingStatus)
      ..writeByte(7)
      ..write(obj.publishingType)
      ..writeByte(8)
      ..write(obj.startDate);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackSearchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
