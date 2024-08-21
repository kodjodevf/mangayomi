// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:mangayomi/services/background_downloader/src/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../models.dart';
import '../task.dart';
import 'package:mangayomi/services/background_downloader/src/downloader/downloader_http_client.dart';
import 'isolate.dart';

const boundary = '-----background_downloader-akjhfw281onqciyhnIk';
const lineFeed = '\r\n';

/// Do the binary or multi-part upload task
///
/// Sends updates via the [sendPort] and can be commanded to cancel via
/// the [messagesToIsolate] queue
Future<void> doUploadTask(
    UploadTask task, String filePath, SendPort sendPort) async {
  final resultStatus = task.post == 'binary'
      ? await binaryUpload(task, filePath, sendPort)
      : await multipartUpload(task, filePath, sendPort);
  processStatusUpdateInIsolate(task, resultStatus, sendPort);
}

/// Do the binary upload and return the TaskStatus
///
/// Sends updates via the [sendPort] and can be commanded to cancel via
/// the [messagesToIsolate] queue
Future<TaskStatus> binaryUpload(
    UploadTask task, String filePath, SendPort sendPort) async {
  final inFile = File(filePath);
  if (!inFile.existsSync()) {
    logError(task, 'file to upload does not exist: $filePath');
    taskException =
        TaskFileSystemException('File to upload does not exist: $filePath');
    return TaskStatus.failed;
  }
  final fileSize = inFile.lengthSync();
  var resultStatus = TaskStatus.failed;
  try {
    final client = DownloaderHttpClient.httpClient;
    final request =
        http.StreamedRequest(task.httpRequestMethod, Uri.parse(task.url));
    request.headers.addAll(task.headers);
    request.contentLength = fileSize;
    request.headers['Content-Type'] = task.mimeType;
    request.headers['Content-Disposition'] =
        'attachment; filename="${task.filename}"';
    // initiate the request and handle completion async
    final requestCompleter = Completer();
    var transferBytesResult = TaskStatus.failed;
    client.send(request).then((response) async {
      // request completed, so send status update and finish
      resultStatus = transferBytesResult == TaskStatus.complete &&
              !okResponses.contains(response.statusCode)
          ? TaskStatus.failed
          : transferBytesResult;
      responseBody = await responseContent(response);
      responseHeaders = response.headers;
      responseStatusCode = response.statusCode;
      taskException ??= TaskHttpException(
          responseBody?.isNotEmpty == true
              ? responseBody!
              : response.reasonPhrase ?? 'Invalid HTTP response',
          response.statusCode);
      if (response.statusCode == 404) {
        resultStatus = TaskStatus.notFound;
      }
      requestCompleter.complete();
    });
    // send the bytes to the request sink
    final inStream = inFile.openRead();
    transferBytesResult =
        await transferBytes(inStream, request.sink, fileSize, task, sendPort);
    request.sink.close(); // triggers request completion, handled above
    await requestCompleter.future; // wait for request to complete
  } catch (e) {
    resultStatus = TaskStatus.failed;
    setTaskError(e);
  }
  if (isCanceled) {
    // cancellation overrides other results
    resultStatus = TaskStatus.canceled;
  }
  return resultStatus;
}

/// Do the multipart upload and return the TaskStatus
///
/// Sends updates via the [sendPort] and can be commanded to cancel via
/// the [messagesToIsolate] queue
Future<TaskStatus> multipartUpload(
    UploadTask task, String filePath, SendPort sendPort) async {
  // field portion of the multipart, all in one string
  // multiple values should be encoded as '"value1", "value2", ...'
  final multiValueRegEx = RegExp(r'^(?:"[^"]+"\s*,\s*)+"[^"]+"$');
  var fieldsString = '';
  for (var entry in task.fields.entries) {
    if (multiValueRegEx.hasMatch(entry.value)) {
      // extract multiple values from entry.value
      for (final match in RegExp(r'"([^"]+)"').allMatches(entry.value)) {
        fieldsString += fieldEntry(entry.key, match.group(1) ?? 'error');
      }
    } else {
      fieldsString +=
          fieldEntry(entry.key, entry.value); // single value for key
    }
  }
  // File portion of the multi-part
  // Assumes list of files. If only one file, that becomes a list of length one.
  // For each file, determine contentDispositionString, contentTypeString
  // and file length, so that we can calculate total size of upload
  const separator = '$lineFeed--$boundary$lineFeed'; // between files
  const terminator = '$lineFeed--$boundary--$lineFeed'; // after last file
  final filesData = filePath.isNotEmpty
      ? [(task.fileField, filePath, task.mimeType)] // one file Upload case
      : await task.extractFilesData(); // MultiUpload case
  final contentDispositionStrings = <String>[];
  final contentTypeStrings = <String>[];
  final fileLengths = <int>[];
  for (final (fileField, path, mimeType) in filesData) {
    final file = File(path);
    if (!await file.exists()) {
      logError(task, 'File to upload does not exist: $path');
      taskException =
          TaskFileSystemException('File to upload does not exist: $path');
      return TaskStatus.failed;
    }
    contentDispositionStrings.add(
      'Content-Disposition: form-data; name="${browserEncode(fileField)}"; '
      'filename="${browserEncode(p.basename(file.path))}"$lineFeed',
    );
    contentTypeStrings.add('Content-Type: $mimeType$lineFeed$lineFeed');
    fileLengths.add(file.lengthSync());
  }
  final fileDataLength = contentDispositionStrings.fold<int>(
          0, (sum, string) => sum + lengthInBytes(string)) +
      contentTypeStrings.fold<int>(0, (sum, string) => sum + string.length) +
      fileLengths.fold<int>(0, (sum, length) => sum + length) +
      separator.length * contentDispositionStrings.length +
      2;
  final contentLength = lengthInBytes(fieldsString) +
      '--$boundary$lineFeed'.length +
      fileDataLength;
  var resultStatus = TaskStatus.failed;
  try {
    // setup the connection
    final client = DownloaderHttpClient.httpClient;
    final request =
        http.StreamedRequest(task.httpRequestMethod, Uri.parse(task.url));
    request.contentLength = contentLength;
    request.headers.addAll(task.headers);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data; boundary=$boundary',
      'Accept-Charset': 'UTF-8',
      'Connection': 'Keep-Alive',
      'Cache-Control': 'no-cache'
    });
    // initiate the request and handle completion async
    final requestCompleter = Completer();
    var transferBytesResult = TaskStatus.failed;
    client.send(request).then((response) async {
      // request completed, so send status update and finish
      resultStatus = transferBytesResult == TaskStatus.complete &&
              !okResponses.contains(response.statusCode)
          ? TaskStatus.failed
          : transferBytesResult;
      responseBody = await responseContent(response);
      responseHeaders = response.headers;
      responseStatusCode = response.statusCode;
      taskException ??= TaskHttpException(
          responseBody?.isNotEmpty == true
              ? responseBody!
              : response.reasonPhrase ?? 'Invalid HTTP response',
          response.statusCode);
      if (response.statusCode == 404) {
        resultStatus = TaskStatus.notFound;
      }
      requestCompleter.complete();
    });

    // write fields
    request.sink.add(utf8.encode('$fieldsString--$boundary$lineFeed'));
    // write each file
    for (var (index, fileData) in filesData.indexed) {
      request.sink.add(utf8.encode(contentDispositionStrings[index]));
      request.sink.add(utf8.encode(contentTypeStrings[index]));
      // send the bytes to the request sink
      final inStream = File(fileData.$2).openRead();
      transferBytesResult = await transferBytes(
          inStream, request.sink, contentLength, task, sendPort);
      if (transferBytesResult != TaskStatus.complete || isCanceled) {
        break;
      } else {
        request.sink.add(
            utf8.encode(fileData == filesData.last ? terminator : separator));
      }
    }
    request.sink.close(); // triggers request completion, handled above
    await requestCompleter.future; // wait for request to complete
  } catch (e) {
    resultStatus = TaskStatus.failed;
    setTaskError(e);
  }
  if (isCanceled) {
    // cancellation overrides other results
    resultStatus = TaskStatus.canceled;
  }
  return resultStatus;
}
