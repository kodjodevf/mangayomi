import 'package:hive/hive.dart';
import 'package:mangayomi/models/model_manga.dart';
part 'download_model.g.dart';

@HiveType(typeId: 6)
class DownloadModel {
  @HiveField(0)
  final ModelManga modelManga;
  @HiveField(1)
  final int index;
  @HiveField(2)
  final int succeeded;
  @HiveField(3)
  final int failed;
  @HiveField(4)
  final int total;
  @HiveField(6)
  final bool isDownload;
  @HiveField(7)
  final List taskIds;
  @HiveField(8)
  final bool isStartDownload;
  DownloadModel(
      {required this.modelManga,
      required this.succeeded,
      required this.failed,
      required this.index,
      required this.total,
      required this.isDownload,
      required this.taskIds,
      required this.isStartDownload});
}
