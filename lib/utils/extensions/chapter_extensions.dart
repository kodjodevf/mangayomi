import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/download.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/track.dart';
import 'package:mangayomi/models/track_preference.dart';
import 'package:mangayomi/modules/manga/detail/providers/track_state_providers.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/utils/extensions/manga_extensions.dart';
import 'package:mangayomi/modules/more/settings/track/providers/track_providers.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/services/download_manager/download_isolate_pool.dart';
import 'package:mangayomi/services/download_manager/m_downloader.dart';
import 'package:mangayomi/utils/chapter_recognition.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';
import 'package:path/path.dart' as p;

extension ChapterExtension on Chapter {
  Future<void> pushToReaderView(
    BuildContext context, {
    bool ignoreIsRead = false,
  }) async {
    if (ignoreIsRead || !isRead!) {
      await pushMangaReaderView(context: context, chapter: this);
    } else {
      final filteredChaps = manga.value!.getChapterListForReading();
      bool exist = false;
      for (var filteredChap in filteredChaps) {
        if (filteredChap.toJson().toString() == toJson().toString()) {
          exist = true;
        }
        if (exist && !filteredChap.isRead!) {
          await pushMangaReaderView(context: context, chapter: filteredChap);
          break;
        }
      }
    }
  }

  void cancelDownloads(int? downloadId) {
    // Cancel via the Isolate pool (new system)
    DownloadIsolatePool.instance.cancelTask('$id');
    DownloadIsolatePool.instance.cancelTask('m3u8_$id');

    // Clean the map for compatibility
    isolateChapsSendPorts.remove('$id');

    isar.writeTxnSync(() {
      isar.downloads.deleteSync(id!);
      if (downloadId != null) {
        isar.downloads.deleteSync(downloadId);
      }
    });
  }

  Future<void> deleteDownloadedFiles() async {
    final download = isar.downloads.getSync(id!);
    if (download == null) return;

    final storageProvider = StorageProvider();
    final chapterName = name!.replaceForbiddenCharacters(' ');

    final mangaDirList = <Directory>[];
    final defaultMangaDir = await storageProvider.getMangaMainDirectory(this);
    if (defaultMangaDir != null) mangaDirList.add(defaultMangaDir);

    final folders = await getAllLocalFolders();
    for (final folder in folders) {
      final folderPath = folder.path;
      if (folderPath == null || folderPath.isEmpty) continue;
      mangaDirList.add(
        Directory(
          p.join(folderPath, manga.value!.name!.replaceForbiddenCharacters('_')),
        ),
      );
    }

    for (final mangaDir in mangaDirList) {
      final chapterDir = await storageProvider.getMangaChapterDirectory(
        this,
        mangaMainDirectory: mangaDir,
      );

      for (final entity in [
        File(p.join(mangaDir.path, "$name.cbz")),
        File(p.join(mangaDir.path, "$chapterName.cbz")),
        File(p.join(mangaDir.path, "$chapterName.mp4")),
        File(p.join(mangaDir.path, "$name.html")),
        File(p.join(chapterDir!.path, "$chapterName.html")),
        chapterDir,
      ]) {
        try {
          if (entity.existsSync()) entity.deleteSync(recursive: true);
        } catch (_) {}
      }
    }

    cancelDownloads(download.id);
  }

  void updateTrackChapterRead(dynamic ref) {
    if (!(ref is WidgetRef || ref is Ref)) return;
    final updateProgressAfterReading = ref.read(
      updateProgressAfterReadingStateProvider,
    );
    if (!updateProgressAfterReading) return;
    final manga = this.manga.value!;
    final chapterNumber = ChapterRecognition().parseEpisodeNumber(
      manga.name!,
      name!,
    );

    final tracks = isar.tracks
        .where()
        .mangaIdItemTypeEqualTo(manga.id!, manga.itemType)
        .findAllSync();

    for (var track in tracks) {
      final service = isar.trackPreferences
          .filter()
          .syncIdIsNotNull()
          .syncIdEqualTo(track.syncId)
          .findFirstSync();
      if (!(service == null || chapterNumber <= (track.lastChapterRead ?? 0))) {
        if (track.status != TrackStatus.completed) {
          final isFirstRead = (track.lastChapterRead ?? 0) == 0;
          track.lastChapterRead = chapterNumber;
          if (track.lastChapterRead == track.totalChapter &&
              (track.totalChapter ?? 0) > 0) {
            track.status = TrackStatus.completed;
            track.finishedReadingDate = DateTime.now().millisecondsSinceEpoch;
          } else {
            track.status = manga.itemType == ItemType.manga
                ? TrackStatus.reading
                : TrackStatus.watching;
            if (isFirstRead) {
              track.startedReadingDate = DateTime.now().millisecondsSinceEpoch;
            }
          }
        }
        ref
            .read(
              trackStateProvider(
                track: track,
                itemType: manga.itemType,
                widgetRef: ref,
              ).notifier,
            )
            .updateManga();
      }
    }
  }
}
