import 'package:isar/isar.dart';
import 'package:mangayomi/models/chapter.dart';

part 'download.g.dart';

@collection
@Name("Download")
class Download {
  Id? id;

  int? succeeded;

  int? failed;

  int? total;

  bool? isDownload;

  bool? isStartDownload;

  final chapter = IsarLink<Chapter>();

  Download({
    this.id = 0,
    required this.succeeded,
    required this.failed,
    required this.total,
    required this.isDownload,
    required this.isStartDownload,
  });
  Download.fromJson(Map<String, dynamic> json) {
    failed = json['failed'];
    id = json['id'];
    isDownload = json['isDownload'];
    isStartDownload = json['isStartDownload'];
    succeeded = json['succeeded'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() => {
        'failed': failed,
        'id': id,
        'isDownload': isDownload,
        'isStartDownload': isStartDownload,
        'succeeded': succeeded,
        'total': total
      };
}
