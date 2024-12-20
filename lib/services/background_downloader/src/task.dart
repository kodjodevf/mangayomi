// ignore_for_file: depend_on_referenced_packages

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'file_downloader.dart';
import 'models.dart';
import 'utils.dart';

final _log = Logger('FileDownloader');

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
  /// - a Map: will be jsonEncoded to a String and set as the POST body
  /// - a List of bytes: will be converted to a String using String.fromCharCodes
  ///   and set as the POST body
  /// - a List: map will be jsonEncoded to a String and set as the POST body
  ///
  /// The field [post] will be a String
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
  /// - a Map: will be jsonEncoded to a String and set as the POST body
  /// - a List of bytes: will be converted to a String using String.fromCharCodes
  ///   and set as the POST body
  /// - a List: map will be jsonEncoded to a String and set as the POST body
  ///
  /// [retries] if >0 will retry a failed download this many times
  Request(
      {required String url,
      Map<String, String>? urlQueryParameters,
      Map<String, String>? headers,
      String? httpRequestMethod,
      post,
      this.retries = 0,
      DateTime? creationTime})
      : url = urlWithQueryParameters(url, urlQueryParameters),
        headers = headers ?? {},
        httpRequestMethod =
            httpRequestMethod?.toUpperCase() ?? (post == null ? 'GET' : 'POST'),
        post = post is Uint8List
            ? String.fromCharCodes(post)
            : post is Map || post is List
                ? jsonEncode(post)
                : post,
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

  /// Creates object from [json]
  Request.fromJson(Map<String, dynamic> json)
      : url = json['url'] ?? '',
        headers = Map<String, String>.from(json['headers'] ?? {}),
        httpRequestMethod = json['httpRequestMethod'] as String? ??
            (json['post'] == null ? 'GET' : 'POST'),
        post = json['post'] as String?,
        retries = (json['retries'] as num?)?.toInt() ?? 0,
        retriesRemaining = (json['retriesRemaining'] as num?)?.toInt() ?? 0,
        creationTime = DateTime.fromMillisecondsSinceEpoch(
            (json['creationTime'] as num?)?.toInt() ?? 0);

  /// Creates JSON map of this object
  Map<String, dynamic> toJson() => {
        'url': url,
        'headers': headers,
        'httpRequestMethod': httpRequestMethod,
        'post': post,
        'retries': retries,
        'retriesRemaining': retriesRemaining,
        'creationTime': creationTime.millisecondsSinceEpoch
      };

  /// The regex pattern to split the cookies in `Set-Cookie`.
  static final _regexSplitSetCookies = RegExp(',(?=[^ ])');

  /// Returns the cookie header appropriate for this [request],
  /// taken from the [cookies] list.
  ///
  /// [cookies] can be a List<Cookie> or the 'Set-Cookie' header value
  ///
  /// The returned map is the 'Cookie:' header, with the
  /// value=name; value2=name2 as the value.
  static Map<String, String> cookieHeader(dynamic cookies, String url) {
    final Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      _log.fine('Invalid url: $url error: $e');
      return {};
    }
    final List<Cookie> cookieList = switch (cookies) {
      http.Response response =>
        cookiesFromSetCookie(response.headers['set-cookie'] ?? ''),
      List<Cookie> list => list,
      String _ => cookiesFromSetCookie(cookies),
      _ => throw ArgumentError(
          'cookies parameter must be a http.Response object, a String or a List<Cookie>')
    };
    final path = uri.path.isNotEmpty ? uri.path : '/';
    final validCookies = cookieList.where((cookie) =>
        (cookie.maxAge == null || cookie.maxAge! > 0) &&
        (cookie.domain == null ||
            uri.host.endsWith(cookie.domain!) ||
            (cookie.domain!.startsWith('.') &&
                uri.host == cookie.domain!.substring(1))) &&
        (cookie.path == null || path.startsWith(cookie.path!)) &&
        (cookie.expires == null || cookie.expires!.isAfter(DateTime.now())) &&
        (!cookie.secure || uri.scheme == 'https'));
    final cookieHeaderValue = validCookies
        .map((c) => c.name.isNotEmpty ? '${c.name}=${c.value}' : c.value)
        .join('; ');
    return cookieHeaderValue.isNotEmpty ? {'Cookie': cookieHeaderValue} : {};
  }

  /// Returns a list of Cookies extracted from the [setCookie] string,
  /// which is the value of the 'Set-Cookie' header of a server response
  ///
  /// Based on https://github.com/dart-lang/http/pull/688/files
  static List<Cookie> cookiesFromSetCookie(String setCookie) {
    final cookies = <Cookie>[];
    if (setCookie.isNotEmpty) {
      for (final cookie in setCookie.split(_regexSplitSetCookies)) {
        cookies.add(Cookie.fromSetCookieValue(cookie));
      }
    }
    return cookies;
  }

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
  /// - a Map: will be jsonEncoded to a String and set as the POST body
  /// - a List of bytes: will be converted to a String using String.fromCharCodes
  ///   and set as the POST body
  /// - a List: map will be jsonEncoded to a String and set as the POST body
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
      String directory = '',
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
        filename = filename ?? Random().nextInt(1 << 32).toString(),
        directory = _startsWithPathSeparator.hasMatch(directory)
            ? directory.substring(1)
            : directory {
    if (filename?.isEmpty == true) {
      throw ArgumentError('Filename cannot be empty');
    }
    if (_pathSeparator.hasMatch(this.filename) && this is! MultiUploadTask) {
      throw ArgumentError('Filename cannot contain path separators');
    }
    if (allowPause && post != null) {
      throw ArgumentError('Tasks that can pause must be GET requests');
    }
    if (priority < 0 || priority > 10) {
      throw ArgumentError('Priority must be 0 <= priority <= 10');
    }
  }

  /// Create a new [Task] subclass from the provided [json]
  factory Task.createFromJson(Map<String, dynamic> json) =>
      switch (json['taskType']) {
        'DownloadTask' => DownloadTask.fromJson(json),
        'UploadTask' => UploadTask.fromJson(json),
        'MultiUploadTask' => MultiUploadTask.fromJson(json),
        'ParallelDownloadTask' => ParallelDownloadTask.fromJson(json),
        'DataTask' => DataTask.fromJson(json),
        _ => throw ArgumentError(
            'taskType not in [DownloadTask, UploadTask, MultiUploadTask, ParallelDownloadTask, DataTask]')
      };

  /// Create a new [Task] subclass from provided [jsonString]
  factory Task.createFromJsonString(String jsonString) {
    return Task.createFromJson(jsonDecode(jsonString));
  }

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
    final baseDirPath = await baseDirectoryPath(baseDirectory);
    return p.join(baseDirPath, directory, withFilename ?? filename);
  }

  /// Returns the path to the directory represented by [baseDirectory]
  ///
  /// On Windows, if [baseDirectory] is .root, returns the empty string
  /// because the drive letter is required to be included in the directory
  /// path
  static Future<String> baseDirectoryPath(BaseDirectory baseDirectory) async {
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
    final baseDir = switch ((baseDirectory, Task.useExternalStorage)) {
      (BaseDirectory.applicationDocuments, false) =>
        await getApplicationDocumentsDirectory(),
      (BaseDirectory.temporary, false) => await getTemporaryDirectory(),
      (BaseDirectory.applicationSupport, false) =>
        await getApplicationSupportDirectory(),
      (BaseDirectory.applicationLibrary, false)
          when Platform.isMacOS || Platform.isIOS =>
        await getLibraryDirectory(),
      (BaseDirectory.applicationLibrary, false) => Directory(
          p.join((await getApplicationSupportDirectory()).path, 'Library')),
      (BaseDirectory.root, _) => Directory('/'),
      // Android only: external storage variants
      (BaseDirectory.applicationDocuments, true) => externalStorageDirectory!,
      (BaseDirectory.temporary, true) => externalCacheDirectory!,
      (BaseDirectory.applicationSupport, true) =>
        Directory(p.join(externalStorageDirectory!.path, 'Support')),
      (BaseDirectory.applicationLibrary, true) =>
        Directory(p.join(externalStorageDirectory!.path, 'Library'))
    };
    return (Platform.isWindows && baseDirectory == BaseDirectory.root)
        ? ''
        : baseDir.absolute.path;
  }

  /// Extract the baseDirectory, directory and filename from
  /// the provided [filePath] or [file], and return this as a record
  ///
  /// Either [filePath] or [file] must be provided, not both.
  ///
  /// Throws a FileSystemException if using external storage on Android (via
  /// configuration at startup), and external storage is not available.
  static Future<
          (BaseDirectory baseDirectory, String directory, String filename)>
      split({String? filePath, File? file}) async {
    assert((filePath != null) ^ (file != null),
        'Either filePath or file must be given and not both');
    final path = filePath ?? file!.absolute.path;
    final absoluteDirectoryPath = p.dirname(path);
    final filename = p.basename(path);
    // try to match the start of the absoluteDirectory to one of the
    // directories represented by the BaseDirectory enum.
    // Order matters, as some may be subdirs of others
    final testSequence =
        Platform.isAndroid || Platform.isLinux || Platform.isWindows
            ? [
                BaseDirectory.temporary,
                BaseDirectory.applicationLibrary,
                BaseDirectory.applicationSupport,
                BaseDirectory.applicationDocuments
              ]
            : [
                BaseDirectory.temporary,
                BaseDirectory.applicationSupport,
                BaseDirectory.applicationLibrary,
                BaseDirectory.applicationDocuments
              ];
    for (final baseDirectoryEnum in testSequence) {
      final baseDirPath = await baseDirectoryPath(baseDirectoryEnum);
      final (match, directory) = _contains(baseDirPath, absoluteDirectoryPath);
      if (match) {
        return (baseDirectoryEnum, directory, filename);
      }
    }
    // if no match, return a BaseDirectory.root with the absoluteDirectory
    // minus the leading characters that designate the root (differs by platform)
    final match =
        RegExp(r'^(/|\\|([a-zA-Z]:[\\/]))').firstMatch(absoluteDirectoryPath);
    return (
      BaseDirectory.root,
      absoluteDirectoryPath.substring(match?.end ?? 0),
      filename
    );
  }

  /// Returns the subdirectory of the given [baseDirPath] within [dirPath],
  /// if [dirPath] starts with [baseDirPath].
  ///
  /// If found, returns (true, subdir) otherwise returns (false, '').
  ///
  /// [dirPath] should not contain a filename - if it does, it is returned
  /// as part of the subdir.
  static (bool, String) _contains(String baseDirPath, String dirPath) {
    final escapedBaseDirPath =
        '$baseDirPath${Platform.pathSeparator}?'.replaceAll(r'\', r'\\');
    final match = RegExp('^$escapedBaseDirPath(.*)').firstMatch(dirPath);
    return (match != null, match?.group(1) ?? '');
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
  /// subclassed [Task] from the [json]
  Task.fromJson(super.json)
      : taskId = json['taskId'] ?? '',
        filename = json['filename'] ?? '',
        directory = json['directory'] ?? '',
        baseDirectory =
            BaseDirectory.values[(json['baseDirectory'] as num?)?.toInt() ?? 0],
        group = json['group'] ?? FileDownloader.defaultGroup,
        updates = Updates.values[(json['updates'] as num?)?.toInt() ?? 0],
        requiresWiFi = json['requiresWiFi'] ?? false,
        allowPause = json['allowPause'] ?? false,
        priority = (json['priority'] as num?)?.toInt() ?? 5,
        metaData = json['metaData'] ?? '',
        displayName = json['displayName'] ?? '',
        super.fromJson();

  /// Creates JSON map of this object
  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
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

  /// Returns this.priority - other.priority if not the same
  /// Returns this.creationTime - other.creationTime if priorities the same
  /// Returns 0 if other is not a [Task]
  @override
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
  /// - a String: POST request with [post] as the body, encoded in utf8
  /// - a Map: will be jsonEncoded to a String and set as the POST body
  /// - a List of bytes: will be converted to a String using String.fromCharCodes
  ///   and set as the POST body
  /// - a List: map will be jsonEncoded to a String and set as the POST body
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

  /// Creates [DownloadTask] object from [json]
  DownloadTask.fromJson(super.json)
      : assert(
            ['DownloadTask', 'ParallelDownloadTask'].contains(json['taskType']),
            'The provided JSON map is not'
            ' a DownloadTask, because key "taskType" is not "DownloadTask" or "ParallelDownloadTask".'),
        super.fromJson();

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

  /// Map of name/value pairs to encode as form fields in a multi-part upload.
  /// To specify multiple values for a single name, format the value as
  /// '"value1", "value2", "value3"' so that it matches the following
  /// RegEx: ^(?:"[^"]+"\s*,\s*)+"[^"]+"$
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
      required String super.filename,
      super.headers,
      String? httpRequestMethod,
      String? super.post,
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
            httpRequestMethod: httpRequestMethod ?? 'POST', allowPause: false);

  /// Creates [UploadTask] from a [File] object, using the [file] absolute path.
  ///
  /// Note that using absolute paths is discouraged on mobile, as the path to
  /// files in an application's directory scope is not stable between application
  /// starts. Use the combination of [baseDirectory], [directory] and [filename]
  /// whenever possible to prevent hard to debug errors.
  UploadTask.fromFile(
      {required File file,
      super.taskId,
      required super.url,
      super.urlQueryParameters,
      super.headers,
      String? httpRequestMethod,
      String? super.post,
      this.fileField = 'file',
      String? mimeType,
      Map<String, String>? fields,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.retries,
      super.priority,
      super.metaData,
      super.displayName,
      super.creationTime})
      : fields = fields ?? {},
        mimeType =
            mimeType ?? lookupMimeType(file.path) ?? 'application/octet-stream',
        super(
            baseDirectory: BaseDirectory.root,
            directory: p.dirname(file.absolute.path),
            filename: p.basename(file.absolute.path),
            httpRequestMethod: httpRequestMethod ?? 'POST',
            allowPause: false);

  /// Creates [UploadTask] object from [json]
  UploadTask.fromJson(super.json)
      : assert(
            ['UploadTask', 'MultiUploadTask'].contains(json['taskType']),
            'The provided JSON map is not an UploadTask, '
            'because key "taskType" is not "UploadTask" or "MultiUploadTask.'),
        fileField = json['fileField'] ?? 'file',
        mimeType = json['mimeType'] ?? 'application/octet-stream',
        fields = Map<String, String>.from(json['fields'] ?? {}),
        super.fromJson();

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
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
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
      super.fields = const {},
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
                  String filename => p.basenameWithoutExtension(filename),
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
        super(filename: 'multi-upload', fileField: '', mimeType: '');

  /// For [MultiUploadTask], returns jsonEncoded list of [fileFields]
  @override
  String get fileField => jsonEncode(fileFields);

  /// For [MultiUploadTask], returns jsonEncoded list of [filenames]
  @override
  String get filename => jsonEncode(filenames);

  /// For [MultiUploadTask], returns jsonEncoded list of [mimeTypes]
  @override
  String get mimeType => jsonEncode(mimeTypes);

  /// Creates [MultiUploadTask] object from [json]
  MultiUploadTask.fromJson(super.json)
      : assert(
            json['taskType'] == 'MultiUploadTask',
            'The provided JSON map is not'
            ' a MultiUploadTask, because key "taskType" is not "MultiUploadTask".'),
        fileFields =
            List.from(jsonDecode(json['fileField'] as String? ?? '[]')),
        filenames = List.from(jsonDecode(json['filename'] as String? ?? '[]')),
        mimeTypes = List.from(jsonDecode(json['mimeType'] as String? ?? '[]')),
        super.fromJson();

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
            ? [urlWithQueryParameters(url, urlQueryParameters)]
            : List.from(
                url.map((e) => urlWithQueryParameters(e, urlQueryParameters))),
        super(url: url is String ? url : url.first) {
    retriesRemaining = 0; // chunk tasks will retry instead, based on [retries]
  }

  /// Creates [ParallelDownloadTask] object from [json]
  ParallelDownloadTask.fromJson(super.json)
      : assert(
            json['taskType'] == 'ParallelDownloadTask',
            'The provided JSON map is not a ParallelDownloadTask, '
            'because key "taskType" is not "ParallelDownloadTask".'),
        urls = List.from(json['urls'] as List<dynamic>? ?? []),
        chunks = json['chunks'] as int? ?? 1,
        super.fromJson();

  @override
  Map<String, dynamic> toJson() =>
      {...super.toJson(), 'urls': urls, 'chunks': chunks};

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

/// Class for background requests that do not involve a file
///
/// Closely resembles a Task, with  fewer fields available during construction
final class DataTask extends Task {
  /// Creates a [DataTask] that runs in the background, but does not involve a
  /// file
  ///
  /// [taskId] must be unique. A unique id will be generated if omitted
  /// [url] properly encoded if necessary, can include query parameters
  /// [urlQueryParameters] may be added and will be appended to the [url], must
  ///   be properly encoded if necessary
  /// [headers] an optional map of HTTP request headers
  /// [httpRequestMethod] the HTTP request method used (e.g. GET, POST)
  /// [post] String post body, encoded in utf8
  /// [json] if given will encode [json] to string and use as the [post] data
  /// [contentType] sets the Content-Type header to this value. If omitted and
  ///   [post] is given, it will be set to 'text-plain; charset=utf-8' and if
  ///   [json] is given, it will be set to 'application/json]
  /// [group] if set allows different callbacks or processing for different
  /// groups
  /// [updates] the kind of progress updates requested (only .status or none)
  /// [requiresWiFi] if set, will not start download until WiFi is available.
  /// If not set may start download over cellular network
  /// [retries] if >0 will retry a failed download this many times
  /// [priority] in range 0 <= priority <= 10 with 0 highest, defaults to 5
  /// [metaData] user data
  /// [displayName] human readable name for this task
  /// [creationTime] time of task creation, 'now' by default.
  DataTask(
      {String? taskId,
      required super.url,
      super.urlQueryParameters,
      super.headers,
      super.httpRequestMethod,
      String? post,
      Map<String, dynamic>? json,
      String? contentType,
      super.group,
      super.updates,
      super.requiresWiFi,
      super.retries,
      super.metaData,
      super.displayName,
      super.priority,
      super.creationTime})
      : assert(const [Updates.status, Updates.none].contains(updates),
            'DataTasks can only provide status updates'),
        super(
            post: json != null ? jsonEncode(json) : post,
            baseDirectory: BaseDirectory.temporary,
            allowPause: false) {
    // if no content-type header set, it is set to [contentType] or
    // (if post or json is given) to text/plain or application/json
    if (!headers.containsKey('Content-Type') &&
        !headers.containsKey('content-type')) {
      try {
        if (contentType != null) {
          headers['Content-Type'] = contentType;
        } else if ((post != null || json != null)) {
          assert((post != null) ^ (json != null),
              'Only post or json can be set, not both');
          headers['Content-Type'] =
              json != null ? 'application/json' : 'text/plain; charset=utf-8';
        }
      } on UnsupportedError {
        _log.warning(
            'Could not add Content-Type header as supplied header is const');
      }
    }
  }

  @override
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
          DateTime? creationTime}) =>
      DataTask(
          taskId: taskId ?? this.taskId,
          url: url ?? this.url,
          headers: headers ?? this.headers,
          httpRequestMethod: httpRequestMethod ?? this.httpRequestMethod,
          post: post as String? ?? this.post,
          group: group ?? this.group,
          updates: updates ?? this.updates,
          requiresWiFi: requiresWiFi ?? this.requiresWiFi,
          retries: retries ?? this.retries,
          priority: priority ?? this.priority,
          metaData: metaData ?? this.metaData,
          displayName: displayName ?? this.displayName,
          creationTime: creationTime ?? this.creationTime)
        ..retriesRemaining = retriesRemaining ?? this.retriesRemaining;

  /// Creates [DataTask] object from [json]
  DataTask.fromJson(super.json)
      : assert(
            json['taskType'] == 'DataTask',
            'The provided JSON map is not a DataTask, '
            'because key "taskType" is not "DataTask".'),
        super.fromJson();

  @override
  String get taskType => 'DataTask';
}
