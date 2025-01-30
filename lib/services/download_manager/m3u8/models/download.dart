import 'dart:isolate';
import 'dart:typed_data';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/ts_info.dart';

class DownloadParams {
  final List<TsInfo>? segments;
  final String? tempDir;
  final Uint8List? key;
  final Uint8List? iv;
  final int? mediaSequence;
  final int? concurrentDownloads;
  final Map<String, String>? headers;
  final SendPort? sendPort;
  final List<PageUrl>? pageUrls;
  final ItemType? itemType;

  DownloadParams({
    this.segments,
    this.tempDir,
    this.key,
    this.iv,
    this.mediaSequence,
    this.concurrentDownloads,
    this.headers,
    this.sendPort,
    this.pageUrls,
    this.itemType,
  });

  @override
  String toString() {
    return 'DownloadParams(segments: ${segments?.length}, tempDir: $tempDir, mediaSequence: $mediaSequence, concurrentDownloads: $concurrentDownloads, pageUrls: ${pageUrls?.length})';
  }
}

class DownloadComplete {}

class DownloadProgress {
  TsInfo? segment;
  PageUrl? pageUrl;
  final int completed;
  final int total;
  bool isCompleted;
  ItemType itemType;

  DownloadProgress(this.completed, this.total, this.itemType,
      {this.segment, this.pageUrl, this.isCompleted = false});

  @override
  String toString() {
    return 'DownloadProgress(segment: $segment, pageUrl: $pageUrl completed: $completed, total: $total, isCompleted: $isCompleted)';
  }
}
