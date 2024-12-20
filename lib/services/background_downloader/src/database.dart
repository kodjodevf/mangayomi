import 'package:flutter/foundation.dart';

import 'base_downloader.dart';
import 'exceptions.dart';
import 'models.dart';
import 'persistent_storage.dart';
import 'task.dart';

/// Persistent database used for tracking task status and progress.
///
/// Stores [TaskRecord] objects.
///
/// This object is accessed by the [Downloader] and [BaseDownloader]
interface class Database {
  static Database? _instance;
  late final PersistentStorage _storage;

  factory Database(PersistentStorage persistentStorage) {
    _instance ??= Database._internal(persistentStorage);
    return _instance!;
  }

  Database._internal(PersistentStorage persistentStorage) {
    assert(_instance == null);
    _storage = persistentStorage;
  }

  /// Direct access to the [PersistentStorage] object underlying the
  /// database. For testing only
  @visibleForTesting
  PersistentStorage get storage => _storage;

  /// Returns all [TaskRecord]
  ///
  /// Optionally, specify a [group] to filter by
  Future<List<TaskRecord>> allRecords({String? group}) async {
    final allRecords = await _storage.retrieveAllTaskRecords();
    return group == null
        ? allRecords.toList()
        : allRecords.where((element) => element.group == group).toList();
  }

  /// Returns all [TaskRecord] older than [age]
  ///
  /// Optionally, specify a [group] to filter by
  Future<List<TaskRecord>> allRecordsOlderThan(Duration age,
      {String? group}) async {
    final allRecordsInGroup = await allRecords(group: group);
    final now = DateTime.now();
    return allRecordsInGroup
        .where((record) => now.difference(record.task.creationTime) > age)
        .toList();
  }

  /// Returns all [TaskRecord] with [TaskStatus] [status]
  ///
  /// Optionally, specify a [group] to filter by
  Future<List<TaskRecord>> allRecordsWithStatus(TaskStatus status,
      {String? group}) async {
    final allRecordsInGroup = await allRecords(group: group);
    return allRecordsInGroup
        .where((record) => record.status == status)
        .toList();
  }

  /// Return [TaskRecord] for this [taskId] or null if not found
  Future<TaskRecord?> recordForId(String taskId) =>
      _storage.retrieveTaskRecord(taskId);

  /// Return list of [TaskRecord] corresponding to the [taskIds]
  ///
  /// Only records that can be found in the database will be included in the
  /// list. TaskIds that cannot be found will be ignored.
  Future<List<TaskRecord>> recordsForIds(Iterable<String> taskIds) async {
    final result = <TaskRecord>[];
    for (var taskId in taskIds) {
      final record = await recordForId(taskId);
      if (record != null) {
        result.add(record);
      }
    }
    return result;
  }

  /// Delete all records
  ///
  /// Optionally, specify a [group] to filter by
  Future<void> deleteAllRecords({String? group}) async {
    if (group == null) {
      await _storage.removeTaskRecord(null);
      return;
    }
    final allRecordsInGroup = await allRecords(group: group);
    await deleteRecordsWithIds(
        allRecordsInGroup.map((record) => record.taskId));
  }

  /// Delete record with this [taskId]
  Future<void> deleteRecordWithId(String taskId) =>
      deleteRecordsWithIds([taskId]);

  /// Delete records with these [taskIds]
  Future<void> deleteRecordsWithIds(Iterable<String> taskIds) async {
    for (var taskId in taskIds) {
      await _storage.removeTaskRecord(taskId);
    }
  }

  /// Update or insert the record in the database
  ///
  /// This is used by the [FileDownloader] to track tasks, and should not
  /// normally be used by the user of this package
  Future<void> updateRecord(TaskRecord record) async =>
      _storage.storeTaskRecord(record);
}

/// Record containing task, task status and task progress.
///
/// [TaskRecord] represents the state of the task as recorded in persistent
/// storage if [trackTasks] has been called to activate this.
final class TaskRecord {
  final Task task;
  final TaskStatus status;
  final double progress;
  final int expectedFileSize;
  final TaskException? exception;

  TaskRecord(this.task, this.status, this.progress, this.expectedFileSize,
      [this.exception]);

  /// Returns the group collection this record is stored under, which is
  /// the [task]'s [Task.group]
  String get group => task.group;

  /// Returns the record id, which is the [task]'s [Task.taskId]
  String get taskId => task.taskId;

  /// Create [TaskRecord] from [json]
  TaskRecord.fromJson(Map<String, dynamic> json)
      : task = Task.createFromJson(json),
        status = TaskStatus.values[
            (json['status'] as num?)?.toInt() ?? TaskStatus.failed.index],
        progress = (json['progress'] as num?)?.toDouble() ?? progressFailed,
        expectedFileSize = (json['expectedFileSize'] as num?)?.toInt() ?? -1,
        exception = json['exception'] == null
            ? null
            : TaskException.fromJson(json['exception']);

  /// Returns JSON map representation of this [TaskRecord]
  ///
  /// Note the [status], [progress] and [exception] fields are merged into
  /// the JSON map representation of the [task]
  Map<String, dynamic> toJson() {
    final json = task.toJson();
    json['status'] = status.index;
    json['progress'] = progress;
    json['expectedFileSize'] = expectedFileSize;
    json['exception'] = exception?.toJson();
    return json;
  }

  /// Copy with optional replacements. [exception] is always copied
  TaskRecord copyWith(
          {Task? task,
          TaskStatus? status,
          double? progress,
          int? expectedFileSize}) =>
      TaskRecord(
          task ?? this.task,
          status ?? this.status,
          progress ?? this.progress,
          expectedFileSize ?? this.expectedFileSize,
          exception);

  @override
  String toString() {
    return 'DatabaseRecord{task: $task, status: $status, progress: $progress,'
        ' expectedFileSize: $expectedFileSize, exception: $exception}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskRecord &&
          runtimeType == other.runtimeType &&
          task == other.task &&
          status == other.status &&
          progress == other.progress &&
          expectedFileSize == other.expectedFileSize &&
          exception == other.exception;

  @override
  int get hashCode =>
      task.hashCode ^ status.hashCode ^ progress.hashCode ^ exception.hashCode;
}
