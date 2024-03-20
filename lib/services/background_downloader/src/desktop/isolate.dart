// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:mangayomi/services/background_downloader/background_downloader.dart';

import 'desktop_downloader.dart';
import 'download_isolate.dart';
import 'parallel_download_isolate.dart';
import 'upload_isolate.dart';

/// global variables, unique to this isolate
var bytesTotal = 0; // total bytes read in this download session
var startByte =
    0; // starting position within the original range, used for resume
var lastProgressUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);
var nextProgressUpdateTime = DateTime.fromMillisecondsSinceEpoch(0);
var lastProgressUpdate = 0.0;
var bytesTotalAtLastProgressUpdate = 0;

var networkSpeed = 0.0; // in MB/s
var isPaused = false;
var isCanceled = false;

// additional parameters for final TaskStatusUpdate
TaskException? taskException;
String? responseBody;
Map<String, String>? responseHeaders;
int? responseStatusCode;
String? mimeType; // derived from Content-Type header
String? charSet; // derived from Content-Type header

// logging from isolate is always 'FINEST', as it is sent to
// the [DesktopDownloader] for processing
final log = Logger('FileDownloader');

/// Do the task, sending messages back to the main isolate via [sendPort]
///
/// The first message sent back is a [ReceivePort] that is the command port
/// for the isolate. The first command must be the arguments: task and filePath.
Future<void> doTask((RootIsolateToken, SendPort) isolateArguments) async {
  final (rootIsolateToken, sendPort) = isolateArguments;
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  final receivePort = ReceivePort();
  // send the receive port back to the main Isolate
  sendPort.send(receivePort.sendPort);
  final messagesToIsolate = StreamQueue<dynamic>(receivePort);
  // get the arguments list and parse each argument
  final (
    Task task,
    String filePath,
    ResumeData? resumeData,
    bool isResume,
    Duration? requestTimeout,
    Map<String, dynamic> proxy,
    bool bypassTLSCertificateValidation,
  ) = await messagesToIsolate.next;
  DesktopDownloader.setHttpClient(
      requestTimeout, proxy, bypassTLSCertificateValidation);
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (kDebugMode) {
      sendPort.send(('log', (rec.message)));
    }
  });
  // start listener/processor for incoming messages
  unawaited(listenToIncomingMessages(task, messagesToIsolate, sendPort));
  processStatusUpdateInIsolate(task, TaskStatus.running, sendPort);
  if (!isResume) {
    processProgressUpdateInIsolate(task, 0.0, sendPort);
  }
  if (task.retriesRemaining < 0) {
    logError(task, 'task has negative retries remaining');
    taskException = TaskException('Task has negative retries remaining');
    processStatusUpdateInIsolate(task, TaskStatus.failed, sendPort);
  } else {
    // allow immediate cancel message to come through
    await Future.delayed(const Duration(milliseconds: 0));
    await switch (task) {
      ParallelDownloadTask() => doParallelDownloadTask(
          task,
          filePath,
          resumeData,
          isResume,
          requestTimeout ?? const Duration(seconds: 60),
          sendPort),
      DownloadTask() => doDownloadTask(task, filePath, resumeData, isResume,
          requestTimeout ?? const Duration(seconds: 60), sendPort),
      UploadTask() => doUploadTask(task, filePath, sendPort)
    };
  }
  receivePort.close();
  sendPort.send('done'); // signals end
  Isolate.exit();
}

/// Listen async to messages to the isolate, and process these
///
/// Called as unawaited Future, which completes when the [messagesToIsolate]
/// stream is closed
Future<void> listenToIncomingMessages(
    Task task, StreamQueue messagesToIsolate, SendPort sendPort) async {
  while (await messagesToIsolate.hasNext) {
    final message = await messagesToIsolate.next;
    switch (message) {
      case 'cancel':
        isCanceled = true; // checked in loop elsewhere
        if (task is ParallelDownloadTask) {
          cancelParallelDownloadTask(task, sendPort);
        }

      case 'pause':
        isPaused = true; // checked in loop elsewhere
        if (task is ParallelDownloadTask) {
          pauseParallelDownloadTask(task, sendPort);
        }

      // Status and progress updates are incoming from chunk tasks, part of a
      // [ParallelDownloadTask]. We update the chunk status/progress and
      // determine the aggregate status/progress for the parent task. If changed,
      // we process that update for the parent task as we would for a regular
      // [DownloadTask].
      // Note that [task] refers to the parent task, whereas [update.task] refers
      // to the chunk (child) task
      case TaskStatusUpdate update:
        await chunkStatusUpdate(task, update, sendPort);

      case TaskProgressUpdate update:
        chunkProgressUpdate(task, update, sendPort);
    }
  }
}

/// Transfer all bytes from [inStream] to [outStream], expecting [contentLength]
/// total bytes
///
/// Sends updates via the [sendPort] and can be commanded to cancel/pause via
/// the [messagesToIsolate] queue
///
/// Returns a [TaskStatus] and will throw any exception generated within
///
/// Note: does not flush or close any streams
Future<TaskStatus> transferBytes(
    Stream<List<int>> inStream,
    StreamSink<List<int>> outStream,
    int contentLength,
    Task task,
    SendPort sendPort,
    [Duration requestTimeout = const Duration(seconds: 60)]) async {
  if (contentLength == 0) {
    contentLength = -1;
  }
  var resultStatus = TaskStatus.complete;
  try {
    await outStream
        .addStream(inStream.timeout(requestTimeout, onTimeout: (sink) {
      taskException = TaskConnectionException('Connection timed out');
      resultStatus = TaskStatus.failed;
      sink.close(); // ends the stream
    }).map((bytes) {
      if (isCanceled) {
        resultStatus = TaskStatus.canceled;
        throw StateError('Canceled');
      }
      if (isPaused) {
        resultStatus = TaskStatus.paused;
        throw StateError('Paused');
      }
      bytesTotal += bytes.length;
      final progress = min(
          (bytesTotal + startByte).toDouble() / (contentLength + startByte),
          0.999);
      final now = DateTime.now();
      if (contentLength > 0 && shouldSendProgressUpdate(progress, now)) {
        processProgressUpdateInIsolate(
            task, progress, sendPort, contentLength + startByte);
        lastProgressUpdate = progress;
        nextProgressUpdateTime = now.add(const Duration(milliseconds: 500));
      }
      return bytes;
    }));
  } catch (e) {
    if (resultStatus == TaskStatus.complete) {
      // this was an unintentional error thrown within the stream processing
      logError(task, e.toString());
      setTaskError(e);
      resultStatus = TaskStatus.failed;
    }
  }
  return resultStatus;
}

/// Processes a change in status for the [task]
///
/// Sends status update via the [sendPort], if requested
/// If the task is finished, processes a final progressUpdate update
void processStatusUpdateInIsolate(
    Task task, TaskStatus status, SendPort sendPort) {
  final retryNeeded = status == TaskStatus.failed && task.retriesRemaining > 0;
  // if task is in final state, process a final progressUpdate
  // A 'failed' progress update is only provided if
  // a retry is not needed: if it is needed, a `waitingToRetry` progress update
  // will be generated in the FileDownloader
  switch (status) {
    case TaskStatus.complete:
      processProgressUpdateInIsolate(task, progressComplete, sendPort);

    case TaskStatus.failed when !retryNeeded:
      processProgressUpdateInIsolate(task, progressFailed, sendPort);

    case TaskStatus.canceled:
      processProgressUpdateInIsolate(task, progressCanceled, sendPort);

    case TaskStatus.notFound:
      processProgressUpdateInIsolate(task, progressNotFound, sendPort);

    case TaskStatus.paused:
      processProgressUpdateInIsolate(task, progressPaused, sendPort);

    default:
      {}
  }
// Post update if task expects one, or if failed and retry is needed
  if (task.providesStatusUpdates || retryNeeded) {
    sendPort.send((
      'statusUpdate',
      task,
      status,
      status == TaskStatus.failed
          ? taskException ?? TaskException('None')
          : null,
      status.isFinalState ? responseBody : null,
      status.isFinalState ? responseHeaders : null,
      status == TaskStatus.complete || status == TaskStatus.notFound
          ? responseStatusCode
          : null,
      status.isFinalState ? mimeType : null,
      status.isFinalState ? charSet : null,
    ));
  }
}

/// Processes a progress update for the [task]
///
/// Sends progress update via the [sendPort], if requested
void processProgressUpdateInIsolate(
    Task task, double progress, SendPort sendPort,
    [int expectedFileSize = -1]) {
  if (task.providesProgressUpdates) {
    if (progress > 0 && progress < 1) {
      // calculate download speed and time remaining
      final now = DateTime.now();
      final timeSinceLastUpdate = now.difference(lastProgressUpdateTime);
      lastProgressUpdateTime = now;
      if (task is ParallelDownloadTask) {
        // approximate based on aggregate progress
        bytesTotal = (progress * expectedFileSize).floor();
      }
      final bytesSinceLastUpdate = bytesTotal - bytesTotalAtLastProgressUpdate;
      bytesTotalAtLastProgressUpdate = bytesTotal;
      final currentNetworkSpeed = timeSinceLastUpdate.inHours > 0
          ? -1.0
          : bytesSinceLastUpdate / timeSinceLastUpdate.inMicroseconds;
      networkSpeed = switch (currentNetworkSpeed) {
        -1.0 => -1.0,
        _ when networkSpeed == -1.0 => currentNetworkSpeed,
        _ => (networkSpeed * 3 + currentNetworkSpeed) / 4.0
      };
      final remainingBytes = (1 - progress) * expectedFileSize;
      final timeRemaining = networkSpeed == -1.0 || expectedFileSize < 0
          ? const Duration(seconds: -1)
          : Duration(microseconds: (remainingBytes / networkSpeed).round());
      sendPort.send((
        'progressUpdate',
        task,
        progress,
        expectedFileSize,
        networkSpeed,
        timeRemaining
      ));
    } else {
      // no download speed or time remaining
      sendPort.send((
        'progressUpdate',
        task,
        progress,
        expectedFileSize,
        -1.0,
        const Duration(seconds: -1)
      ));
    }
  }
}

// The following functions are related to multipart uploads and are
// by and large copied from the dart:http package. Similar implementations
// in Kotlin and Swift are translations of the same code

/// Returns the multipart entry for one field name/value pair
String fieldEntry(String name, String value) =>
    '--$boundary$lineFeed${headerForField(name, value)}$value$lineFeed';

/// Returns the header string for a field.
///
/// The return value is guaranteed to contain only ASCII characters.
String headerForField(String name, String value) {
  var header = 'content-disposition: form-data; name="${browserEncode(name)}"';
  if (!isPlainAscii(value)) {
    header = '$header\r\n'
        'content-type: text/plain; charset=utf-8\r\n'
        'content-transfer-encoding: binary';
  }
  return '$header\r\n\r\n';
}

/// A regular expression that matches strings that are composed entirely of
/// ASCII-compatible characters.
final _asciiOnly = RegExp(r'^[\x00-\x7F]+$');

final _newlineRegExp = RegExp(r'\r\n|\r|\n');

/// Returns whether [string] is composed entirely of ASCII-compatible
/// characters.
bool isPlainAscii(String string) => _asciiOnly.hasMatch(string);

/// Encode [value] in the same way browsers do.
String browserEncode(String value) =>
    // http://tools.ietf.org/html/rfc2388 mandates some complex encodings for
// field names and file names, but in practice user agents seem not to
// follow this at all. Instead, they URL-encode `\r`, `\n`, and `\r\n` as
// `\r\n`; URL-encode `"`; and do nothing else (even for `%` or non-ASCII
// characters). We follow their behavior.
    value.replaceAll(_newlineRegExp, '%0D%0A').replaceAll('"', '%22');

/// Returns the length of the [string] in bytes when utf-8 encoded
int lengthInBytes(String string) => utf8.encode(string).length;

/// Log an error for this task
void logError(Task task, String error) {
  log.fine('Error for taskId ${task.taskId}: $error');
}

/// Set the [taskException] variable based on error e
void setTaskError(dynamic e) {
  switch (e) {
    case HttpException():
    case TimeoutException():
      taskException = TaskConnectionException(e.toString());

    case IOException():
      taskException = TaskFileSystemException(e.toString());

    case TaskException():
      taskException = e;

    default:
      taskException = TaskException(e.toString());
  }
}

/// Return the response's content as a String, or null if unable
Future<String?> responseContent(http.StreamedResponse response) {
  try {
    return response.stream.bytesToString();
  } catch (e) {
    log.fine(
        'Could not read response content from httpResponseCode ${response.statusCode}: $e');
    return Future.value(null);
  }
}

/// Returns true if [currentProgress] > [lastProgressUpdate] + threshold and
/// [now] > [nextProgressUpdateTime]
bool shouldSendProgressUpdate(double currentProgress, DateTime now) {
  return currentProgress - lastProgressUpdate > 0.02 &&
      now.isAfter(nextProgressUpdateTime);
}
