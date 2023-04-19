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
      source: fields[8] as String?,
      author: fields[4] as String?,
      favorite: fields[7] as bool,
      genre: (fields[6] as List?)?.cast<String>(),
      imageUrl: fields[2] as String?,
      lang: fields[9] as String?,
      link: fields[1] as String?,
      name: fields[0] as String?,
      status: fields[5] as String?,
      description: fields[3] as String?,
      dateAdded: fields[10] as int?,
      lastUpdate: fields[11] as int?,
      category: fields[14] as int?,
      lastRead: fields[13] as String?,
      chapters: (fields[12] as List?)?.cast<ModelChapters>(),
    );
  }

  @override
  void write(BinaryWriter writer, ModelManga obj) {
    writer
      ..writeByte(15)
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
      ..write(obj.source)
      ..writeByte(9)
      ..write(obj.lang)
      ..writeByte(10)
      ..write(obj.dateAdded)
      ..writeByte(11)
      ..write(obj.lastUpdate)
      ..writeByte(12)
      ..write(obj.chapters)
      ..writeByte(13)
      ..write(obj.lastRead)
      ..writeByte(14)
      ..write(obj.category);
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

class ModelChaptersAdapter extends TypeAdapter<ModelChapters> {
  @override
  final int typeId = 7;

  @override
  ModelChapters read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelChapters(
      name: fields[0] as String?,
      url: fields[1] as String?,
      dateUpload: fields[2] as String?,
      isBookmarked: fields[4] as bool,
      scanlator: fields[3] as String?,
      isRead: fields[5] as bool,
      lastPageRead: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelChapters obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.dateUpload)
      ..writeByte(3)
      ..write(obj.scanlator)
      ..writeByte(4)
      ..write(obj.isBookmarked)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.lastPageRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelChaptersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
