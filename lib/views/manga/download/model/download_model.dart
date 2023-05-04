import 'package:hive_flutter/hive_flutter.dart';

part 'download_model.g.dart';

@HiveType(typeId: 6)
class DownloadModel extends HiveObject {
  @HiveField(0)
  final int chapterIndex;
  @HiveField(1)
  final int succeeded;
  @HiveField(2)
  final int failed;
  @HiveField(3)
  final int total;
  @HiveField(4)
  final bool isDownload;
  @HiveField(5)
  final List taskIds;
  @HiveField(6)
  final bool isStartDownload;
  @HiveField(7)
  final int? chapterId;
  @HiveField(9)
  final String? mangaSource;
  @HiveField(10)
  final String? chapterName;
  @HiveField(11)
  final String? mangaName;
  DownloadModel({
    required this.chapterId,
    required this.succeeded,
    required this.failed,
    required this.chapterIndex,
    required this.total,
    required this.isDownload,
    required this.taskIds,
    required this.isStartDownload,
    required this.mangaSource,
    required this.chapterName,
    required this.mangaName,
  });
}
