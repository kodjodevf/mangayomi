import 'package:hive_flutter/hive_flutter.dart';

part 'download_model.g.dart';

@HiveType(typeId: 6)
class DownloadModel extends HiveObject {
  @HiveField(0)
  final int succeeded;
  @HiveField(1)
  final int failed;
  @HiveField(2)
  final int total;
  @HiveField(3)
  final bool isDownload;
  @HiveField(4)
  final List taskIds;
  @HiveField(5)
  final bool isStartDownload;
  @HiveField(6)
  final int? chapterId;
  @HiveField(7)
  final String? mangaSource;
  @HiveField(8)
  final String? chapterName;
  @HiveField(9)
  final String? mangaName;
  @HiveField(10)
  final int? mangaId;
  DownloadModel(
      {required this.chapterId,
      required this.succeeded,
      required this.failed,
      required this.total,
      required this.isDownload,
      required this.taskIds,
      required this.isStartDownload,
      required this.mangaSource,
      required this.chapterName,
      required this.mangaName,
      required this.mangaId});
}
