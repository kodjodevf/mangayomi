import 'dart:convert';

import 'base_downloader.dart';
import 'file_downloader.dart';
import 'models.dart';

/// Class representing a chunk of a download and its status
class Chunk {
  // key parameters
  final String parentTaskId;
  final String url;
  final String filename;
  final int fromByte; // start byte
  final int toByte; // end byte
  final DownloadTask task; // task to download this chunk

  // state parameters
  late TaskStatus status;
  late double progress;

  /// Define a chunk by its key parameters, in default state
  ///
  /// This also generates the [task] to download this chunk, and that
  /// task contains the [parentTaskId] and [toByte] and [fromByte] values of the
  /// chunk in its [Task.metaData] field as a JSON encoded map
  Chunk(
      {required Task parentTask,
      required this.url,
      required this.filename,
      required this.fromByte,
      required this.toByte})
      : parentTaskId = parentTask.taskId,
        task = DownloadTask(
            url: url,
            filename: filename,
            headers: {
              ...parentTask.headers,
              'Range': 'bytes=$fromByte-$toByte'
            },
            baseDirectory: BaseDirectory.temporary,
            group: BaseDownloader.chunkGroup,
            updates: updatesBasedOnParent(parentTask),
            retries: parentTask.retries,
            allowPause: parentTask.allowPause,
            priority: parentTask.priority,
            requiresWiFi: parentTask.requiresWiFi,
            metaData: jsonEncode({
              'parentTaskId': parentTask.taskId,
              'from': fromByte,
              'to': toByte
            })) {
    status = TaskStatus.enqueued;
    progress = 0;
  }

  /// Creates object from JsonMap
  Chunk.fromJsonMap(Map<String, dynamic> jsonMap)
      : parentTaskId = jsonMap['parentTaskId'],
        url = jsonMap['url'],
        filename = jsonMap['filename'],
        fromByte = (jsonMap['fromByte'] as num).toInt(),
        toByte = (jsonMap['toByte'] as num).toInt(),
        task = Task.createFromJsonMap(jsonMap['task']) as DownloadTask,
        status = TaskStatus.values[(jsonMap['status'] as num).toInt()],
        progress = (jsonMap['progress'] as num).toDouble();

  /// Revive List<Chunk> from a JSON map in a jsonDecode operation,
  /// where each element is a map representing the [Chunk]
  static Object? listReviver(Object? key, Object? value) =>
      key is int ? Chunk.fromJsonMap(jsonDecode(value as String)) : value;

  /// Creates JSON map of this object
  Map<String, dynamic> toJsonMap() => {
        'parentTaskId': parentTaskId,
        'url': url,
        'filename': filename,
        'fromByte': fromByte,
        'toByte': toByte,
        'task': task.toJsonMap(),
        'status': status.index,
        'progress': progress
      };

  /// Creates JSON String of this object
  String toJson() => jsonEncode(toJsonMap());

  /// Return the parentTaskId embedded in the metaData of a chunkTask
  static String getParentTaskId(Task task) =>
      jsonDecode(task.metaData)['parentTaskId'] as String;

  /// Return [Updates] that is based on the [parentTask]
  static Updates updatesBasedOnParent(Task parentTask) =>
      switch (parentTask.updates) {
        Updates.none || Updates.status => Updates.status,
        Updates.progress ||
        Updates.statusAndProgress =>
          Updates.statusAndProgress
      };
}

/// Resume all chunk tasks associated with this [task], and
/// return true if successful, otherwise cancels this [task]
/// which will also cancel all chunk tasks
Future<bool> resumeChunkTasks(
    ParallelDownloadTask task, ResumeData resumeData) async {
  final chunks =
      List<Chunk>.from(jsonDecode(resumeData.data, reviver: Chunk.listReviver));
  final results = await Future.wait(
      chunks.map((chunk) => FileDownloader().resume(chunk.task)));
  if (results.any((result) => result == false)) {
    // cancel [ParallelDownloadTask] if any resume did not succeed.
    // this will also cancel all chunk tasks
    await FileDownloader().cancelTaskWithId(task.taskId);
    return false;
  }
  return true;
}
