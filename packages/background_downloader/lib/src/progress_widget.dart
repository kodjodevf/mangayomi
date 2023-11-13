import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'file_downloader.dart';
import 'models.dart';

/// Progress indicator for use with the [FileDownloader]
///
/// Configuration parameters:
/// [message] message to show for a single download. Templates {filename} and
///   {metadata} are replaced by a task's filename and metadata respectively
/// [collapsedMessage] message to show when multiple file downloads are
///   collapsed into a single row. The template {n} is replaced by the number
///   of tasks finished, and {total} is replaced by the total number of tasks
///   started in this batch. Both reset to 0 when all downloads finish.
///   In collapsed mode, progress is indicated as {n}/{total}
/// [showPauseButton] if true, shows a pause button if the task allows it
/// [showCancelButton] if true, shows a cancel button
/// [height] height of the [DownloadProgressIndicator], and of each row when
///   in expanded mode
/// [maxExpandable] maximum number of rows the indicator can expand to, with
///   each row showing one download in progress. If set to 1 (the default) the
///   indicator will not expand: if the number of downloads in progress exceeds
///   1, the indicator will switch to a 'collapsed' state showing the
///   number of files finished out of the total started. It will stay in
///   'collapsed' state until all downloads have finished. To start the
///   indicator in collapsed state (i.e. never show the download progress of a
///   single file), set [maxExpandable] to 0
/// [backgroundColor] background color for the widget
class DownloadProgressIndicator extends StatefulWidget {
  const DownloadProgressIndicator(this.updates,
      {this.message = '{filename}',
      this.collapsedMessage = '{n}/{total}',
      this.showPauseButton = false,
      this.showCancelButton = false,
      this.height = 50,
      this.maxExpandable = 1,
      this.backgroundColor = Colors.grey,
      Key? key})
      : super(key: key);

  final Stream<TaskUpdate> updates;
  final String message;
  final String collapsedMessage;
  final bool showPauseButton;
  final bool showCancelButton;
  final double height;
  final int maxExpandable;
  final Color backgroundColor;

  @override
  State<DownloadProgressIndicator> createState() =>
      _DownloadProgressIndicatorState();
}

class _DownloadProgressIndicatorState extends State<DownloadProgressIndicator> {
  StreamSubscription<TaskUpdate>? downloadUpdates;
  final inProgress = <Task, (double, int)>{};
  final pausedTasks = <Task>{};
  final totalTasks = <Task>{};
  final finishedTasks = <Task>{};
  bool isExpanded = false;
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    isCollapsed = widget.maxExpandable == 0;
    downloadUpdates = widget.updates.listen((update) {
      if (update is TaskStatusUpdate) {
        switch (update.status) {
          case TaskStatus.running:
            totalTasks.add(update.task);
            pausedTasks.remove(update.task);
            inProgress[update.task] =
                (0, DateTime.now().millisecondsSinceEpoch);

          case TaskStatus.waitingToRetry:
            break;

          case TaskStatus.paused:
            pausedTasks.add(update.task);

          default:
            // task finished
            _finish(update.task);
        }
      } else if (update is TaskProgressUpdate) {
        switch (update.progress) {
          case >= 0 && < 1:
            // active, so add task to set and update progress
            totalTasks.add(update.task);
            pausedTasks.remove(update.task);
            final previousInProgress = inProgress[update.task];
            inProgress[update.task] = (
              update.progress,
              previousInProgress?.$2 ?? DateTime.now().millisecondsSinceEpoch
            );

          case progressWaitingToRetry:
            break;

          case progressPaused:
            pausedTasks.add(update.task);

          default:
            // task finished
            _finish(update.task);
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    downloadUpdates?.cancel();
    downloadUpdates = null;
  }

  /// Process a finished task
  ///
  /// Remove the task from [inProgress] and [pausedTasks], add to [finishedTasks]
  /// If [inProgress] is empty, also empty the sets and reset
  /// the [isExpanded] and [isCollapsed] flags.
  void _finish(Task task) {
    inProgress.remove(task);
    finishedTasks.add(task);
    pausedTasks.remove(task);
    if (inProgress.isEmpty) {
      totalTasks.clear();
      finishedTasks.clear();
      isExpanded = false;
      isCollapsed = widget.maxExpandable == 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = inProgress.keys
        .where((taskId) => inProgress[taskId]!.$1 >= 0)
        .sorted((a, b) => inProgress[a]!.$2.compareTo(inProgress[b]!.$2));
    final numActive = activeTasks.length;
    if (numActive > 1) {
      if (widget.maxExpandable > 1) {
        isExpanded = true; // only resets when all downloads finish
      } else {
        isCollapsed = true; // only resets when all downloads finish
      }
    }
    final itemsToShow = isExpanded
        ? min(numActive, widget.maxExpandable)
        : isCollapsed
            ? min(1, numActive)
            : numActive;
    return AnimatedSize(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.bottomCenter,
        child: switch (itemsToShow) {
          0 => Container(
              height: 0,
            ),
          1 => isCollapsed
              ? _CollapsedDownloadProgress(
                  finishedTasks.length,
                  totalTasks.length,
                  widget.collapsedMessage,
                  widget.height,
                  widget.backgroundColor)
              : _DownloadProgressItem(
                  activeTasks.first,
                  inProgress[activeTasks.first]!.$1,
                  widget.message,
                  widget.showPauseButton,
                  widget.showCancelButton,
                  widget.height,
                  widget.backgroundColor,
                  pausedTasks),
          _ => _ExpandedDownloadProgress(
              activeTasks.take(widget.maxExpandable).toList(growable: false),
              widget.message,
              widget.height,
              widget.backgroundColor,
              inProgress)
        });
  }
}

final _fileNameRegEx = RegExp("""{filename}""", caseSensitive: false);
final _metadataRegEx = RegExp("""{metadata}""", caseSensitive: false);

/// Single file download progress widget
class _DownloadProgressItem extends StatelessWidget {
  const _DownloadProgressItem(
      this.task,
      this.progress,
      this.message,
      this.showPauseButton,
      this.showCancelButton,
      this.height,
      this.backgroundColor,
      this.pausedTasks,
      {Key? key})
      : super(key: key);

  final Task task;
  final double progress;
  final String message;
  final bool showPauseButton;
  final bool showCancelButton;
  final double height;
  final Color backgroundColor;
  final Set<Task> pausedTasks;

  @override
  Widget build(BuildContext context) {
    final messageText = message
        .replaceAll(_fileNameRegEx, task.filename)
        .replaceAll(_metadataRegEx, task.metaData);
    return Container(
      height: height,
      decoration: BoxDecoration(color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                messageText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: LinearProgressIndicator(
                value: progress == 0 ? null : progress,
              ),
            ),
            if (showPauseButton &&
                task.allowPause &&
                !pausedTasks.contains(task))
              IconButton(
                onPressed: () => FileDownloader().pause(task as DownloadTask),
                icon: const Icon(Icons.pause),
                color: Theme.of(context).primaryColor,
              ),
            if (showPauseButton &&
                task.allowPause &&
                pausedTasks.contains(task))
              IconButton(
                onPressed: () => FileDownloader().resume(task as DownloadTask),
                icon: const Icon(Icons.play_arrow),
                color: Theme.of(context).primaryColor,
              ),
            if (showCancelButton)
              IconButton(
                  onPressed: () =>
                      FileDownloader().cancelTaskWithId(task.taskId),
                  icon: const Icon(Icons.cancel),
                  color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}

/// Collapsed file download progress widget, showing the number of files
/// downloaded out of the total number of files downloaded as a progress
/// indicator
class _CollapsedDownloadProgress extends StatelessWidget {
  const _CollapsedDownloadProgress(this.numCompleted, this.numTotal,
      this.collapsedMessage, this.height, this.backgroundColor,
      {Key? key})
      : super(key: key);

  final int numCompleted;
  final int numTotal;
  final String collapsedMessage;
  final double height;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final messageText = collapsedMessage
        .replaceAll('{n}', '$numCompleted')
        .replaceAll('{total}', '$numTotal');
    final progress = numCompleted / numTotal;

    return Container(
        height: height,
        decoration: BoxDecoration(color: backgroundColor),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  messageText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                ),
              )
            ],
          ),
        ));
  }
}

/// Expanded file download progress widget, showing multiple file download
/// progress indicators (up to expandable as defined in the core widget
class _ExpandedDownloadProgress extends StatelessWidget {
  const _ExpandedDownloadProgress(this.tasks, this.message, this.height,
      this.backgroundColor, this.inProgress,
      {Key? key})
      : super(key: key);

  final List<Task> tasks;
  final String message;
  final double height;
  final Color backgroundColor;
  final Map<Task, (double, int)> inProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          border:
              Border(top: BorderSide(color: Theme.of(context).dividerColor))),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth()
        },
        children: tasks.map((task) {
          return TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Theme.of(context).dividerColor))),
              children: [
                SizedBox(
                  height: height,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                          message
                              .replaceAll(_fileNameRegEx, task.filename)
                              .replaceAll(_metadataRegEx, task.metaData),
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: LinearProgressIndicator(
                    value: inProgress[task]!.$1,
                  ),
                ),
              ]);
        }).toList(),
      ),
    );
  }
}
