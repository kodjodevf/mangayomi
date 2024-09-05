// ignore_for_file: depend_on_referenced_packages

import '../file_downloader.dart';
import '../task.dart';

/// Interface allowing the [FileDownloader] to signal finished tasks to
/// a [TaskQueue]
abstract interface class TaskQueue {
  /// Signals that [task] has finished
  void taskFinished(Task task);
}
