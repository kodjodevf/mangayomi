import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:path/path.dart' as path;

/// Map to allow cancellation of downloads
final isolateChapsSendPorts = <String?, dynamic>{};

class MDownloader {
  List<PageUrl> pageUrls;
  final int concurrentDownloads;
  final Chapter chapter;
  final List<Track>? subtitles;
  final String? subDownloadDir;

  static var httpClient = MClient.httpClient(
    settings: const ClientSettings(
      throwOnStatusCode: false,
      tlsSettings: TlsSettings(verifyCertificates: false),
    ),
  );

  MDownloader({
    required this.chapter,
    required this.pageUrls,
    required this.subtitles,
    required this.subDownloadDir,
    this.concurrentDownloads = 1,
  });

  void _log(String message) {
    if (kDebugMode) {
      log('[MDownloader] $message');
    }
  }

  /// Initialize the Isolate pool (call once at app startup)
  /// poolSize = 6 workers allows 6 chapters to download in parallel
  static Future<void> initializeIsolatePool({int poolSize = 6}) async {
    DownloadIsolatePool.configure(poolSize: poolSize);
    await DownloadIsolatePool.instance.initialize();
  }

  void close() {
    // Cancel the task in the pool
    DownloadIsolatePool.instance.cancelTask('${chapter.id}');
    isolateChapsSendPorts.remove('${chapter.id}');
  }

  static Future<T> _withRetryStatic<T>(
    Future<T> Function() operation,
    int maxRetries,
  ) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= maxRetries) {
          throw MDownloaderException(
            'Operation failed after $maxRetries attempts',
            e,
          );
        }
      }
    }
  }

  Future<void> download(void Function(DownloadProgress) onProgress) async {
    try {
      await _downloadFilesWithProgress(pageUrls, onProgress);

      // Download subtitles (on the main isolate, no need for pool)
      for (var element in subtitles ?? <Track>[]) {
        final subtitleFile = File(
          path.join('${subDownloadDir}_subtitles', '${element.label}.srt'),
        );
        if (subtitleFile.existsSync()) {
          _log('Subtitle file already exists: ${element.label}');
          continue;
        }
        _log('Downloading subtitle file: ${element.label}');
        subtitleFile.createSync(recursive: true);
        final response = await _withRetryStatic(
          () => httpClient.get(Uri.parse(element.file ?? '')),
          3,
        );
        if (response.statusCode != 200) {
          _log('Warning: Failed to download subtitle file: ${element.label}');
          continue;
        }
        _log('Subtitle file downloaded: ${element.label}');
        await subtitleFile.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      throw MDownloaderException('Download failed', e);
    } finally {
      close();
    }
  }

  Future<void> _downloadFilesWithProgress(
    List<PageUrl> pageUrls,
    void Function(DownloadProgress) onProgress,
  ) async {
    final completer = Completer<void>();
    final taskId = '${chapter.id}';

    // Mark as active for compatibility with cancelDownloads()
    isolateChapsSendPorts[taskId] = true;

    await DownloadIsolatePool.instance.submitFileDownload(
      taskId: taskId,
      pageUrls: pageUrls,
      concurrentDownloads: concurrentDownloads,
      itemType: chapter.manga.value!.itemType,
      onProgress: (progress) {
        onProgress(progress);
      },
      onComplete: () {
        onProgress(
          DownloadProgress(
            1,
            1,
            chapter.manga.value!.itemType,
            isCompleted: true,
          ),
        );
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    return completer.future;
  }
}

class MDownloaderException implements Exception {
  final String message;
  final dynamic originalError;

  MDownloaderException(this.message, [this.originalError]);

  @override
  String toString() =>
      'MDownloaderException: $message${originalError != null ? ' ($originalError)' : ''}';
}
