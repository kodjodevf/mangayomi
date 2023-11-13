# A background file downloader and uploader for iOS, Android, MacOS, Windows and Linux

---
**NOTE**

This version requires Dart 3. If you need support for Dart 2 please use version `^6.1.1`, which will be maintained until the end of 2023.

If you want a 'lite' version, without references to the `sqflite` package, use branch [V7-lite](https://github.com/781flyingdutchman/background_downloader/tree/V7-lite) of the repo.

---

**If you are migrating from Flutter Downloader, please read the [migration document](https://github.com/781flyingdutchman/background_downloader/blob/main/MIGRATION.md)**

---
Create a [DownloadTask](https://pub.dev/documentation/background_downloader/latest/background_downloader/DownloadTask-class.html) to define where to get your file from, where to store it, and how you want to monitor the download, then call `FileDownloader().download` and wait for the result.  Background_downloader uses URLSessions on iOS and DownloadWorker on Android, so tasks will complete also when your app is in the background. The download behavior is highly consistent across all supported platforms: iOS, Android, MacOS, Windows and Linux.

Monitor progress by passing an `onProgress` listener, and monitor detailed status updates by passing an `onStatus` listener to the `download` call.  Alternatively, monitor tasks centrally using an [event listener](#using-an-event-listener) or [callbacks](#using-callbacks) and call `enqueue` to start the task.

Optionally, keep track of task status and progress in a persistent [database](#using-the-database-to-track-tasks), and show mobile [notifications](#notifications) to keep the user informed and in control when your app is in the background.

To upload a file, create an [UploadTask](https://pub.dev/documentation/background_downloader/latest/background_downloader/UploadTask-class.html) and call `upload`. To make a regular [server request](#server-requests), create a [Request](https://pub.dev/documentation/background_downloader/latest/background_downloader/Request-class.html) and call `request`. To download in parallel from multiple servers, create a [ParallelDownloadTask](https://pub.dev/documentation/background_downloader/latest/background_downloader/ParallelDownloadTask-class.html).

The plugin supports [headers](#headers), [retries](#retries), [priority](#priority), [requiring WiFi](#requiring-wifi) before starting the up/download, user-defined [metadata and display name](#metadata-and-displayname) and GET, [POST](#post-requests) and other http(s) [requests](#http-request-method), and can be [configured](#configuration) by platform. You can [manage  the tasks in the queue](#managing-tasks-and-the-queue) (e.g. cancel, pause and resume), and have different handlers for updates by [group](#grouping-tasks) of tasks. Downloaded files can be moved to [shared storage](#shared-and-scoped-storage) to make them available outside the app.

No setup is required for [Android](#android) (except when using notifications), Windows and Linux, and only minimal [setup for iOS](#ios) and [MacOS](#macos).

## Usage examples

### Downloads example

```dart
// Use .download to start a download and wait for it to complete

// define the download task (subset of parameters shown)
final task = DownloadTask(
        url: 'https://google.com/search',
        urlQueryParameters: {'q': 'pizza'},
        filename: 'results.html',
        headers: {'myHeader': 'value'},
        directory: 'my_sub_directory',
        updates: Updates.statusAndProgress, // request status and progress updates
        requiresWiFi: true,
        retries: 5,
        allowPause: true,
        metaData: 'data for me');

// Start download, and wait for result. Show progress and status changes
// while downloading
final result = await FileDownloader().download(task,
    onProgress: (progress) => print('Progress: ${progress * 100}%'),
    onStatus: (status) => print('Status: $status')
);

// Act on the result
switch (result.status) {
  case TaskStatus.complete:
    print('Success!');

  case TaskStatus.canceled:
    print('Download was canceled');

  case TaskStatus.paused:
    print('Download was paused');

  default:
    print('Download not successful');
}
```

### Enqueue example

```dart
// Use .enqueue for true parallel downloads, i.e. you don't wait for completion of the tasks you 
// enqueue, and can enqueue hundreds of tasks simultaneously.

// First define an event listener to process `TaskUpdate` events sent to you by the downloader, 
// typically in your app's `initState()`:
FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate _:
          // process the TaskStatusUpdate, e.g.
        switch (update.status) {
          case TaskStatus.complete:
          print('Task ${update.task.taskId} success!');
          
          case TaskStatus.canceled:
          print('Download was canceled');
          
          case TaskStatus.paused:
          print('Download was paused');
          
          default:
          print('Download not successful');
          }

        case TaskProgressUpdate _:
          // process the TaskProgressUpdate, e.g.
          progressUpdateStream.add(update); // pass on to widget for indicator
      }
    });

// Next, enqueue tasks to kick off background downloads, e.g.
final successfullyEnqueued = await FileDownloader().enqueue(DownloadTask(
                                url: 'https://google.com',
                                filename: 'google.html',
                                updates: Updates.statusAndProgress));
```

### Uploads example

```dart
/// define the multi-part upload task (subset of parameters shown)
final task = UploadTask(
        url: 'https://myserver.com/uploads',
        filename: 'myData.txt',
        fields: {'datafield': 'value'},
        fileField: 'myFile', 
        updates: Updates.statusAndProgress // request status and progress updates
);

// Start upload, and wait for result. Show progress and status changes
// while uploading
final result = await FileDownloader().upload(task,
  onProgress: (progress) => print('Progress: ${progress * 100}%'),
  onStatus: (status) => print('Status: $status')
);

// Act on result, similar to download
```

### Batch download example
```dart
final tasks = [task1, task2, task3]; // a list of Download tasks

// download the batch
final result = await FileDownloader().downloadBatch(tasks,
  batchProgressCallback: (succeeded, failed) =>
    print('Completed ${succeeded + failed} out of ${tasks.length}, $failed failed')
);
```

### Task tracking database example
```dart
// activate tracking at the start of your app
await FileDownloader().trackTasks();

// somewhere else: enqueue a download (does not complete immediately)
final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt');
final successfullyEnqueued = await FileDownloader().enqueue(task);

// query the tracking database, returning a record for each task
final records = await FileDownloader().database.allRecords();
for (record in records) {
  print('Task ${record.tasksId} status is ${record.status}');
  if (record.status == TaskStatus.running) {
    print('-- progress ${record.progress * 100}%');
    print('-- file size ${record.expectedFileSize} bytes');
  }
};

// or get record for specific task
final record = await FileDownloader().database.recordForId(task.taskId);
```

### Notifications example
```dart
// configure notification for all tasks
FileDownloader().configureNotification(
  running: TaskNotification('Downloading', 'file: {filename}'),
  complete: TaskNotification('Download finished', 'file: {filename}'),
  progressBar: true
);

// all downloads will now show a notification while downloading, and when complete. 
// {filename} will be replaced with the task's filename.
```

---

# Contents

- [Basic use](#basic-use)
  - [Tasks and the FileDownloader](#tasks-and-the-filedownloader)
  - [Monitoring the task](#monitoring-the-task)
  - [Specifying the location of the file to download or upload](#specifying-the-location-of-the-file-to-download-or-upload)
  - [A batch of files](#a-batch-of-files)
- [Central monitoring and tracking in a persistent database](#central-monitoring-and-tracking-in-a-persistent-database)
  - [Using an event listener](#using-an-event-listener)
  - [Using callbacks](#using-callbacks)
  - [Using the database to track Tasks](#using-the-database-to-track-tasks)
- [Notifications](#notifications)
- [Shared and scoped storage](#shared-and-scoped-storage)
- [Uploads](#uploads)
- [Parallel downloads](#parallel-downloads)
- [Managing tasks in the queue](#managing-tasks-and-the-queue)
  - [Canceling, pausing and resuming tasks](#canceling-pausing-and-resuming-tasks)
  - [Grouping tasks](#grouping-tasks)
  - [Task queues](#task-queues)
- [Server requests](#server-requests)
- [Optional parameters](#optional-parameters)
- [Initial setup](#initial-setup)
- [Configuration](#configuration)
- [Limitations](#limitations)

## Basic use

### Tasks and the FileDownloader

A `DownloadTask` or `UploadTask` (both subclasses of `Task`) defines one download or upload. It contains the `url`, the file name and location, what updates you want to receive while the task is in progress, [etc](#optional-parameters).  The [FileDownloader](https://pub.dev/documentation/background_downloader/latest/background_downloader/FileDownloader-class.html) class is the entrypoint for all calls. To download a file:
```dart
final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt'); // define your task
final result = await FileDownloader().download(task);  // do the download and wait for result
```

The `result` will be a [TaskStatusUpdate](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskStatusUpdate-class.html), which has a field `status` that indicates how the download ended: `.complete`, `.failed`, `.canceled` or `.notFound`. If the `status` is `.failed`, the `result.exception` field will contain a `TaskException` with information about what went wrong. For uploads and some unsuccessful downloads, the `responseBody` will contain the server response.

### Monitoring the task

#### Progress

If you want to monitor progress during the download itself (e.g. for a large file), then add a progress callback that takes a double as its argument:
```dart
final result = await FileDownloader().download(task, 
    onProgress: (progress) => print('Progress update: $progress'));
```
Progress updates start with 0.0 when the actual download starts (which may be in the future, e.g. if waiting for a WiFi connection), and will be sent periodically, not more than twice per second per task.  If a task completes successfully you will receive a final progress update with a `progress` value of 1.0 (`progressComplete`). Failed tasks generate `progress` of `progressFailed` (-1.0), canceled tasks `progressCanceled` (-2.0), notFound tasks `progressNotFound` (-3.0), waitingToRetry tasks `progressWaitingToRetry` (-4.0) and paused tasks `progressPaused` (-5.0).

Use `await task.expectedFileSize()` to query the server for the size of the file you are about
to download.  The expected file size is also included in `TaskProgressUpdate`s that are sent to
listeners and callbacks - see [Using an event listener](#using-an-event-listener) and [Using callbacks](#using-callbacks)

A [DownloadProgressIndicator](https://pub.dev/documentation/background_downloader/latest/background_downloader/DownloadProgressIndicator-class.html) widget is included with the package, and the example app shows how to wire it up.
The widget can be configured to include pause and resume buttons, and to expand to show multiple
simultaneous downloads, or to collapse and show a file download counter.

To provide progress updates (as a percentage of total file size) the downloader needs to know the size of the file when starting the download. Most servers provide this in the "Content-Length" header of their response. If the server does not provide the file size, yet you know the file size (e.g. because you have stored the file on the server yourself), then you can let the downloader know by providing a `{'Range': 'bytes=0-999'}` or a `{'Known-Content-Length': '1000'}` header to the task's `header` field. Both examples are for a content length of 1000 bytes.  The downloader will assume this content length when calculating progress.  

#### Status

If you want to monitor status changes while the download is underway (i.e. not only the final state, which you will receive as the result of the `download` call) you can add a status change callback that takes the status as an argument:
```dart
final result = await FileDownloader().download(task,
    onStatus: (status) => print('Status update: $status'));
```

The status will follow a sequence of `.enqueued` (waiting to execute), `.running` (actively 
downloading) and then one of the final states mentioned before, or `.waitingToRetry` if retries 
are enabled and the task failed.

If a task fails with `TaskStatus.failed` then in some cases it is possible to `resume` the task without having to start from scratch. You can test whether this is possible by calling `FileDownloader().taskCanResume(task)` and if true, call `resume` instead of `download` or `enqueue`.

#### Elapsed time

If you want to keep an eye on how long the download is taking (e.g. to warn the user that there may be an issue with their network connection, or to cancel the task if it takes too long), pass an `onElapsedTime` callback to the `download` method. The callback takes a single argument of type `Duration`, representing the time elapsed since the call to `download` was made. It is called at regular intervals (defined by `elapsedTimeInterval` which defaults to 5 seconds), so you can react in different ways depending on the total time elapsed. For example:
```dart
final result = await FileDownloader().download(
                      task, 
                      onElapsedTime: (elapsed) {
                          print('This is taking rather long: $elapsed');
                      },
                      elapsedTimeInterval: const Duration(seconds: 30));
```

The elapsed time logic is only available for `download`, `upload`, `downloadBatch` and `uploadBatch`. It is not available for tasks started using `enqueue`, as there is no expectation that those complete imminently.


### Specifying the location of the file to download or upload

In the `DownloadTask` and `UploadTask` objects, the `filename` of the task refers to the filename without directory. To store the task in a specific directory, add the `directory` parameter to the task. That directory is relative to the base directory, so cannot start with a `/`. By default, the base directory is the directory returned by the call to `getApplicationDocumentsDirectory()` of the [path_provider](https://pub.dev/packages/path_provider) package, but this can be changed by also passing a `baseDirectory` parameter (`BaseDirectory.temporary` for the directory returned by `getTemporaryDirectory()`, `BaseDirectory.applicationSupport` for the directory returned by `getApplicationSupportDirectory()` and `BaseDirectory.applicationLibrary` for the directory returned by `getLibraryDirectory()` on iOS and MacOS, or subdir 'Library' of the directory returned by `getApplicationSupportDirectory()` on other platforms).

So, to store a file named 'testfile.txt' in the documents directory, subdirectory 'my/subdir', define the task as follows:
```dart
final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt',
        directory: 'my/subdir');
```

To store that file in the temporary directory:
```dart
final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt',
        directory: 'my/subdir',
        baseDirectory: BaseDirectory.temporary);
```

The downloader will only store the file upon success (so there will be no partial files saved), and if so, the destination is overwritten if it already exists, and all intermediate directories will be created if needed.

Note: the reason you cannot simply pass a full absolute directory path to the downloader is that the location of the app's documents directory may change between application starts (on iOS), and may therefore fail for downloads that complete while the app is suspended.  You should therefore never store permanently, or hard-code, an absolute path.

Android has two storage modes: internal (default) and external storage. Read the [configuration document](https://github.com/781flyingdutchman/background_downloader/blob/main/CONFIG.md) for details on how to configure your app to use external storage instead of the default.

#### Server-suggested filename

If you want the filename to be provided by the server (instead of assigning a value to `filename` yourself), you have two options. The first is to create a `DownloadTask` that pings the server to determine the suggested filename:
```dart
final task = await DownloadTask(url: 'https://google.com')
        .withSuggestedFilename(unique: true);
```
The method `withSuggestedFilename` returns a copy of the task it is called on, with the `filename` field modified based on the filename suggested by the server, or the last path segment of the URL, or unchanged if neither is feasible (e.g. due to a lack of connection). If `unique` is true, the filename will be modified such that it does not conflict with an existing filename by adding a sequence. For example "file.txt" would become "file (1).txt". You can also supply a `taskWithFilenameBuilder` to suggest the filename yourself, based on response headers.

The second approach is to set the `filename` field of the `DownloadTask` to `DownloadTask.suggestedFilename`, to indicate that you would like the server to suggest the name. In this case, you will receive the name via the task's status and/or progress updates, so you have to be careful _not_ to use the original task's filename, as that will still be `DownloadTask.suggestedFilename`. For example:
```dart
final task = await DownloadTask(url: 'https://google.com', filename: DownloadTask.suggestedFilename);
final result = await FileDownloader().download(task);
print('Suggested filename=${result.task.filename}'); // note we don't use 'task', but 'result.task'
print('Wrong use filename=${task.filename}'); // this will print '?' as 'task' hasn't changed
```

### A batch of files

To download a batch of files and wait for completion of all, create a `List` of `DownloadTask` objects and call `downloadBatch`:
```dart
final result = await FileDownloader().downloadBatch(tasks);
```

The result is a `Batch` object that contains the result for each task in `.results`. You can use `.numSucceeded` and `.numFailed` to check if all files in the batch downloaded successfully, and use `.succeeded` or `.failed` to iterate over successful or failed tasks within the batch.  If you want to get progress updates for the batch (in terms of how many files have been downloaded) then add a callback:
```dart
final result = await FileDownloader().downloadBatch(tasks, batchProgressCallback: (succeeded, failed) {
  print('$succeeded files succeeded, $failed have failed');
  print('Progress is ${(succeeded + failed) / tasks.length} %');
});
```
The callback will be called upon completion of each task (whether successful or not), and will start with (0, 0) before any downloads start, so you can use that to start a progress indicator.

To also monitor status and progress for each file in the batch, add a [TaskStatusCallback](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskStatusCallback.html)  and/or a [TaskProgressCallback](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskProgressCallback.html)

To monitor based on elapsed time, see [Elapsed time](#elapsed-time).

For uploads, create a `List` of `UploadTask` objects and call `uploadBatch` - everything else is the same.

## Central monitoring and tracking in a persistent database

Instead of monitoring in the `download` call, you may want to use a centralized task monitoring approach, and/or keep track of tasks in a database. This is helpful for instance if:
1. You start download in multiple locations in your app, but want to monitor those in one place, instead of defining `onStatus` and `onProgress` for every call to `download`
2. You have different groups of tasks, and each group needs a different monitor
3. You want to keep track of the status and progress of tasks in a persistent database that you query
4. Your downloads take long, and your user may switch away from your app for a long time, which causes your app to get suspended by the operating system. A download started with a call to `download` will continue in the background and will finish eventually, but when your app restarts from a suspended state, the result `Future` that you were awaiting when you called `download` may no longer be 'alive', and you will therefore miss the completion of the downloads that happened while suspended. This situation is uncommon, as the app will typically remain alive for several minutes even when moving to the background, but if you find this to be a problem for your use case, then you should process status and progress updates for long running background tasks centrally.

Central monitoring can be done by listening to an updates stream, or by registering callbacks. In both cases you now use `enqueue` instead of `download` or `upload`. `enqueue` returns almost immediately with a `bool` to indicate if the `Task` was successfully enqueued. Monitor status changes and act when a `Task` completes via the listener or callback.

To ensure your callbacks or listener capture events that may have happened when your app was suspended in the background, call `resumeFromBackground` right after registering your callbacks or listener.

In summary, to track your tasks persistently, follow these steps in order, immediately after app startup:
1. Register an event listener or callback(s) to process status and progress updates
2. call `await FileDownloader().trackTasks()` if you want to track the tasks in a persistent database
3. call `await FileDownloader().resumeFromBackground()` to ensure events that happened while your app was in the background are processed

The rest of this section details [event listeners](#using-an-event-listener), [callbacks](#using-callbacks) and the [database](#using-the-database-to-track-tasks) in detail.

### Using an event listener

Listen to updates from the downloader by listening to the `updates` stream, and process those updates centrally. For example, the following creates a listener to monitor status and progress updates for downloads, and then enqueues a task as an example:
```dart
    final subscription = FileDownloader().updates.listen((update) {
        if (update is TaskStatusUpdate) {
            print('Status update for ${update.task} with status ${update.status}');
        } else if (update is TaskProgressUpdate) {
            print('Progress update for ${update.task} with progress ${update.progress}');
        }
    });
    
    // define the task
    final task = DownloadTask(
        url: 'https://google.com',
        filename: 'google.html',
        updates: Updates.statusAndProgress); // needed to also get progress updates
        
    // enqueue the download
    final successFullyEnqueued = await FileDownloader().enqueue(task);
    // updates will be sent to your subscription listener
```

A TaskProgressUpdate includes `expectedFileSize`, `networkSpeed` and `timeRemaining`. Check the associated `hasExpectedFileSize`, `hasNetworkSpeed` and `hasTimeRemaining` before using the values in these fields.  Use `networkSpeedAsString` and `timeRemainingAsString` for human readable versions of these values.

Note that `successFullyEnqueued` only refers to the enqueueing of the download task, not its result, which must be monitored via the listener. Also note that in order to get progress updates the task must set its `updates` field to a value that includes progress updates. In the example, we are asking for both status and progress updates, but other combinations are possible. For example, if you set `updates` to `Updates.status` then the task will only generate status updates and no progress updates. You define what updates to receive on a task by task basis via the `Task.updates` field, which defaults to status updates only.

You can start your subscription in a convenient place, like a widget's `initState`, and don't forget to cancel your subscription to the stream using `subscription.cancel()`. Note the stream can only be listened to once, though you can reset the stream controller by calling `await FileDownloader().resetUpdates()` to start listening again.

### Using callbacks

Instead of listening to the `updates` stream you can register a callback for status updates, and/or a callback for progress updates.  This may be the easiest way if you want different callbacks for different [groups](#grouping-tasks).

The [TaskStatusCallback](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskStatusCallback.html) receives a [TaskStatusUpdate](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskStatusUpdate-class.html), so a simple callback function is:
```dart
void taskStatusCallback(TaskStatusUpdate update) {
  print('taskStatusCallback for ${update.task) with status ${update.status} and exception ${update.exception}');
}
```

The [TaskProgressCallback](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskProgressCallback.html) receives a [TaskProgressUpdate](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskProgressUpdate-class.html), so a simple callback function is:
```dart
void taskProgressCallback(TaskProgressUpdate update) {
  print('taskProgressCallback for ${update.task} with progress ${update.progress} '
        'and expected file size ${update.expectedFileSize}');
}
```

A basic file download with just status monitoring (no progress) then requires registering the central callback, and a call to `enqueue` to start the download:
```dart
FileDownloader().registerCallbacks(taskStatusCallback: taskStatusCallback);
final successFullyEnqueued = await FileDownloader().enqueue(
    DownloadTask(url: 'https://google.com', filename: 'google.html'));
```

You define what updates to receive on a task by task basis via the `Task.updates` field, which defaults to status updates only.  If you register a callback for a type of task, updates are provided only through that callback and will not be posted on the `updates` stream.

Note that all tasks will call the same callback, unless you register separate callbacks for different [groups](#grouping-tasks) and set your `Task.group` field accordingly.

You can unregister callbacks using `FileDownloader().unregisterCallbacks()`.

### Using the database to track Tasks

To keep track of the status and progress of all tasks, even after they have completed, activate tracking by calling `trackTasks()` and use the `database` field to query and retrieve the [TaskRecord](https://pub.dev/documentation/background_downloader/latest/background_downloader/TaskRecord-class.html) entries stored. For example:
```dart
// at app startup, after registering listener or callback, start tracking
await FileDownloader().trackTasks();

// somewhere else: enqueue a download
final task = DownloadTask(
        url: 'https://google.com',
        filename: 'testfile.txt');
final successfullyEnqueued = await FileDownloader().enqueue(task);

// somewhere else: query the task status by getting a `TaskRecord`
// from the database
final record = await FileDownloader().database.recordForId(task.taskId);
print('Taskid ${record.taskId} with task ${record.task} has '
    'status ${record.status} and progress ${record.progress} '
    'with an expected file size of ${record.expectedFileSize} bytes'
```

You can interact with the `database` using `allRecords`, `allRecordsOlderThan`, `recordForId`,`deleteAllRecords`,
`deleteRecordWithId` etc. If you only want to track tasks in a specific [group](#grouping-tasks), call `trackTasksInGroup` instead.

By default, the downloader uses a modified version of the [localstore](https://pub.dev/packages/localstore) package to store the `TaskRecord` and other objects. To use a different persistent storage solution, create a class that implements the [PersistentStorage](https://pub.dev/documentation/background_downloader/latest/background_downloader/PersistentStorage-class.html) interface, and initialize the downloader by calling `FileDownloader(persistentStorage: yourStorageClass())` as the first use of the `FileDownloader`.

As an alternative to LocalStore, use `SqlitePersistentStorage` and see the [migration document](https://github.com/781flyingdutchman/background_downloader/blob/main/MIGRATION.md) to understand how it can migrate files from Localstore and the Flutter Downloader package.


## Notifications

On iOS and Android, for downloads only, the downloader can generate notifications to keep the user informed of progress also when the app is in the background, and allow pause/resume and cancellation of an ongoing download from those notifications.

Configure notifications by calling `FileDownloader().configureNotification` and supply a
`TaskNotification` object for different states. For example, the following configures
notifications to show only when actively running (i.e. download in progress), disappearing when
the download completes or ends with an error. It will also show a progress bar and a 'cancel'
button, and will substitute {filename} with the actual filename of the file being downloaded.
```dart
FileDownloader().configureNotification(
    running: TaskNotification('Downloading', 'file: {filename}'),
    progressBar: true);
```

To also show a notifications for other states, add a `TaskNotification` for `complete`, `error`
and/or `paused`. If `paused` is configured and the task can be paused, a 'Pause' button will
show for the `running` notification, next to the 'Cancel' button. To open the downloaded file
when the user taps the `complete` notification, add `tapOpensFile: true` to your call to
`configureNotification`

There are four possible substitutions of the text in the `title` or `body` of a `TaskNotification`:
* {filename} is replaced with the `filename` field of the `Task`
* {displayName} is replaced with the `displayName` field of the `Task`
* {progress} is substituted by a progress percentage, or '--%' if progress is unknown
* {metadata} is substituted by the `metaData` field of the `Task`

Notifications on iOS follow Apple's [guidelines](https://developer.apple.com/design/human-interface-guidelines/components/system-experiences/notifications/), notably:
* No progress bar is shown, and the {progress} substitution always substitutes to an empty string. In other words: only a single `running` notification is shown and it is not updated until the download state changes
* When the app is in the foreground, on iOS 14 and above the notification will not be shown but will appear in the NotificationCenter. On older iOS versions the notification will be shown also in the foreground. Apple suggests showing progress and download controls within the app when it is in the foreground

While notifications are possible on desktop platforms, there is no true background mode, and progress updates and indicators can be shown within the app. Notifications are therefore ignored on desktop platforms.

The `configureNotification` call configures notification behavior for all download tasks. You can specify a separate configuration for a `group` of tasks by calling `configureNotificationForGroup` and for a single task by calling `configureNotificationForTask`. A `Task` configuration overrides a `group` configuration, which overrides the default configuration.

When attempting to show its first notification, the downloader will ask the user for permission to show notifications (platform version dependent) and abide by the user choice. For Android, starting with API 33, you need to add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />` to your app's `AndroidManifest.xml`. Also on Android you can localize the button text by overriding string resources `bg_downloader_cancel`, `bg_downloader_pause`, `bg_downloader_resume` and descriptions `bg_downloader_notification_channel_name`, `bg_downloader_notification_channel_description`. Localization on iOS can be done through [configuration](#configuration).

To respond to the user tapping a notification, register a callback that takes `Task` and `NotificationType` as parameters:

```dart
FileDownloader().registerCallbacks(
  taskNotificationTapCallback: myNotificationTapCallback);

void myNotificationTapCallback(Task task, NotificationType notificationType) {
  print('Tapped notification $notificationType for taskId ${task.taskId}');
}
```

Note that convenience methods that `await` a result, such as `download` (but not `enqueue`), use the default `taskNotificationTapCallback` you register, even though those tasks are in the `awaitGroup`, because that behavior is more in line with expectations. If you need a separate callback for the `awaitGroup`, then set it _after_ setting the default callback. You set the default callback by omitting the `group` parameter in the `registerCallbacks` call.

### Opening a downloaded file

To open a file (e.g. in response to the user tapping a notification), call `FileDownloader().openFile` and supply either a `Task` or a full `filePath` (but not both) and optionally a `mimeType` to assist the Platform in choosing the right application to use to open the file.
The file opening behavior is platform dependent, and while you should check the return value of the call to `openFile`, error checking is not fully consistent.

Note that on Android, files stored in the `BaseDirectory.applicationDocuments` cannot be opened. You need to download to a different base directory (e.g. `.applicationSupport`) or move the file to shared storage before attempting to open it.

If all you want to do on notification tap is to open the file, you can simplify the process by
adding `tapOpensFile: true` to your call to `configureNotifications`, and you don't need to
register a `taskNotificationTapCallback`.


### Setup for notifications

On iOS, add the following to your `AppDelegate.swift`:
```swift
UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
```
or if using Objective C, add to `AppDelegate.m`:
```objective-c
[UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
```


## Shared and scoped storage

The download directories specified in the `BaseDirectory` enum are all local to the app. To make downloaded files available to the user outside of the app, or to other apps, they need to be moved to shared or scoped storage, and this is platform dependent behavior. For example, to move the downloaded file associated with a `DownloadTask` to a shared 'Downloads' storage destination, execute the following _after_ the download has completed:
```dart
final newFilepath = await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads);
if (newFilePath == null) {
  // handle error
} else {
  // do something with the newFilePath
}
```

Because the behavior is very platform-specific, not all `SharedStorage` destinations have the same result. The options are:
* `.downloads` - implemented on all platforms, but 'faked' on iOS: files in this directory are not accessible to other users
* `.images` - implemented on Android and iOS only, and 'faked' on iOS: files in this directory are not accessible to other users
* `.video` - implemented on Android and iOS only, and 'faked' on iOS: files in this directory are not accessible to other users
* `.audio` - implemented on Android and iOS only, and 'faked' on iOS: files in this directory are not accessible to other users
* `.files` - implemented on Android only
* `.external` - implemented on Android only

The 'fake' on iOS is that we create an appropriately named subdirectory in the application's Documents directory where the file is moved to. iOS apps do not have access to the system wide directories.

Methods `moveToSharedStorage` and the similar `moveFileToSharedStorage` also take an optional
`directory` argument for a subdirectory in the `SharedStorage` destination. They also take an
optional `mimeType` parameter that overrides the mimeType derived from the filePath extension.

If the file already exists in shared storage, then on iOS and desktop it will be overwritten,
whereas on Android API 29+ a new file will be created with an indexed name (e.g. 'myFile (1).txt').

__On MacOS:__ For the `.downloads` to work you need to enable App Sandbox entitlements and set the key `com.apple.security.files.downloads.read-write` to true.  
__On Android:__ Depending on what `SharedStorage` destination you move a file to, and depending on the OS version your app runs on, you _may_ require extra permissions `WRITE_EXTERNAL_STORAGE` and/or `READ_EXTERNAL_STORAGE` . See [here](https://medium.com/androiddevelopers/android-11-storage-faq-78cefea52b7c) for details on the new scoped storage rules starting with Android API version 30, which is what the plugin is using.

### Path to file in shared storage

To check if a file exists in shared storage, obtain the path to the file by calling
`pathInSharedStorage` and, if not null, check if that file exists.

__On Android 29+:__ If you
have generated a version with an indexed name (e.g. 'myFile (1).txt'), then only the most recently stored version is available this way, even if an earlier version actually does exist. Also, only files stored by your app will be returned via this call, as you don't have access to files stored by other apps.

__On iOS:__ To make files visible in the Files browser, do not move them to shared storage. Instead, download the file to the `BaseDirectory.applicationDocuments` and add the following to your `Info.plist`:
```
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>UIFileSharingEnabled</key>
<true/>
```
This will make all files in your app's `Documents` directory visible to the Files browser.

## Uploads

Uploads are very similar to downloads, except:
* define an `UploadTask` object instead of a `DownloadTask`
* the file location now refers to the file you want to upload
* call `upload` instead of `download`, or `uploadBatch` instead of `downloadBatch`

There are two ways to upload a file to a server: binary upload (where the file is included in the POST body) and form/multi-part upload. Which type of upload is appropriate depends on the server you are uploading to. The upload will be done using the binary upload method only if you have set the `post` field of the `UploadTask` to 'binary'.

For multi-part uploads you can specify name/value pairs in the `fields` field of the `UploadTask` as a `Map<String, String>`. These will be uploaded as form fields along with the file. You can also set the field name used for the file itself by setting `fileField` (default is "file") and override the mimeType by setting `mimeType` (default is derived from filename extension).

If you need to upload multiple files in a single request, create a [MultiUploadTask](https://pub.dev/documentation/background_downloader/latest/background_downloader/MultiUploadTask-class.html) instead of an `UploadTask`. It has similar parameters as the `UploadTask`, except you specifiy a list of files to upload as the `files` argument of the constructor, and do not use `fileName`, `fileField` and `mimeType`. Each element in the `files` list is either:
* a filename (e.g. `"file1.txt"`). The `fileField` for that file will be set to the base name (i.e. "file1" for "file1.txt") and the mime type will be derived from the extension (i.e. "text/plain" for "file1.txt")
* a record containing `(fileField, filename)`, e.g. `("document", "file1.txt")`. The `fileField` for that file will be set to "document" and the mime type derived from the file extension (i.e. "text/plain" for "file1.txt")
* a record containing `(filefield, filename, mimeType)`, e.g. `("document", "file1.txt", "text/plain")`

The `baseDirectory` and `directory` fields of the `MultiUploadTask` determine the expected location of the file referenced, unless the filename used in any of the 3 formats above is an absolute path (e.g. "/data/user/0/com.my_app/file1.txt"). In that case, the absolute path is used and the `baseDirectory` and `directory` fields are ignored for that element of the list.
Once the `MultiUpoadTask` is created, the fields `fileFields`, `filenames` and `mimeTypes` will contain the parsed items, and the fields `fileField`, `filename` and `mimeType` contain those lists encoded as a JSON string.

Use the `MultiTaskUpload` object in the `upload` and `enqueue` methods as you would a regular `UploadTask`.

## Parallel downloads

Some servers may offer an option to download part of the same file from multiple URLs or have multiple parallel downloads of part of a large file using a single URL. This can speed up the download of large files.  To do this, create a `ParallelDownloadTask` instead of a regular `DownloadTask` and specify `chunks` (the number of pieces you want to break the file into, i.e. the number of downloads that will happen in parallel) and `urls` (as a list of URLs, or just one). For example, if you specify 4 chunks and 2 URLs, then the download will be broken into 8 pieces, four each for each URL.

Note that the implementation of this feature creates a regular `DownloadTask` for each chunk, with the group name 'chunk' which is now a reserved group. You will not get updates for this group, but you will get normal updates (status and/or progress) for the `ParallelDownloadTask`.

## Managing tasks and the queue

### Canceling, pausing and resuming tasks

To enable pausing, set the `allowPause` field of the `Task` to `true`. This may also cause the task to `pause` un-commanded. For example, the OS may choose to pause the task if someone walks out of WiFi coverage.

To cancel, pause or resume a task, call:
* `cancelTaskWithId` to cancel the tasks with that taskId
* `cancelTasksWithIds` to cancel all tasks with a `taskId` in the provided list of taskIds
* `pause` to attempt to pause a task. Pausing is only possible for download GET requests, only if the `Task.allowPause` field is true, and only if the server supports pause/resume. Soon after the task is running (`TaskStatus.running`) you can call `taskCanResume` which will return a Future that resolves to `true` if the server appears capable of pause & resume. If it is not, then `pause` will have no effect and return false
* `resume` to resume a previously paused task (or certain failed tasks), which returns true if resume appears feasible. The task status will follow the same sequence as a newly enqueued task. If resuming turns out to be not feasible (e.g. the operating system deleted the temp file with the partial download) then the task will either restart as a normal download, or fail.


To manage or query the queue of waiting or running tasks, call:
* `reset` to reset the downloader, which cancels all ongoing download tasks
* `allTaskIds` to get a list of `taskId` values of all tasks currently active (i.e. not in a final state). You can exclude tasks waiting for retries by setting `includeTasksWaitingToRetry` to `false`. Note that paused tasks are not included in this list
* `allTasks` to get a list of all tasks currently active (i.e. not in a final state). You can exclude tasks waiting for retries by setting `includeTasksWaitingToRetry` to `false`. Note that paused tasks are not included in this list
* `taskForId` to get the `Task` for the given `taskId`, or `null` if not found.
* `tasksFinished` to check if all tasks have finished (successfully or otherwise)

Each of these methods accept a `group` parameter that targets the method to a specific group. If tasks are enqueued with a `group` other than default, calling any of these methods without a group parameter will not affect/include those tasks - only the default tasks. In particular, this may affect tasks started using a method like `download`, which changes the task's group to `FileDownloader.awaitGroup`.

**NOTE:** Only tasks that are active (ie. not in a final state) are guaranteed to be returned or counted, but returning a task does not guarantee that it is active.
This means that if you check `tasksFinished` when processing a task update, the task you received an update for may still show as 'active', even though it just finished, and result in `false` being returned. To fix this, pass that task's taskId as `ignoreTaskId` to the `tasksFinished` call, and it will be ignored for the purpose of testing if all tasks are finished: 
```dart
void downloadStatusCallback(TaskStatusUpdate update) async {
    // process your status update, then check if all tasks are finished
    final bool allTasksFinished = update.status.isFinalState && 
        await FileDownloader().tasksFinished(ignoreTaskId: update.task.taskId) ;
    print('All tasks finished: $allTasksFinished');
  }
```

### Grouping tasks

Because an app may require different types of downloads, and handle those differently, you can specify a `group` with your task, and register callbacks specific to each `group`. If no group is specified the default group `FileDownloader.defaultGroup` is used. For example, to create and handle downloads for group 'bigFiles':
```dart
FileDownloader().registerCallbacks(
    group: 'bigFiles'
    taskStatusCallback: bigFilesDownloadStatusCallback,
    taskProgressCallback: bigFilesDownloadProgressCallback);
final task = DownloadTask(
    group: 'bigFiles',
    url: 'https://google.com',
    filename: 'google.html',
    updates: Updates.statusAndProgress);
final successFullyEnqueued = await FileDownloader().enqueue(task);
```

The methods `registerCallBacks`, `unregisterCallBacks`, `reset`, `allTaskIds`, `allTasks` and `tasksFinished` all take an optional `group` parameter to target tasks in a specific group. Note that if tasks are enqueued with a `group` other than default, calling any of these methods without a group parameter will not affect/include those tasks - only the default tasks.

If you listen to the `updates` stream instead of using callbacks, you can test for the task's `group` field in your listener, and process the update differently for different groups.

Note: tasks that are started using `download`, `upload`, `batchDownload` or `batchUpload` (where you `await` a result instead of `enqueue`ing a task) are assigned a special group name `FileDownloader.awaitGroup`, as callbacks for these tasks are handled within the `FileDownloader`, and will therefore not show up in your listener or callback.

### Task queues
Once you `enqueue` a task with the `FileDownloader` it is added to an internal queue that is managed by the native platform you're running on (e.g. Android). Once enqueued, you have limited control over the execution order, the number of tasks running in parallel, etc, because all that is managed by the platform.  If you want more control over the queue, you need to add a `TaskQueue`.

The `MemoryTaskQueue` bundled with the `background_downloader` allows:
* pacing the rate of enqueueing tasks, based on `minInterval`, to avoid 'choking' the FileDownloader when adding a large number of tasks
* managing task priorities while waiting in the queue, such that higher priority tasks are enqueued before lower priority ones, even if they are added later
* managing the total number of tasks running concurrently, by setting `maxConcurrent`
* managing the number of tasks that talk to the same host concurrently, by setting `maxConcurrentByHost`
* managing the number of tasks running that are in the same `Task.group`, by setting `maxConcurrentByGroup`

A `TaskQueue` conceptually sits 'before' the FileDownloader's queue, and the `TaskQueue` makes the call to `FileDownloader().enqueue`. To use it, add it to the `FileDownloader` and instead of enqueuing tasks with the `FileDownloader`, you now `add` tasks to the queue:
```dart
final tq = MemoryTaskQueue();
tq.maxConcurrent = 5; // no more than 5 tasks active at any one time
tq.maxConcurrentByHost = 2; // no more than two tasks talking to the same host at the same time
tq.maxConcurrentByGroup = 3; // no more than three tasks from the same group active at the same time
FileDownloader().add(tq); // 'connects' the TaskQueue to the FileDownloader
FileDownloader().updates.listen((update) { // listen to updates as per usual
  print('Received update for ${update.task.taskId}: $update')
});
for (var n = 0; n < 100; n++) {
  task = DownloadTask(url: workingUrl, metData: 'task #$n'); // define task
  tq.add(task); // add to queue. The queue makes the FileDownloader().enqueue call
}
```

Because it is possible that an error occurs when the taskQueue eventually actually enqueues the task with the FileDownloader, you can listen to the `enqueueErrors` stream for tasks that failed to enqueue.

A common use for the `MemoryTaskQueue` is enqueueing a large number of tasks. This can 'choke' the downloader if done in a loop, but is easy to do when adding all tasks to a queue. The `minInterval` field of the `MemoryTaskQueue` ensures that the tasks are fed to the `FileDownloader` at a rate that does not grind your app to a halt.

The default `TaskQueue` is the `MemoryTaskQueue` which, as the  name suggests, keeps everything in memory. This is fine for most situations, but be aware that the queue may get dropped if the OS aggressively moves the app to the background. Tasks still waiting in the queue will not be enqueued, and will therefore be lost. If you want a `TaskQueue` with more persistence, or add different prioritzation and concurrency roles, then subclass the `MemoryTaskQueue` and add your own persistence or logic.
In addition, if your app is supended by the OS due to resource constraints, tasks waiting in the queue will not be enqueued to the native platform and will not run in the background. TaskQueues are therefore best for situations where you expect the queue to be emptied while the app is still in the foreground.

## Server requests

To make a regular server request (e.g. to obtain a response from an API end point that you process directly in your app) use the `request` method.  It works similar to the `download` method, except you pass a `Request` object that has fewer fields than the `DownloadTask`, but is similar in structure.  You `await` the response, which will be a [Response](https://pub.dev/documentation/http/latest/http/Response-class.html) object as defined in the dart [http package](https://pub.dev/packages/http), and includes getters for the response body (as a `String` or as `UInt8List`), `statusCode` and `reasonPhrase`.

Because requests are meant to be immediate, they are not enqueued like a `Task` is, and do not allow for status/progress monitoring.

## Optional parameters

The `DownloadTask`, `UploadTask` and `Request` objects all take several optional parameters that define how the task will be executed.  Note that a `Task` is a subclass of `Request`, and both `DownloadTask` and `UploadTask` are subclasses of `Task`, so what applies to a `Request` or `Task` will also apply to a `DownloadTask` and `UploadTask`.

### Request, DownloadTask & UploadTask

#### urlQueryParameters

If provided, these parameters (presented as a `Map<String, String>`) will be appended to the url as query parameters. Note that both the `url` and `urlQueryParameters` must be urlEncoded (e.g. a space must be encoded as %20).

#### Headers

Optionally, `headers` can be added to the `Task`, which will be added to the HTTP request. This may be useful for authentication, for example.


#### HTTP request method

If provided, this request method will be used to make the request. By default, the request method is GET unless `post` is not null, or the `Task` is a `DownloadTask`, in which case it will be POST. Valid HTTP request methods are those listed in `Request.validHttpMethods`.

#### POST requests

For downloads, if the required server request is a HTTP POST request (instead of the default GET request) then set the `post` field of a `DownloadTask` to a `String` or `UInt8List` representing the data to be posted (for example, a JSON representation of an object). To make a POST request with no data, set `post` to an empty `String`.

For an `UploadTask` the POST field is used to request a binary upload, by setting it to 'binary'. By default, uploads are done using the form/multi-part format.

#### Retries

To schedule automatic retries of failed requests/tasks (with exponential backoff), set the `retries` field to an
integer between 1 and 10. A normal `Task` (without the need for retries) will follow status
updates from `enqueued` -> `running` -> `complete` (or `notFound`). If `retries` has been set and
the task fails, the sequence will be `enqueued` -> `running` ->
`waitingToRetry` -> `enqueued` -> `running` -> `complete` (if the second try succeeds, or more
retries if needed).  A `Request` will behave similarly, except it does not provide intermediate status updates.

Note that certain failures can be resumed, and retries will therefore attempt to resume from a failure instead of retrying the task from scratch.

### DownloadTask & UploadTask

#### Requiring WiFi

If the `requiresWiFi` field of a `Task` is set to true, the task won't start unless a WiFi network is available. By default `requiresWiFi` is false, and downloads/uploads will use the cellular (or metered) network if WiFi is not available, which may incur cost.

#### Priority

The `priority` field must be 0 <= priority <= 10 with 0 being the highest priority, and defaults to 5. On Desktop and iOS all priority levels are supported. On Android, priority levels <5 are handled as 'expedited', and >=5 is handled as a normal task.

#### Metadata and displayName

`metaData` and `displayName` can be added to a `Task`. They are ignored by the downloader but may be helpful when receiving an update about the task, and can be shown in notifications using `{metaData}` or `{displayName}`.

### UploadTask

#### File field

Set `fileField` to the field name the server expects for the file portion of a multi-part upload. Defaults to "file".

#### Mime type

Set `mimeType` to the MIME type of the file to be uploaded. By default the MIME type is derived from the filename extension, e.g. a .txt file has MIME type `text/plain`.

#### Form fields

Set `fields` to a `Map<String, String>` of name/value pairs to upload as "form fields" along with the file.

## Initial setup

No setup is required for Windows or Linux.

### Android

No setup is required if you don't use notifications. If you do:
* Starting with API 33, you need to add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />` to your app's `AndroidManifest.xml`
* If needed, localize the button text by overriding string resources `bg_downloader_cancel`, `bg_downloader_pause`, `bg_downloader_resume` and descriptions `bg_downloader_notification_channel_name`, `bg_downloader_notification_channel_description`.

### iOS

On iOS, ensure that you have the Background Fetch capability enabled:
* Select the Runner target in XCode
* Select the Signing & Capabilities tab
* Click the + icon to add capabilities
* Select 'Background Modes'
* Tick the 'Background Fetch' mode

Note that iOS by default requires all URLs to be https (and not http). See [here](https://developer.apple.com/documentation/security/preventing_insecure_network_connections) for more details and how to address issues.

If using notifications, add the following to your `AppDelegate.swift`:
```swift
UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
```
or if using Objective C, add to `AppDelegate.m`:
```objective-c
[UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
```


### MacOS

MacOS needs you to request a specific entitlement in order to access the network. To do that open macos/Runner/DebugProfile.entitlements and add the following key-value pair.

```
  <key>com.apple.security.network.client</key>
  <true/>
```
Then do the same thing in macos/Runner/Release.entitlements.

## Configuration

Several aspects of the downloader can be configured on startup:
* Setting the request timeout value and, for iOS only, the 'resourceTimeout'
* Checking available space before attempting a download
* On Android, when to use the `cacheDir` for temporary files
* Setting a proxy
* Bypassing TLS Certificate validation (for debug mode only, Android and Desktop only)
* On Android, running tasks in 'foreground mode' to allow longer runs
* On Android, whether or not to use external storage
* On iOS, localizing the notification button texts

Please read the [configuration document](https://github.com/781flyingdutchman/background_downloader/blob/main/CONFIG.md) for details on how to configure.

## Limitations

* iOS 13.0 or greater; Android API 24 or greater
* On Android, downloads are by default limited to 9 minutes, after which the download will end with `TaskStatus.failed`. To allow for longer downloads, set the `DownloadTask.allowPause` field to true: if the task times out, it will pause and automatically resume, eventually downloading the entire file. Alternatively, [configure](#configuration) the downloader to allow tasks to run in the foreground
* On iOS, once enqueued (i.e. `TaskStatus.enqueued`), a background download must complete within 4 hours. [Configure](#configuration) 'resourceTimeout' to adjust.
* Redirects will be followed
* Background downloads and uploads are aggressively controlled by the native platform. You should therefore always assume that a task that was started may not complete, and may disappear without providing any status or progress update to indicate why. For example, if a user swipes your app up from the iOS App Switcher, all scheduled background downloads are terminated without notification    
