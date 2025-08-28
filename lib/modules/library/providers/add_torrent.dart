import 'package:file_picker/file_picker.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/services/torrent_server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'add_torrent.g.dart';

@riverpod
Future addTorrentFromUrlOrFromFile(
  Ref ref,
  Manga? mManga, {
  required bool init,
  String? url,
}) async {
  FilePickerResult? result;
  if (url == null) {
    result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['torrent'],
    );
  }

  if (result != null || url != null) {
    String torrentName = "";
    if (url != null) {
      torrentName = (await MTorrentServer().getTorrentPlaylist(
        url,
        null,
      )).$1.first.quality;
    }
    final dateNow = DateTime.now().millisecondsSinceEpoch;
    final manga =
        mManga ??
        Manga(
          favorite: true,
          source: 'torrent',
          author: '',
          itemType: ItemType.anime,
          genre: [],
          imageUrl: '',
          lang: '',
          link: '',
          name: url != null ? torrentName : _getName(result!.files.first.path!),
          dateAdded: dateNow,
          lastUpdate: dateNow,
          status: Status.unknown,
          description: '',
          isLocalArchive: true,
          artist: '',
          updatedAt: dateNow,
          sourceId: null,
        );

    if (url != null) {
      manga.customCoverImage = null;
      isar.writeTxnSync(() {
        isar.mangas.putSync(manga);
        final chapters = Chapter(
          name: torrentName,
          url: url,
          mangaId: manga.id,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        )..manga.value = manga;
        isar.chapters.putSync(chapters);
        chapters.manga.saveSync();
      });
    } else {
      for (var file in result!.files.reversed.toList()) {
        String name = _getName(file.path!);

        if (init) {
          manga.customCoverImage = null;
        }

        isar.writeTxnSync(() {
          isar.mangas.putSync(manga);
          final chapters = Chapter(
            name: name,
            archivePath: file.path,
            mangaId: manga.id,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          )..manga.value = manga;
          isar.chapters.putSync(chapters);
          chapters.manga.saveSync();
        });
      }
    }
  }
  return "";
}

String _getName(String path) {
  return path
      .split('/')
      .last
      .split("\\")
      .last
      .replaceAll(
        RegExp(r'\.(mp4|mov|avi|flv|wmv|mpeg|mkv|cbz|zip|cbt|tar|torrent)'),
        '',
      );
}
