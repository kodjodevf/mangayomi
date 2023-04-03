// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_manga.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelMangaAdapter extends TypeAdapter<ModelManga> {
  @override
  final int typeId = 0;

  @override
  ModelManga read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelManga(
      chapterDate: (fields[10] as List?)?.cast<String>(),
      source: fields[11] as String?,
      chapterTitle: (fields[8] as List?)?.cast<String>(),
      chapterUrl: (fields[9] as List?)?.cast<String>(),
      author: fields[4] as String?,
      favorite: fields[7] as bool,
      genre: (fields[6] as List?)?.cast<String>(),
      imageUrl: fields[2] as String?,
      lang: fields[12] as String?,
      link: fields[1] as String?,
      name: fields[0] as String?,
      status: fields[5] as String?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelManga obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.link)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.author)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.genre)
      ..writeByte(7)
      ..write(obj.favorite)
      ..writeByte(8)
      ..write(obj.chapterTitle)
      ..writeByte(9)
      ..write(obj.chapterUrl)
      ..writeByte(10)
      ..write(obj.chapterDate)
      ..writeByte(11)
      ..write(obj.source)
      ..writeByte(12)
      ..write(obj.lang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelMangaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
