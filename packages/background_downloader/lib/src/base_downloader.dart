import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'database.dart';
import 'exceptions.dart';
import 'models.dart';
import 'persistent_storage.dart';
import 'queue/task_queue.dart';
import 'web_downloader.dart'
    if (dart.library.io) 'desktop/desktop_downloader.dart';

/// Common download functionality
///
/// Concrete subclass will implement platform-specific functionality, eg
/// [DesktopDownloader] for dart based desktop platforms, and
/// [NativeDownloader] for iOS and Android
///
/// The common functionality mostly relates to:
/// - callback handling (for groups of tasks registered via the [FileDownloader])
/// - tasks waiting to retry and retry handling
/// - Task updates provided to the [FileDownloader]
/// - Pause/resume status and information
abstract base class BaseDownloader {
  final log = Logger('BaseDownloader');

  static const databaseVersion = 1;

  /// Special group name for tasks that download a chunk, as part of a
  /// [ParallelDownloadTask]
  static const chunkGroup = 'chunk';

  /// Persistent storage
  late final PersistentStorage _storage;
  late final Database database;

  final tasksWaitingToRetry = <Task>{};

  /// Registered [TaskStatusCallback] for each group
  final groupStatusCallbacks = <String, TaskStatusCallback>{};

  /// Registered [TaskProgressCallback] for each group
  final groupProgressCallbacks = <String, TaskProgressCallback>{};

  /// Registered [TaskNotificationTapCallback] for each group
  final groupNotificationTapCallbacks = <String, TaskNotificationTapCallback>{};

  /// List of notification configurations
  final notificationConfigs = <TaskNotificationConfig>[];

  /// StreamController for [TaskUpdate] updates
  var updates = StreamController<TaskUpdate>();

  /// Groups tracked in persistent database
  final trackedGroups = <String?>{};

  /// Map of tasks and completer to indicate whether task can be resumed
  final canResumeTask = <Task, Completer<bool>>{};

  /// Flag indicating we have retrieved missed data
  var _retrievedLocallyStoredData = false;

  /// Connected TaskQueues that will receive a signal upon task completion
  final taskQueues = <TaskQueue>[];

  BaseDownloader();

  factory BaseDownloader.instance(
      PersistentStorage persistentStorage, Database database) {
    final instance = DesktopDownloader();
    instance._storage = persistentStorage;
    instance.database = database;
    unawaited(instance.initialize());
    return instance;
  }

  /// Initialize
  ///
  /// Initializes the PersistentStorage instance and if necessary perform database
  /// migration, then initializes the subclassed implementation for
  /// desktop or native
  @mustCallSuper
  Future<void> initialize() => _storage.initialize();

  /// Configures the downloader
  ///
  /// Configuration is either a single configItem or a list of configItems.
  /// Each configItem is a (String, dynamic) where the String is the config
  /// type and 'dynamic' can be any appropriate parameter, including another Record.
  /// [globalConfig] is routed to every platform, whereas the platform specific
  /// ones only get routed to that platform, after the global configs have
  /// completed.
  /// If a config type appears more than once, they will all be executed in order,
  /// with [globalConfig] executed before the platform-specific config.
  ///
  /// Returns a list of (String, String) which is the config type and a response
  /// which is empty if OK, 'not implemented' if the item could not be recognized and
  /// processed, or may contain other error/warning information
  Future<List<(String, String)>> configure(
      {dynamic globalConfig,
      dynamic androidConfig,
      dynamic iOSConfig,
      dynamic desktopConfig}) async {
    final global = globalConfig is List ? globalConfig : [globalConfig];
    final rawPlatformConfig = platformConfig(
        androidConfig: androidConfig,
        iOSConfig: iOSConfig,
        desktopConfig: desktopConfig);
    final platform =
        rawPlatformConfig is List ? rawPlatformConfig : [rawPlatformConfig];
    return await Future.wait([...global, ...platform]
        .where((e) => e != null)
        .map((e) => configureItem(e)));
  }

  /// Returns the config for the platform, e.g. the [androidConfig] parameter
  /// on Android
  dynamic platformConfig(
      {dynamic globalConfig,
      dynamic androidConfig,
      dynamic iOSConfig,
      dynamic desktopConfig});

  /// Configures one [configItem] and returns the (String, String) result
  ///
  /// If the second element is 'ignored' then the method did not act on
  /// the [configItem]
  Future<(String, String)> configureItem((String, dynamic) configItem);

  /// Retrieve data that was stored locally because it could not be
  /// delivered to the downloader
  Future<void> retrieveLocallyStoredData() async {
    if (!_retrievedLocallyStoredData) {
      final resumeDataMap = await popUndeliveredData(Undelivered.resumeData);
      for (var taskId in resumeDataMap.keys) {
        // map is <taskId, ResumeData>
        final resumeData = ResumeData.fromJsonMap(resumeDataMap[taskId]);
        await setResumeData(resumeData);
        await setPausedTask(resumeData.task);
      }
      final statusUpdateMap =
          await popUndeliveredData(Undelivered.statusUpdates);
      for (var taskId in statusUpdateMap.keys) {
        // map is <taskId, Task/TaskStatus> where TaskStatus is added to Task JSON
        final payload = statusUpdateMap[taskId];
        processStatusUpdate(TaskStatusUpdate.fromJsonMap(payload));
      }
      final progressUpdateMap =
          await popUndeliveredData(Undelivered.progressUpdates);
      for (var taskId in progressUpdateMap.keys) {
        // map is <taskId, Task/progress> where progress is added to Task JSON
        final payload = progressUpdateMap[taskId];
        processProgressUpdate(TaskProgressUpdate.fromJsonMap(payload));
      }
      _retrievedLocallyStoredData = true;
    }
  }

  /// Returns the [TaskNotificationConfig] for this [task] or null
  ///
  /// Matches on task, then on group, then on default
  TaskNotificationConfig? notificationConfigForTask(Task task) {
    if (task.group == chunkGroup) {
      return null;
    }
    return notificationConfigs
            .firstWhereOrNull((config) => config.taskOrGroup == task) ??
        notificationConfigs
            .firstWhereOrNull((config) => config.taskOrGroup == task.group) ??
        notificationConfigs
            .firstWhereOrNull((config) => config.taskOrGroup == null);
  }

  /// Enqueue the task
  @mustCallSuper
  Future<bool> enqueue(Task task) async {
    if (task.allowPause) {
      canResumeTask[task] = Completer();
    }
    return true;
  }

  /// Resets the download worker by cancelling all ongoing tasks for the group
  ///
  ///  Returns the number of tasks canceled
  @mustCallSuper
  Future<int> reset(String group) async {
    final retryCount =
        tasksWaitingToRetry.where((task) => task.group == group).length;
    tasksWaitingToRetry.removeWhere((task) => task.group == group);
    final pausedTasks = await getPausedTasks();
    var pausedCount = 0;
    for (var task in pausedTasks) {
      if (task.group == group) {
        await removePausedTask(task.taskId);
        pausedCount++;
      }
    }
    return retryCount + pausedCount;
  }

  /// Returns a list of all tasks in progress, matching [group]
  @mustCallSuper
  Future<List<Task>> allTasks(
      String group, bool includeTasksWaitingToRetry) async {
    final tasks = <Task>[];
    if (includeTasksWaitingToRetry) {
      tasks.addAll(tasksWaitingToRetry.where((task) => task.group == group));
    }
    final pausedTasks = await getPausedTasks();
    tasks.addAll(pausedTasks.where((task) => task.group == group));
    return tasks;
  }

  /// Cancels ongoing tasks whose taskId is in the list provided with this call
  ///
  /// Returns true if all cancellations were successful
  @mustCallSuper
  Future<bool> cancelTasksWithIds(List<String> taskIds) async {
    final matchingTasksWaitingToRetry = tasksWaitingToRetry
        .where((task) => taskIds.contains(task.taskId))
        .toList(growable: false);
    final matchingTaskIdsWaitingToRetry = matchingTasksWaitingToRetry
        .map((task) => task.taskId)
        .toList(growable: false);
    // remove tasks waiting to retry from the list so they won't be retried
    for (final task in matchingTasksWaitingToRetry) {
      tasksWaitingToRetry.remove(task);
      processStatusUpdate(TaskStatusUpdate(task, TaskStatus.canceled));
      processProgressUpdate(TaskProgressUpdate(task, progressCanceled));
    }
    final remainingTaskIds = taskIds
        .where((taskId) => !matchingTaskIdsWaitingToRetry.contains(taskId));
    // cancel paused tasks
    final pausedTasks = await getPausedTasks();
    final pausedTaskIdsToCancel = pausedTasks
        .where((task) => remainingTaskIds.contains(task.taskId))
        .map((e) => e.taskId)
        .toList(growable: false);
    await cancelPausedPlatformTasksWithIds(pausedTasks, pausedTaskIdsToCancel);
    // cancel remaining taskIds on the platform
    final platformTaskIds = remainingTaskIds
        .where((taskId) => !pausedTaskIdsToCancel.contains(taskId))
        .toList(growable: false);
    if (platformTaskIds.isEmpty) {
      return true;
    }
    return cancelPlatformTasksWithIds(platformTaskIds);
  }

  /// Cancel these tasks on the platform
  Future<bool> cancelPlatformTasksWithIds(List<String> taskIds);

  /// Cancel paused tasks
  ///
  /// Deletes the associated temp file and emits [TaskStatus.cancel]
  Future<void> cancelPausedPlatformTasksWithIds(
      List<Task> pausedTasks, List<String> taskIds) async {
    for (final taskId in taskIds) {
      final task =
          pausedTasks.firstWhereOrNull((element) => element.taskId == taskId);
      if (task != null) {
        final resumeData = await getResumeData(task.taskId);
        if (!Platform.isIOS && resumeData != null) {
          final tempFilePath = resumeData.tempFilepath;
          try {
            await File(tempFilePath).delete();
          } on FileSystemException {
            log.fine('Could not delete temp file $tempFilePath');
          }
        }
        processStatusUpdate(TaskStatusUpdate(task, TaskStatus.canceled));
        processProgressUpdate(TaskProgressUpdate(task, progressCanceled));
      }
    }
  }

  /// Returns Task for this taskId, or nil
  @mustCallSuper
  Future<Task?> taskForId(String taskId) async {
    try {
      return tasksWaitingToRetry.where((task) => task.taskId == taskId).first;
    } on StateError {
      try {
        final pausedTasks = await getPausedTasks();
        return pausedTasks.where((task) => task.taskId == taskId).first;
      } on StateError {
        return null;
      }
    }
  }

  /// Activate tracking for tasks in this group
  ///
  /// All subsequent tasks in this group will be recorded in persistent storage
  /// and can be queried with methods that include 'tracked', e.g.
  /// [allTrackedTasks]
  ///
  /// If [markDownloadedComplete] is true (default) then all tasks that are
  /// marked as not yet [TaskStatus.complete] will be set to complete if the
  /// target file for that task exists, and will emit [TaskStatus.complete]
  /// and [progressComplete] to their registered listener or callback.
  /// This is a convenient way to capture downloads that have completed while
  /// the app was suspended, provided you have registered your listeners
  /// or callback before calling this.
  Future<void> trackTasks(String? group, bool markDownloadedComplete) async {
    trackedGroups.add(group);
    if (markDownloadedComplete) {
      final records = await database.allRecords(group: group);
      for (var record in records.where((record) =>
          record.task is DownloadTask &&
          record.status != TaskStatus.complete)) {
        final filePath = await record.task.filePath();
        if (await File(filePath).exists()) {
          processStatusUpdate(
              TaskStatusUpdate(record.task, TaskStatus.complete));
          final updatedRecord = record.copyWith(
              status: TaskStatus.complete, progress: progressComplete);
          await database.updateRecord(updatedRecord);
        }
      }
    }
  }

  /// Attempt to pause this [task]
  ///
  /// Returns true if successful
  Future<bool> pause(Task task);

  /// Attempt to resume this [task]
  ///
  /// Returns true if successful
  @mustCallSuper
  Future<bool> resume(Task task) async {
    await removePausedTask(task.taskId);
    if (await getResumeData(task.taskId) != null) {
      final currentCompleter = canResumeTask[task];
      if (currentCompleter == null || currentCompleter.isCompleted) {
        // create if didn't exist or was completed
        canResumeTask[task] = Completer();
      }
      return true;
    }
    return false;
  }

  /// Sets the 'canResumeTask' flag for this task
  ///
  /// Completes the completer already associated with this task
  /// if it wasn't completed already
  void setCanResume(Task task, bool canResume) {
    if (canResumeTask[task]?.isCompleted == false) {
      canResumeTask[task]?.complete(canResume);
    }
  }

  /// Returns a Future that indicates whether this task can be resumed
  ///
  /// If we have stored [ResumeData] this is true
  /// If we have completer then we return its future
  /// Otherwise we return false
  Future<bool> taskCanResume(Task task) async {
    if (await getResumeData(task.taskId) != null) {
      return true;
    }
    if (canResumeTask.containsKey(task)) {
      return canResumeTask[task]!.future;
    }
    return false;
  }

  /// Stores the resume data
  Future<void> setResumeData(ResumeData resumeData) =>
      _storage.storeResumeData(resumeData);

  /// Retrieve the resume data for this [taskId]
  Future<ResumeData?> getResumeData(String taskId) =>
      _storage.retrieveResumeData(taskId);

  /// Remove resumeData for this [taskId], or all if null
  Future<void> removeResumeData([String? taskId]) =>
      _storage.removeResumeData(taskId);

  /// Store the paused [task]
  Future<void> setPausedTask(Task task) => _storage.storePausedTask(task);

  /// Return a stored paused task with this [taskId], or null if not found
  Future<Task?> getPausedTask(String taskId) =>
      _storage.retrievePausedTask(taskId);

  /// Return a list of paused [Task] objects
  Future<List<Task>> getPausedTasks() => _storage.retrieveAllPausedTasks();

  /// Remove paused task for this taskId, or all if null
  Future<void> removePausedTask([String? taskId]) =>
      _storage.removePausedTask(taskId);

  /// Retrieve data that was not delivered to Dart
  Future<Map<String, dynamic>> popUndeliveredData(Undelivered dataType);

  /// Clear pause and resume info associated with this [task]
  void _clearPauseResumeInfo(Task task) {
    canResumeTask.remove(task);
    removeResumeData(task.taskId);
    removePausedTask(task.taskId);
  }

  /// Move the file at [filePath] to the shared storage
  /// [destination] and potential subdirectory [directory]
  ///
  /// Returns the path to the file in shared storage, or null
  Future<String?> moveToSharedStorage(String filePath,
      SharedStorage destination, String directory, String? mimeType) {
    return Future.value(null);
  }

  /// Returns the path to the file at [filePath] in shared storage
  /// [destination] and potential subdirectory [directory], or null
  Future<String?> pathInSharedStorage(
      String filePath, SharedStorage destination, String directory) {
    return Future.value(null);
  }

  /// Open the file represented by [task] or [filePath] using the application
  /// available on the platform.
  ///
  /// [mimeType] may override the mimetype derived from the file extension,
  /// though implementation depends on the platform and may not always work.
  ///
  /// Returns true if an application was launched successfully
  ///
  /// Precondition: either task or filename is not null
  Future<bool> openFile(Task? task, String? filePath, String? mimeType);

  /// Stores modified [modifiedTask] in local storage if [Task.group]
  /// or [Task.updates] fields differ from [originalTask]
  ///
  /// Modification happens in convenience functions, and storing the modified
  /// version allows us to replace the original when used in pause/resume
  /// functionality. Without this, a convenience download may not be able to
  /// resume using the original [modifiedTask] object (as the [Task.group]
  /// and [Task.updates] fields may have been modified)
  Future<void> setModifiedTask(Task modifiedTask, Task originalTask) async {
    if (modifiedTask.group != originalTask.group ||
        modifiedTask.updates != originalTask.updates) {
      await _storage.storeModifiedTask(modifiedTask);
    }
  }

  // Testing methods

  /// Get the duration for a task to timeout - Android only, for testing
  @visibleForTesting
  Future<Duration> getTaskTimeout();

  /// Set forceFailPostOnBackgroundChannel for native downloader
  @visibleForTesting
  Future<void> setForceFailPostOnBackgroundChannel(bool value);

  /// Test suggested filename based on task and content disposition header
  @visibleForTesting
  Future<String> testSuggestedFilename(
      DownloadTask task, String contentDisposition);

  // Helper methods

  /// Retrieves modified version of the [originalTask] or null
  ///
  /// See [setModifiedTask]
  Future<Task?> getModifiedTask(Task originalTask) =>
      _storage.retrieveModifiedTask(originalTask.taskId);

  /// Remove modified [task], or all if null
  Future<void> removeModifiedTask([Task? task]) =>
      _storage.removeModifiedTask(task?.taskId);

  /// Closes the [updates] stream and re-initializes the [StreamController]
  /// such that the stream can be listened to again
  Future<void> resetUpdatesStreamController() async {
    if (updates.hasListener && !updates.isPaused) {
      await updates.close();
    }
    updates = StreamController();
  }

  /// Process status update coming from Downloader and emit to listener
  ///
  /// Also manages retries ([tasksWaitingToRetry] and delay) and pause/resume
  /// ([pausedTasks] and [_clearPauseResumeInfo]
  void processStatusUpdate(TaskStatusUpdate update) {
    // Normal status updates are only sent here when the task is expected
    // to provide those.  The exception is a .failed status when a task
    // has retriesRemaining > 0: those are always sent here, and are
    // intercepted to hold the task and reschedule in the near future
    final task = update.task;
    if (update.status == TaskStatus.failed && task.retriesRemaining > 0) {
      _emitStatusUpdate(TaskStatusUpdate(task, TaskStatus.waitingToRetry));
      _emitProgressUpdate(TaskProgressUpdate(task, progressWaitingToRetry));
      task.decreaseRetriesRemaining();
      tasksWaitingToRetry.add(task);
      final waitTime = Duration(
          seconds: 2 << min(task.retries - task.retriesRemaining - 1, 8));
      log.finer('TaskId ${task.taskId} failed, waiting ${waitTime.inSeconds}'
          ' seconds before retrying. ${task.retriesRemaining}'
          ' retries remaining');
      Future.delayed(waitTime, () async {
        // after delay, resume or enqueue task again if it's still waiting
        if (tasksWaitingToRetry.remove(task)) {
          if (!((await getResumeData(task.taskId) != null &&
                  await resume(task)) ||
              await enqueue(task))) {
            log.warning(
                'Could not resume/enqueue taskId ${task.taskId} after retry timeout');
            removeModifiedTask(task);
            _clearPauseResumeInfo(task);
            _emitStatusUpdate(TaskStatusUpdate(
                task,
                TaskStatus.failed,
                TaskException(
                    'Could not resume/enqueue taskId${task.taskId} after retry timeout')));
            _emitProgressUpdate(TaskProgressUpdate(task, progressFailed));
          }
        }
      });
    } else {
      // normal status update
      if (update.status == TaskStatus.paused) {
        setPausedTask(task);
      }
      if (update.status.isFinalState) {
        removeModifiedTask(task);
        _clearPauseResumeInfo(task);
      }
      if (update.status.isFinalState || update.status == TaskStatus.paused) {
        notifyTaskQueues(task);
      }
      _emitStatusUpdate(update);
    }
  }

  /// Process progress update coming from Downloader to client listener
  void processProgressUpdate(TaskProgressUpdate update) {
    switch (update.progress) {
      case progressComplete:
      case progressFailed:
      case progressNotFound:
      case progressCanceled:
      case progressPaused:
        notifyTaskQueues(update.task);

      default:
      // no-op
    }
    _emitProgressUpdate(update);
  }

  /// Notify all [taskQueues] that this task has finished
  void notifyTaskQueues(Task task) {
    for (var taskQueue in taskQueues) {
      taskQueue.taskFinished(task);
    }
  }

  /// Process user tapping on a notification
  ///
  /// Because a notification tap may cause the app to start from scratch, we
  /// allow a few retries with backoff to let the app register a callback
  Future<void> processNotificationTap(
      Task task, NotificationType notificationType) async {
    var retries = 0;
    var success = false;
    while (retries < 5 && !success) {
      final notificationTapCallback = groupNotificationTapCallbacks[task.group];
      if (notificationTapCallback != null) {
        notificationTapCallback(task, notificationType);
        success = true;
      } else {
        await Future.delayed(
            Duration(milliseconds: 100 * pow(2, retries).round()));
        retries++;
      }
    }
  }

  /// Emits the status update for this task to its callback or listener, and
  /// update the task in the database
  void _emitStatusUpdate(TaskStatusUpdate update) {
    final task = update.task;
    _updateTaskInDatabase(task,
        status: update.status, taskException: update.exception);
    if (task.providesStatusUpdates) {
      final taskStatusCallback = groupStatusCallbacks[task.group];
      if (taskStatusCallback != null) {
        taskStatusCallback(update);
      } else {
        if (updates.hasListener) {
          updates.add(update);
        } else {
          log.warning('Requested status updates for task ${task.taskId} in '
              'group ${task.group} but no TaskStatusCallback '
              'was registered, and there is no listener to the '
              'updates stream');
        }
      }
    }
  }

  /// Emit the progress update for this task to its callback or listener, and
  /// update the task in the database
  void _emitProgressUpdate(TaskProgressUpdate update) {
    final task = update.task;
    if (task.providesProgressUpdates) {
      _updateTaskInDatabase(task,
          progress: update.progress, expectedFileSize: update.expectedFileSize);
      final taskProgressCallback = groupProgressCallbacks[task.group];
      if (taskProgressCallback != null) {
        taskProgressCallback(update);
      } else if (updates.hasListener) {
        updates.add(update);
      } else {
        log.warning('Requested progress updates for task ${task.taskId} in '
            'group ${task.group} but no TaskProgressCallback '
            'was registered, and there is no listener to the '
            'updates stream');
      }
    }
  }

  /// Insert or update the [TaskRecord] in the tracking database
  Future<void> _updateTaskInDatabase(Task task,
      {TaskStatus? status,
      double? progress,
      int expectedFileSize = -1,
      TaskException? taskException}) async {
    if (trackedGroups.contains(null) || trackedGroups.contains(task.group)) {
      if (status == null && progress != null) {
        // update existing record with progress only (provided it's not 'paused')
        final existingRecord = await database.recordForId(task.taskId);
        if (existingRecord != null && progress != progressPaused) {
          database.updateRecord(existingRecord.copyWith(progress: progress));
        }
        return;
      }
      if (progress == null && status != null) {
        // set progress based on status
        progress = switch (status) {
          TaskStatus.enqueued || TaskStatus.running => 0.0,
          TaskStatus.complete => progressComplete,
          TaskStatus.notFound => progressNotFound,
          TaskStatus.failed => progressFailed,
          TaskStatus.canceled => progressCanceled,
          TaskStatus.waitingToRetry => progressWaitingToRetry,
          TaskStatus.paused => progressPaused
        };
      }
      if (status != TaskStatus.paused) {
        database.updateRecord(TaskRecord(
            task, status!, progress!, expectedFileSize, taskException));
      } else {
        // if paused, don't modify the stored progress
        final existingRecord = await database.recordForId(task.taskId);
        database.updateRecord(TaskRecord(task, status!,
            existingRecord?.progress ?? 0, expectedFileSize, taskException));
      }
    }
  }

  /// Destroy - clears callbacks, updates stream and retry queue
  ///
  /// Clears all queues and references without sending cancellation
  /// messages or status updates
  @mustCallSuper
  void destroy() {
    tasksWaitingToRetry.clear();
    groupStatusCallbacks.clear();
    groupProgressCallbacks.clear();
    notificationConfigs.clear();
    trackedGroups.clear();
    canResumeTask.clear();
    removeResumeData(); // removes all
    removePausedTask(); // removes all
    removeModifiedTask(); // removes all
    resetUpdatesStreamController();
  }
}
