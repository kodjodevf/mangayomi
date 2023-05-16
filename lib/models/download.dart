import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';

part 'download.g.dart';

@collection
@Name("Download")
class Download {
  Id? id;

  int? chapterId;

  int? succeeded;

  int? failed;

  int? total;

  bool? isDownload;

  List<String>? taskIds;

  bool? isStartDownload;

  final chapter = IsarLink<Chapter>();

  Download({
    this.id = Isar.autoIncrement,
    required this.chapterId,
    required this.succeeded,
    required this.failed,
    required this.total,
    required this.isDownload,
    required this.taskIds,
    required this.isStartDownload,
  });
}
