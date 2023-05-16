import 'package:isar/isar.dart';
part 'reader_settings.g.dart';

@collection
@Name("Reader settings")
class ReaderSettings {
  Id? id;

  @enumerated
  ReaderMode defaultReaderMode = ReaderMode.vertical;

  ReaderSettings({this.id = 227, required this.defaultReaderMode});
}

@collection
@Name("Personal ReaderMode")
class PersonalReaderMode {
  Id? id;

  int? mangaId;

  @enumerated
  ReaderMode readerMode;

  PersonalReaderMode(
      {this.id = Isar.autoIncrement,
      required this.mangaId,
      required this.readerMode});
}

enum ReaderMode { vertical, ltr, rtl, verticalContinuous, webtoon }
