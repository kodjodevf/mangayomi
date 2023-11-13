// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

const urlWithContentLength = 'https://storage.googleapis'
    '.com/approachcharts/test/5MB-test.ZIP';
const urlWithLongContentLength = 'https://storage.googleapis'
    '.com/approachcharts/test/57MB-test.ZIP';

final task = DownloadTask(
    taskId: 'taskId',
    url: 'url',
    urlQueryParameters: {'a': 'b'},
    filename: 'filename',
    headers: {'c': 'd'},
    httpRequestMethod: 'GET',
    baseDirectory: BaseDirectory.temporary,
    directory: 'dir',
    group: 'group',
    updates: Updates.statusAndProgress,
    requiresWiFi: true,
    retries: 5,
    allowPause: true,
    metaData: 'metaData',
    creationTime: DateTime.fromMillisecondsSinceEpoch(1000));
const downloadTaskJsonString =
    '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"}';
const downloadTaskJsonStringDoubles =
    '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1.0,"group":"group","updates":3.0,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"}';

final uploadTask = UploadTask(
    taskId: 'taskId',
    url: 'url',
    urlQueryParameters: {'a': 'b'},
    filename: 'filename',
    headers: {'c': 'd'},
    httpRequestMethod: 'PUT',
    fileField: 'fileField',
    fields: {'e': 'f'},
    baseDirectory: BaseDirectory.temporary,
    directory: 'dir',
    group: 'group',
    updates: Updates.statusAndProgress,
    requiresWiFi: true,
    retries: 5,
    metaData: 'metaData',
    creationTime: DateTime.fromMillisecondsSinceEpoch(1000));
const uploadTaskJsonString =
    '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"PUT","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":false,"metaData":"metaData","taskType":"UploadTask","fileField":"fileField","mimeType":"application/octet-stream","fields":{"e":"f"}}';
const uploadTaskJsonStringDoubles =
    '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"PUT","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1.0,"group":"group","updates":3.0,"requiresWiFi":true,"allowPause":false,"metaData":"metaData","fileField":"fileField","mimeType":"application/octet-stream","fields":{"e":"f"},"taskType":"UploadTask"}';

void main() {
  group('JSON conversion', () {
    test('DownloadTask', () {
      final task2 = Task.createFromJsonMap(jsonDecode(downloadTaskJsonString));
      expect(task2, equals(task));
      expect(jsonEncode(task2.toJsonMap()), equals(downloadTaskJsonString));
      final task3 =
          Task.createFromJsonMap(jsonDecode(downloadTaskJsonStringDoubles));
      expect(jsonEncode(task3.toJsonMap()), equals(downloadTaskJsonString));
    });

    test('UploadTask', () {
      final task2 = Task.createFromJsonMap(jsonDecode(uploadTaskJsonString));
      expect(jsonEncode(task2.toJsonMap()), equals(uploadTaskJsonString));
      final task3 =
          Task.createFromJsonMap(jsonDecode(uploadTaskJsonStringDoubles));
      expect(jsonEncode(task3.toJsonMap()), equals(uploadTaskJsonString));
    });

    test('MultiUploadTask', () async {
      // try with list of Strings
      var muTask = MultiUploadTask(
          taskId: 'task1',
          url: urlWithContentLength,
          files: ['f1.txt', 'f2.txt']);
      expect(muTask.fileFields, equals(['f1', 'f2']));
      expect(muTask.filenames, equals(['f1.txt', 'f2.txt']));
      expect(muTask.mimeTypes, equals(['text/plain', 'text/plain']));
      expect(muTask.fileField, equals('["f1","f2"]')); // json string
      expect(muTask.filename, equals('["f1.txt","f2.txt"]')); // json string
      expect(muTask.mimeType,
          equals('["text/plain","text/plain"]')); // json string
      var muTask2 = MultiUploadTask.fromJsonMap(muTask.toJsonMap());
      expect(muTask2.taskId, equals(muTask.taskId));
      expect(muTask2.fileFields, equals(muTask.fileFields));
      expect(muTask2.filenames, equals(muTask.filenames));
      expect(muTask2.mimeTypes, equals(muTask.mimeTypes));
      expect(muTask2.fileField, equals(muTask.fileField));
      expect(muTask2.filename, equals(muTask.filename));
      expect(muTask2.mimeType, equals(muTask.mimeType));
      // try with list of (String, String)
      muTask = MultiUploadTask(
          taskId: 'task2',
          url: urlWithContentLength,
          files: [('file1', 'f1.txt'), ('file2', 'f2.txt')]);
      expect(muTask.fileFields, equals(['file1', 'file2']));
      expect(muTask.filenames, equals(['f1.txt', 'f2.txt']));
      expect(muTask.mimeTypes, equals(['text/plain', 'text/plain']));
      expect(muTask.fileField, equals('["file1","file2"]'));
      expect(muTask.filename, equals('["f1.txt","f2.txt"]'));
      expect(muTask.mimeType, equals('["text/plain","text/plain"]'));
      muTask2 = MultiUploadTask.fromJsonMap(muTask.toJsonMap());
      expect(muTask2.taskId, equals(muTask.taskId));
      expect(muTask2.fileFields, equals(muTask.fileFields));
      expect(muTask2.filenames, equals(muTask.filenames));
      expect(muTask2.mimeTypes, equals(muTask.mimeTypes));
      expect(muTask2.fileField, equals(muTask.fileField));
      expect(muTask2.filename, equals(muTask.filename));
      expect(muTask2.mimeType, equals(muTask.mimeType));
      //try with list of (String, String, String)
      muTask = MultiUploadTask(
          taskId: 'task3',
          url: urlWithContentLength,
          files: [('file1', 'f1.txt', 'text/plain'), ('file2', 'f2')]);
      expect(muTask.fileFields, equals(['file1', 'file2']));
      expect(muTask.filenames, equals(['f1.txt', 'f2']));
      expect(
          muTask.mimeTypes, equals(['text/plain', 'application/octet-stream']));
      expect(muTask.fileField, equals('["file1","file2"]'));
      expect(muTask.filename, equals('["f1.txt","f2"]'));
      expect(
          muTask.mimeType, equals('["text/plain","application/octet-stream"]'));
      muTask2 = MultiUploadTask.fromJsonMap(muTask.toJsonMap());
      expect(muTask2.taskId, equals(muTask.taskId));
      expect(muTask2.fileFields, equals(muTask.fileFields));
      expect(muTask2.filenames, equals(muTask.filenames));
      expect(muTask2.mimeTypes, equals(muTask.mimeTypes));
      expect(muTask2.fileField, equals(muTask.fileField));
      expect(muTask2.filename, equals(muTask.filename));
      expect(muTask2.mimeType, equals(muTask.mimeType));
      // check taskType
      expect(muTask.toJsonMap()['taskType'], equals('MultiUploadTask'));
    });

    test('ParallelDownloadTask', () async {
      // single url
      var pdlTask = ParallelDownloadTask(url: urlWithLongContentLength);
      expect(pdlTask.urls, equals([urlWithLongContentLength]));
      expect(pdlTask.chunks, equals(1));
      expect(pdlTask.url, equals(urlWithLongContentLength));
      var pdlTask2 = ParallelDownloadTask.fromJsonMap(pdlTask.toJsonMap());
      expect(pdlTask2, equals(pdlTask));
      expect(pdlTask2.urls, equals(pdlTask.urls));
      expect(pdlTask2.chunks, equals(pdlTask.chunks));
      expect(pdlTask2.url, equals(pdlTask.url));
      // multiple url with url parameters and chunks
      pdlTask = ParallelDownloadTask(
          url: [urlWithLongContentLength, urlWithContentLength],
          urlQueryParameters: {'a': 'b'},
          chunks: 5);
      expect(
          pdlTask.urls,
          equals(
              ['$urlWithLongContentLength?a=b', '$urlWithContentLength?a=b']));
      expect(pdlTask.chunks, equals(5));
      expect(pdlTask.url, equals('$urlWithLongContentLength?a=b'));
      pdlTask2 = ParallelDownloadTask.fromJsonMap(pdlTask.toJsonMap());
      expect(pdlTask2, equals(pdlTask));
      expect(pdlTask2.urls, equals(pdlTask.urls));
      expect(pdlTask2.chunks, equals(pdlTask.chunks));
    });

    test('TaskStatusUpdate', () {
      final statusUpdate = TaskStatusUpdate(
          task, TaskStatus.failed, TaskConnectionException('test'));
      const expected =
          '{"task":{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"},"taskStatus":4,"exception":{"type":"TaskConnectionException","description":"test"},"responseBody":null}';
      expect(jsonEncode(statusUpdate.toJsonMap()), equals(expected));
      final update2 = TaskStatusUpdate.fromJsonMap(jsonDecode(expected));
      expect(update2.task, equals(statusUpdate.task));
      expect(update2.status, equals(TaskStatus.failed));
      expect(update2.exception?.description, equals('test'));
      expect(update2.exception is TaskConnectionException, isTrue);
      const withDoubles =
          '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1.0,"group":"group","updates":3.0,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask","taskStatus":4.0,"exception":{"type":"TaskConnectionException","description":"test"}}';
      expect(
          jsonEncode(TaskStatusUpdate.fromJsonMap(jsonDecode(withDoubles))
              .toJsonMap()),
          equals(expected));
    });

    test('TaskProgressUpdate', () {
      final progressUpdate = TaskProgressUpdate(task, 1, 123);
      const expected =
          '{"task":{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"},"progress":1.0,"expectedFileSize":123,"networkSpeed":-1.0,"timeRemaining":-1}';
      expect(jsonEncode(progressUpdate.toJsonMap()), equals(expected));
      final update2 = TaskProgressUpdate.fromJsonMap(jsonDecode(expected));
      expect(update2.task, equals(progressUpdate.task));
      expect(update2.progress, equals(1));
      expect(update2.expectedFileSize, equals(123));
      const withDoubles =
          '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1.0,"group":"group","updates":3.0,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask","progress":1,"expectedFileSize":123.0}';
      expect(
          jsonEncode(TaskProgressUpdate.fromJsonMap(jsonDecode(withDoubles))
              .toJsonMap()),
          equals(expected));
    });

    test('TaskRecord', () {
      final taskRecord =
          TaskRecord(task, TaskStatus.failed, 1, 123, TaskUrlException('test'));
      const expected =
          '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask","status":4,"progress":1.0,"expectedFileSize":123,"exception":{"type":"TaskUrlException","description":"test"}}';
      expect(jsonEncode(taskRecord.toJsonMap()), equals(expected));
      final update2 = TaskRecord.fromJsonMap(jsonDecode(expected));
      expect(update2.task, equals(taskRecord.task));
      expect(update2.status, equals(TaskStatus.failed));
      expect(update2.exception?.description, equals('test'));
      expect(update2.exception is TaskUrlException, isTrue);
      expect(update2.progress, equals(1));
      expect(update2.expectedFileSize, equals(123));
      const withDoubles =
          '{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask","status":4.0,"progress":1,"expectedFileSize":123.0,"exception":{"type":"TaskUrlException","description":"test"}}';
      expect(
          jsonEncode(
              TaskRecord.fromJsonMap(jsonDecode(withDoubles)).toJsonMap()),
          equals(expected));
    });

    test('ResumeData', () {
      final resumeData = ResumeData(task, 'data', 123, 'tag');
      const expected =
          '{"task":{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"},"data":"data","requiredStartByte":123,"eTag":"tag"}';
      expect(jsonEncode(resumeData.toJsonMap()), equals(expected));
      final update2 = ResumeData.fromJsonMap(jsonDecode(expected));
      expect(update2.task, equals(resumeData.task));
      expect(update2.data, equals('data'));
      expect(update2.requiredStartByte, equals(123));
      expect(update2.eTag, equals('tag'));
      const withDoubles =
          '{"task":{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5.0,"retriesRemaining":5.0,"creationTime":1000.0,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1.0,"group":"group","updates":3.0,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"},"data":"data","requiredStartByte":123.0,"eTag":"tag"}';
      expect(
          jsonEncode(
              ResumeData.fromJsonMap(jsonDecode(withDoubles)).toJsonMap()),
          equals(expected));
      final resumeData2 = ResumeData(task, 'data', 123, null);
      const expected2 =
          '{"task":{"url":"url?a=b","headers":{"c":"d"},"httpRequestMethod":"GET","post":null,"retries":5,"retriesRemaining":5,"creationTime":1000,"taskId":"taskId","filename":"filename","directory":"dir","baseDirectory":1,"group":"group","updates":3,"requiresWiFi":true,"allowPause":true,"metaData":"metaData","taskType":"DownloadTask"},"data":"data","requiredStartByte":123,"eTag":null}';
      expect(jsonEncode(resumeData2.toJsonMap()), equals(expected2));
      final update3 = ResumeData.fromJsonMap(jsonDecode(expected2));
      expect(update3.task, equals(resumeData.task));
      expect(update3.data, equals('data'));
      expect(update3.requiredStartByte, equals(123));
      expect(update3.eTag, isNull);
    });

    test('DownloadTask incoming from Android', () {
      const incoming =
          '{"allowPause":false,"baseDirectory": 1,"chunks":1,"creationTime":1694879914883,"directory":"","fields":{},"fileField":"","filename":"com.bbflight.background_downloader.1186323287","group":"chunk","headers":{"Range":"bytes\u003d0-29836749"},"httpRequestMethod":"GET","metaData":"{\\"parentTaskId\\":\\"3069222547\\",\\"from\\":0,\\"to\\":29836749}","mimeType":"","requiresWiFi":false,"retries":0,"retriesRemaining":0,"taskId":"1702658487","taskType":"DownloadTask","updates":2,"url":"https://storage.googleapis.com/approachcharts/test/57MB-test.ZIP","urls":[]}';
      final task = Task.createFromJsonMap(jsonDecode(incoming));
      print(task);
    });
  });
}
