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
  Future<void> initialize() async {
    if (_initialized) return;

    if (kDebugMode) {
      print('[DownloadPool] Initializing with $poolSize workers...');
    }

    for (int i = 0; i < poolSize; i++) {
      final worker = await _PoolWorker.create(i);
      _workers.add(worker);
      _availableWorkers.add(i); // All workers start as available
    }

    _initialized = true;
    if (kDebugMode) {
      print('[DownloadPool] Pool initialized with $poolSize workers');
    }
  }

  /// Submit a file download task (manga/anime)
  Future<void> submitFileDownload({
    required String taskId,
    required List<PageUrl> pageUrls,
    required int concurrentDownloads,
    required ItemType itemType,
    required void Function(DownloadProgress) onProgress,
    required void Function() onComplete,
    required void Function(Exception) onError,
  }) async {
    if (!_initialized) await initialize();

    // Mark the task as active (not cancelled)
    downloadTaskCancellation[taskId] = false;

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
    receivePort.listen((message) {
      if (downloadTaskCancellation[taskId] == true) {
        receivePort.close();
        return;
      }

      if (message is DownloadProgress) {
        onProgress(message);
      } else if (message is DownloadComplete) {
        downloadTaskCancellation.remove(taskId);
        receivePort.close();
        onComplete();
      } else if (message is Exception) {
        downloadTaskCancellation.remove(taskId);
        receivePort.close();
        onError(message);
      }
    });

    _enqueueTask(task);
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
    if (!_initialized) await initialize();

    downloadTaskCancellation[taskId] = false;

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

    receivePort.listen((message) {
      if (downloadTaskCancellation[taskId] == true) {
        receivePort.close();
        return;
      }

      if (message is DownloadProgress) {
        onProgress(message);
      } else if (message is DownloadComplete) {
        downloadTaskCancellation.remove(taskId);
        receivePort.close();
        onComplete();
      } else if (message is Exception) {
        downloadTaskCancellation.remove(taskId);
        receivePort.close();
        onError(message);
      }
    });

    _enqueueTask(task);
  }

  /// Cancel a download task
  void cancelTask(String taskId) {
    downloadTaskCancellation[taskId] = true;
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

      worker.executeTask(task).then((_) {
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

  _PoolWorker._(this.id);

  static Future<_PoolWorker> create(int id) async {
    final worker = _PoolWorker._(id);
    await worker._spawn();
    return worker;
  }

  Future<void> _spawn() async {
    _receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _workerEntryPoint,
      _WorkerInit(id, _receivePort.sendPort),
    );

    // Wait for the worker to be ready and get its SendPort
    final completer = Completer<SendPort>();
    _receivePort.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      }
    });

    _sendPort = await completer.future;
    _ready.complete();
  }

  /// Execute a task in this worker
  Future<void> executeTask(_DownloadTask task) async {
    await _ready.future;

    final completer = Completer<void>();

    // Create a port to receive messages from this worker
    final taskPort = ReceivePort();

    taskPort.listen((message) {
      // Forward the message to the original task port
      task.sendPort.send(message);

      if (message is DownloadComplete || message is Exception) {
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

/// Worker initialization message
class _WorkerInit {
  final int workerId;
  final SendPort mainPort;
  _WorkerInit(this.workerId, this.mainPort);
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
void _workerEntryPoint(_WorkerInit init) async {
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
  init.mainPort.send(receivePort.sendPort);

  if (kDebugMode) {
    print('[Worker ${init.workerId}] Ready');
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
          await _processM3u8Download(
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
        () => client.get(Uri.parse(pageUrl.url), headers: pageUrl.headers),
        3,
      );
      if (response.statusCode != 200) {
        throw DownloadPoolException(
          'Failed to download file: ${pageUrl.fileName!}',
        );
      }

      final file = File(pageUrl.fileName!);
      await file.writeAsBytes(response.bodyBytes);
    } else {
      // Streaming for videos (saves RAM)
      await _withRetry(() async {
        var request = Request('GET', Uri.parse(pageUrl.url));
        request.headers.addAll(pageUrl.headers ?? {});
        StreamedResponse response = await client.send(request);
        if (response.statusCode != 200) {
          throw DownloadPoolException(
            'Failed to download file: ${pageUrl.fileName!}',
          );
        }
        int total = response.contentLength ?? 0;
        int received = 0;

        final file = File(pageUrl.fileName!);
        final sink = file.openWrite();
        try {
          await for (var value in response.stream) {
            sink.add(value);
            received += value.length;
            try {
              replyPort.send(
                DownloadProgress(
                  (received / total * 100).toInt(),
                  100,
                  pageUrl: pageUrl,
                  itemType,
                ),
              );
            } catch (_) {}
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
Future<void> _processM3u8Download(
  M3u8DownloadParams params,
  SendPort replyPort,
  Client client,
) async {
  int completed = 0;
  final total = params.segments.length;
  final queue = Queue<TsInfo>.from(params.segments);
  final List<Future<void>> activeTasks = [];

  try {
    while (queue.isNotEmpty || activeTasks.isNotEmpty) {
      while (queue.isNotEmpty &&
          activeTasks.length < params.concurrentDownloads) {
        final segment = queue.removeFirst();
        final task = _downloadSegment(segment, params, client)
            .then((_) {
              completed++;
              replyPort.send(
                DownloadProgress(
                  segment: segment,
                  completed,
                  total,
                  params.itemType,
                ),
              );
            })
            .catchError((error) {
              replyPort.send(
                DownloadPoolException(
                  'Error downloading segment ${segment.name}',
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
    replyPort.send(DownloadPoolException('M3U8 download failed', e));
  }
}

/// Download a TS segment
Future<void> _downloadSegment(
  TsInfo ts,
  M3u8DownloadParams params,
  Client client,
) async {
  try {
    final file = File(path.join(params.tempDir, '${ts.name}.ts'));

    // Streaming to save memory
    var request = Request('GET', Uri.parse(ts.url));
    if (params.headers != null) {
      request.headers.addAll(params.headers!);
    }
    StreamedResponse response = await _withRetry(() => client.send(request), 3);

    if (response.statusCode != 200) {
      throw DownloadPoolException('Failed to download segment: ${ts.name}');
    }

    final sink = file.openWrite();
    try {
      await for (var chunk in response.stream) {
        sink.add(chunk);
      }
    } finally {
      await sink.flush();
      await sink.close();
    }

    // Decrypt if necessary
    if (params.key != null) {
      final bytes = await file.readAsBytes();
      final index = int.parse(ts.name.substringAfter("TS_"));
      final decrypted = _aesDecrypt(
        (params.mediaSequence ?? 1) + (index - 1),
        bytes,
        params.key!,
        iv: params.iv,
      );
      await file.writeAsBytes(decrypted);
    }
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
