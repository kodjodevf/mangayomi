import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/download_manager/download_queue_runner.dart';

void main() {
  test('returns successful outcomes in original job order', () async {
    final runner = DownloadQueueRunner<int>(concurrency: 2);

    final run = await runner.run(<DownloadQueueJob<int>>[
      () async => 1,
      () async => 2,
      () async => 3,
    ]);

    expect(run.isSuccessful, isTrue);
    expect(run.outcomes.map((outcome) => outcome.index), <int>[0, 1, 2]);
    expect(run.successes.map((outcome) => outcome.value), <int?>[1, 2, 3]);
  });

  test('records a failure and continues with later jobs', () async {
    final runner = DownloadQueueRunner<int>(concurrency: 1);
    final executed = <int>[];

    final run = await runner.run(<DownloadQueueJob<int>>[
      () async {
        executed.add(1);
        return 1;
      },
      () async {
        executed.add(2);
        throw StateError('expected failure');
      },
      () async {
        executed.add(3);
        return 3;
      },
    ]);

    expect(executed, <int>[1, 2, 3]);
    expect(run.outcomes[1].error, isA<StateError>());
    expect(run.successes.length, 2);
    expect(run.failures.length, 1);
  });

  test('never runs more jobs than the configured concurrency', () async {
    const concurrency = 2;
    final runner = DownloadQueueRunner<int>(concurrency: concurrency);
    var activeJobs = 0;
    var maximumActiveJobs = 0;

    Future<int> job(int value) async {
      activeJobs++;
      maximumActiveJobs = maximumActiveJobs > activeJobs
          ? maximumActiveJobs
          : activeJobs;
      try {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return value;
      } finally {
        activeJobs--;
      }
    }

    final run = await runner.run(
      List<DownloadQueueJob<int>>.generate(7, (index) => () => job(index)),
    );

    expect(maximumActiveJobs, concurrency);
    expect(run.outcomes.length, 7);
  });

  test('rejects a non-positive concurrency', () {
    expect(
      () => DownloadQueueRunner<Object>(concurrency: 0),
      throwsArgumentError,
    );
  });
}
