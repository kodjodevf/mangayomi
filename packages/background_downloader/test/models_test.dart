import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

const workingUrl = 'https://google.com';
const failingUrl = 'https://avmaps-dot-bbflightserver-hrd.appspot'
    '.com/public/get_current_app_data?key=background_downloader_integration_test';
const urlWithContentLength = 'https://storage.googleapis'
    '.com/approachcharts/test/5MB-test.ZIP';
const urlWithLongContentLength = 'https://storage.googleapis'
    '.com/approachcharts/test/57MB-test.ZIP';
const getTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_get_data';
const getRedirectTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_get_redirect';
const postTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_post_data';
const uploadTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_upload_file';
const uploadBinaryTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_upload_binary_file';
const uploadMultiTestUrl =
    'https://avmaps-dot-bbflightserver-hrd.appspot.com/public/test_multi_upload_file';
const urlWithContentLengthFileSize = 6207471;

const defaultFilename = 'google.html';
const postFilename = 'post.txt';
const uploadFilename = 'a_file.txt';
const uploadFilename2 = 'second_file.txt';
const largeFilename = '5MB-test.ZIP';

var task = DownloadTask(url: workingUrl, filename: defaultFilename);

var retryTask =
    DownloadTask(url: failingUrl, filename: defaultFilename, retries: 3);

var uploadTask = UploadTask(url: uploadTestUrl, filename: uploadFilename);
var uploadTaskBinary = uploadTask.copyWith(post: 'binary');

void main() {
  test('TaskProgressUpdate', () {
    final task = DownloadTask(url: 'http://google.com');
    var update = TaskProgressUpdate(task, 0.1);
    expect(update.hasExpectedFileSize, isFalse);
    expect(update.hasNetworkSpeed, isFalse);
    expect(update.hasTimeRemaining, isFalse);
    expect(update.networkSpeedAsString, equals('-- MB/s'));
    expect(update.timeRemainingAsString, equals('--:--'));
    update =
        TaskProgressUpdate(task, 0.1, 123, 0.2, const Duration(seconds: 30));
    expect(update.hasExpectedFileSize, isTrue);
    expect(update.hasNetworkSpeed, isTrue);
    expect(update.hasTimeRemaining, isTrue);
    expect(update.networkSpeedAsString, equals('200 kB/s'));
    expect(update.timeRemainingAsString, equals('00:30'));
    update = TaskProgressUpdate(task, 0.1, 123, 2, const Duration(seconds: 90));
    expect(update.networkSpeedAsString, equals('2 MB/s'));
    expect(update.timeRemainingAsString, equals('01:30'));
    update =
        TaskProgressUpdate(task, 0.1, 123, 1.1, const Duration(seconds: 3610));
    expect(update.networkSpeedAsString, equals('1 MB/s'));
    expect(update.timeRemainingAsString, equals('1:00:10'));
  });

  test('copyWith', () async {
    final complexTask = DownloadTask(
        taskId: 'uniqueId',
        url: postTestUrl,
        filename: defaultFilename,
        headers: {'Auth': 'Test'},
        httpRequestMethod: 'PATCH',
        post: 'TestPost',
        directory: 'directory',
        baseDirectory: BaseDirectory.temporary,
        group: 'someGroup',
        updates: Updates.statusAndProgress,
        requiresWiFi: true,
        retries: 5,
        metaData: 'someMetaData');
    final now = DateTime.now();
    expect(
        now.difference(complexTask.creationTime).inMilliseconds, lessThan(100));
    final task = complexTask.copyWith(); // all the same
    expect(task.taskId, equals(complexTask.taskId));
    expect(task.url, equals(complexTask.url));
    expect(task.filename, equals(complexTask.filename));
    expect(task.headers, equals(complexTask.headers));
    expect(task.httpRequestMethod, equals(complexTask.httpRequestMethod));
    expect(task.post, equals(complexTask.post));
    expect(task.directory, equals(complexTask.directory));
    expect(task.baseDirectory, equals(complexTask.baseDirectory));
    expect(task.group, equals(complexTask.group));
    expect(task.updates, equals(complexTask.updates));
    expect(task.requiresWiFi, equals(complexTask.requiresWiFi));
    expect(task.retries, equals(complexTask.retries));
    expect(task.retriesRemaining, equals(complexTask.retriesRemaining));
    expect(task.retriesRemaining, equals(task.retries));
    expect(task.metaData, equals(complexTask.metaData));
    expect(task.creationTime, equals(complexTask.creationTime));
  });

  test('downloadTask url and urlQueryParameters', () {
    final task0 = DownloadTask(
        url: 'url with space',
        filename: defaultFilename,
        urlQueryParameters: {});
    expect(task0.url, equals('url with space'));
    final task1 = DownloadTask(
        url: 'url',
        filename: defaultFilename,
        urlQueryParameters: {'param1': '1', 'param2': 'with space'});
    expect(task1.url, equals('url?param1=1&param2=with space'));
    final task2 = DownloadTask(
        url: 'url?param0=0',
        filename: defaultFilename,
        urlQueryParameters: {'param1': '1', 'param2': 'with space'});
    expect(task2.url, equals('url?param0=0&param1=1&param2=with space'));
    final task4 =
        DownloadTask(url: urlWithContentLength, filename: defaultFilename);
    expect(task4.url, equals(urlWithContentLength));
  });

  test('downloadTask filename', () {
    final task0 = DownloadTask(url: workingUrl);
    expect(task0.filename.isNotEmpty, isTrue);
    final task1 = DownloadTask(url: workingUrl, filename: defaultFilename);
    expect(task1.filename, equals(defaultFilename));
    expect(
        () =>
            DownloadTask(url: workingUrl, filename: 'somedir/$defaultFilename'),
        throwsArgumentError);
  });

  test('downloadTask hasFilename and ?', () {
    final task0 = DownloadTask(url: workingUrl);
    expect(task0.hasFilename, isTrue);
    final task1 = DownloadTask(url: workingUrl, filename: '?');
    expect(task1.hasFilename, isFalse);
  });

  test('downloadTask directory', () {
    final task0 = DownloadTask(url: workingUrl);
    expect(task0.directory.isEmpty, isTrue);
    final task1 = DownloadTask(url: workingUrl, directory: 'testDir');
    expect(task1.directory, equals('testDir'));
    expect(() => DownloadTask(url: workingUrl, directory: '/testDir'),
        throwsArgumentError);
  });
}
