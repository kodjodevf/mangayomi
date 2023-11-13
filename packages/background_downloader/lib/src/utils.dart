import 'package:logging/logging.dart';

import 'models.dart';

final _log = Logger('FileDownloader');

/// Parses the range in a Range header, and returns a Pair representing
/// the range. The format needs to be "bytes=10-20"
///
/// A missing lower range is substituted with 0, and a missing upper
/// range with null.  If the string cannot be parsed, returns (0, null)
(int, int?) parseRange(String rangeStr) {
  final regex = RegExp(r'bytes=(\d*)-(\d*)');
  final match = regex.firstMatch(rangeStr);
  if (match == null) {
    return (0, null);
  }

  final start = int.tryParse(match.group(1) ?? '') ?? 0;
  final end = int.tryParse(match.group(2) ?? '');
  return (start, end);
}

/// Returns the content length extracted from the [responseHeaders], or from
/// the [task] headers
int getContentLength(Map<String, String> responseHeaders, Task task) {
  // if response provides contentLength, return it
  final contentLength = int.tryParse(responseHeaders['Content-Length'] ??
      responseHeaders['content-length'] ??
      '-1');
  if (contentLength != null && contentLength != -1) {
    return contentLength;
  }
  // try extracting it from Range header
  final taskRangeHeader = task.headers['Range'] ?? task.headers['range'] ?? '';
  final taskRange = parseRange(taskRangeHeader);
  if (taskRange.$2 != null) {
    var rangeLength = taskRange.$2! - taskRange.$1 + 1;
    _log.finest(
        'TaskId ${task.taskId} contentLength set to $rangeLength based on Range header');
    return rangeLength;
  }
  // try extracting it from a special "Known-Content-Length" header
  var knownLength = int.tryParse(task.headers['Known-Content-Length'] ??
          task.headers['known-content-length'] ??
          '-1') ??
      -1;
  if (knownLength != -1) {
    _log.finest(
        'TaskId ${task.taskId} contentLength set to $knownLength based on Known-Content-Length header');
  } else {
    _log.finest('TaskId ${task.taskId} contentLength undetermined');
  }
  return knownLength;
}
