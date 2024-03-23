// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../file_downloader.dart';
import '../task.dart';

/// Interface allowing the [FileDownloader] to signal finished tasks to
/// a [TaskQueue]
abstract interface class TaskQueue {
  /// Signals that [task] has finished
  void taskFinished(Task task);
}

/// TaskQueue that holds all information in memory
class MemoryTaskQueue implements TaskQueue {
  static final _log = Logger('MemoryTaskQueue');
  static const unlimited = 1 << 20;

  /// Tasks waiting to be enqueued, in priority order
  final waiting = PriorityQueue<Task>();

  /// Max number of tasks running concurrently, default is unlimited
  int maxConcurrent = unlimited;

  /// Max number of active tasks connecting to the same host concurrently,
  /// default is unlimited
  int maxConcurrentByHost = unlimited;

  /// Max number of active tasks with the same group concurrently,
  /// default is unlimited
  int maxConcurrentByGroup = unlimited;

  /// Minimum interval between successive enqueues, set to avoid choking the
  /// message loop when adding many tasks
  Duration minInterval = const Duration(milliseconds: 20);

  /// Set of tasks that have been enqueued with the FileDownloader
  final enqueued = <Task>{}; // by TaskId

  var _readyForEnqueue = Completer();

  final _enqueueErrorsStreamController = StreamController<Task>();

  MemoryTaskQueue() {
    _readyForEnqueue.complete();
  }

  /// Add one [task] to the queue and advance the queue if possible
  void add(Task task) {
    waiting.add(task);
    advanceQueue();
  }

  /// Add multiple [tasks] to the queue and advance the queue if possible
  void addAll(Iterable<Task> tasks) {
    waiting.addAll(tasks);
    advanceQueue();
  }

  /// Remove all items in the queue. Does not affect tasks already enqueued
  /// with the [FileDownloader]
  void removeAll() => waiting.removeAll();

  /// remove all waiting tasks matching [taskIds]. Does not affect tasks already enqueued
  /// with the [FileDownloader]
  void removeTasksWithIds(List<String> taskIds) {
    for (final taskId in taskIds) {
      final match = waiting.unorderedElements
          .firstWhereOrNull((task) => task.taskId == taskId);
      if (match != null) {
        waiting.remove(match);
      }
    }
  }

  /// remove all waiting tasks in [group]. Does not affect tasks already enqueued
  /// with the [FileDownloader]
  void removeTasksWithGroup(String group) {
    final tasksToRemove = waiting.unorderedElements
        .where((task) => task.group == group)
        .toList(growable: false);
    for (final task in tasksToRemove) {
      waiting.remove(task);
    }
  }

  /// Remove [task] from the queue. Does not affect tasks already enqueued
  /// with the [FileDownloader]
  void remove(Task task) => waiting.remove(task);

  /// Reset the state of the [TaskQueue].
  ///
  /// Clears the [waiting] queue and resets active tasks to 0
  void reset({String? group}) {
    if (group == null) {
      removeAll();
      enqueued.clear();
    } else {
      removeTasksWithGroup(group);
      final tasksToRemove =
          enqueued.where((task) => task.group != group).toList(growable: false);
      for (final task in tasksToRemove) {
        enqueued.remove(task);
      }
    }
  }

  /// Advance the queue if possible and ready, no-op if not
  ///
  /// After the enqueue, [advanceQueue] is called again to ensure the
  /// next item in the queue is enqueued, so the queue keeps going until
  /// empty, or until it cannot enqueue another task
  void advanceQueue() async {
    if (_readyForEnqueue.isCompleted) {
      final task = getNextTask();
      if (task == null) {
        return;
      }
      _readyForEnqueue = Completer();
      enqueued.add(task);
      enqueue(task).then((success) async {
        if (!success) {
          _log.warning(
              'TaskId ${task.taskId} did not enqueue successfully and will be ignored');
          if (_enqueueErrorsStreamController.hasListener) {
            _enqueueErrorsStreamController.add(task);
          }
        }
        await Future.delayed(minInterval);
        _readyForEnqueue.complete();
      });
      _readyForEnqueue.future.then((_) => advanceQueue());
    }
  }

  /// Get the next waiting task from the queue, or null if not available
  Task? getNextTask() {
    if (numActive >= maxConcurrent) {
      return null;
    }
    final tasksThatHaveToWait = <Task>[];
    while (waiting.isNotEmpty) {
      var task = waiting.removeFirst();
      if (numActiveWithHostname(task.hostName) < maxConcurrentByHost &&
          numActiveWithGroup(task.group) < maxConcurrentByGroup) {
        waiting.addAll(tasksThatHaveToWait); // put back in queue
        return task;
      }
      tasksThatHaveToWait.add(task);
    }
    waiting.addAll(tasksThatHaveToWait); // put back in queue
    return null;
  }

  /// Enqueue the task to the [FileDownloader]
  ///
  /// When using a [MemoryTaskQueue], do not use this method directly. Instead,
  /// add your tasks to the queue using [add] and [addAll], and
  /// let the [MemoryTaskQueue] manage the enqueueing.
  Future<bool> enqueue(Task task) => FileDownloader().enqueue(task);

  /// Task has finished, so remove from active and advance the queue to the
  /// next task if the task was indeed managed by this queue
  @override
  void taskFinished(Task task) {
    if (enqueued.remove(task)) {
      advanceQueue();
    }
  }

  /// Number of active tasks, i.e. enqueued with the FileDownloader and
  /// not yet finished
  int get numActive => enqueued.length;

  /// Returns number of tasks active with this host name
  int numActiveWithHostname(String hostname) => enqueued.fold(
      0,
      (previousValue, task) =>
          task.hostName == hostname ? previousValue + 1 : previousValue);

  /// Returns number of tasks active with this group
  int numActiveWithGroup(String group) => enqueued.fold(
      0,
      (previousValue, task) =>
          task.group == group ? previousValue + 1 : previousValue);

  /// True if queue is empty
  bool get isEmpty => waiting.isEmpty;

  /// Number of tasks waiting to be enqueued
  int get numWaiting => waiting.length;

  /// Number of tasks waiting to be enqueued in [group]
  int numWaitingWithGroup(String group) => waiting.unorderedElements
      .where((element) => element.group == group)
      .length;

  /// Stream with [Task]s that failed to enqueue correctly
  Stream<Task> get enqueueErrors => _enqueueErrorsStreamController.stream;
}
