import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'exceptions.dart';
import 'file_downloader.dart';
import 'utils.dart';
import 'web_downloader.dart'
    if (dart.library.io) 'desktop/desktop_downloader.dart';

final _log = Logger('FileDownloader');

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
  applicationLibrary
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

/// A server Request
///
/// An equality test on a [Request] is an equality test on the [url]
base class Request {
  final validHttpMethods = ['GET', 'POST', 'HEAD', 'PUT', 'DELETE', 'PATCH'];

  /// String representation of the url, urlEncoded
  final String url;

  /// potential additional headers to send with the request
  final Map<String, String> headers;

  /// HTTP request method to use
  final String httpRequestMethod;

  /// Set [post] to make the request using POST instead of GET.
  /// In the constructor, [post] must be one of the following:
  /// - a String: POST request with [post] as the body, encoded in utf8
  /// - a List of bytes: POST request with [post] as the body
  ///
  /// The field [post] will be a UInt8List representing the bytes, or the String
  final String? post;

  /// Maximum number of retries the downloader should attempt
  ///
  /// Defaults to 0, meaning no retry will be attempted
  final int retries;

  /// Number of retries remaining
  int retriesRemaining;

  /// Time at which this request was first created
  final DateTime creationTime;

  /// Creates a [Request]
  ///
  /// [url] must not be encoded and can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url]
  /// [headers] an optional map of HTTP request headers
  /// [post] if set, uses POST instead of GET. Post must be one of the
  /// following:
  /// - a String: POST request with [post] as the body, encoded in utf8
  /// - a List of bytes: POST request with [post] as the body
  ///
  /// [retries] if >0 will retry a failed download this many times
  Request(
      {required String url,
      Map<String, String>? urlQueryParameters,
      this.headers = const {},
      String? httpRequestMethod,
      post,
      this.retries = 0,
      DateTime? creationTime})
      : url = _urlWithQueryParameters(url, urlQueryParameters),
        httpRequestMethod =
            httpRequestMethod?.toUpperCase() ?? (post == null ? 'GET' : 'POST'),
        post = post is Uint8List ? String.fromCharCodes(post) : post,
        retriesRemaining = retries,
        creationTime = creationTime ?? DateTime.now() {
    if (retries < 0 || retries > 10) {
      throw ArgumentError('Number of retries must be in range 1 through 10');
    }
    if (!validHttpMethods.contains(this.httpRequestMethod)) {
      throw ArgumentError(
          'Invalid httpRequestMethod "${this.httpRequestMethod}": Must be one of ${validHttpMethods.join(', ')}');
    }
  }

  /// Creates object from JsonMap
  Request.fromJsonMap(Map<String, dynamic> jsonMap)
      : url = jsonMap['url'] ?? '',
        headers = Map<String, String>.from(jsonMap['headers'] ?? {}),
        httpRequestMethod = jsonMap['httpRequestMethod'] as String? ??
            (jsonMap['post'] == null ? 'GET' : 'POST'),
        post = jsonMap['post'] as String?,
        retries = (jsonMap['retries'] as num?)?.toInt() ?? 0,
        retriesRemaining = (jsonMap['retriesRemaining'] as num?)?.toInt() ?? 0,
        creationTime = DateTime.fromMillisecondsSinceEpoch(
            (jsonMap['creationTime'] as num?)?.toInt() ?? 0);

  /// Creates JSON map of this object
  Map<String, dynamic> toJsonMap() => {
        'url': url,
        'headers': headers,
        'httpRequestMethod': httpRequestMethod,
        'post': post,
        'retries': retries,
        'retriesRemaining': retriesRemaining,
        'creationTime': creationTime.millisecondsSinceEpoch
      };

  /// Decrease [retriesRemaining] by one
  void decreaseRetriesRemaining() => retriesRemaining--;

  /// Hostname represented by the url. Throws [FormatException] if url cannot
  /// be parsed, and returns empty string if no host in url
  String get hostName => Uri.parse(url).host;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Request && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() {
    return 'Request{url: $url, headers: $headers, httpRequestMethod: '
        '$httpRequestMethod, post: ${post == null ? "null" : "not null"}, '
        'retries: $retries, retriesRemaining: $retriesRemaining}';
  }
}

/// RegEx to match a path separator
final _pathSeparator = RegExp(r'[/\\]');
final _startsWithPathSeparator = RegExp(r'^[/\\]');

/// Information related to a [Task]
///
/// A [Task] is the base class for [DownloadTask] and
/// [UploadTask]
///
/// An equality test on a [Task] is a test on the [taskId]
/// only - all other fields are ignored in that test
sealed class Task extends Request implements Comparable {
  /// Identifier for the task - auto generated if omitted
  final String taskId;

  /// Filename of the file to store - use {filename} in notification
  final String filename;

  /// Optional directory, relative to the base directory
  final String directory;

  /// Base directory
  final BaseDirectory baseDirectory;

  /// Group that this task belongs to
  final String group;

  /// Type of progress updates desired
  final Updates updates;

  /// If true, will not download over cellular (metered) network
  final bool requiresWiFi;

  /// If true, task will pause if the task fails partly through the execution,
  /// when some but not all bytes have transferred, provided the server supports
  /// partial transfers. Such failures are typically temporary, eg due to
  /// connectivity issues, and may be resumed when connectivity returns.
  /// If false, task fails on any issue, and task cannot be paused
  final bool allowPause;

  /// Priority of this task, relative to other tasks.
  /// Range 0 <= priority <= 10 with 0 being the highest priority.
  /// Not all platforms will have the same actual granularity, and how
  /// priority is considered is inconsistent across platforms.
  final int priority;

  /// User-defined metadata - use {metaData} in notification
  final String metaData;

  /// Human readable name for this task - use {displayName} in notification
  final String displayName;

  static bool useExternalStorage = false; // for Android configuration only

  /// Creates a [Task]
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [filename] of the file to save. If omitted, a random filename will be
  /// generated
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET, POST)
  /// [post] if set, uses POST instead of GET. Post must be one of the
  /// following:
  /// - a String: POST request with [post] as the body, encoded in utf8
  /// - a List of bytes: POST request with [post] as the body
  /// [directory] optional directory name, precedes [filename]
  /// [baseDirectory] one of the base directories, precedes [directory]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested
  /// [requiresWiFi] if set, will not start download until WiFi is available.
  /// If not set may start download over cellular network
  /// [retries] if >0 will retry a failed download this many times
  /// [allowPause]
  /// If true, task will pause if the task fails partly through the execution,
  /// when some but not all bytes have transferred, provided the server supports
  /// partial transfers. Such failures are typically temporary, eg due to
  /// connectivity issues, and may be resumed when connectivity returns
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  Task(
      {String? taskId,
      required super.url,
      super.urlQueryParameters,
      String? filename,
      super.headers,
      super.httpRequestMethod,
      super.post,
      this.directory = '',
      this.baseDirectory = BaseDirectory.applicationDocuments,
      this.group = 'default',
      this.updates = Updates.status,
      this.requiresWiFi = false,
      super.retries,
      this.metaData = '',
      this.displayName = '',
      this.allowPause = false,
      this.priority = 5,
      super.creationTime})
      : taskId = taskId ?? Random().nextInt(1 << 32).toString(),
        filename = filename ?? Random().nextInt(1 << 32).toString() {
    if (filename?.isEmpty == true) {
      throw ArgumentError('Filename cannot be empty');
    }
    if (_pathSeparator.hasMatch(this.filename) && this is! MultiUploadTask) {
      throw ArgumentError('Filename cannot contain path separators');
    }
    if (_startsWithPathSeparator.hasMatch(directory)) {
      throw ArgumentError(
          'Directory must be relative to the baseDirectory specified in the baseDirectory argument');
    }
    if (allowPause && post != null) {
      throw ArgumentError('Tasks that can pause must be GET requests');
    }
    if (priority < 0 || priority > 10) {
      throw ArgumentError('Priority must be 0 <= priority <= 10');
    }
  }

  /// Create a new [Task] subclass from the provided [jsonMap]
  factory Task.createFromJsonMap(Map<String, dynamic> jsonMap) =>
      switch (jsonMap['taskType']) {
        'DownloadTask' => DownloadTask.fromJsonMap(jsonMap),
        'UploadTask' => UploadTask.fromJsonMap(jsonMap),
        'MultiUploadTask' => MultiUploadTask.fromJsonMap(jsonMap),
        'ParallelDownloadTask' => ParallelDownloadTask.fromJsonMap(jsonMap),
        _ => throw ArgumentError(
            'taskType not in [DownloadTask, UploadTask, MultiUploadTask, ParallelDownloadTask]')
      };

  /// Returns the absolute path to the file represented by this task
  /// based on the [Task.filename] (default) or [withFilename]
  ///
  /// If the task is a MultiUploadTask and no [withFilename] is given,
  /// returns the empty string, as there is no single path that can be
  /// returned.
  ///
  /// Throws a FileSystemException if using external storage on Android (via
  /// configuration at startup), and external storage is not available.
  Future<String> filePath({String? withFilename}) async {
    if (this is MultiUploadTask && withFilename == null) {
      return '';
    }
    Directory? externalStorageDirectory;
    Directory? externalCacheDirectory;
    if (Task.useExternalStorage) {
      externalStorageDirectory = await getExternalStorageDirectory();
      externalCacheDirectory = (await getExternalCacheDirectories())?.first;
      if (externalStorageDirectory == null || externalCacheDirectory == null) {
        throw const FileSystemException(
            'Android external storage is not available');
      }
    }
    final Directory baseDir =
        switch ((baseDirectory, Task.useExternalStorage)) {
      (BaseDirectory.applicationDocuments, false) =>
        await getApplicationDocumentsDirectory(),
      (BaseDirectory.temporary, false) => await getTemporaryDirectory(),
      (BaseDirectory.applicationSupport, false) =>
        await getApplicationSupportDirectory(),
      (BaseDirectory.applicationLibrary, false)
          when Platform.isMacOS || Platform.isIOS =>
        await getLibraryDirectory(),
      (BaseDirectory.applicationLibrary, false) => Directory(
          path.join((await getApplicationSupportDirectory()).path, 'Library')),
      // Android only: external storage variants
      (BaseDirectory.applicationDocuments, true) => externalStorageDirectory!,
      (BaseDirectory.temporary, true) => externalCacheDirectory!,
      (BaseDirectory.applicationSupport, true) =>
        Directory(path.join(externalStorageDirectory!.path, 'Support')),
      (BaseDirectory.applicationLibrary, true) =>
        Directory(path.join(externalStorageDirectory!.path, 'Library'))
    };
    return path.join(baseDir.path, directory, withFilename ?? filename);
  }

  /// Returns a copy of the [Task] with optional changes to specific fields
  Task copyWith(
      {String? taskId,
      String? url,
      String? filename,
      Map<String, String>? headers,
      String? httpRequestMethod,
      Object? post,
      String? directory,
      BaseDirectory? baseDirectory,
      String? group,
      Updates? updates,
      bool? requiresWiFi,
      int? retries,
      int? retriesRemaining,
      bool? allowPause,
      int? priority,
      String? metaData,
      String? displayName,
      DateTime? creationTime});

  /// Creates [Task] object from JsonMap
  ///
  /// Only used by subclasses. Use [createFromJsonMap] to create a properly
  /// subclassed [Task] from the [jsonMap]
  Task.fromJsonMap(Map<String, dynamic> jsonMap)
      : taskId = jsonMap['taskId'] ?? '',
        filename = jsonMap['filename'] ?? '',
        directory = jsonMap['directory'] ?? '',
        baseDirectory = BaseDirectory
            .values[(jsonMap['baseDirectory'] as num?)?.toInt() ?? 0],
        group = jsonMap['group'] ?? FileDownloader.defaultGroup,
        updates = Updates.values[(jsonMap['updates'] as num?)?.toInt() ?? 0],
        requiresWiFi = jsonMap['requiresWiFi'] ?? false,
        allowPause = jsonMap['allowPause'] ?? false,
        priority = (jsonMap['priority'] as num?)?.toInt() ?? 5,
        metaData = jsonMap['metaData'] ?? '',
        displayName = jsonMap['displayName'] ?? '',
        super.fromJsonMap(jsonMap);

  /// Creates JSON map of this object
  @override
  Map<String, dynamic> toJsonMap() => {
        ...super.toJsonMap(),
        'taskId': taskId,
        'filename': filename,
        'directory': directory,
        'baseDirectory': baseDirectory.index, // stored as int
        'group': group,
        'updates': updates.index, // stored as int
        'requiresWiFi': requiresWiFi,
        'allowPause': allowPause,
        'priority': priority,
        'metaData': metaData,
        'displayName': displayName,
        'taskType': taskType
      };

  /// If true, task expects progress updates
  bool get providesProgressUpdates =>
      updates == Updates.progress || updates == Updates.statusAndProgress;

  /// If true, task expects status updates
  bool get providesStatusUpdates =>
      updates == Updates.status || updates == Updates.statusAndProgress;

  /// Returns the type of task as a String
  ///
  /// Used to identify the task type in JSON format
  String get taskType => 'Task';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          taskId == other.taskId;

  @override
  int get hashCode => taskId.hashCode;

  @override

  /// Returns this.priority - other.priority if not the same
  /// Returns this.creationTime - other.creationTime if priorities the same
  /// Returns 0 if other is not a [Task]
  int compareTo(other) {
    if (other is Task) {
      final diff = priority - other.priority;
      if (diff != 0) {
        return diff;
      }
      return creationTime.difference(other.creationTime).inMicroseconds;
    }
    return 0;
  }

  @override
  String toString() {
    return '$taskType{taskId: $taskId, url: $url, filename: $filename, headers: '
        '$headers, httpRequestMethod: $httpRequestMethod, post: ${post == null ? "null" : "not null"}, directory: $directory, baseDirectory: $baseDirectory, group: $group, updates: $updates, requiresWiFi: $requiresWiFi, retries: $retries, retriesRemaining: $retriesRemaining, allowPause: $allowPause, priority: $priority, metaData: $metaData, displayName: $displayName}';
  }
}

/// Information related to a download task
///
/// An equality test on a [DownloadTask] is a test on the [taskId]
/// only - all other fields are ignored in that test
final class DownloadTask extends Task {
  /// Creates a [DownloadTask]
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [filename] of the file to save. If omitted, a random filename will be
  /// generated
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET, POST)
  /// [post] if set, uses POST instead of GET. Post must be one of the
  /// following:
  /// - true: POST request without a body
  /// - a String: POST request with [post] as the body, encoded in utf8 and
  ///   content-type 'text/plain'
  /// - a List of bytes: POST request with [post] as the body
  /// - a Map: POST request with [post] as form fields, encoded in utf8 and
  ///   content-type 'application/x-www-form-urlencoded'
  ///
  /// [directory] optional directory name, precedes [filename]
  /// [baseDirectory] one of the base directories, precedes [directory]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested
  /// [requiresWiFi] if set, will not start download until WiFi is available.
  /// If not set may start download over cellular network
  /// [retries] if >0 will retry a failed download this many times
  /// [allowPause] if true, allows pause command
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  DownloadTask(
      {super.taskId,
      required super.url,
      super.urlQueryParameters,
      super.filename,
      super.headers,
      super.httpRequestMethod,
      super.post,
      super.directory,
      super.baseDirectory,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.retries,
      super.allowPause,
      super.priority,
      super.metaData,
      super.displayName,
      super.creationTime});

  /// Creates [DownloadTask] object from JsonMap
  DownloadTask.fromJsonMap(Map<String, dynamic> jsonMap)
      : assert(
            ['DownloadTask', 'ParallelDownloadTask']
                .contains(jsonMap['taskType']),
            'The provided JSON map is not'
            ' a DownloadTask, because key "taskType" is not "DownloadTask" or "ParallelDownloadTask".'),
        super.fromJsonMap(jsonMap);

  @override
  String get taskType => 'DownloadTask';

  @override
  DownloadTask copyWith(
          {String? taskId,
          String? url,
          String? filename,
          Map<String, String>? headers,
          String? httpRequestMethod,
          Object? post,
          String? directory,
          BaseDirectory? baseDirectory,
          String? group,
          Updates? updates,
          bool? requiresWiFi,
          int? retries,
          int? retriesRemaining,
          bool? allowPause,
          int? priority,
          String? metaData,
          String? displayName,
          DateTime? creationTime}) =>
      DownloadTask(
          taskId: taskId ?? this.taskId,
          url: url ?? this.url,
          filename: filename ?? this.filename,
          headers: headers ?? this.headers,
          httpRequestMethod: httpRequestMethod ?? this.httpRequestMethod,
          post: post ?? this.post,
          directory: directory ?? this.directory,
          baseDirectory: baseDirectory ?? this.baseDirectory,
          group: group ?? this.group,
          updates: updates ?? this.updates,
          requiresWiFi: requiresWiFi ?? this.requiresWiFi,
          retries: retries ?? this.retries,
          allowPause: allowPause ?? this.allowPause,
          priority: priority ?? this.priority,
          metaData: metaData ?? this.metaData,
          displayName: displayName ?? this.displayName,
          creationTime: creationTime ?? this.creationTime)
        ..retriesRemaining = retriesRemaining ?? this.retriesRemaining;

  /// Returns a copy of the task with the [Task.filename] property changed
  /// to the filename suggested by the server, or derived from the url, or
  /// unchanged.
  ///
  /// If [unique] is true, the filename is guaranteed not to already exist. This
  /// is accomplished by adding a suffix to the suggested filename with a number,
  /// e.g. "data (2).txt"
  /// If a [taskWithFilenameBuilder] is supplied, this is the function called to
  /// convert the task, response headers and [unique] values into a new [DownloadTask]
  /// with the suggested filename. By default, [taskWithSuggestedFilename] is used,
  /// which parses the Content-Disposition according to RFC6266, or takes the last
  /// path segment of the URL, or leaves the filename unchanged
  ///
  /// The suggested filename is obtained by making a HEAD request to the url
  /// represented by the [DownloadTask], including urlQueryParameters and headers
  Future<DownloadTask> withSuggestedFilename(
      {unique = false,
      Future<DownloadTask> Function(
              DownloadTask task, Map<String, String> headers, bool unique)
          taskWithFilenameBuilder = taskWithSuggestedFilename}) async {
    try {
      final response = await DesktopDownloader.httpClient
          .head(Uri.parse(url), headers: headers);
      if ([200, 201, 202, 203, 204, 205, 206].contains(response.statusCode)) {
        return taskWithFilenameBuilder(this, response.headers, unique);
      }
    } catch (e) {
      _log.finer('Error connecting to server');
    }
    return taskWithFilenameBuilder(this, {}, unique);
  }

  /// Return the expected file size for this task, or -1 if unknown
  ///
  /// The expected file size is obtained by making a HEAD request to the url
  /// represented by the [DownloadTask], including urlQueryParameters and headers
  Future<int> expectedFileSize() async {
    try {
      final response = await DesktopDownloader.httpClient
          .head(Uri.parse(url), headers: headers);
      if ([200, 201, 202, 203, 204, 205, 206].contains(response.statusCode)) {
        return getContentLength(response.headers, this);
      }
    } catch (e) {
      // no content length available
    }
    return -1;
  }

  /// Constant used with `filename` field to indicate server suggestion requested
  static const suggestedFilename = '?';

  /// True if this task has a filename, or false if set to `suggest`
  bool get hasFilename => filename != suggestedFilename;
}

/// Information related to an upload task
///
/// An equality test on a [UploadTask] is a test on the [taskId]
/// only - all other fields are ignored in that test
final class UploadTask extends Task {
  /// Name of the field used for multi-part file upload
  final String fileField;

  /// mimeType of the file to upload
  final String mimeType;

  /// Map of name/value pairs to encode as form fields in a multi-part upload
  final Map<String, String> fields;

  /// Creates [UploadTask]
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [filename] of the file to upload
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET, POST)
  /// [post] if set to 'binary' will upload as binary file, otherwise multi-part
  /// [fileField] for multi-part uploads, name of the file field or 'file' by
  /// default
  /// [mimeType] the mimeType of the file, or derived from filename extension
  /// by default
  /// [fields] for multi-part uploads, optional map of name/value pairs to upload
  ///   along with the file as form fields
  /// [directory] optional directory name, precedes [filename]
  /// [baseDirectory] one of the base directories, precedes [directory]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested
  /// [requiresWiFi] if set, will not start upload until WiFi is available.
  /// If not set may start upload over cellular network
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [retries] if >0 will retry a failed upload this many times
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  UploadTask(
      {super.taskId,
      required super.url,
      super.urlQueryParameters,
      required String filename,
      super.headers,
      String? httpRequestMethod,
      String? post,
      this.fileField = 'file',
      String? mimeType,
      Map<String, String>? fields,
      super.directory,
      super.baseDirectory,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.retries,
      super.priority,
      super.metaData,
      super.displayName,
      super.creationTime})
      : assert(filename.isNotEmpty, 'A filename is required'),
        assert(post == null || post == 'binary',
            'post field must be null, or "binary" for binary file upload'),
        assert(fields == null || fields.isEmpty || post != 'binary',
            'fields only allowed for multi-part uploads'),
        fields = fields ?? {},
        mimeType =
            mimeType ?? lookupMimeType(filename) ?? 'application/octet-stream',
        super(
            filename: filename,
            httpRequestMethod: httpRequestMethod ?? 'POST',
            post: post,
            allowPause: false);

  /// Creates [UploadTask] object from JsonMap
  UploadTask.fromJsonMap(Map<String, dynamic> jsonMap)
      : assert(
            ['UploadTask', 'MultiUploadTask'].contains(jsonMap['taskType']),
            'The provided JSON map is not an UploadTask, '
            'because key "taskType" is not "UploadTask" or "MultiUploadTask.'),
        fileField = jsonMap['fileField'] ?? 'file',
        mimeType = jsonMap['mimeType'] ?? 'application/octet-stream',
        fields = Map<String, String>.from(jsonMap['fields'] ?? {}),
        super.fromJsonMap(jsonMap);

  /// Returns a list of fileData elements, one for each file to upload.
  /// Each element is a triple containing fileField, full filePath, mimeType
  ///
  /// The lists are stored in the similarly named String fields as a JSON list,
  /// with each list the same length. For the filenames list, if a filename refers
  /// to a file that exists (i.e. it is a full path) then that is the filePath used,
  /// otherwise the filename is appended to the [Task.baseDirectory] and [Task.directory]
  /// to form a full file path
  Future<List<(String, String, String)>> extractFilesData() async {
    final List<String> fileFields = List.from(jsonDecode(fileField));
    final List<String> filenames = List.from(jsonDecode(filename));
    final List<String> mimeTypes = List.from(jsonDecode(mimeType));
    final result = <(String, String, String)>[];
    for (int i = 0; i < fileFields.length; i++) {
      final file = File(filenames[i]);
      if (await file.exists()) {
        result.add((fileFields[i], filenames[i], mimeTypes[i]));
      } else {
        result.add(
          (
            fileFields[i],
            await filePath(withFilename: filenames[i]),
            mimeTypes[i],
          ),
        );
      }
    }
    return result;
  }

  @override
  Map<String, dynamic> toJsonMap() => {
        ...super.toJsonMap(),
        'fileField': fileField,
        'mimeType': mimeType,
        'fields': fields
      };

  @override
  String get taskType => 'UploadTask';

  @override
  UploadTask copyWith(
          {String? taskId,
          String? url,
          String? filename,
          Map<String, String>? headers,
          String? httpRequestMethod,
          Object? post,
          String? fileField,
          String? mimeType,
          Map<String, String>? fields,
          String? directory,
          BaseDirectory? baseDirectory,
          String? group,
          Updates? updates,
          bool? requiresWiFi,
          int? retries,
          int? retriesRemaining,
          bool? allowPause,
          int? priority,
          String? metaData,
          String? displayName,
          DateTime? creationTime}) =>
      UploadTask(
          taskId: taskId ?? this.taskId,
          url: url ?? this.url,
          filename: filename ?? this.filename,
          headers: headers ?? this.headers,
          httpRequestMethod: httpRequestMethod ?? this.httpRequestMethod,
          post: post as String? ?? this.post,
          fileField: fileField ?? this.fileField,
          mimeType: mimeType ?? this.mimeType,
          fields: fields ?? this.fields,
          directory: directory ?? this.directory,
          baseDirectory: baseDirectory ?? this.baseDirectory,
          group: group ?? this.group,
          updates: updates ?? this.updates,
          requiresWiFi: requiresWiFi ?? this.requiresWiFi,
          priority: priority ?? this.priority,
          retries: retries ?? this.retries,
          metaData: metaData ?? this.metaData,
          displayName: displayName ?? this.displayName,
          creationTime: creationTime ?? this.creationTime)
        ..retriesRemaining = retriesRemaining ?? this.retriesRemaining;

  @override
  String toString() => '${super.toString()} and fileField $fileField, '
      'mimeType $mimeType and fields $fields';
}

/// Information related to an UploadTask, containing multiple files to upload
///
/// An equality test on a [UploadTask] is a test on the [taskId]
/// only - all other fields are ignored in that test
///
/// A [MultiUploadTask] is initialized with a list representing the files to upload.
/// Each element is either a filename/path, or a (fileField, filename/path),
/// or a (fileField, filename/path, mimeType).
/// When instantiating a [MultiUploadTask], this list is converted into
/// three lists: [fileFields], [filenames], and [mimeTypes], available
/// as fields. These lists are also encoded to a JSON string representation in
/// the fields [fileField], [filename] and [mimeType],so - different from
/// a single [UploadTask] - these fields now contain a JSON object representing all
/// files.
/// filename/path means either a filename without directory (and the
/// directory will be based on the [Task.baseDirectory] and [Task.directory]
/// fields), or you specify a full file path. For example: "hello.txt" or
/// "/data/com.myapp/data/dir/hello.txt"
final class MultiUploadTask extends UploadTask {
  final List<String> fileFields, filenames, mimeTypes;

  static const _filesArgumentError =
      'files must be a list of filenames, or a list of records of type '
      '(fileField, filename) or (fileField, filename, mimeType)';

  /// Creates [UploadTask]
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [files] list of objects representing each file to upload. The object must
  ///   be either a String representing the filename/path (and the fileField will
  ///   be the filename without extension), a Record of type
  ///   (String fileField, String filename/path) or a Record with a third String
  ///   for the mimeType (if omitted, mimeType will be derived from the filename
  ///   extension).
  ///   Each file must be based in the directory represented by the combination
  ///   of [baseDirectory] and [directory], unless a full filepath is given
  ///   instead of only the filename. For example: "hello.txt" or
  ///   "/data/com.myapp/data/dir/hello.txt"
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET, POST)
  /// [fields] optional map of name/value pairs to upload
  ///   along with the file as form fields
  /// [directory] optional directory name, precedes [filename]
  /// [baseDirectory] one of the base directories, precedes [directory]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested
  /// [requiresWiFi] if set, will not start upload until WiFi is available.
  /// If not set may start upload over cellular network
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [retries] if >0 will retry a failed upload this many times
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  MultiUploadTask(
      {super.taskId,
      required super.url,
      super.urlQueryParameters,
      required List<dynamic> files,
      super.headers,
      super.httpRequestMethod,
      Map<String, String>? fields = const {},
      super.directory,
      super.baseDirectory,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.priority,
      super.retries,
      super.metaData,
      super.displayName,
      super.creationTime})
      : fileFields = files
            .map((e) => switch (e) {
                  String filename => path.basenameWithoutExtension(filename),
                  (String fileField, String _, String _) => fileField,
                  (String fileField, String _) => fileField,
                  _ => throw ArgumentError(_filesArgumentError)
                })
            .toList(growable: false),
        filenames = files
            .map((e) => switch (e) {
                  String filename => filename,
                  (String _, String filename, String _) => filename,
                  (String _, String filename) => filename,
                  _ => throw ArgumentError(_filesArgumentError)
                })
            .toList(growable: false),
        mimeTypes = files
            .map((e) => switch (e) {
                  (String _, String _, String mimeType) => mimeType,
                  String filename ||
                  (String _, String filename) =>
                    lookupMimeType(filename) ?? 'application/octet-stream',
                  _ => throw ArgumentError(_filesArgumentError)
                })
            .toList(growable: false),
        super(
            filename: 'multi-upload',
            fileField: '',
            mimeType: '',
            fields: fields);

  /// For [MultiUploadTask], returns jsonEncoded list of [fileFields]
  @override
  String get fileField => jsonEncode(fileFields);

  /// For [MultiUploadTask], returns jsonEncoded list of [filenames]
  @override
  String get filename => jsonEncode(filenames);

  /// For [MultiUploadTask], returns jsonEncoded list of [mimeTypes]
  @override
  String get mimeType => jsonEncode(mimeTypes);

  /// Creates [MultiUploadTask] object from JsonMap
  MultiUploadTask.fromJsonMap(Map<String, dynamic> jsonMap)
      : assert(
            jsonMap['taskType'] == 'MultiUploadTask',
            'The provided JSON map is not'
            ' a MultiUploadTask, because key "taskType" is not "MultiUploadTask".'),
        fileFields =
            List.from(jsonDecode(jsonMap['fileField'] as String? ?? '[]')),
        filenames =
            List.from(jsonDecode(jsonMap['filename'] as String? ?? '[]')),
        mimeTypes =
            List.from(jsonDecode(jsonMap['mimeType'] as String? ?? '[]')),
        super.fromJsonMap(jsonMap);

  @override
  MultiUploadTask copyWith(
          {String? taskId,
          String? url,
          String? filename,
          Map<String, String>? headers,
          String? httpRequestMethod,
          Object? post,
          String? fileField,
          String? mimeType,
          Map<String, String>? fields,
          String? directory,
          BaseDirectory? baseDirectory,
          String? group,
          Updates? updates,
          bool? requiresWiFi,
          int? priority,
          int? retries,
          int? retriesRemaining,
          bool? allowPause,
          String? metaData,
          String? displayName,
          DateTime? creationTime}) =>
      MultiUploadTask(
          taskId: taskId ?? this.taskId,
          url: url ?? this.url,
          files: fileFields.indexed.map(_toRecord).toList(),
          headers: headers ?? this.headers,
          httpRequestMethod: httpRequestMethod ?? this.httpRequestMethod,
          fields: fields ?? this.fields,
          directory: directory ?? this.directory,
          baseDirectory: baseDirectory ?? this.baseDirectory,
          group: group ?? this.group,
          updates: updates ?? this.updates,
          requiresWiFi: requiresWiFi ?? this.requiresWiFi,
          priority: priority ?? this.priority,
          retries: retries ?? this.retries,
          metaData: metaData ?? this.metaData,
          displayName: displayName ?? this.displayName,
          creationTime: creationTime ?? this.creationTime)
        ..retriesRemaining = retriesRemaining ?? this.retriesRemaining;

  /// Zips the fileField, filename and mimeType at an index to
  /// a record
  (String, String, String) _toRecord((int, String) record) =>
      (fileFields[record.$1], filenames[record.$1], mimeTypes[record.$1]);

  @override
  String get taskType => 'MultiUploadTask';
}

final class ParallelDownloadTask extends DownloadTask {
  /// List of URLs to download the file from
  final List<String> urls;

  /// Number of chunks per URL
  final int chunks;

  /// Creates a [ParallelDownloadTask]
  ///
  /// A [ParallelDownloadTask] is a [DownloadTask] that downloads the file
  /// from one or more URLs, and in one or more chunks per URL. The parallel
  /// download may speed up download from slow or restrictive servers.
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  ///   and can be a list of urls, each providing the same file. The same
  ///   [urlQueryParameters] and [headers] will be applied to all urls in the list
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [filename] of the file to save. If omitted, a random filename will be
  /// generated
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET)
  /// [chunks] the number of chunks to break the download into, i.e. the
  ///   number of downloads that will happen in parallel
  /// [directory] optional directory name, precedes [filename]
  /// [baseDirectory] one of the base directories, precedes [directory]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested
  /// [requiresWiFi] if set, will not start download until WiFi is available.
  /// If not set may start download over cellular network
  /// [retries] if >0 will retry a failed download this many times
  /// [allowPause] if true, allows pause command
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  ///
  /// A [ParallelDownloadTask] cannot be paused or resumed on failure
  ParallelDownloadTask(
      {super.taskId,
      required dynamic url,
      super.urlQueryParameters,
      super.filename,
      super.headers,
      super.httpRequestMethod,
      this.chunks = 1,
      super.directory,
      super.baseDirectory,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.retries,
      super.allowPause,
      super.priority,
      super.metaData,
      super.displayName,
      super.creationTime})
      : assert(url is String || url is List<String>,
            'The `url` parameter must be a string or a list of strings'),
        assert(url is String || (url is List<String> && url.isNotEmpty),
            'The list of urls must not be empty'),
        urls = url is String
            ? [_urlWithQueryParameters(url, urlQueryParameters)]
            : List.from(
                url.map((e) => _urlWithQueryParameters(e, urlQueryParameters))),
        super(url: url is String ? url : url.first) {
    retriesRemaining = 0; // chunk tasks will retry instead, based on [retries]
  }

  /// Creates [ParallelDownloadTask] object from JsonMap
  ParallelDownloadTask.fromJsonMap(Map<String, dynamic> jsonMap)
      : assert(
            jsonMap['taskType'] == 'ParallelDownloadTask',
            'The provided JSON map is not a ParallelDownloadTask, '
            'because key "taskType" is not "ParallelDownloadTask".'),
        urls = List.from(jsonMap['urls'] as List<dynamic>? ?? []),
        chunks = jsonMap['chunks'] as int? ?? 1,
        super.fromJsonMap(jsonMap);

  @override
  Map<String, dynamic> toJsonMap() =>
      {...super.toJsonMap(), 'urls': urls, 'chunks': chunks};

  @override
  String get taskType => 'ParallelDownloadTask';

  @override
  ParallelDownloadTask copyWith(
          {String? taskId,
          String? url,
          String? filename,
          Map<String, String>? headers,
          String? httpRequestMethod,
          Object? post,
          String? directory,
          BaseDirectory? baseDirectory,
          String? group,
          Updates? updates,
          bool? requiresWiFi,
          int? retries,
          int? retriesRemaining,
          bool? allowPause,
          int? priority,
          String? metaData,
          String? displayName,
          DateTime? creationTime}) =>
      ParallelDownloadTask(
          taskId: taskId ?? this.taskId,
          url: url ?? urls,
          filename: filename ?? this.filename,
          headers: headers ?? this.headers,
          httpRequestMethod: httpRequestMethod ?? this.httpRequestMethod,
          chunks: chunks,
          directory: directory ?? this.directory,
          baseDirectory: baseDirectory ?? this.baseDirectory,
          group: group ?? this.group,
          updates: updates ?? this.updates,
          requiresWiFi: requiresWiFi ?? this.requiresWiFi,
          retries: retries ?? this.retries,
          allowPause: allowPause ?? this.allowPause,
          priority: priority ?? this.priority,
          metaData: metaData ?? this.metaData,
          displayName: displayName ?? this.displayName,
          creationTime: creationTime ?? this.creationTime)
        ..retriesRemaining = retriesRemaining ?? this.retriesRemaining;
}

/// Return url String composed of the [url] and the
/// [urlQueryParameters], if given
String _urlWithQueryParameters(
    String url, Map<String, String>? urlQueryParameters) {
  if (urlQueryParameters == null || urlQueryParameters.isEmpty) {
    return url;
  }
  final separator = url.contains('?') ? '&' : '?';
  return '$url$separator${urlQueryParameters.entries.map((e) => '${e.key}=${e.value}').join('&')}';
}

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

  /// Create object from JSON Map
  TaskUpdate.fromJsonMap(Map<String, dynamic> jsonMap)
      : task = Task.createFromJsonMap(jsonMap['task'] ?? jsonMap);

  /// Return JSON Map representing object
  Map<String, dynamic> toJsonMap() => {'task': task.toJsonMap()};
}

/// A status update
///
/// Contains [TaskStatus] and, if [TaskStatus.failed] possibly a
/// [TaskException] and [responseBody]
class TaskStatusUpdate extends TaskUpdate {
  final TaskStatus status;
  final TaskException? exception;
  final String? responseBody;

  const TaskStatusUpdate(super.task, this.status,
      [this.exception, this.responseBody]);

  /// Create object from JSON Map
  TaskStatusUpdate.fromJsonMap(Map<String, dynamic> jsonMap)
      : status =
            TaskStatus.values[(jsonMap['taskStatus'] as num?)?.toInt() ?? 0],
        exception = jsonMap['exception'] != null
            ? TaskException.fromJsonMap(jsonMap['exception'])
            : null,
        responseBody = jsonMap['responseBody'],
        super.fromJsonMap(jsonMap);

  /// Return JSON Map representing object
  @override
  Map<String, dynamic> toJsonMap() => {
        ...super.toJsonMap(),
        'taskStatus': status.index,
        'exception': exception?.toJsonMap(),
        'responseBody': responseBody
      };

  TaskStatusUpdate copyWith(
          {Task? task,
          TaskStatus? status,
          TaskException? exception,
          String? responseBody}) =>
      TaskStatusUpdate(task ?? this.task, status ?? this.status,
          exception ?? this.exception, responseBody ?? this.responseBody);
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

  /// Create object from JSON Map
  TaskProgressUpdate.fromJsonMap(Map<String, dynamic> jsonMap)
      : progress = (jsonMap['progress'] as num?)?.toDouble() ?? progressFailed,
        expectedFileSize = (jsonMap['expectedFileSize'] as num?)?.toInt() ?? -1,
        networkSpeed = (jsonMap['networkSpeed'] as num?)?.toDouble() ?? -1,
        timeRemaining = Duration(
            seconds: (jsonMap['timeRemaining'] as num?)?.toInt() ?? -1),
        super.fromJsonMap(jsonMap);

  /// Return JSON Map representing object
  @override
  Map<String, dynamic> toJsonMap() => {
        ...super.toJsonMap(),
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

  /// Create object from JSON Map
  ResumeData.fromJsonMap(Map<String, dynamic> jsonMap)
      : task = Task.createFromJsonMap(jsonMap['task']),
        data = jsonMap['data'] as String,
        requiredStartByte =
            (jsonMap['requiredStartByte'] as num?)?.toInt() ?? 0,
        eTag = jsonMap['eTag'] as String?;

  /// Return JSON Map representing object
  Map<String, dynamic> toJsonMap() => {
        'task': task.toJsonMap(),
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
  Map<String, dynamic> toJsonMap() => {"title": title, "body": body};
}

/// Notification configuration object
///
/// Determines how a [taskOrGroup] or [group] of tasks needs to be notified
///
/// [running] is the notification used while the task is in progress
/// [complete] is the notification used when the task completed
/// [error] is the notification used when something went wrong,
/// including pause, failed and notFound status
final class TaskNotificationConfig {
  final dynamic taskOrGroup;
  final TaskNotification? running;
  final TaskNotification? complete;
  final TaskNotification? error;
  final TaskNotification? paused;
  final bool progressBar;
  final bool tapOpensFile;

  /// Create notification configuration that determines what notifications are shown,
  /// whether a progress bar is shown (Android only), and whether tapping
  /// the 'complete' notification opens the downloaded file.
  ///
  /// [running] is the notification used while the task is in progress
  /// [complete] is the notification used when the task completed
  /// [error] is the notification used when something went wrong,
  /// including pause, failed and notFound status
  TaskNotificationConfig(
      {this.taskOrGroup,
      this.running,
      this.complete,
      this.error,
      this.paused,
      this.progressBar = false,
      this.tapOpensFile = false}) {
    assert(
        running != null || complete != null || error != null || paused != null,
        'At least one notification must be set');
  }

  /// Return JSON Map representing object, excluding the [taskOrGroup] field,
  /// as the JSON map is only required to pass along the config with a task
  Map<String, dynamic> toJsonMap() => {
        'running': running?.toJsonMap(),
        'complete': complete?.toJsonMap(),
        'error': error?.toJsonMap(),
        'paused': paused?.toJsonMap(),
        'progressBar': progressBar,
        'tapOpensFile': tapOpensFile
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

// helper function for DownloadTask

/// Returns a copy of the [task] with the [Task.filename] property changed
/// to the filename suggested by the server, or derived from the url, or
/// unchanged.
///
/// If [unique] is true, the filename is guaranteed not to already exist. This
/// is accomplished by adding a suffix to the suggested filename with a number,
/// e.g. "data (2).txt"
///
/// The server-suggested filename is obtained from the  [responseHeaders] entry
/// "Content-Disposition" according to RFC6266, or the last path segment of the
/// URL, or leaves the filename unchanged
Future<DownloadTask> taskWithSuggestedFilename(
    DownloadTask task, Map<String, String> responseHeaders, bool unique) {
  /// Returns [DownloadTask] with a filename similar to the one
  /// supplied, but unused.
  ///
  /// If [unique], filename will sequence up in "filename (8).txt" format,
  /// otherwise returns the [task]
  Future<DownloadTask> uniqueFilename(DownloadTask task, bool unique) async {
    if (!unique) {
      return task;
    }
    final sequenceRegEx = RegExp(r'\((\d+)\)\.?[^.]*$');
    final extensionRegEx = RegExp(r'\.[^.]*$');
    var newTask = task;
    var filePath = await newTask.filePath();
    var exists = await File(filePath).exists();
    while (exists) {
      final extension =
          extensionRegEx.firstMatch(newTask.filename)?.group(0) ?? '';
      final match = sequenceRegEx.firstMatch(newTask.filename);
      final newSequence = int.parse(match?.group(1) ?? "0") + 1;
      final newFilename = match == null
          ? '${path.basenameWithoutExtension(newTask.filename)} ($newSequence)$extension'
          : '${newTask.filename.substring(0, match.start - 1)} ($newSequence)$extension';
      newTask = newTask.copyWith(filename: newFilename);
      filePath = await newTask.filePath();
      exists = await File(filePath).exists();
    }
    return newTask;
  }

  // start of main function
  try {
    final disposition = responseHeaders.entries
        .firstWhere(
            (element) => element.key.toLowerCase() == 'content-disposition')
        .value;
    // Try filename="filename"
    final plainFilenameRegEx =
        RegExp(r'filename=\s*"?([^"]+)"?.*$', caseSensitive: false);
    var match = plainFilenameRegEx.firstMatch(disposition);
    if (match != null && match.group(1)?.isNotEmpty == true) {
      return uniqueFilename(task.copyWith(filename: match.group(1)), unique);
    }
    // Try filename*=UTF-8'language'"encodedFilename"
    final encodedFilenameRegEx = RegExp(
        'filename\\*=\\s*([^\']+)\'([^\']*)\'"?([^"]+)"?',
        caseSensitive: false);
    match = encodedFilenameRegEx.firstMatch(disposition);
    if (match != null &&
        match.group(1)?.isNotEmpty == true &&
        match.group(3)?.isNotEmpty == true) {
      try {
        final suggestedFilename = match.group(1)?.toUpperCase() == 'UTF-8'
            ? Uri.decodeComponent(match.group(3)!)
            : match.group(3)!;
        return uniqueFilename(task.copyWith(filename: suggestedFilename), true);
      } on ArgumentError {
        _log.finest(
            'Could not interpret suggested filename (UTF-8 url encoded) ${match.group(3)}');
      }
    }
  } catch (_) {}
  _log.finest('Could not determine suggested filename from server');
  // Try filename derived from last path segment of the url
  try {
    final suggestedFilename = Uri.parse(task.url).pathSegments.last;
    return uniqueFilename(task.copyWith(filename: suggestedFilename), unique);
  } catch (_) {}
  _log.finest('Could not parse URL pathSegment for suggested filename');
  // if everything fails, return the task with unchanged filename
  // except for possibly making it unique
  return uniqueFilename(task, unique);
}
