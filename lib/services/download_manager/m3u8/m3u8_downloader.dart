import 'dart:developer';
import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'dart:io';
import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/video.dart';
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
  final String? subDownloadDir;

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
    this.concurrentDownloads = 4,
    required this.subtitles,
    this.subDownloadDir,
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
        return await operation().timeout(const Duration(seconds: 30));
      } catch (e) {
        if (attempts >= 3) {
          throw M3u8DownloaderException('Operation failed after 3 attempts', e);
        }
      }
    }
  }

  Future<(List<TsInfo>, Uint8List?, Uint8List?, int?)> _getTsList() async {
    try {
      final (playlistUri, m3u8Body) = await _getMediaPlaylist();
      final tsList = _parseTsList(playlistUri, m3u8Body);
      final mediaSequence = _extractMediaSequence(m3u8Body);

      _log("Total TS files to download: ${tsList.length}");

      final (key, iv) = await _getM3u8KeyAndIv(m3u8Body, playlistUri);
      if (key != null) _log("TS Key found");
      if (iv != null) _log("TS IV found");
      if (mediaSequence != null) _log("Media sequence: $mediaSequence");

      return (tsList, key, iv, mediaSequence);
    } catch (e) {
      throw M3u8DownloaderException('Failed to get TS list', e);
    }
  }

  Future<void> download(void Function(DownloadProgress) onProgress) async {
    // Do not repeat the episode title: Windows directory enumeration can fail
    // on the resulting long path even when segment writes succeeded.
    final tempDir = path.join(
      path.dirname(fileName),
      m3u8TempDirectoryName('${chapter.id}:$m3u8Url'),
    );
    await Directory(tempDir).create(recursive: true);

    try {
      final (tsList, key, iv, mediaSequence) = await _getTsList();

      if (tsList.isEmpty) {
        throw M3u8DownloaderException('Playlist contains no media segments');
      }
      final tsListToDownload = await _filterExistingSegments(tsList, tempDir);
      _log('Downloading ${tsListToDownload.length} segments...');

      await _downloadSegmentsWithProgress(
        tsListToDownload,
        tsList.length,
        tempDir,
        key,
        iv,
        mediaSequence,
        onProgress,
      );
      for (var element in subtitles ?? <Track>[]) {
        final subtitlesBase = subDownloadDir ?? downloadDir;
        final subtitleFile = File(
          path.join('${subtitlesBase}_subtitles', '${element.label}.srt'),
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
    return tsList.where((ts) {
      final file = File(path.join(tempDir, '${ts.name}.ts'));
      return !file.existsSync() || file.lengthSync() == 0;
    }).toList();
  }

  Future<void> _downloadSegmentsWithProgress(
    List<TsInfo> segments,
    int totalSegments,
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
        onProgress(
          DownloadProgress(
            totalSegments - segments.length + progress.completed,
            totalSegments,
            progress.itemType,
            segment: progress.segment,
          ),
        );
      },
      onComplete: () async {
        try {
          // Merge the segments after downloading
          await _mergeSegments(fileName, tempDir, totalSegments, onProgress);

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
        } catch (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
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
    int totalSegments,
    void Function(DownloadProgress) onProgress,
  ) async {
    _log('Merging segments...');
    try {
      await _mergeTsToMp4(outputFile, tempDir, totalSegments);
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

  Future<void> _mergeTsToMp4(
    String fileName,
    String directory,
    int total,
  ) async {
    try {
      await Isolate.run(() => mergeM3u8Segments(fileName, directory, total));
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

  Future<(Uri, String)> _getMediaPlaylist() async {
    var playlistUri = Uri.parse(m3u8Url);
    var body = await _withRetry(() => _getM3u8Body(playlistUri.toString()));

    // A source may return a master playlist even when the selected video URL
    // looks like a media playlist. Follow the highest-bandwidth variant before
    // interpreting playlist entries as TS segments.
    for (var depth = 0; depth < 5; depth++) {
      final variantUrl = selectM3u8VariantUrl(playlistUri.toString(), body);
      if (variantUrl == null) return (playlistUri, body);
      playlistUri = Uri.parse(variantUrl);
      body = await _withRetry(() => _getM3u8Body(playlistUri.toString()));
    }
    throw M3u8DownloaderException('Too many nested m3u8 playlists');
  }

  List<TsInfo> _parseTsList(Uri playlistUri, String body) {
    final lines = body.split('\n');
    final tsList = <TsInfo>[];
    var index = 0;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      index++;
      final tsUrl = resolveM3u8Reference(playlistUri.toString(), line);
      tsList.add(TsInfo('TS_$index', tsUrl));
    }
    return tsList;
  }

  Future<(Uint8List?, Uint8List?)> _getM3u8KeyAndIv(
    String m3u8Body,
    Uri playlistUri,
  ) async {
    try {
      for (final line in m3u8Body.split('\n')) {
        if (!line.contains('#EXT-X-KEY')) continue;

        final (keyUrl, iv) = _extractKeyAttributes(line, playlistUri);
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

  (String?, Uint8List?) _extractKeyAttributes(String content, Uri playlistUri) {
    final keyPattern = RegExp(
      r'#EXT-X-KEY:METHOD=AES-128(?:,URI="([^"]+)")?(?:,IV=0x([A-F0-9]+))?',
      caseSensitive: false,
    );
    final match = keyPattern.firstMatch(content);
    if (match == null) return (null, null);

    String? uri = match.group(1);
    if (uri != null) {
      uri = resolveM3u8Reference(playlistUri.toString(), uri);
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

/// Resolves a playlist reference using URI semantics rather than string
/// concatenation. Mihon's video proxy routes child URLs through `/video/`; keep
/// that route rooted whether a manifest includes its leading slash or not.
String resolveM3u8Reference(String playlistUrl, String reference) {
  final base = Uri.parse(playlistUrl);
  final value = reference.trim();
  if (value.isEmpty) return base.toString();

  final parsed = Uri.parse(value);
  if (parsed.hasScheme) return parsed.toString();
  if (parsed.host.isNotEmpty) return base.resolve(value).toString();

  if (base.pathSegments.isNotEmpty &&
      base.pathSegments.first == 'video' &&
      parsed.pathSegments.isNotEmpty &&
      parsed.pathSegments.first == 'video') {
    return base
        .replace(
          path: parsed.path.startsWith('/') ? parsed.path : '/${parsed.path}',
          query: parsed.hasQuery ? parsed.query : null,
          fragment: parsed.hasFragment ? parsed.fragment : null,
        )
        .toString();
  }
  return base.resolve(value).toString();
}

/// Returns the highest-bandwidth variant URL when [body] is a master playlist.
/// A media playlist returns null so callers can parse its segment entries.
String? selectM3u8VariantUrl(String playlistUrl, String body) {
  final lines = body.split('\n');
  String? bestUrl;
  var bestBandwidth = -1;
  int? pendingBandwidth;

  for (final rawLine in lines) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    if (line.toUpperCase().startsWith('#EXT-X-STREAM-INF:')) {
      final bandwidth = RegExp(
        r'(?:^|,)BANDWIDTH=(\d+)',
        caseSensitive: false,
      ).firstMatch(line)?.group(1);
      pendingBandwidth = int.tryParse(bandwidth ?? '') ?? 0;
      continue;
    }
    if (pendingBandwidth == null || line.startsWith('#')) continue;

    final resolved = resolveM3u8Reference(playlistUrl, line);
    if (bestUrl == null || pendingBandwidth >= bestBandwidth) {
      bestUrl = resolved;
      bestBandwidth = pendingBandwidth;
    }
    pendingBandwidth = null;
  }
  return bestUrl;
}

class M3u8DownloaderException implements Exception {
  final String message;
  final dynamic originalError;

  M3u8DownloaderException(this.message, [this.originalError]);

  @override
  String toString() =>
      'M3u8DownloaderException: $message${originalError != null ? ' ($originalError)' : ''}';
}

/// Short, source-specific name prevents long Windows paths and mixing variants.
String m3u8TempDirectoryName(String url) =>
    '.tmp_hls_${sha256.convert(utf8.encode(url)).toString().substring(0, 16)}';

Future<void> mergeM3u8Segments(
  String output,
  String directory,
  int total,
) async {
  if (total <= 0) throw StateError('No segments to merge');
  final partial = File('$output.part');
  final sink = partial.openWrite();
  try {
    try {
      for (var index = 1; index <= total; index++) {
        final file = File(path.join(directory, 'TS_$index.ts'));
        if (!await file.exists() || await file.length() == 0) {
          throw StateError('Missing or empty segment $index');
        }
        await sink.addStream(file.openRead());
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
    await partial.rename(output);
  } catch (_) {
    if (await partial.exists()) await partial.delete();
    rethrow;
  }
}
