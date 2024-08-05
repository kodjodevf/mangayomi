// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:mangayomi/services/background_downloader/src/desktop/desktop_downloader_http_client.dart';
import 'package:mangayomi/services/background_downloader/src/desktop/desktop_downloader_native_http_client.dart.dart'
    as desktop_downloader_native;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../exceptions.dart';
import '../models.dart';
import '../task.dart';
import '../utils.dart';
import 'isolate.dart';

var taskRangeStartByte = 0; // Start of the Task's download range
String? eTagHeader;
late DownloadTask downloadTask; // global because filename may change

/// Execute the download task
///
/// Sends updates via the [sendPort] and can be commanded to cancel/pause via
/// the [messagesToIsolate] queue
Future<void> doDownloadTask(
    DownloadTask task,
    String filePath,
    ResumeData? resumeData,
    bool isResume,
    Duration requestTimeout,
    SendPort sendPort,
    bool useNativeHttpClient) async {
  // use downloadTask from here on as a 'global' variable in this isolate,
  // as we may change the filename of the task
  downloadTask = task;
  // tempFilePath is taken from [resumeDataString] if this is a resuming task.
  // Otherwise, it is a generated full path to the temp directory
  final tempFilePath = isResume && resumeData != null
      ? resumeData.tempFilepath
      : p.join((await getTemporaryDirectory()).path,
          'com.bbflight.background_downloader${Random().nextInt(1 << 32).toString()}');
  final requiredStartByte =
      resumeData?.requiredStartByte ?? 0; // start for resume
  final eTag = resumeData?.eTag;
  isResume = isResume &&
      await determineIfResumeIsPossible(tempFilePath, requiredStartByte);
  final client = useNativeHttpClient
      ? desktop_downloader_native.DesktopDownloaderNativeHttpClient.httpClient
      : DesktopDownloaderHttpClient.httpClient;
  var request =
      http.Request(downloadTask.httpRequestMethod, Uri.parse(downloadTask.url));
  request.headers.addAll(downloadTask.headers);
  if (isResume) {
    final taskRangeHeader = downloadTask.headers['Range'] ?? '';
    final taskRange = parseRange(taskRangeHeader);
    taskRangeStartByte = taskRange.$1;
    final resumeRange = (taskRangeStartByte + requiredStartByte, taskRange.$2);
    final newRangeString = 'bytes=${resumeRange.$1}-${resumeRange.$2 ?? ""}';
    request.headers['Range'] = newRangeString;
  }
  if (downloadTask.post is String) {
    request.body = downloadTask.post!;
  }
  var resultStatus = TaskStatus.failed;
  try {
    final response = await client.send(request);
    if (!isCanceled) {
      eTagHeader = response.headers['etag'] ?? response.headers['ETag'];
      final acceptRangesHeader = response.headers['accept-ranges'];
      final serverAcceptsRanges =
          acceptRangesHeader == 'bytes' || response.statusCode == 206;
      var taskCanResume = false;
      if (downloadTask.allowPause) {
        // determine if this task can be paused
        taskCanResume = serverAcceptsRanges;
        sendPort.send(('taskCanResume', taskCanResume));
      }
      isResume =
          isResume && response.statusCode == 206; // confirm resume response
      if (isResume && (eTagHeader != eTag || eTag?.startsWith('W/') == true)) {
        throw TaskException('Cannot resume: ETag is not identical, or is weak');
      }
      if (!downloadTask.hasFilename) {
        downloadTask = await taskWithSuggestedFilename(
            downloadTask, response.headers, true);
        // update the filePath by replacing the last segment with the new filename
        filePath = p.join(p.dirname(filePath), downloadTask.filename);
        log.finest(
            'Suggested filename for taskId ${task.taskId}: ${task.filename}');
      }
      responseHeaders = response.headers;
      responseStatusCode = response.statusCode;
      extractContentType(response.headers);
      if (okResponses.contains(response.statusCode)) {
        resultStatus = await processOkDownloadResponse(
            filePath,
            tempFilePath,
            serverAcceptsRanges,
            taskCanResume,
            isResume,
            requestTimeout,
            response,
            sendPort);
      } else {
        // not an OK response
        responseBody = await responseContent(response);
        if (response.statusCode == 404) {
          resultStatus = TaskStatus.notFound;
        } else {
          taskException = TaskHttpException(
              responseBody?.isNotEmpty == true
                  ? responseBody!
                  : response.reasonPhrase ?? 'Invalid HTTP Request',
              response.statusCode);
        }
      }
    }
  } catch (e) {
    logError(downloadTask, e.toString());
    setTaskError(e);
  }
  if (isCanceled) {
    // cancellation overrides other results
    resultStatus = TaskStatus.canceled;
  }
  processStatusUpdateInIsolate(downloadTask, resultStatus, sendPort);
}

/// Return true if resume is possible
///
/// Confirms that file at [tempFilePath] exists and its length equals
/// [requiredStartByte]
Future<bool> determineIfResumeIsPossible(
    String tempFilePath, int requiredStartByte) async {
  if (File(tempFilePath).existsSync()) {
    if (await File(tempFilePath).length() == requiredStartByte) {
      return true;
    } else {
      log.fine('Partially downloaded file is corrupted, resume not possible');
    }
  } else {
    log.fine('Partially downloaded file not available, resume not possible');
  }
  return false;
}

/// Process response with valid response code
///
/// Performs the actual bytes transfer from response to a temp file,
/// and handles the result of the transfer:
/// - .complete -> copy temp to final file location
/// - .failed -> delete temp file
/// - .paused -> post resume information
Future<TaskStatus> processOkDownloadResponse(
    String filePath,
    String tempFilePath,
    bool serverAcceptsRanges,
    bool taskCanResume,
    bool isResume,
    Duration requestTimeout,
    http.StreamedResponse response,
    SendPort sendPort) async {
  // contentLength is extracted from response header, and if not available
  // we attempt to extract from [Task.headers], allowing developer to
  // set the content length if already known
  final contentLength = getContentLength(response.headers, downloadTask);
  isResume = isResume && response.statusCode == 206;
  if (isResume && !await prepareResume(response, tempFilePath)) {
    deleteTempFile(tempFilePath);
    return TaskStatus.failed;
  }
  var resultStatus = TaskStatus.failed;
  IOSink? outStream;
  try {
    // do the actual download
    outStream = File(tempFilePath)
        .openWrite(mode: isResume ? FileMode.append : FileMode.write);
    final transferBytesResult = await transferBytes(response.stream, outStream,
        contentLength, downloadTask, sendPort, requestTimeout);
    switch (transferBytesResult) {
      case TaskStatus.complete:
        // copy file to destination, creating dirs if needed
        await outStream.flush();
        final dirPath = p.dirname(filePath);
        Directory(dirPath).createSync(recursive: true);
        File(tempFilePath).copySync(filePath);
        resultStatus = TaskStatus.complete;

      case TaskStatus.canceled:
        deleteTempFile(tempFilePath);
        resultStatus = TaskStatus.canceled;

      case TaskStatus.paused:
        if (taskCanResume) {
          sendPort.send(
              ('resumeData', tempFilePath, bytesTotal + startByte, eTagHeader));
          resultStatus = TaskStatus.paused;
        } else {
          taskException =
              TaskResumeException('Task was paused but cannot resume');
          resultStatus = TaskStatus.failed;
        }

      case TaskStatus.failed:
        break;

      default:
        throw ArgumentError('Cannot process $transferBytesResult');
    }
  } catch (e) {
    logError(downloadTask, e.toString());
    setTaskError(e);
  } finally {
    try {
      await outStream?.close();
      if (resultStatus == TaskStatus.failed &&
          serverAcceptsRanges &&
          bytesTotal + startByte > 1 << 20) {
        // send ResumeData to allow resume after fail
        sendPort.send(
            ('resumeData', tempFilePath, bytesTotal + startByte, eTagHeader));
      } else if (resultStatus != TaskStatus.paused) {
        File(tempFilePath).deleteSync();
      }
    } catch (e) {
      logError(downloadTask, 'Could not delete temp file $tempFilePath');
    }
  }
  return resultStatus;
}

/// Prepare for resume if possible
///
/// Returns true if task can continue, false if task failed.
/// Extracts and parses Range headers, and truncates temp file
Future<bool> prepareResume(
    http.StreamedResponse response, String tempFilePath) async {
  final range = response.headers['content-range'];
  if (range == null) {
    log.fine('Could not process partial response Content-Range');
    taskException =
        TaskResumeException('Could not process partial response Content-Range');
    return false;
  }
  final contentRangeRegEx = RegExp(r"(\d+)-(\d+)/(\d+)");
  final matchResult = contentRangeRegEx.firstMatch(range);
  if (matchResult == null) {
    log.fine('Could not process partial response Content-Range $range');
    taskException = TaskResumeException('Could not process '
        'partial response Content-Range $range');
    return false;
  }
  final start = int.parse(matchResult.group(1) ?? '0');
  final end = int.parse(matchResult.group(2) ?? '0');
  final total = int.parse(matchResult.group(3) ?? '0');
  final tempFile = File(tempFilePath);
  final tempFileLength = await tempFile.length();
  log.finest(
      'Resume start=$start, end=$end of total=$total bytes, tempFile = $tempFileLength bytes');
  startByte = start - taskRangeStartByte; // relative to start of range
  if (startByte > tempFileLength) {
    log.fine('Offered range not feasible: $range with startByte $startByte');
    taskException = TaskResumeException(
        'Offered range not feasible: $range with startByte $startByte');
    return false;
  }
  try {
    final file = await tempFile.open(mode: FileMode.writeOnlyAppend);
    await file.truncate(startByte);
    file.close();
  } on FileSystemException {
    log.fine('Could not truncate temp file');
    taskException = TaskResumeException('Could not truncate temp file');
    return false;
  }
  return true;
}

/// Delete the temporary file
void deleteTempFile(String tempFilePath) async {
  try {
    File(tempFilePath).deleteSync();
  } on FileSystemException {
    log.fine('Could not delete temp file $tempFilePath');
  }
}

/// Extract content type from [headers] and set [mimeType] and [charSet]
void extractContentType(Map<String, String> headers) {
  final contentType = headers['content-type'];
  if (contentType != null) {
    final regEx = RegExp(r'(.*);\s*charset\s*=(.*)');
    final match = regEx.firstMatch(contentType);
    if (match != null) {
      mimeType = match.group(1);
      charSet = match.group(2);
    } else {
      mimeType = contentType;
    }
  }
}
