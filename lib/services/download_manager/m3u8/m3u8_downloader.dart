import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/ts_info.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:mangayomi/utils/log/logger.dart';
import 'package:path/path.dart' as path;
import 'package:convert/convert.dart';

class M3u8Downloader {
  final String m3u8Url;
  final String downloadDir;
  final Map<String, String>? headers;
  final String fileName;
  final int concurrentDownloads;
  final Chapter chapter;
  final List<Track>? subtitles;

  static var httpClient = MClient.httpClient(
    settings: const ClientSettings(
      throwOnStatusCode: false,
      tlsSettings: TlsSettings(verifyCertificates: false),
    ),
  );

  M3u8Downloader({
    required this.m3u8Url,
    required this.downloadDir,
    required this.fileName,
    this.headers,
    required this.chapter,
    this.concurrentDownloads = 1,
    required this.subtitles,
  });

  void _log(String message) {
    if (kDebugMode) {
      log('[M3u8Downloader] $message');
    }
    AppLogger.log(message);
  }

  void close() {
    DownloadIsolatePool.instance.cancelTask('m3u8_${chapter.id}');
    isolateChapsSendPorts.remove('${chapter.id}');
  }

  Future<T> _withRetry<T>(Future<T> Function() operation) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= 3) {
          throw M3u8DownloaderException('Operation failed after 3 attempts', e);
        }
      }
    }
  }

  Future<(List<TsInfo>, Uint8List?, Uint8List?, int?)> _getTsList() async {
    try {
      final uri = Uri.parse(m3u8Url);
      final m3u8Host = "${uri.scheme}://${uri.host}${path.dirname(uri.path)}";
      final m3u8Body = await _withRetry(() => _getM3u8Body(m3u8Url));
      final tsList = _parseTsList(m3u8Host, m3u8Body);
      final mediaSequence = _extractMediaSequence(m3u8Body);

      _log("Total TS files to download: ${tsList.length}");

      final (key, iv) = await _getM3u8KeyAndIv(m3u8Body);
      if (key != null) _log("TS Key found");
      if (iv != null) _log("TS IV found");
      if (mediaSequence != null) _log("Media sequence: $mediaSequence");

      return (tsList, key, iv, mediaSequence);
    } catch (e) {
      throw M3u8DownloaderException('Failed to get TS list', e);
    }
  }

  Future<void> download(void Function(DownloadProgress) onProgress) async {
    final tempDir = path.join(downloadDir, 'temp');
    await StorageProvider().createDirectorySafely(tempDir);

    try {
      final (tsList, key, iv, mediaSequence) = await _getTsList();

      final tsListToDownload = await _filterExistingSegments(tsList, tempDir);
      _log('Downloading ${tsListToDownload.length} segments...');

      await _downloadSegmentsWithProgress(
        tsListToDownload,
        tempDir,
        key,
        iv,
        mediaSequence,
        onProgress,
      );
      for (var element in subtitles ?? <Track>[]) {
        final subtitleFile = File(
          path.join('${downloadDir}_subtitles', '${element.label}.srt'),
        );
        if (subtitleFile.existsSync()) {
          _log('Subtitle file already exists: ${element.label}');
          continue;
        }
        _log('Downloading subtitle file: ${element.label}');
        if (element.file == null || element.file!.trim().isEmpty) {
          _log('Warning: No subtitle file: ${element.label}');
          continue;
        }
        subtitleFile.createSync(recursive: true);
        if (element.file!.startsWith("http")) {
          final response = await _withRetry(
            () =>
                httpClient.get(Uri.parse(element.file ?? ''), headers: headers),
          );
          if (response.statusCode != 200) {
            _log('Warning: Failed to download subtitle file: ${element.label}');
            continue;
          }
          _log('Subtitle file downloaded: ${element.label}');
          await subtitleFile.writeAsBytes(response.bodyBytes);
        } else {
          _log('Subtitle file written: ${element.label}');
          await subtitleFile.writeAsString(element.file!);
        }
      }
    } catch (e) {
      AppLogger.log("Download failed", logLevel: LogLevel.error);
      AppLogger.log(e.toString(), logLevel: LogLevel.error);
      throw M3u8DownloaderException('Download failed', e);
    } finally {
      close();
    }
  }

  Future<List<TsInfo>> _filterExistingSegments(
    List<TsInfo> tsList,
    String tempDir,
  ) async {
    return tsList
        .where((ts) => !File(path.join(tempDir, '${ts.name}.ts')).existsSync())
        .toList();
  }

  Future<void> _downloadSegmentsWithProgress(
    List<TsInfo> segments,
    String tempDir,
    Uint8List? key,
    Uint8List? iv,
    int? mediaSequence,
    void Function(DownloadProgress) onProgress,
  ) async {
    final completer = Completer<void>();
    final taskId = 'm3u8_${chapter.id}';

    // Mark as active for compatibility with cancelDownloads()
    isolateChapsSendPorts['${chapter.id}'] = true;

    await DownloadIsolatePool.instance.submitM3u8Download(
      taskId: taskId,
      segments: segments,
      tempDir: tempDir,
      key: key,
      iv: iv,
      mediaSequence: mediaSequence,
      concurrentDownloads: concurrentDownloads,
      headers: headers,
      itemType: chapter.manga.value!.itemType,
      onProgress: (progress) {
        onProgress(progress);
      },
      onComplete: () async {
        // Merge the segments after downloading
        await _mergeSegments(fileName, tempDir, onProgress);

        // Clean up the temporary directory
        if (await Directory(tempDir).exists()) {
          try {
            await Directory(tempDir).delete(recursive: true);
          } catch (e) {
            _log('Warning: Failed to clean up temporary directory: $e');
          }
        }

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

  Future<void> _mergeSegments(
    String outputFile,
    String tempDir,
    void Function(DownloadProgress) onProgress,
  ) async {
    _log('Merging segments...');
    try {
      await _mergeTsToMp4(outputFile, tempDir);
      onProgress.call(
        DownloadProgress(
          1,
          1,
          chapter.manga.value!.itemType,
          isCompleted: true,
        ),
      );
      _log('Merge completed successfully');
    } catch (e) {
      throw M3u8DownloaderException('Failed to merge segments', e);
    }
  }

  Future<void> _mergeTsToMp4(String fileName, String directory) async {
    try {
      final dir = Directory(directory);
      final files = await dir
          .list()
          .where((entity) => entity.path.endsWith('.ts'))
          .toList();

      files.sort((a, b) {
        final aIndex = int.parse(
          a.path.substringAfter("TS_").substringBefore("."),
        );
        final bIndex = int.parse(
          b.path.substringAfter("TS_").substringBefore("."),
        );
        return aIndex.compareTo(bIndex);
      });

      final outFile = File(fileName).openWrite();
      for (var file in files) {
        final inFile = File(file.path).openRead();
        await outFile.addStream(inFile);
      }
      await outFile.close();
    } catch (e) {
      throw M3u8DownloaderException('Failed to merge TS files', e);
    }
  }

  Future<String> _getM3u8Body(String url) async {
    final response = await httpClient.get(Uri.parse(url), headers: headers);
    if (response.statusCode != 200) {
      throw M3u8DownloaderException('Failed to load m3u8 body');
    }
    return response.body;
  }

  List<TsInfo> _parseTsList(String host, String body) {
    final lines = body.split('\n');
    final tsList = <TsInfo>[];
    var index = 0;

    for (final line in lines) {
      if (line.isEmpty || line.startsWith('#')) continue;
      index++;
      final tsUrl = line.startsWith('http')
          ? line
          : '$host${line.replaceFirst("/", "")}';
      tsList.add(TsInfo('TS_$index', tsUrl));
    }
    return tsList;
  }

  Future<(Uint8List?, Uint8List?)> _getM3u8KeyAndIv(String m3u8Body) async {
    try {
      final uri = Uri.parse(m3u8Url);
      final m3u8Host = '${uri.scheme}://${uri.host}${path.dirname(uri.path)}';

      for (final line in m3u8Body.split('\n')) {
        if (!line.contains('#EXT-X-KEY')) continue;

        final (keyUrl, iv) = _extractKeyAttributes(line, m3u8Host);
        if (keyUrl == null) break;

        final response = await _withRetry(
          () => httpClient.get(Uri.parse(keyUrl), headers: headers),
        );
        if (response.statusCode == 200) {
          return (Uint8List.fromList(response.bodyBytes), iv);
        }
      }
      return (null, null);
    } catch (e) {
      throw M3u8DownloaderException('Failed to get m3u8 key and IV', e);
    }
  }

  (String?, Uint8List?) _extractKeyAttributes(String content, String host) {
    final keyPattern = RegExp(
      r'#EXT-X-KEY:METHOD=AES-128(?:,URI="([^"]+)")?(?:,IV=0x([A-F0-9]+))?',
      caseSensitive: false,
    );
    final match = keyPattern.firstMatch(content);
    if (match == null) return (null, null);

    String? uri = match.group(1);
    if (uri != null && !uri.contains('http')) {
      uri = '$host$uri';
    }

    final ivStr = match.group(2);
    final iv = ivStr != null
        ? Uint8List.fromList(hex.decode(ivStr.replaceFirst('0x', '')))
        : null;

    return (uri, iv);
  }

  int? _extractMediaSequence(String content) {
    for (final line in content.split('\n')) {
      if (!line.startsWith('#EXT-X-MEDIA-SEQUENCE')) continue;
      return int.tryParse(line.substringAfter(':').trim());
    }
    return null;
  }
}

class M3u8DownloaderException implements Exception {
  final String message;
  final dynamic originalError;

  M3u8DownloaderException(this.message, [this.originalError]);

  @override
  String toString() =>
      'M3u8DownloaderException: $message${originalError != null ? ' ($originalError)' : ''}';
}
