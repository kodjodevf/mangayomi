// ignore_for_file: avoid_print

import 'dart:math';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final class TestTaskQueue extends MemoryTaskQueue {
  double probFailure = 0;

  @override
  Future<bool> enqueue(Task task) async {
    debugPrint('${task.taskId} - enqueueing');
    Future.delayed(const Duration(milliseconds: 200));
    debugPrint('${task.taskId} - enqueued');
    Future.delayed(const Duration(seconds: 4)).then((_) {
      // complete the task after 4 seconds
      debugPrint('${task.taskId} - finished');
      taskFinished(task);
      debugPrint('Remaining tasks: ${waiting.length}, $numActive active');
    });
    return Random().nextDouble() > probFailure;
  }
}

const workingUrl = 'https://google.com';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final tq = TestTaskQueue();

  var task = DownloadTask(url: 'testUrl');

  setUp(() {
    tq.probFailure = 0;
    tq.maxConcurrent = 10000000;
    tq.minInterval = const Duration(milliseconds: 550);
    tq.reset();
  });

  group('Add to queue', () {
    test('add', () async {
      expect(tq.isEmpty, isTrue);
      tq.add(task);
      await Future.delayed(const Duration(seconds: 5));
      expect(tq.isEmpty, isTrue);
    });

    test('add multiple', () async {
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: 'testUrl');
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isTrue);
      tq.add(DownloadTask(url: 'testUrl'));
      expect(tq.isEmpty, isTrue);
      await Future.delayed(const Duration(seconds: 5));
      expect(tq.isEmpty, isTrue);
    });

    test('addAll', () async {
      expect(tq.isEmpty, isTrue);
      final tasks = <Task>[];
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: 'testUrl');
        tasks.add(task);
      }
      tq.addAll(tasks);
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isTrue);
    });
  });

  group('Concurrent', () {
    test('maxConcurrent', () async {
      tq.maxConcurrent = 2;
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: 'testUrl');
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isFalse);
      expect(tq.waiting.length, greaterThan(0));
      await Future.delayed(const Duration(seconds: 20));
      expect(tq.isEmpty, isTrue);
    });

    test('numActiveWithHostname', () async {
      expect(() => DownloadTask(url: '::invalid::').hostName,
          throwsFormatException);
      expect(DownloadTask(url: 'empty').hostName, equals(''));
      expect(DownloadTask(url: workingUrl).hostName, equals('google.com'));
      task = DownloadTask(taskId: '1', url: workingUrl);
      tq.add(task);
      expect(tq.numActive, equals(1));
      expect(tq.numActiveWithHostname('google.com'), equals(1));
      expect(tq.numActiveWithHostname('somethingElse.com'), equals(0));
      await Future.delayed(const Duration(seconds: 5));
      expect(tq.isEmpty, isTrue);
    });

    test('maxConcurrentByHost', () async {
      tq.maxConcurrentByHost = 2;
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: workingUrl);
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isFalse);
      expect(tq.waiting.length, greaterThan(0));
      await Future.delayed(const Duration(seconds: 20));
      expect(tq.isEmpty, isTrue);
    });

    test('numActiveWithGroup', () async {
      task = DownloadTask(taskId: '1', url: workingUrl);
      tq.add(task);
      expect(tq.numActive, equals(1));
      expect(tq.numActiveWithGroup('default'), equals(1));
      expect(tq.numActiveWithGroup('other'), equals(0));
      await Future.delayed(const Duration(seconds: 5));
      expect(tq.isEmpty, isTrue);
    });

    test('maxConcurrentByGroup', () async {
      tq.maxConcurrentByGroup = 2;
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: workingUrl);
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isFalse);
      expect(tq.waiting.length, greaterThan(0));
      await Future.delayed(const Duration(seconds: 20));
      expect(tq.isEmpty, isTrue);
    });

    test('combine maxConcurrent with limit from ByHost', () async {
      // we load only two urls, so the maxConcurrentByHost is going to be
      // the limiting factor
      tq.maxConcurrentByHost = 2;
      tq.maxConcurrent = 5;
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: 'google-$n', url: workingUrl);
        tq.add(task);
      }
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: 'other-$n', url: 'http://netflix.com');
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isFalse);
      expect(tq.waiting.length, greaterThan(0));
      await Future.delayed(const Duration(seconds: 20));
      expect(tq.isEmpty, isTrue);
    });

    test('combine maxConcurrent without limit from ByHost', () async {
      // now we load only multiple urls, so the maxConcurrentByHost is not
      // going to be the limiting factor
      tq.maxConcurrentByHost = 2;
      tq.maxConcurrent = 5;
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: 'google-$n', url: workingUrl);
        tq.add(task);
      }
      for (var n = 0; n < 10; n++) {
        // different url for each
        task = DownloadTask(taskId: 'other-$n', url: 'http://netflix$n.com');
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isFalse);
      expect(tq.waiting.length, greaterThan(0));
      await Future.delayed(const Duration(seconds: 20));
      expect(tq.isEmpty, isTrue);
    });
  });

  group('errors', () {
    test('enqueueErrors', () async {
      tq.probFailure = 0.8; // 80% failure rate
      var errorCount = 0;
      tq.enqueueErrors.listen((task) {
        errorCount += 1;
        print('${task.taskId} failed to enqueue');
      });
      expect(tq.isEmpty, isTrue);
      for (var n = 0; n < 10; n++) {
        task = DownloadTask(taskId: '$n', url: 'testUrl');
        tq.add(task);
      }
      expect(tq.isEmpty, isFalse);
      await Future.delayed(const Duration(seconds: 10));
      expect(tq.isEmpty, isTrue);
      print('$errorCount enqueue errors');
      expect(errorCount, greaterThan(3));
    });
  });
}
