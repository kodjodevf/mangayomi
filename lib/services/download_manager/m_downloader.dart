import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/services/download_manager/m3u8/m3u8_downloader.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';

class MDownloader {
  List<PageUrl> pageUrls;
  final int concurrentDownloads;
  final Chapter chapter;
  Isolate? _isolate;
  ReceivePort? _receivePort;
  static var httpClient = MClient.httpClient(
      settings: const ClientSettings(
          throwOnStatusCode: false,
          tlsSettings: TlsSettings(verifyCertificates: false)));
  MDownloader({
    required this.chapter,
    required this.pageUrls,
    this.concurrentDownloads = 15,
  });

  void _log(String message) {
    if (kDebugMode) {
      log('[MDownloader] $message');
    }
  }

  void close() {
    _isolate?.kill();
    _receivePort?.close();
  }

  static _recreateClient() async {
    await RustLib.init();
    httpClient = MClient.httpClient(
        settings: const ClientSettings(
            throwOnStatusCode: false,
            tlsSettings: TlsSettings(verifyCertificates: false)));
  }

  static Future<T> _withRetryStatic<T>(
      Future<T> Function() operation, int maxRetries) async {
    int attempts = 0;
    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= maxRetries) {
          throw M3u8DownloaderException(
              'Operation failed after $maxRetries attempts', e);
        }
      }
    }
  }

  Future<void> download(void Function(DownloadProgress) onProgress) async {
    try {
      await _downloadFilesWithProgress(pageUrls, onProgress);
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
    _receivePort = ReceivePort();

    final errorPort = ReceivePort();
    _isolate = await Isolate.spawn(
      _downloadWorker,
      DownloadParams(
          pageUrls: pageUrls,
          sendPort: _receivePort!.sendPort,
          concurrentDownloads: concurrentDownloads,
          itemType: chapter.manga.value!.itemType),
      onError: errorPort.sendPort,
    );
    isolateChapsSendPorts['${chapter.id}'] = (_receivePort, _isolate);
    errorPort.listen((message) {
      final stackTrace = message.last;
      _log('Stack trace: $stackTrace');
      _receivePort!.close();
    });
    await for (final message in _receivePort!) {
      if (message is DownloadProgress) {
        onProgress.call(message);
      } else if (message is DownloadComplete) {
        onProgress.call(DownloadProgress(1, 1, chapter.manga.value!.itemType,
            isCompleted: true));
        errorPort.close();
        break;
      } else if (message is Exception) {
        errorPort.close();
        throw message;
      }
    }
  }

  static void _downloadWorker(DownloadParams params) async {
    await _recreateClient();
    int completed = 0;
    final total = params.pageUrls!.length;
    final queue = Queue<PageUrl>.from(params.pageUrls!);
    final List<Future<void>> activeTasks = [];

    try {
      while (queue.isNotEmpty || activeTasks.isNotEmpty) {
        while (queue.isNotEmpty &&
            activeTasks.length < params.concurrentDownloads!) {
          final pageUrl = queue.removeFirst();
          final task = _processFile(pageUrl, httpClient, params).then((_) {
            if (params.itemType! != ItemType.anime) {
              completed++;
              params.sendPort!.send(DownloadProgress(
                  pageUrl: pageUrl, completed, total, params.itemType!));
            }
          }).catchError((error) {
            params.sendPort!.send(
              MDownloaderException(
                  'Error downloading ${pageUrl.fileName}', error),
            );
            throw error;
          });

          activeTasks.add(task);
        }

        if (activeTasks.isNotEmpty) {
          await Future.wait(activeTasks.toList(), eagerError: true);
          activeTasks.clear();
        }
      }

      params.sendPort!.send(DownloadComplete());
    } catch (e) {
      params.sendPort!.send(MDownloaderException('Download failed', e));
    } finally {
      httpClient.close();
    }
  }

  static Future<void> _processFile(
      PageUrl pageUrl, Client client, DownloadParams params) async {
    try {
      if (params.itemType! != ItemType.anime) {
        final response = await _withRetryStatic(
            () => client.get(Uri.parse(pageUrl.url), headers: pageUrl.headers),
            3);
        if (response.statusCode != 200) {
          throw MDownloaderException(
              'Failed to download file: ${pageUrl.fileName!}');
        }

        final file = File(pageUrl.fileName!);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        final bytes = await _withRetryStatic(() async {
          List<int> bytes = [];
          var request = Request('GET', Uri.parse(pageUrl.url));
          request.headers.addAll(pageUrl.headers ?? {});
          StreamedResponse response = await client.send(request);
          if (response.statusCode != 200) {
            throw MDownloaderException(
                'Failed to download file: ${pageUrl.fileName!}');
          }
          int total = response.contentLength ?? 0;
          int recieved = 0;

          await for (var value in response.stream) {
            bytes.addAll(value);
            try {
              recieved += value.length;
              params.sendPort!.send(DownloadProgress(
                  (recieved / total * 100).toInt(),
                  100,
                  pageUrl: pageUrl,
                  params.itemType!));
            } catch (_) {}
          }
          return bytes;
        }, 3);

        final file = File(pageUrl.fileName!);
        await file.writeAsBytes(bytes);
      }
    } catch (e) {
      throw MDownloaderException(
          'Failed to process file: ${pageUrl.fileName!}', e);
    }
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
