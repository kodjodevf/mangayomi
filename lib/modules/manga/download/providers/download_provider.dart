import 'dart:io';
import 'package:background_downloader/background_downloader.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_chapter_url.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'download_provider.g.dart';

@riverpod
Future<List<String>> downloadChapter(
  DownloadChapterRef ref, {
  required Chapter chapter,
}) async {
  List<String> pageUrls = [];
  List<DownloadTask> tasks = [];
  final StorageProvider storageProvider = StorageProvider();
  await storageProvider.requestPermission();
  Directory? path;
  bool isOk = false;
  final manga = chapter.manga.value!;
  final path1 = await storageProvider.getDirectory();
  final regExp = RegExp(r'[^a-zA-Z0-9 .()\-\s]');
  String scanlator = chapter.scanlator!.isNotEmpty
      ? "${chapter.scanlator!.replaceAll(regExp, '_')}_"
      : "";
  final finalPath =
      "downloads/${manga.source} (${manga.lang!.toUpperCase()})/${manga.name!.replaceAll(regExp, '_')}/$scanlator${chapter.name!.replaceAll(regExp, '_')}";
  path = Directory("${path1!.path}$finalPath/");
  ref
      .read(getChapterUrlProvider(
    chapter: chapter,
  ).future)
      .then((value) {
    if (value.pageUrls.isNotEmpty) {
      pageUrls = value.pageUrls;
      isOk = true;
    }
  });
  await Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 1));
    if (isOk == true) {
      return false;
    }
    return true;
  });

  if (pageUrls.isNotEmpty) {
    for (var index = 0; index < pageUrls.length; index++) {
      final path2 = Directory("${path1.path}downloads/");
      final path4 = Directory(
          "${path2.path}${manga.source} (${manga.lang!.toUpperCase()})/");
      final path3 =
          Directory("${path4.path}${manga.name!.replaceAll(regExp, '_')}/");

      if (!(await path1.exists())) {
        path1.create();
      }
      if (Platform.isAndroid) {
        if (!(await File("${path1.path}" ".nomedia").exists())) {
          File("${path1.path}" ".nomedia").create();
        }
      }
      // log(path2.path);
      if (!(await path2.exists())) {
        path2.create();
      }
      if (!(await path4.exists())) {
        path4.create();
      }
      if (!(await path3.exists())) {
        path3.create();
      }

      if ((await path.exists())) {
        if (await File("${path.path}" "${padIndex(index + 1)}.jpg").exists()) {
        } else {
          tasks.add(DownloadTask(
            taskId: pageUrls[index],
            headers: ref.watch(headersProvider(source: manga.source!)),
            url: pageUrls[index],
            filename: "${padIndex(index + 1)}.jpg",
            baseDirectory:
                Platform.isWindows || Platform.isMacOS || Platform.isLinux
                    ? BaseDirectory.applicationDocuments
                    : BaseDirectory.temporary,
            directory:
                Platform.isWindows || Platform.isMacOS || Platform.isLinux
                    ? 'Mangayomi/$finalPath'
                    : finalPath,
            updates: Updates.statusAndProgress,
            allowPause: true,
          ));
        }
      } else {
        path.create();
        if (await File("${path.path}" "${padIndex(index + 1)}.jpg").exists()) {
        } else {
          tasks.add(DownloadTask(
            taskId: pageUrls[index],
            headers: ref.watch(headersProvider(source: manga.source!)),
            url: pageUrls[index],
            filename: "${padIndex(index + 1)}.jpg",
            baseDirectory: Platform.isWindows ||
                    Platform.isMacOS ||
                    Platform.isLinux ||
                    Platform.isIOS
                ? BaseDirectory.applicationDocuments
                : BaseDirectory.temporary,
            directory: Platform.isWindows ||
                    Platform.isMacOS ||
                    Platform.isLinux ||
                    Platform.isIOS
                ? 'Mangayomi/$finalPath'
                : finalPath,
            updates: Updates.statusAndProgress,
            allowPause: true,
          ));
        }
      }
    }

    if (tasks.isEmpty && pageUrls.isNotEmpty) {
      final model = Download(
          succeeded: 0,
          failed: 0,
          total: 0,
          isDownload: true,
          taskIds: pageUrls,
          isStartDownload: false,
          chapterId: chapter.id);

      isar.writeTxnSync(() {
        isar.downloads.putSync(model..chapter.value = chapter);
      });
    } else {
      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) {
          bool isEmpty = isar.downloads
              .filter()
              .chapterIdEqualTo(chapter.id!)
              .isEmptySync();
          if (isEmpty) {
            final model = Download(
              succeeded: succeeded,
              failed: failed,
              total: tasks.length,
              isDownload: (succeeded == tasks.length) ? true : false,
              taskIds: pageUrls,
              isStartDownload: true,
              chapterId: chapter.id,
            );
            isar.writeTxnSync(() {
              isar.downloads.putSync(model..chapter.value = chapter);
            });
          } else {
            final model = isar.downloads
                .filter()
                .chapterIdEqualTo(chapter.id!)
                .findFirstSync()!;
            isar.writeTxnSync(() {
              isar.downloads.putSync(model
                ..succeeded = succeeded
                ..failed = failed
                ..isDownload = (succeeded == tasks.length) ? true : false);
            });
          }
        },
        taskProgressCallback: (taskProgress) async {
          if (taskProgress.progress == 1.0) {
            final downloadTask = DownloadTask(
              creationTime: taskProgress.task.creationTime,
              taskId: taskProgress.task.taskId,
              headers: taskProgress.task.headers,
              url: taskProgress.task.url,
              filename: taskProgress.task.filename,
              baseDirectory: taskProgress.task.baseDirectory,
              directory: taskProgress.task.directory,
              updates: taskProgress.task.updates,
              allowPause: taskProgress.task.allowPause,
            );
            if (Platform.isAndroid) {
              await FileDownloader().moveToSharedStorage(
                  downloadTask, SharedStorage.external,
                  directory: finalPath);
            }
          }
        },
      );
    }
  }
  return pageUrls;
}
