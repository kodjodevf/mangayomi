import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/get_manga_chapter_url.dart';
import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/views/manga/download/download_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'download_provider.g.dart';

@riverpod
Future<List<dynamic>> downloadChapter(DownloadChapterRef ref,
    {required ModelManga modelManga, required int index}) async {
  List urll = [];
  List<DownloadTask> tasks = [];
  final StorageProvider storageProvider = StorageProvider();
  await storageProvider.requestPermission();
  Directory? path;
  bool isOk = false;
  final path1 = await storageProvider.getDirectory();

  final finalPath =
      "downloads/${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/${modelManga.chapters![index].name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}";
  path = Directory(
      "${path1!.path}downloads/${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/${modelManga.chapters![index].name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/");
  ref
      .read(getMangaChapterUrlProvider(
    modelManga: modelManga,
    index: index,
  ).future)
      .then((value) {
    if (value.urll.isNotEmpty) {
      urll = value.urll;
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

  if (urll.isNotEmpty) {
    for (var index = 0; index < urll.length; index++) {
      final path2 = Directory("${path1.path}downloads/");
      final path4 = Directory(
          "${path2.path}${modelManga.source} (${modelManga.lang!.toUpperCase()})/");
      final path3 = Directory(
          "${path2.path}${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/");
      final path5 = Directory(
          "${path2.path}${modelManga.source} (${modelManga.lang!.toUpperCase()})/${modelManga.name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}/${modelManga.chapters![index].name!.replaceAll(RegExp(r'[^a-zA-Z0-9 .()\-\s]'), '_')}");

      if (!(await path1.exists())) {
        path1.create();
      }
      if (Platform.isAndroid) {
        if (!(await File("${path1.path}" ".nomedia").exists())) {
          File("${path1.path}" ".nomedia").create();
        }
      }

      if (!(await path2.exists())) {
        path2.create();
      }
      if (!(await path4.exists())) {
        path4.create();
      }
      if (!(await path3.exists())) {
        path3.create();
      }
      if (!(await path5.exists())) {
        path5.create();
      }
      if ((await path.exists())) {
        if (await File("${path.path}" "${padIndex(index + 1)}.jpg").exists()) {
        } else {
          tasks.add(DownloadTask(
            taskId: urll[index],
            headers: headers(modelManga.source!),
            url: urll[index],
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
            taskId: urll[index],
            headers: headers(modelManga.source!),
            url: urll[index],
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
      }
    }
    if (tasks.isEmpty && urll.isNotEmpty) {
      final model = DownloadModel(
          modelManga: modelManga,
          succeeded: 0,
          failed: 0,
          index: index,
          total: 0,
          isDownload: true,
          taskIds: urll,
          isStartDownload: false);

      ref
          .watch(hiveBoxMangaDownloads)
          .put(modelManga.chapters![index].name!, model);
    } else {
      await FileDownloader().downloadBatch(
        tasks,
        batchProgressCallback: (succeeded, failed) {
          final model = DownloadModel(
              modelManga: modelManga,
              succeeded: succeeded,
              failed: failed,
              index: index,
              total: tasks.length,
              isDownload: (succeeded == tasks.length) ? true : false,
              taskIds: urll,
              isStartDownload: true);

          Hive.box<DownloadModel>(HiveConstant.hiveBoxDownloads)
              .put(modelManga.chapters![index].name!, model);
        },
        taskProgressCallback: (task, progress) async {
          if (progress == 1.0) {
            final downloadTask = DownloadTask(
              creationTime: task.creationTime,
              taskId: task.taskId,
              headers: task.headers,
              url: task.url,
              filename: task.filename,
              baseDirectory: task.baseDirectory,
              directory: task.directory,
              updates: task.updates,
              allowPause: task.allowPause,
            );
            if (Platform.isAndroid || Platform.isIOS) {
              await FileDownloader().moveToSharedStorage(
                  downloadTask, SharedStorage.external,
                  directory: finalPath);
            }
          }
        },
      );
    }
  }
  return urll;
}
