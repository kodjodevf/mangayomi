// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:mangayomi/services/background_downloader/src/downloader/downloader_http_client.dart';
import '../chunk.dart';
import '../exceptions.dart';
import '../models.dart';
import '../task.dart';
import '../utils.dart';
import 'download_isolate.dart';
import 'isolate.dart';

/// A [ParallelDownloadTask] pings the server to get the content-length of the
/// download, then creates a list of [Chunk]s, each representing a portion
/// of the download.  Each chunk-task has its group set to 'chunk' and
/// has the taskId of the parent [ParallelDownloadTask] in its
/// [Task.metaData] field.
/// The isolate sends 'enqueue' messages back to the [DesktopDownloader] to
/// start each chunk-task, just like any other download task.
/// Messages with group 'chunk' are intercepted in the [DesktopDownloader],
/// where the sendPort for the isolate running the parent task is
/// looked up, and the update is sent to the isolate via that sendPort.
/// In the isolate, the update is processed and the new status/progress
/// of the [ParallelDownloadTask] is determined. If the status/progress has
/// changed, an update is sent and the status is processed (e.g., a complete
/// status triggers the piecing together of the downloaded file from
/// its chunk pieces).
///
/// Similarly, pause and cancel commands are sent to all chunk tasks before
/// updating the status of the parent [ParallelDownloadTask]

late ParallelDownloadTask parentTask;
var chunks = <Chunk>[]; // chunks associated with this download
var lastTaskStatus = TaskStatus.running;
Completer<TaskStatusUpdate> parallelTaskStatusUpdateCompleter = Completer();
var parallelDownloadContentLength = -1;

/// Execute the parallel download task
///
/// Sends updates via the [sendPort] and can be commanded to cancel/pause via
/// the [messagesToIsolate] queue.
///
/// If [isResume] is false, we create [Chunk]s and enqueue each of its tasks
/// by sending a message to the [DesktopDownloader], then wait for the
/// completion of [parallelTaskStatusUpdateCompleter]
///
/// If [isResume] is true, [resumeData] contains the json encoded [chunks] list,
/// and the associated chunk [DownloadTask] tasks will be started by the
/// [DesktopDownloader], so we just wait for completion of
/// [parallelTaskStatusUpdateCompleter]
///
/// Incoming messages from the [DesktopDownloader] are received in the
/// [listenToIncomingMessages] function
Future<void> doParallelDownloadTask(ParallelDownloadTask task, String filePath, ResumeData? resumeData, bool isResume,
    Duration requestTimeout, SendPort sendPort) async {
  parentTask = task;
  if (!isResume) {
    // start the download by creating [Chunk]s and enqueuing chunk tasks
    final response = await (DownloaderHttpClient.httpClient).head(Uri.parse(task.url), headers: task.headers);
    responseHeaders = response.headers;
    responseStatusCode = response.statusCode;
    if ([200, 201, 202, 203, 204, 205, 206].contains(response.statusCode)) {
      // get suggested filename if needed, and change task and parentTask
      if (!task.hasFilename) {
        task = (await taskWithSuggestedFilename(task, response.headers, true)) as ParallelDownloadTask;
        parentTask = task;
        log.finest('Suggested filename for taskId ${task.taskId}: ${task.filename}');
      }
      extractContentType(response.headers);
      chunks = createChunks(task, response.headers);
      for (var chunk in chunks) {
        // Ask main isolate to enqueue the child task. Updates related to the child
        // will be sent to this isolate (the child's metaData contains the parent taskId).
        sendPort.send(('enqueueChild', chunk.task));
      }
      // wait for all chunk tasks to complete
      final statusUpdate = await parallelTaskStatusUpdateCompleter.future;
      processStatusUpdateInIsolate(task, statusUpdate.status, sendPort);
    } else {
      log.fine('TaskId ${task.taskId}: Invalid server response code ${response.statusCode}');
      // not an OK response
      responseBody = response.body;
      if (response.statusCode == 404) {
        processStatusUpdateInIsolate(task, TaskStatus.notFound, sendPort);
      } else {
        taskException = TaskHttpException(
            responseBody?.isNotEmpty == true ? responseBody! : response.reasonPhrase ?? 'Invalid HTTP Request',
            response.statusCode);
        processStatusUpdateInIsolate(task, TaskStatus.failed, sendPort);
      }
    }
  } else {
    // resume: reconstruct [chunks] and wait for all chunk tasks to complete
    chunks = List.from(jsonDecode(resumeData!.data, reviver: Chunk.listReviver));
    parallelDownloadContentLength =
        chunks.fold(0, (previousValue, chunk) => previousValue + chunk.toByte - chunk.fromByte + 1);
    final statusUpdate = await parallelTaskStatusUpdateCompleter.future;
    processStatusUpdateInIsolate(task, statusUpdate.status, sendPort);
  }
}

/// Process incoming [update] for a chunk, within the [ParallelDownloadTask]
/// represented by [task]
Future<void> chunkStatusUpdate(Task task, TaskStatusUpdate update, SendPort sendPort) async {
  final chunkTask = update.task;
  // first check for fail -> retry
  if (update.status == TaskStatus.failed && chunkTask.retriesRemaining > 0) {
    chunkTask.decreaseRetriesRemaining();
    final waitTime = Duration(seconds: 2 << min(chunkTask.retries - chunkTask.retriesRemaining - 1, 8));
    log.finer('Chunk task with taskId ${chunkTask.taskId} failed, waiting ${waitTime.inSeconds}'
        ' seconds before retrying. ${chunkTask.retriesRemaining}'
        ' retries remaining');
    Future.delayed(waitTime, () async {
      // after delay, resume or enqueue task again if it's still waiting
      sendPort.send(('enqueueChild', chunkTask));
    });
  } else {
    // no retry
    final newStatusUpdate = updateChunkStatus(update);
    switch (newStatusUpdate) {
      case TaskStatus.complete:
        final result = await stitchChunks();
        parallelTaskStatusUpdateCompleter
            .complete(TaskStatusUpdate(task, result, null, responseBody, responseHeaders, responseStatusCode));
        break;

      case TaskStatus.failed:
        taskException = update.exception;
        responseBody = update.responseBody;
        cancelAllChunkTasks(sendPort);
        parallelTaskStatusUpdateCompleter.complete(TaskStatusUpdate(
            task, TaskStatus.failed, taskException, responseBody, responseHeaders, responseStatusCode));
        break;

      case TaskStatus.notFound:
        responseBody = update.responseBody;
        cancelAllChunkTasks(sendPort);
        parallelTaskStatusUpdateCompleter.complete(
            TaskStatusUpdate(task, TaskStatus.notFound, null, responseBody, responseHeaders, responseStatusCode));
        break;

      default:
        // ignore all other status updates, including null
        break;
    }
  }
}

/// Update the status for this chunk, and return the status for the parent task
/// as derived from the sum of the child tasks, or null if undefined
///
/// The updates are received from the [DeskTopDownloader], which intercepts
/// status updates for the [chunkGroup]. Not all regular statuses are passed on
TaskStatus? updateChunkStatus(TaskStatusUpdate update) {
  final chunk = chunks.firstWhereOrNull((chunk) => chunk.task == update.task);
  if (chunk == null) {
    return null; // chunk is not part of this parent task
  }
  chunk.status = update.status;
  final newStatusUpdate = parentTaskStatus();
  if ((newStatusUpdate != null && newStatusUpdate != lastTaskStatus)) {
    lastTaskStatus = newStatusUpdate;
    return newStatusUpdate;
  }
  return null;
}

/// Returns the [TaskStatus] for the parent of this chunk, as derived from
/// the 'sum' of the child tasks, or null if undetermined
///
/// The updates are received from the [DeskTopDownloader], which intercepts
/// status updates for the [chunkGroup]
TaskStatus? parentTaskStatus() {
  final failed = chunks.firstWhereOrNull((chunk) => chunk.status == TaskStatus.failed);
  if (failed != null) {
    return TaskStatus.failed;
  }
  final notFound = chunks.firstWhereOrNull((chunk) => chunk.status == TaskStatus.notFound);
  if (notFound != null) {
    return TaskStatus.notFound;
  }
  final allComplete = chunks.every((chunk) => chunk.status == TaskStatus.complete);
  if (allComplete) {
    return TaskStatus.complete;
  }
  return null;
}

/// Process incoming [update] for a chunk, within the [ParallelDownloadTask]
/// represented by [task]
void chunkProgressUpdate(Task task, TaskProgressUpdate update, SendPort sendPort) {
  // update of child task of a [ParallelDownloadTask], only for regular
  // progress updates
  final now = DateTime.now();
  if (update.progress > 0 && update.progress < 1) {
    final parentProgressUpdate = updateChunkProgress(update);
    if (parentProgressUpdate != null && shouldSendProgressUpdate(parentProgressUpdate, now)) {
      processProgressUpdateInIsolate(task, parentProgressUpdate, sendPort, parallelDownloadContentLength);
      lastProgressUpdate = parentProgressUpdate;
      nextProgressUpdateTime = now.add(const Duration(milliseconds: 500));
    }
  }
}

/// Update the progress for this chunk, and return the progress for the parent
/// task as derived from the sum of the child tasks, or null if undefined
///
/// The updates are received from the [DeskTopDownloader], which intercepts
/// progress updates for the [chunkGroup].
/// Only true progress updates (in range 0-1) are passed on to this method
double? updateChunkProgress(TaskProgressUpdate update) {
  final chunk = chunks.firstWhereOrNull((chunk) => chunk.task == update.task);
  if (chunk == null) {
    return null; // chunk is not part of this parent task
  }
  chunk.progress = update.progress;
  return parentTaskProgress();
}

/// Returns the progress for the parent of this chunk, as derived
/// from the 'sum' of the child tasks
///
/// The updates are received from the [DeskTopDownloader], which intercepts
/// progress updates for the [chunkGroup].
/// Only true progress updates (in range 0-1) are passed on to this method,
/// so we just calculate the average progress
double parentTaskProgress() {
  final avgProgress = chunks.fold(0.0, (previousValue, chunk) => previousValue + chunk.progress) / chunks.length;
  return avgProgress;
}

/// Cancel this [ParallelDownloadTask]
void cancelParallelDownloadTask(ParallelDownloadTask task, SendPort sendPort) {
  cancelAllChunkTasks(sendPort);
  parallelTaskStatusUpdateCompleter.complete(TaskStatusUpdate(task, TaskStatus.canceled));
}

/// Cancel the tasks associated with each chunk
///
/// Accomplished by sending list of taskIds to cancel to the
/// [DesktopDownloader]
void cancelAllChunkTasks(SendPort sendPort) {
  sendPort.send(('cancelTasksWithId', chunks.map((e) => e.task.taskId).toList()));
}

/// Pause this [ParallelDownloadTask]
///
/// Because each [Chunk] is a [DownloadTask], each is paused
/// and generates its own [ResumeData].
/// [ResumeData] for a [ParallelDownloadTask] is the list of [Chunk]s,
/// including their status and progress, json encoded.
/// To resume, we need to recreate the list of [Chunk]s and pass this with
/// the resumed [ParallelDownloadTask], then resume each of the
/// [DownloadTask]s. This is done in [DesktopDownloader.resume]
void pauseParallelDownloadTask(ParallelDownloadTask task, SendPort sendPort) {
  pauseAllChunkTasks(sendPort);
  sendPort.send(('resumeData', jsonEncode(chunks), -1, null));
  parallelTaskStatusUpdateCompleter.complete(TaskStatusUpdate(task, TaskStatus.paused));
}

/// Pause the tasks associated with each chunk
///
/// Accomplished by sending list of tasks to pause to the
/// [DesktopDownloader]
void pauseAllChunkTasks(SendPort sendPort) {
  sendPort.send(('pauseTasks', chunks.map((e) => e.task).toList()));
}

/// Stitch all chunks together into one file, per the [parentTask]
Future<TaskStatus> stitchChunks() async {
  IOSink? outStream;
  StreamSubscription? subscription;
  try {
    final outFile = File(await parentTask.filePath());
    if (await outFile.exists()) {
      await outFile.delete();
    }
    outStream = outFile.openWrite();
    for (final chunk in chunks.sorted((a, b) => a.fromByte - b.fromByte)) {
      final inFile = File(await chunk.task.filePath());
      if (!await inFile.exists()) {
        throw const FileSystemException('Missing chunk file');
      }
      final inStream = inFile.openRead();
      final doneCompleter = Completer<bool>();
      subscription = inStream.listen(
          (bytes) {
            outStream?.add(bytes);
          },
          onDone: () => doneCompleter.complete(true),
          onError: (error) {
            logError(parentTask, e.toString());
            setTaskError(error);
            doneCompleter.complete(false);
          });
      final success = await doneCompleter.future;
      if (!success) {
        return TaskStatus.failed;
      }
      subscription.cancel();
      await inFile.delete();
    }
    await outStream.flush();
  } catch (e) {
    logError(parentTask, e.toString());
    setTaskError(e);
    return TaskStatus.failed;
  } finally {
    await outStream?.close();
    subscription?.cancel();
    for (final chunk in chunks) {
      try {
        final file = File(await chunk.task.filePath());
        await file.delete();
      } on FileSystemException {
        // ignore
      }
    }
  }
  return TaskStatus.complete;
}

/// Returns a list of chunk information for this task, and sets
/// [parallelDownloadContentLength] to the total length of the download
///
/// Throws a StateError if any information is missing, which should lead
/// to a failure of the [ParallelDownloadTask]
List<Chunk> createChunks(ParallelDownloadTask task, Map<String, String> headers) {
  try {
    final numChunks = task.urls.length * task.chunks;
    final contentLength = getContentLength(headers, task);
    if (contentLength <= 0) {
      throw StateError('Server does not provide content length - cannot chunk download. '
          'If you know the length, set Range or Known-Content-Length header');
    }
    parallelDownloadContentLength = contentLength;
    try {
      headers.entries.firstWhere((element) => element.key.toLowerCase() == 'accept-ranges' && element.value == 'bytes');
    } on StateError {
      throw StateError('Server does not accept ranges - cannot chunk download');
    }
    final chunkSize = (contentLength / numChunks).ceil();
    return [
      for (var i = 0; i < numChunks; i++)
        Chunk(
            parentTask: task,
            url: task.urls[i % task.urls.length],
            filename: Random().nextInt(1 << 32).toString(),
            fromByte: i * chunkSize,
            toByte: min(i * chunkSize + chunkSize - 1, contentLength - 1))
    ];
  } on StateError {
    throw StateError('Server does not provide content length - cannot chunk download. '
        'If you know the length, set Range or Known-Content-Length header');
  }
}
