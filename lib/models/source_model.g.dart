// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SourceModelAdapter extends TypeAdapter<SourceModel> {
  @override
  final int typeId = 3;

  @override
  SourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SourceModel(
      sourceName: fields[0] as String,
      baseUrl: fields[1] as String,
      lang: fields[2] as String,
      typeSource: fields[6] as TypeSource,
      logoUrl: fields[7] as String,
      dateFormat: fields[10] as String,
      dateFormatLocale: fields[11] as String,
      isActive: fields[3] == null ? true : fields[3] as bool,
      isAdded: fields[4] == null ? false : fields[4] as bool,
      isNsfw: fields[5] == null ? false : fields[5] as bool,
      isFullData: fields[8] == null ? false : fields[8] as bool,
      isCloudflare: fields[9] == null ? false : fields[9] as bool,
      apiUrl: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SourceModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.sourceName)
      ..writeByte(1)
      ..write(obj.baseUrl)
      ..writeByte(2)
      ..write(obj.lang)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.isAdded)
      ..writeByte(5)
      ..write(obj.isNsfw)
      ..writeByte(6)
      ..write(obj.typeSource)
      ..writeByte(7)
      ..write(obj.logoUrl)
      ..writeByte(8)
      ..write(obj.isFullData)
      ..writeByte(9)
      ..write(obj.isCloudflare)
      ..writeByte(10)
      ..write(obj.dateFormat)
      ..writeByte(11)
      ..write(obj.dateFormatLocale)
      ..writeByte(12)
      ..write(obj.apiUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TypeSourceAdapter extends TypeAdapter<TypeSource> {
  @override
  final int typeId = 4;

  @override
  TypeSource read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return TypeSource.single;
      case 2:
        return TypeSource.mangathemesia;
      case 3:
        return TypeSource.comick;
      case 4:
        return TypeSource.mmrcms;
      case 5:
        return TypeSource.heancms;
      default:
        return TypeSource.single;
    }
  }

  @override
  void write(BinaryWriter writer, TypeSource obj) {
    switch (obj) {
      case TypeSource.single:
        writer.writeByte(1);
        break;
      case TypeSource.mangathemesia:
        writer.writeByte(2);
        break;
      case TypeSource.comick:
        writer.writeByte(3);
        break;
      case TypeSource.mmrcms:
        writer.writeByte(4);
        break;
      case TypeSource.heancms:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
