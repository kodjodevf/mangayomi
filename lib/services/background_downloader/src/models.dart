import 'dart:convert';

import 'exceptions.dart';
import 'task.dart';

/// Defines a set of possible states which a [Task] can be in.
enum TaskStatus {
  /// Task is enqueued on the native platform and waiting to start
  ///
  /// It may wait for resources, or for an appropriate network to become
  /// available before starting the actual download and changing state to
  /// `running`.
  enqueued,

  /// Task is running, i.e. actively downloading
  running,

  /// Task has completed successfully
  ///
  /// This is a final state
  complete,

  /// Task has completed because the url was not found (Http status code 404)
  ///
  /// This is a final state
  notFound,

  /// Task has failed due to an exception
  ///
  /// This is a final state
  failed,

  /// Task has been canceled by the user or the system
  ///
  /// This is a final state
  canceled,

  /// Task failed, and is now waiting to retry
  ///
  /// The task is held in this state until the exponential backoff time for
  /// this retry has passed, and will then be rescheduled on the native
  /// platform, switching state to `enqueued` and then `running`
  waitingToRetry,

  /// Task is in paused state and may be able to resume
  ///
  /// To resume a paused Task, call [resumeTaskWithId]. If the resume is
  /// possible, status will change to [TaskStatus.running] and continue from
  /// there. If resume fails (e.g. because the temp file with the partial
  /// download has been deleted by the operating system) status will switch
  /// to [TaskStatus.failed]
  paused;

  /// True if this state is one of the 'final' states, meaning no more
  /// state changes are possible
  bool get isFinalState {
    switch (this) {
      case TaskStatus.complete:
      case TaskStatus.notFound:
      case TaskStatus.failed:
      case TaskStatus.canceled:
        return true;

      case TaskStatus.enqueued:
      case TaskStatus.running:
      case TaskStatus.waitingToRetry:
      case TaskStatus.paused:
        return false;
    }
  }

  /// True if this state is not a 'final' state, meaning more
  /// state changes are possible
  bool get isNotFinalState => !isFinalState;
}

/// Base directory in which files will be stored, based on their relative
/// path.
///
/// These correspond to the directories provided by the path_provider package
enum BaseDirectory {
  /// As returned by getApplicationDocumentsDirectory()
  applicationDocuments,

  /// As returned by getTemporaryDirectory()
  temporary,

  /// As returned by getApplicationSupportDirectory()
  applicationSupport,

  /// As returned by getApplicationLibrary() on iOS. For other platforms
  /// this resolves to the subdirectory 'Library' created in the directory
  /// returned by getApplicationSupportDirectory()
  applicationLibrary,

  /// System root directory. This allows you to set a path to any directory
  /// via [Task.directory]. Only use this if you are certain that this
  /// path is stable. on iOS and Android, references to paths within
  /// the application's directory structure are *not* stable, and you
  /// should use [applicationDocuments], [applicationSupport] or
  /// [applicationLibrary] instead to avoid errors.
  root
}

/// Type of updates requested for a task or group of tasks
enum Updates {
  /// no status change or progress updates
  none,

  /// only status changes
  status,

  /// only progress updates while downloading, no status change updates
  progress,

  /// Status change updates and progress updates while downloading
  statusAndProgress,
}

/// Signature for a function you can register to be called
/// when the status of a [task] changes.
typedef TaskStatusCallback = void Function(TaskStatusUpdate update);

/// Signature for a function you can register to be called
/// for every progress change of a [task].
///
/// A successfully completed task will always finish with progress 1.0
/// [TaskStatus.failed] results in progress -1.0
/// [TaskStatus.canceled] results in progress -2.0
/// [TaskStatus.notFound] results in progress -3.0
/// [TaskStatus.waitingToRetry] results in progress -4.0
/// These constants are available as [progressFailed] etc
typedef TaskProgressCallback = void Function(TaskProgressUpdate update);

/// Signature for function you can register to be called when a notification
/// is tapped by the user
typedef TaskNotificationTapCallback = void Function(
    Task task, NotificationType notificationType);

/// Signature for a function you can provide to the [downloadBatch] or
/// [uploadBatch] that will be called upon completion of each task
/// in the batch.
///
/// [succeeded] will count the number of successful downloads, and
/// [failed] counts the number of failed downloads (for any reason).
typedef BatchProgressCallback = void Function(int succeeded, int failed);

/// Contains tasks and results related to a batch of tasks
class Batch {
  final List<Task> tasks;
  final BatchProgressCallback? batchProgressCallback;
  final results = <Task, TaskStatus>{};

  Batch(this.tasks, this.batchProgressCallback);

  /// Returns an Iterable with successful tasks in this batch
  Iterable<Task> get succeeded => results.entries
      .where((entry) => entry.value == TaskStatus.complete)
      .map((e) => e.key);

  /// Returns the number of successful tasks in this batch
  int get numSucceeded =>
      results.values.where((result) => result == TaskStatus.complete).length;

  /// Returns an Iterable with failed tasks in this batch
  Iterable<Task> get failed => results.entries
      .where((entry) => entry.value != TaskStatus.complete)
      .map((e) => e.key);

  /// Returns the number of failed downloads in this batch
  int get numFailed => results.values.length - numSucceeded;
}

/// Base class for updates related to [task]. Actual updates are
/// either a status update or a progress update.
///
/// When receiving an update, test if the update is a
/// [TaskStatusUpdate] or a [TaskProgressUpdate]
/// and treat the update accordingly
sealed class TaskUpdate {
  final Task task;

  const TaskUpdate(this.task);

  /// Create object from [json]
  TaskUpdate.fromJson(Map<String, dynamic> json)
      : task = Task.createFromJson(json['task'] ?? json);

  /// Return JSON Map representing object
  Map<String, dynamic> toJson() => {'task': task.toJson()};
}

/// A status update
///
/// Contains [TaskStatus] and, if [TaskStatus.failed] possibly a
/// [TaskException] and if this is a final state possibly [responseBody],
/// [responseHeaders], [responseStatusCode], [mimeType] and [charSet].
/// Note: header names in [responseHeaders] are converted to lowercase
class TaskStatusUpdate extends TaskUpdate {
  final TaskStatus status;
  final TaskException? exception;
  final String? responseBody;
  final int? responseStatusCode;
  final Map<String, String>? responseHeaders;
  final String? mimeType; // derived from Content-Type header
  final String? charSet; // derived from Content-Type header

  const TaskStatusUpdate(super.task, this.status,
      [this.exception,
      this.responseBody,
      this.responseHeaders,
      this.responseStatusCode,
      this.mimeType,
      this.charSet]);

  /// Create object from [json]
  TaskStatusUpdate.fromJson(super.json)
      : status = TaskStatus.values[(json['taskStatus'] as num?)?.toInt() ?? 0],
        exception = json['exception'] != null
            ? TaskException.fromJson(json['exception'])
            : null,
        responseBody = json['responseBody'],
        responseHeaders = json['responseHeaders'],
        responseStatusCode = json['responseStatusCode'],
        mimeType = json['mimeType'],
        charSet = json['charSet'],
        super.fromJson();

  /// Create object from [jsonString]
  factory TaskStatusUpdate.fromJsonString(String jsonString) =>
      TaskStatusUpdate.fromJson(jsonDecode(jsonString));

  /// Return JSON Map representing object
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'taskStatus': status.index,
        'exception': exception?.toJson(),
        'responseBody': responseBody,
        'responseHeaders': responseHeaders,
        'responseStatusCode': responseStatusCode,
        'mimeType': mimeType,
        'charSet': charSet
      };

  TaskStatusUpdate copyWith(
          {Task? task,
          TaskStatus? status,
          TaskException? exception,
          String? responseBody,
          Map<String, String>? responseHeaders,
          int? responseStatusCode,
          String? mimeType,
          String? charSet}) =>
      TaskStatusUpdate(
          task ?? this.task,
          status ?? this.status,
          exception ?? this.exception,
          responseBody ?? this.responseBody,
          responseHeaders ?? this.responseHeaders,
          responseStatusCode ?? this.responseStatusCode,
          mimeType ?? this.mimeType,
          charSet ?? this.charSet);
}

/// A progress update
///
/// A successfully downloaded task will always finish with progress 1.0
///
/// [TaskStatus.failed] results in progress -1.0
/// [TaskStatus.canceled] results in progress -2.0
/// [TaskStatus.notFound] results in progress -3.0
/// [TaskStatus.waitingToRetry] results in progress -4.0
///
/// [expectedFileSize] will only be representative if the 0 < [progress] < 1,
/// so NOT representative when progress == 0 or progress == 1, and
/// will be -1 if the file size is not provided by the server or otherwise
/// not known.
/// [networkSpeed] is valid if positive, expressed in MB/second
/// [timeRemaining] is valid if positive
///
/// Use the [has...] getters to determine whether a field is valid
class TaskProgressUpdate extends TaskUpdate {
  final double progress;
  final int expectedFileSize;
  final double networkSpeed; // in MB/s
  final Duration timeRemaining;

  const TaskProgressUpdate(super.task, this.progress,
      [this.expectedFileSize = -1,
      this.networkSpeed = -1,
      this.timeRemaining = const Duration(seconds: -1)]);

  /// Create object from [json]
  TaskProgressUpdate.fromJson(super.json)
      : progress = (json['progress'] as num?)?.toDouble() ?? progressFailed,
        expectedFileSize = (json['expectedFileSize'] as num?)?.toInt() ?? -1,
        networkSpeed = (json['networkSpeed'] as num?)?.toDouble() ?? -1,
        timeRemaining =
            Duration(seconds: (json['timeRemaining'] as num?)?.toInt() ?? -1),
        super.fromJson();

  /// Create object from [jsonString]
  factory TaskProgressUpdate.fromJsonString(String jsonString) =>
      TaskProgressUpdate.fromJson(jsonDecode(jsonString));

  /// Return JSON Map representing object
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'progress': progress,
        'expectedFileSize': expectedFileSize,
        'networkSpeed': networkSpeed,
        'timeRemaining': timeRemaining.inSeconds
      };

  /// If true, [expectedFileSize] contains a valid value
  bool get hasExpectedFileSize => expectedFileSize >= 0;

  /// If true, [networkSpeed] contains a valid value
  bool get hasNetworkSpeed => networkSpeed >= 0;

  /// If true, [timeRemaining] contains a valid value
  bool get hasTimeRemaining => !timeRemaining.isNegative;

  /// String is '-- MB/s' if N/A, otherwise in MB/s or kB/s
  String get networkSpeedAsString => switch (networkSpeed) {
        <= 0 => '-- MB/s',
        >= 1 => '${networkSpeed.round()} MB/s',
        _ => '${(networkSpeed * 1000).round()} kB/s'
      };

  /// String is '--:--' if N/A, otherwise HH:MM:SS or MM:SS
  String get timeRemainingAsString => switch (timeRemaining.inSeconds) {
        <= 0 => '--:--',
        < 3600 => '${timeRemaining.inMinutes.toString().padLeft(2, "0")}'
            ':${timeRemaining.inSeconds.remainder(60).toString().padLeft(2, "0")}',
        _ => '${timeRemaining.inHours}'
            ':${timeRemaining.inMinutes.remainder(60).toString().padLeft(2, "0")}'
            ':${timeRemaining.inSeconds.remainder(60).toString().padLeft(2, "0")}'
      };

  @override
  String toString() {
    return 'TaskProgressUpdate{progress: $progress, expectedFileSize: $expectedFileSize, networkSpeed: $networkSpeed, timeRemaining: $timeRemaining}';
  }
}

// Progress values representing a status
const progressRunning = 0.0;
const progressComplete = 1.0;
const progressFailed = -1.0;
const progressCanceled = -2.0;
const progressNotFound = -3.0;
const progressWaitingToRetry = -4.0;
const progressPaused = -5.0;

/// Holds data associated with a resume
class ResumeData {
  final Task task;
  final String data;
  final int requiredStartByte;
  final String? eTag;

  const ResumeData(this.task, this.data,
      [this.requiredStartByte = 0, this.eTag]);

  /// Create object from [json]
  ResumeData.fromJson(Map<String, dynamic> json)
      : task = Task.createFromJson(json['task']),
        data = json['data'] as String,
        requiredStartByte = (json['requiredStartByte'] as num?)?.toInt() ?? 0,
        eTag = json['eTag'] as String?;

  /// Create object from [jsonString]
  factory ResumeData.fromJsonString(String jsonString) =>
      ResumeData.fromJson(jsonDecode(jsonString));

  /// Return JSON Map representing object
  Map<String, dynamic> toJson() => {
        'task': task.toJson(),
        'data': data,
        'requiredStartByte': requiredStartByte,
        'eTag': eTag
      };

  String get taskId => task.taskId;

  /// The tempFilepath contained in the [data] field
  String get tempFilepath => data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResumeData &&
          runtimeType == other.runtimeType &&
          task == other.task &&
          data == other.data &&
          requiredStartByte == other.requiredStartByte &&
          eTag == other.eTag;

  @override
  int get hashCode =>
      task.hashCode ^
      data.hashCode ^
      requiredStartByte.hashCode ^
      (eTag?.hashCode ?? 0);
}

/// Types of undelivered data that can be requested
enum Undelivered { resumeData, statusUpdates, progressUpdates }

/// Notification types, as configured in [TaskNotificationConfig] and passed
/// on to [TaskNotificationTapCallback]
enum NotificationType { running, complete, error, paused }

/// Notification specification for a [Task]
///
/// [body] and [title] may contain special strings to substitute display values:
/// {filename] to insert the filename
/// {progress} to insert progress in %
/// {networkSpeed} to insert the network speed in MB/s or kB/s, or '--' if N/A
/// {timeRemaining} to insert the estimated time remaining to complete the task
///   in HH:MM:SS or MM:SS or --:-- if N/A
///
/// Actual appearance of notification is dependent on the platform, e.g.
/// on iOS {progress} is not available and ignored
final class TaskNotification {
  final String title;
  final String body;

  const TaskNotification(this.title, this.body);

  /// Return JSON Map representing object
  Map<String, dynamic> toJson() => {"title": title, "body": body};
}

/// Notification configuration object
///
/// Determines how a [taskOrGroup] or [group] of tasks needs to be notified
///
/// [running] is the notification used while the task is in progress
/// [complete] is the notification used when the task completed
/// [error] is the notification used when something went wrong,
/// including pause, failed and notFound status
/// [progressBar] if set will show a progress bar
/// [tapOpensFile] if set will attempt to open the file when the [complete]
///     notification is tapped
/// [groupNotificationId] if set will group all notifications with the same
///    [groupNotificationId] and change the progress bar to number of finished
///    tasks versus total number of tasks in the groupNotification.
///    Use {finished} and {total} tokens in the [TaskNotification.title] and
///    [TaskNotification.body] to substitute. Task-specific substitutions
///    such as {filename} are not valid.
///    The groupNotification is considered [complete] when there are no
///    more tasks running within that group, and at that point the
///    [complete] notification is shown (if configured). If any task in the
///    groupNotification fails, the [error] notification is shown.
///    The first character of the [groupNotificationId] cannot be '*'.
final class TaskNotificationConfig {
  final dynamic taskOrGroup;
  final TaskNotification? running;
  final TaskNotification? complete;
  final TaskNotification? error;
  final TaskNotification? paused;
  final bool progressBar;
  final bool tapOpensFile;
  final String groupNotificationId;

  /// Create notification configuration that determines what notifications are shown,
  /// whether a progress bar is shown (Android only), and whether tapping
  /// the 'complete' notification opens the downloaded file.
  ///
  /// [running] is the notification used while the task is in progress
  /// [complete] is the notification used when the task completed
  /// [error] is the notification used when something went wrong,
  /// including pause, failed and notFound status
  /// [progressBar] if set will show a progress bar
  /// [tapOpensFile] if set will attempt to open the file when the [complete]
  ///     notification is tapped
  /// [groupNotificationId] if set will group all notifications with the same
  ///    [groupNotificationId] and change the progress bar to number of finished
  ///    tasks versus total number of tasks in the groupNotification.
  ///    Use {numFinished}, {numFailed} and {numTotal} tokens in the [TaskNotification.title]
  ///    and [TaskNotification.body] to substitute. Task-specific substitutions
  ///    such as {filename} are not valid.
  ///    The groupNotification is considered [complete] when there are no
  ///    more tasks running within that group, and at that point the
  ///    [complete] notification is shown (if configured). If any task in the
  ///    groupNotification fails, the [error] notification is shown.
  ///    The first character of the [groupNotificationId] cannot be '*'.
  TaskNotificationConfig(
      {this.taskOrGroup,
      this.running,
      this.complete,
      this.error,
      this.paused,
      this.progressBar = false,
      this.tapOpensFile = false,
      this.groupNotificationId = ''}) {
    assert(
        running != null || complete != null || error != null || paused != null,
        'At least one notification must be set');
  }

  /// Return JSON Map representing object, excluding the [taskOrGroup] field,
  /// as the JSON map is only required to pass along the config with a task
  Map<String, dynamic> toJson() => {
        'running': running?.toJson(),
        'complete': complete?.toJson(),
        'error': error?.toJson(),
        'paused': paused?.toJson(),
        'progressBar': progressBar,
        'tapOpensFile': tapOpensFile,
        'groupNotificationId': groupNotificationId
      };
}

/// Shared storage destinations
enum SharedStorage {
  /// The 'Downloads' directory
  downloads,

  /// The 'Photos' or 'Images' or 'Pictures' directory
  images,

  /// The 'Videos' or 'Movies' directory
  video,

  /// The 'Music' or 'Audio' directory
  audio,

  /// Android-only: the 'Files' directory
  files,

  /// Android-only: the 'external storage' directory
  external
}

final class Config {
  // Config topics
  static const requestTimeout = 'requestTimeout';
  static const resourceTimeout = 'resourceTimeout';
  static const checkAvailableSpace = 'checkAvailableSpace';
  static const proxy = 'proxy';
  static const bypassTLSCertificateValidation =
      'bypassTLSCertificateValidation';
  static const runInForeground = 'runInForeground';
  static const runInForegroundIfFileLargerThan =
      'runInForegroundIfFileLargerThan';
  static const localize = 'localize';
  static const useCacheDir = 'useCacheDir';
  static const useExternalStorage = 'useExternalStorage';
  static const holdingQueue = 'holdingQueue';

  // Config arguments
  static const always = 'always'; // int 0 on native side
  static const never = 'never'; // int -1 on native side
  static const whenAble = 'whenAble'; // int -2 on native side

  /// Returns the int equivalent of commonly used String arguments
  ///
  /// The int equivalent is used in communication with the native downloader
  static int argToInt(String argument) {
    final value =
        {Config.always: 0, Config.whenAble: -2, Config.never: -1}[argument];
    if (value == null) {
      throw ArgumentError('Argument $argument cannot be converted to int');
    }
    return value;
  }
}

/// Wifi requirement modes at the application level
enum RequireWiFi { asSetByTask, forAllTasks, forNoTasks }
