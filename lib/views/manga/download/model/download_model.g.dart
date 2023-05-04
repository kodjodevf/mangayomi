// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadModelAdapter extends TypeAdapter<DownloadModel> {
  @override
  final int typeId = 6;

  @override
  DownloadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadModel(
      chapterId: fields[7] as int?,
      succeeded: fields[1] as int,
      failed: fields[2] as int,
      chapterIndex: fields[0] as int,
      total: fields[3] as int,
      isDownload: fields[4] as bool,
      taskIds: (fields[5] as List).cast<dynamic>(),
      isStartDownload: fields[6] as bool,
      mangaSource: fields[9] as String?,
      chapterName: fields[10] as String?,
      mangaName: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.chapterIndex)
      ..writeByte(1)
      ..write(obj.succeeded)
      ..writeByte(2)
      ..write(obj.failed)
      ..writeByte(3)
      ..write(obj.total)
      ..writeByte(4)
      ..write(obj.isDownload)
      ..writeByte(5)
      ..write(obj.taskIds)
      ..writeByte(6)
      ..write(obj.isStartDownload)
      ..writeByte(7)
      ..write(obj.chapterId)
      ..writeByte(9)
      ..write(obj.mangaSource)
      ..writeByte(10)
      ..write(obj.chapterName)
      ..writeByte(11)
      ..write(obj.mangaName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
