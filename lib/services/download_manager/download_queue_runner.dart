/// A single download job executed by [DownloadQueueRunner].
typedef DownloadQueueJob<T> = Future<T> Function();

enum DownloadQueueOutcomeType { success, failure }

class DownloadQueueOutcome<T> {
  const DownloadQueueOutcome._({
    required this.index,
    required this.type,
    this.value,
    this.error,
    this.stackTrace,
  });

  const DownloadQueueOutcome.success({required int index, required T value})
    : this._(
        index: index,
        type: DownloadQueueOutcomeType.success,
        value: value,
      );

  const DownloadQueueOutcome.failure({
    required int index,
    required Object error,
    required StackTrace stackTrace,
  }) : this._(
         index: index,
         type: DownloadQueueOutcomeType.failure,
         error: error,
         stackTrace: stackTrace,
       );

  final int index;
  final DownloadQueueOutcomeType type;
  final T? value;
  final Object? error;
  final StackTrace? stackTrace;

  bool get isSuccess => type == DownloadQueueOutcomeType.success;
  bool get isFailure => type == DownloadQueueOutcomeType.failure;
}

class DownloadQueueRun<T> {
  const DownloadQueueRun(this.outcomes);

  final List<DownloadQueueOutcome<T>> outcomes;

  Iterable<DownloadQueueOutcome<T>> get successes =>
      outcomes.where((outcome) => outcome.isSuccess);

  Iterable<DownloadQueueOutcome<T>> get failures =>
      outcomes.where((outcome) => outcome.isFailure);

  bool get isSuccessful => failures.isEmpty;
}

/// Runs each job once with a bounded number of workers.
///
/// A failed job is recorded as an outcome so it cannot stop later jobs. Retry
/// and cancellation remain the responsibility of the caller.
class DownloadQueueRunner<T> {
  DownloadQueueRunner({required this.concurrency}) {
    if (concurrency <= 0) {
      throw ArgumentError.value(
        concurrency,
        'concurrency',
        'must be greater than zero',
      );
    }
  }

  final int concurrency;

  Future<DownloadQueueRun<T>> run(Iterable<DownloadQueueJob<T>> jobs) async {
    final jobList = jobs.toList(growable: false);
    if (jobList.isEmpty) {
      return DownloadQueueRun(<DownloadQueueOutcome<T>>[]);
    }

    final outcomes = List<DownloadQueueOutcome<T>?>.filled(
      jobList.length,
      null,
    );
    var nextJobIndex = 0;

    Future<void> runWorker() async {
      while (true) {
        final jobIndex = nextJobIndex++;
        if (jobIndex >= jobList.length) return;
        try {
          outcomes[jobIndex] = DownloadQueueOutcome.success(
            index: jobIndex,
            value: await jobList[jobIndex](),
          );
        } catch (error, stackTrace) {
          outcomes[jobIndex] = DownloadQueueOutcome.failure(
            index: jobIndex,
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
    }

    final workerCount = concurrency < jobList.length
        ? concurrency
        : jobList.length;
    await Future.wait(
      List<Future<void>>.generate(workerCount, (_) => runWorker()),
    );

    return DownloadQueueRun(
      List<DownloadQueueOutcome<T>>.unmodifiable(
        List<DownloadQueueOutcome<T>>.generate(
          outcomes.length,
          (index) => outcomes[index]!,
        ),
      ),
    );
  }
}
