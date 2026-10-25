import 'package:isar_community/isar.dart';
import 'package:mangayomi/models/manga.dart';
part 'reading_log.g.dart';

enum ReadingLogKind { time, completion }

/// One reading event, kept for the Statistics recap. A [ReadingLogKind.time]
/// row is a stretch of reading on one chapter ([seconds] long); a
/// [ReadingLogKind.completion] row is reaching the end of a chapter, re-reads
/// included. History keeps one row per series, so it can't answer "how much
/// did I read in October"; this can.
@collection
@Name("ReadingLog")
class ReadingLog {
  Id? id;

  @Index()
  int? mangaId;

  int? chapterId;

  @Index()
  @enumerated
  late ItemType itemType;

  /// UTC epoch milliseconds.
  @Index()
  late int at;

  @enumerated
  late ReadingLogKind kind;

  int seconds = 0;

  ReadingLog({
    this.id = Isar.autoIncrement,
    required this.mangaId,
    this.chapterId,
    required this.itemType,
    required this.at,
    required this.kind,
    this.seconds = 0,
  });

  ReadingLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mangaId = json['mangaId'];
    chapterId = json['chapterId'];
    itemType = ItemType.values[json['itemType'] ?? 0];
    at = json['at'] ?? 0;
    kind = ReadingLogKind.values[json['kind'] ?? 0];
    seconds = json['seconds'] ?? 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'mangaId': mangaId,
    'chapterId': chapterId,
    'itemType': itemType.index,
    'at': at,
    'kind': kind.index,
    'seconds': seconds,
  };
}
