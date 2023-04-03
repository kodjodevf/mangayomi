// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MangaHistoryModelAdapter extends TypeAdapter<MangaHistoryModel> {
  @override
  final int typeId = 2;

  @override
  MangaHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MangaHistoryModel(
      date: fields[1] as String,
      modelManga: fields[0] as ModelManga,
    );
  }

  @override
  void write(BinaryWriter writer, MangaHistoryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.modelManga)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MangaHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
