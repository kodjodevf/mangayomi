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
      modelManga: fields[0] as ModelManga,
      succeeded: fields[2] as int,
      failed: fields[3] as int,
      index: fields[1] as int,
      total: fields[4] as int,
      isDownload: fields[6] as bool,
      taskIds: (fields[7] as List).cast<dynamic>(),
      isStartDownload: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.modelManga)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.succeeded)
      ..writeByte(3)
      ..write(obj.failed)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(6)
      ..write(obj.isDownload)
      ..writeByte(7)
      ..write(obj.taskIds)
      ..writeByte(8)
      ..write(obj.isStartDownload);
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
