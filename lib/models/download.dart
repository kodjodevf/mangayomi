import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';

part 'download.g.dart';

@collection
@Name("Download")
class Download {
  Id? id;

  int? chapterId;

  int? mangaId;

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
    required this.mangaId,
    required this.succeeded,
    required this.failed,
    required this.total,
    required this.isDownload,
    required this.taskIds,
    required this.isStartDownload,
  });
  Download.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    failed = json['failed'];
    id = json['id'];
    isDownload = json['isDownload'];
    isStartDownload = json['isStartDownload'];
    mangaId = json['mangaId'];
    succeeded = json['succeeded'];
    taskIds = json['taskIds'].cast<String>();
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chapterId'] = chapterId;
    data['failed'] = failed;
    data['id'] = id;
    data['isDownload'] = isDownload;
    data['isStartDownload'] = isStartDownload;
    data['mangaId'] = mangaId;
    data['succeeded'] = succeeded;
    data['taskIds'] = taskIds;
    data['total'] = total;
    return data;
  }
}
