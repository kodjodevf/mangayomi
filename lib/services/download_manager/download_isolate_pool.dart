import 'dart:collection';
import 'dart:isolate';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/services/http/m_client.dart';
import 'package:mangayomi/services/http/rhttp/src/model/settings.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/download.dart';
import 'package:mangayomi/services/download_manager/m3u8/models/ts_info.dart';
import 'package:mangayomi/src/rust/frb_generated.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:encrypt/encrypt.dart' as encrypt;

final downloadTaskCancellation = <String, bool>{};

/// Shared Isolate pool to optimize performance
/// Instead of creating a new Isolate for each download,
/// we use a limited pool of workers that process tasks in queue.
class DownloadIsolatePool {
  static DownloadIsolatePool? _instance;
  final List<_PoolWorker> _workers = [];
  final Queue<_DownloadTask> _taskQueue = Queue();
  final Set<int> _availableWorkers = {}; // Track available workers by index
  final int poolSize;
  bool _initialized = false;
  Future<void>? _initializing;
  final Map<String, _PoolWorker> _runningTasks = {};
  void Function(SendPort)? _testWorkerEntryPoint;

  @visibleForTesting
  DownloadIsolatePool.forTesting({
    this.poolSize = 1,
    required void Function(SendPort) workerEntryPoint,
  }) : _testWorkerEntryPoint = workerEntryPoint;

  DownloadIsolatePool._({this.poolSize = 3});

  /// Get the singleton instance of the pool
  static DownloadIsolatePool get instance {
    _instance ??= DownloadIsolatePool._();
    return _instance!;
  }

  /// Configure the pool size (call before initialize)
  static void configure({int poolSize = 3}) {
    if (_instance != null && _instance!._initialized) {
      if (kDebugMode) {
        print('[DownloadPool] Cannot reconfigure after initialization');
      }
      return;
    }
    _instance = DownloadIsolatePool._(poolSize: poolSize);
  }

  /// Initialize the Isolate pool
  Future<void> initialize() =>
      _initializing ??= _initialize().catchError((Object error) {
        for (final worker in _workers) {
          worker.dispose();
        }
        _workers.clear();
        _availableWorkers.clear();
        _initializing = null;
        throw error;
      });

  Future<void> _initialize() async {
    if (_initialized) return;

    if (kDebugMode) {
      print('[DownloadPool] Initializing with $poolSize workers...');
    }

    for (int i = 0; i < poolSize; i++) {
      final worker = await _PoolWorker.create(
        i,
        entryPoint: _testWorkerEntryPoint,
      );
      _workers.add(worker);
      _availableWorkers.add(i); // All workers start as available
    }

    _initialized = true;
    if (kDebugMode) {
      print('[DownloadPool] Pool initialized with $poolSize workers');
    }
  }

  /// Submit a file download task (manga/anime)
  Future<bool> _prepareSubmission(
    String taskId,
    void Function(Exception) onError,
  ) async {
    downloadTaskCancellation[taskId] = false;
    try {
      if (!_initialized) await initialize();
    } catch (_) {
      downloadTaskCancellation.remove(taskId);
      rethrow;
    }
    if (downloadTaskCancellation[taskId] == true) {
      downloadTaskCancellation.remove(taskId);
      onError(Exception('Download cancelled'));
      return false;
    }
    return true;
  }

  Future<void> submitFileDownload({
    required String taskId,
    required List<PageUrl> pageUrls,
    required int concurrentDownloads,
    required ItemType itemType,
    required void Function(DownloadProgress) onProgress,
    required void Function() onComplete,
    required void Function(Exception) onError,
  }) async {
    if (!await _prepareSubmission(taskId, onError)) return;

    final receivePort = ReceivePort();
    final task = _DownloadTask(
      taskId: taskId,
      type: _TaskType.fileDownload,
      params: FileDownloadParams(
        pageUrls: pageUrls,
        concurrentDownloads: concurrentDownloads,
        itemType: itemType,
      ),
      sendPort: receivePort.sendPort,
    );

    // Listen for progress messages
    _listenToTask(receivePort, taskId, onProgress, onComplete, onError);
    _enqueueTask(task);
  }

  void _listenToTask(
    ReceivePort receivePort,
    String taskId,
    void Function(DownloadProgress) onProgress,
    void Function() onComplete,
    void Function(Exception) onError,
  ) {
    receivePort.listen((message) {
      if (message is DownloadProgress) {
        onProgress(message);
      } else if (message is DownloadComplete || message is Exception) {
        downloadTaskCancellation.remove(taskId);
        receivePort.close();
        if (message is DownloadComplete) onComplete();
        if (message is Exception) onError(message);
      }
    });
  }

  /// Submit an M3U8 segment download task
  Future<void> submitM3u8Download({
    required String taskId,
    required List<TsInfo> segments,
    required String tempDir,
    required Uint8List? key,
    required Uint8List? iv,
    required int? mediaSequence,
    required int concurrentDownloads,
    required Map<String, String>? headers,
    required ItemType itemType,
    required void Function(DownloadProgress) onProgress,
    required void Function() onComplete,
    required void Function(Exception) onError,
  }) async {
    if (!await _prepareSubmission(taskId, onError)) return;

    final receivePort = ReceivePort();
    final task = _DownloadTask(
      taskId: taskId,
      type: _TaskType.m3u8Download,
      params: M3u8DownloadParams(
        segments: segments,
        tempDir: tempDir,
        key: key,
        iv: iv,
        mediaSequence: mediaSequence,
        concurrentDownloads: concurrentDownloads,
        headers: headers,
        itemType: itemType,
      ),
      sendPort: receivePort.sendPort,
    );

    _listenToTask(receivePort, taskId, onProgress, onComplete, onError);

    _enqueueTask(task);
  }

  /// Cancel a download task
  void cancelTask(String taskId) {
    if (downloadTaskCancellation.containsKey(taskId)) {
      downloadTaskCancellation[taskId] = true;
    }
    final queued = _taskQueue.where((task) => task.taskId == taskId).toList();
    _taskQueue.removeWhere((task) => task.taskId == taskId);
    for (final task in queued) {
      task.sendPort.send(Exception('Download cancelled'));
    }
    _runningTasks[taskId]?.cancelCurrentTask();
  }

  /// Add a task to the queue and try to process it
  void _enqueueTask(_DownloadTask task) {
    _taskQueue.add(task);
    _processQueue();
  }

  /// Process the task queue
  void _processQueue() {
    while (_taskQueue.isNotEmpty && _availableWorkers.isNotEmpty) {
      final task = _taskQueue.removeFirst();
      final workerIndex = _availableWorkers.first;
      _availableWorkers.remove(workerIndex);
      final worker = _workers[workerIndex];

      if (kDebugMode) {
        print(
          '[DownloadPool] Worker $workerIndex starting task ${task.taskId}',
        );
      }

      _runningTasks[task.taskId] = worker;
      worker.executeTask(task).then((_) async {
        _runningTasks.remove(task.taskId);
        if (worker.terminated) {
          _workers[workerIndex] = await _PoolWorker.create(
            workerIndex,
            entryPoint: _testWorkerEntryPoint,
          );
        }
        _availableWorkers.add(workerIndex); // Worker is free again
        if (kDebugMode) {
          print(
            '[DownloadPool] Worker $workerIndex finished task ${task.taskId}, available workers: ${_availableWorkers.length}',
          );
        }
        _processQueue(); // Process the next task
      });
    }
  }

  /// Number of pending tasks
  int get pendingTasks => _taskQueue.length;

  /// Number of active workers
  int get activeWorkers => poolSize - _availableWorkers.length;

  /// Close the pool
  void dispose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    _workers.clear();
    _taskQueue.clear();
    _availableWorkers.clear();
    downloadTaskCancellation.clear();
    _initialized = false;
    _initializing = null;
    _runningTasks.clear();
  }
}

/// Supported task types
enum _TaskType { fileDownload, m3u8Download }

/// Download task
class _DownloadTask {
  final String taskId;
  final _TaskType type;
  final dynamic params;
  final SendPort sendPort;

  _DownloadTask({
    required this.taskId,
    required this.type,
    required this.params,
    required this.sendPort,
  });
}

/// Parameters for file download
class FileDownloadParams {
  final List<PageUrl> pageUrls;
  final int concurrentDownloads;
  final ItemType itemType;

  FileDownloadParams({
    required this.pageUrls,
    required this.concurrentDownloads,
    required this.itemType,
  });
}

/// Parameters for M3U8 download
class M3u8DownloadParams {
  final List<TsInfo> segments;
  final String tempDir;
  final Uint8List? key;
  final Uint8List? iv;
  final int? mediaSequence;
  final int concurrentDownloads;
  final Map<String, String>? headers;
  final ItemType itemType;

  M3u8DownloadParams({
    required this.segments,
    required this.tempDir,
    required this.key,
    required this.iv,
    required this.mediaSequence,
    required this.concurrentDownloads,
    required this.headers,
    required this.itemType,
  });
}

/// Pool worker that executes tasks in a persistent Isolate
class _PoolWorker {
  final int id;
  late Isolate _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  final Completer<void> _ready = Completer();
  void Function(Exception)? _cancelCurrent;
  bool terminated = false;

  void cancelCurrentTask() =>
      _cancelCurrent?.call(Exception('Download cancelled'));

  _PoolWorker._(this.id);

  static Future<_PoolWorker> create(
    int id, {
    void Function(SendPort)? entryPoint,
  }) async {
    final worker = _PoolWorker._(id);
    await worker._spawn(entryPoint);
    return worker;
  }

  Future<void> _spawn(void Function(SendPort)? entryPoint) async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      entryPoint ?? _workerEntryPoint,
      _receivePort.sendPort,
      onError: _receivePort.sendPort,
      onExit: _receivePort.sendPort,
    );

    // Wait for the worker to be ready and get its SendPort
    final completer = Completer<SendPort>();
    _receivePort.listen((message) {
      if (message is SendPort) {
        if (!completer.isCompleted) completer.complete(message);
      } else {
        final error = DownloadPoolException(
          'Download worker exited or failed to initialize',
          message,
        );
        if (!completer.isCompleted) {
          completer.completeError(error);
        } else {
          _cancelCurrent?.call(error);
        }
      }
    });

    try {
      _sendPort = await completer.future.timeout(const Duration(seconds: 30));
    } catch (_) {
      _isolate.kill(priority: Isolate.immediate);
      _receivePort.close();
      rethrow;
    }
    _ready.complete();
  }

  /// Execute a task in this worker
  Future<void> executeTask(_DownloadTask task) async {
    await _ready.future;

    final completer = Completer<void>();

    // Create a port to receive messages from this worker
    final taskPort = ReceivePort();
    _cancelCurrent = (error) {
      // Cancellation must stop disk writes and settle the waiting downloader,
      // otherwise its per-source gate remains held forever.
      _cancelCurrent = null;
      terminated = true;
      _isolate.kill(priority: Isolate.immediate);
      _receivePort.close();
      taskPort.close();
      task.sendPort.send(error);
      if (!completer.isCompleted) completer.complete();
    };

    taskPort.listen((message) {
      // Forward the message to the original task port
      task.sendPort.send(message);

      if (message is DownloadComplete || message is Exception) {
        _cancelCurrent = null;
        taskPort.close();
        completer.complete();
      }
    });

    // Send the task to the worker
    _sendPort.send(
      _WorkerTask(
        taskId: task.taskId,
        type: task.type,
        params: task.params,
        replyPort: taskPort.sendPort,
      ),
    );

    return completer.future;
  }

  void dispose() {
    _isolate.kill();
    _receivePort.close();
  }
}

/// Task sent to the worker
class _WorkerTask {
  final String taskId;
  final _TaskType type;
  final dynamic params;
  final SendPort replyPort;

  _WorkerTask({
    required this.taskId,
    required this.type,
    required this.params,
    required this.replyPort,
  });
}

/// Isolate worker entry point
void _workerEntryPoint(SendPort mainPort) async {
  // Initialize dependencies in the Isolate
  await RustLib.init();

  final httpClient = MClient.httpClient(
    settings: const ClientSettings(
      throwOnStatusCode: false,
      tlsSettings: TlsSettings(verifyCertificates: false),
    ),
  );

  // Create the receive port for this worker
  final receivePort = ReceivePort();

  // Send the SendPort to the main isolate
  mainPort.send(receivePort.sendPort);

  if (kDebugMode) {
    print('[Download worker] Ready');
  }

  // Listen for tasks
  await for (final message in receivePort) {
    if (message is _WorkerTask) {
      try {
        if (message.type == _TaskType.fileDownload) {
          await _processFileDownload(
            message.params as FileDownloadParams,
            message.replyPort,
            httpClient,
          );
        } else if (message.type == _TaskType.m3u8Download) {
          await processM3u8Download(
            message.params as M3u8DownloadParams,
            message.replyPort,
            httpClient,
          );
        }
      } catch (e) {
        message.replyPort.send(DownloadPoolException('Task failed', e));
      }
    }
  }
}

/// Process a file download
Future<void> _processFileDownload(
  FileDownloadParams params,
  SendPort replyPort,
  Client client,
) async {
  int completed = 0;
  final total = params.pageUrls.length;
  final queue = Queue<PageUrl>.from(params.pageUrls);
  final List<Future<void>> activeTasks = [];

  try {
    while (queue.isNotEmpty || activeTasks.isNotEmpty) {
      while (queue.isNotEmpty &&
          activeTasks.length < params.concurrentDownloads) {
        final pageUrl = queue.removeFirst();
        final task = _downloadFile(pageUrl, client, params.itemType, replyPort)
            .then((_) {
              if (params.itemType != ItemType.anime) {
                completed++;
                replyPort.send(
                  DownloadProgress(
                    pageUrl: pageUrl,
                    completed,
                    total,
                    params.itemType,
                  ),
                );
              }
            })
            .catchError((error) {
              replyPort.send(
                DownloadPoolException(
                  'Error downloading ${pageUrl.fileName}',
                  error,
                ),
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

    replyPort.send(DownloadComplete());
  } catch (e) {
    replyPort.send(DownloadPoolException('Download failed', e));
  }
}

/// Download an individual file
Future<void> _downloadFile(
  PageUrl pageUrl,
  Client client,
  ItemType itemType,
  SendPort replyPort,
) async {
  try {
    if (itemType != ItemType.anime) {
      final response = await _withRetry(
        () => client
            .get(Uri.parse(pageUrl.url), headers: pageUrl.headers)
            .timeout(const Duration(seconds: 30)),
        3,
      );
      if (response.statusCode != 200) {
        throw DownloadPoolException(
          'Failed to download file: ${pageUrl.fileName!}',
        );
      }

      final bytes = response.bodyBytes;
      final realExt = detectImageExtension(bytes);
      // fileName has no extension at this point (see download_provider.dart)
      // - the real one is only knowable now that the bytes are in hand.
      final targetFile = File(path.setExtension(pageUrl.fileName!, realExt));
      await targetFile.writeAsBytes(bytes);
    } else {
      // Streaming for videos (saves RAM)
      await _withRetry(() async {
        var request = Request('GET', Uri.parse(pageUrl.url));
        request.headers.addAll(pageUrl.headers ?? {});
        // Connection/response-headers timeout. Without it, a wifi drop after
        // streaming has begun makes the stream idle-timeout fire, retry, and
        // then hang forever on this send with no network — the download stalls
        // with no progress, no retry, and no error. Bail so _withRetry cycles
        // and, once exhausted, the failure propagates to the UI.
        StreamedResponse response = await client
            .send(request)
            .timeout(const Duration(seconds: 30));
        // Accept any 2xx — including 206 Partial Content, which the server
        // returns when the source extension sends `Range: bytes=0-` on the
        // streaming request (e.g. AnimeGG). Rejecting 206 here caused 3
        // retries → silent stall.
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw DownloadPoolException(
            'Failed to download file: ${pageUrl.fileName!} '
            '(status ${response.statusCode})',
          );
        }
        int total = response.contentLength ?? 0;
        int received = 0;
        // Throttle progress. Emitting on every chunk floods the main isolate
        // with synchronous DB writes (setProgress) and freezes the whole UI
        // while a download runs — worst with large single files (anime .mp4).
        // Send at most once per 1% step (known length) or every 250ms
        // (unknown length); the final 100% is delivered by onComplete.
        int lastPercent = -1;
        final progressWatch = Stopwatch()..start();

        final file = File(pageUrl.fileName!);
        final sink = file.openWrite();
        try {
          // Idle timeout: if no bytes arrive for 30s the connection has
          // stalled, so fail (and retry) instead of hanging the whole
          // download forever with no progress.
          await for (var value in response.stream.timeout(
            const Duration(seconds: 30),
            onTimeout: (sink) => sink.addError(
              TimeoutException('Download stalled (no data for 30s)'),
            ),
          )) {
            sink.add(value);
            received += value.length;
            final percent = total > 0 ? (received / total * 100).toInt() : -1;
            final shouldSend = percent >= 0
                ? percent != lastPercent
                : progressWatch.elapsedMilliseconds >= 250;
            if (shouldSend) {
              lastPercent = percent;
              if (percent < 0) progressWatch.reset();
              try {
                replyPort.send(
                  DownloadProgress(
                    percent < 0 ? 0 : percent,
                    100,
                    pageUrl: pageUrl,
                    itemType,
                  ),
                );
              } catch (_) {}
            }
          }
        } finally {
          await sink.flush();
          await sink.close();
        }
      }, 3);
    }
  } catch (e) {
    throw DownloadPoolException(
      'Failed to process file: ${pageUrl.fileName!}',
      e,
    );
  }
}

/// Process an M3U8 download
Future<void> processM3u8Download(
  M3u8DownloadParams params,
  SendPort replyPort,
  Client client,
) async {
  int completed = 0;
  final total = params.segments.length;
  final queue = Queue<TsInfo>.from(params.segments);
  Object? failure;
  Future<void> worker() async {
    while (queue.isNotEmpty && failure == null) {
      final segment = queue.removeFirst();
      try {
        await _downloadSegment(segment, params, client);
        completed++;
        replyPort.send(
          DownloadProgress(completed, total, params.itemType, segment: segment),
        );
      } catch (error) {
        failure ??= error;
      }
    }
  }

  // Refill each slot immediately; a slow segment must not hold up a batch.
  // Settle all writers before reporting failure or reusing this worker.
  await Future.wait(
    List.generate(params.concurrentDownloads.clamp(1, 8), (_) => worker()),
  );
  if (failure != null) {
    replyPort.send(DownloadPoolException('M3U8 download failed', failure));
  } else {
    replyPort.send(DownloadComplete());
  }
}

/// Download a TS segment
Future<void> _downloadSegment(
  TsInfo ts,
  M3u8DownloadParams params,
  Client client,
) async {
  final file = File(path.join(params.tempDir, '${ts.name}.ts'));
  final partial = File('${file.path}.part');
  try {
    await _withRetry(() async {
      try {
        final request = Request('GET', Uri.parse(ts.url));
        request.headers.addAll(params.headers ?? {});
        if (!request.headers.keys.any(
          (name) => name.toLowerCase() == HttpHeaders.rangeHeader,
        )) {
          request.headers[HttpHeaders.rangeHeader] = 'bytes=0-';
        }
        final response = await client
            .send(request)
            .timeout(const Duration(seconds: 30));
        if (response.statusCode != 200 && response.statusCode != 206) {
          await response.stream.listen((_) {}).cancel();
          throw DownloadPoolException(
            'Failed to download segment: ${ts.name} (status ${response.statusCode})',
          );
        }
        final sink = partial.openWrite();
        try {
          await sink.addStream(
            response.stream.timeout(const Duration(seconds: 30)),
          );
          await sink.flush();
        } finally {
          await sink.close();
        }
        final length = await partial.length();
        if (length == 0 ||
            (response.contentLength != null &&
                length != response.contentLength)) {
          throw DownloadPoolException('Incomplete segment: ${ts.name}');
        }
        if (params.key != null) {
          final bytes = await partial.readAsBytes();
          final index = int.parse(ts.name.substringAfter('TS_'));
          final decrypted = _aesDecrypt(
            (params.mediaSequence ?? 0) + index - 1,
            bytes,
            params.key!,
            iv: params.iv,
          );
          await partial.writeAsBytes(decrypted);
        }
        // Only complete, decrypted segments may be reused after a retry.
        await partial.rename(file.path);
      } catch (_) {
        if (await partial.exists()) await partial.delete();
        rethrow;
      }
    }, 3);
  } catch (e) {
    throw DownloadPoolException('Failed to process segment: ${ts.name}', e);
  }
}

/// AES decryption
Uint8List _aesDecrypt(
  int sequence,
  Uint8List encrypted,
  Uint8List key, {
  Uint8List? iv,
}) {
  try {
    if (iv == null) {
      iv = Uint8List(16);
      ByteData.view(iv.buffer).setUint64(8, sequence);
    }
    final encrypter = encrypt.Encrypter(
      encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.cbc),
    );
    return Uint8List.fromList(
      encrypter.decryptBytes(encrypt.Encrypted(encrypted), iv: encrypt.IV(iv)),
    );
  } catch (e) {
    throw DownloadPoolException('Decryption failed', e);
  }
}

/// Helper for retry
Future<T> _withRetry<T>(Future<T> Function() operation, int maxRetries) async {
  int attempts = 0;
  while (true) {
    try {
      attempts++;
      return await operation();
    } catch (e) {
      if (attempts >= maxRetries) {
        throw DownloadPoolException(
          'Operation failed after $maxRetries attempts',
          e,
        );
      }
    }
  }
}

/// Pool exception
class DownloadPoolException implements Exception {
  final String message;
  final dynamic originalError;

  DownloadPoolException(this.message, [this.originalError]);

  @override
  String toString() =>
      'DownloadPoolException: $message${originalError != null ? ' ($originalError)' : ''}';
}
