import 'dart:convert';
import 'dart:io'; // For I/O-operations
import 'dart:ui' as ui;
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart'; // Isar database package for local storage
import 'package:mangayomi/main.dart'; // Exposes the global `isar` instance
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/downloaded_page_file.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/local_directory_access.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:path/path.dart' as p; // For manipulating file system paths
import 'package:bot_toast/bot_toast.dart'; // For Exceptions
import 'package:mangayomi/models/manga.dart'; // Has Manga model and ItemType enum
import 'package:mangayomi/models/chapter.dart'; // Has Chapter model with archivePath
import 'package:mangayomi/providers/storage_provider.dart'; // Provides storage directory selection
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Annotations for code generation
part 'file_scanner.g.dart';

@riverpod
class LocalFoldersState extends _$LocalFoldersState {
  @override
  List<LocalFolder> build() {
    final settings = isar.settings.getSync(227)!;
    return _normalizeLocalFolders(
      settings.namedLocalFolders ??
          settings.localFolders
              ?.map((e) => LocalFolder.fromPath(path: e))
              .toList() ??
          [],
    );
  }

  void set(List<LocalFolder> value) {
    final settings = isar.settings.getSync(227)!;
    state = _normalizeLocalFolders(value);
    final downloadFolderName = _resolveDownloadFolderName(
      settings.downloadLocalFolderName,
      [LocalFolder(name: 'local'), ...state],
    );
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..localFolders = state.map((e) => e.path ?? '').toList()
          ..namedLocalFolders = state
          ..downloadLocalFolderName = downloadFolderName
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class DownloadLocalFolderNameState extends _$DownloadLocalFolderNameState {
  @override
  String? build() {
    return isar.settings.getSync(227)!.downloadLocalFolderName;
  }

  void set(String? value) {
    state = value;
    setDownloadLocalFolderName(value);
  }
}

/// Scans `Mangayomi/local` folder (if exists) for Mangas/Animes and imports in library.
///
/// **Folder structure:**
/// ```
/// Mangayomi/local/MangaName/CustomCover.jpg (optional)
/// Mangayomi/local/MangaName/Chapter1/Page1.jpg
/// Mangayomi/local/MangaName/Chapter2.cbz
/// Mangayomi/local/AnimeName/Episode1.mp4
/// Mangayomi/local/NovelName/NovelName.epub
/// ```
/// **Supported filetypes:** (taken from lib/modules/library/providers/local_archive.dart, line 98)
/// ```
/// Videotypes:   mp4, mov, avi, flv, wmv, mpeg, mkv
/// Imagetypes:   jpg, jpeg, png, webp
/// Archivetypes: cbz, zip, cbt, tar
/// Other types: epub
/// ```
@riverpod
Future<void> scanLocalLibrary(Ref ref) async {
  // Get /local directory
  final defaultFolder = await getDefaultLocalFolder();
  final customFolders = ref.read(localFoldersStateProvider);
  final localFolders = [?defaultFolder, ...customFolders];
  for (final folder in localFolders) {
    await _scanDirectory(ref, folder, localFolders);
  }
}

Future<void> _scanDirectory(
  Ref ref,
  LocalFolder localFolder,
  List<LocalFolder> localFolders,
) async {
  final folderName = localFolder.name?.trim();
  final dirPath = localFolder.path?.trim();
  debugPrint(
    '[LocalLibraryScanner] _scanDirectory start: '
    'name=${folderName?.isNotEmpty == true ? folderName : '<empty>'}, '
    'path=${dirPath?.isNotEmpty == true ? dirPath : '<empty>'}, '
    'platform=${Platform.operatingSystem}, '
    'platformVersion=${Platform.operatingSystemVersion}, '
    'configuredFolders=${localFolders.length}',
  );
  debugPrint(
    '[LocalLibraryScanner] configured local folders: '
    '${localFolders.map(_debugLocalFolder).join(' | ')}',
  );
  if (dirPath == null || dirPath.isEmpty) {
    debugPrint(
      '[LocalLibraryScanner] _scanDirectory skipped: empty path for '
      'folder=${folderName?.isNotEmpty == true ? folderName : '<empty>'}',
    );
    return;
  }

  final resolvedDirectory = await _resolveLocalDirectoryPath(
    dirPath,
    logContext: '_scanDirectory',
  );
  final resolvedDirPath = resolvedDirectory.path;
  final dir = Directory(resolvedDirPath);
  if (resolvedDirPath != dirPath) {
    debugPrint(
      '[LocalLibraryScanner] _scanDirectory using resolved path: '
      'original=$dirPath, resolved=$resolvedDirPath',
    );
  }
  localFolder = LocalFolder(name: localFolder.name, path: resolvedDirPath);
  localFolders = _replaceLocalFolder(localFolders, dirPath, localFolder);
  // Don't do anything if /local doesn't exist
  if (!resolvedDirectory.probe.exists) {
    debugPrint(
      '[LocalLibraryScanner] _scanDirectory skipped: directory does not exist '
      'or is not accessible: $dirPath',
    );
    return;
  }

  final dateNow = DateTime.now().millisecondsSinceEpoch;

  // Fetch all existing mangas in library that are in /local (or \local)
  final List<Manga> existingMangas = await isar.mangas
      .filter()
      .sourceEqualTo("local")
      .or()
      .linkContains("Mangayomi/local")
      .or()
      .linkContains("Mangayomi\\local")
      .findAll();
  final mangaMap = {
    for (var m in existingMangas)
      localVirtualPathFromStoredPath(m.link!, localFolders): m,
  };

  // Fetch all chapters for existing mangas
  final existingMangaIds = existingMangas.map((m) => m.id);
  final existingChapters = await isar.chapters
      .filter()
      .anyOf(existingMangaIds, (q, id) => q.mangaIdEqualTo(id))
      .findAll();

  // Map where the key is manga ID and the value is a set of chapter paths.
  final chaptersMap = <int, Set<String>>{};

  // Add manga.Ids with all the corresponding relative! paths (Manga/Chapter)
  for (var chap in existingChapters) {
    if (chap.archivePath == null || chap.archivePath!.isEmpty) continue;
    String path = localVirtualPathFromStoredPath(
      chap.archivePath!,
      localFolders,
    );
    // For the given manga ID, add the path to its associated set.
    // If there's no entry for the manga ID yet, create a new empty set.
    chaptersMap.putIfAbsent(chap.mangaId!, () => <String>{}).add(path);
  }

  // Collect all chapter paths chaptersMap into a single set for easy lookup.
  final existingPaths = chaptersMap.values.expand((s) => s).toSet();
  List<Manga> processedMangas = <Manga>[];
  final List<List<dynamic>> newChapters = [];

  // If newMangas > 0, save all collected Mangas in library first to get a Manga ID
  int newMangas = 0;

  /// helper function to add chapters to newChapters list
  void addNewChapters(List<FileSystemEntity> items, bool imageFolder) {
    for (final chapter in items) {
      final relPath = getLocalVirtualPath(localFolder, chapter.path).trim();
      // Skip if the relative path is empty (invalid entry).
      if (relPath.isEmpty) continue;

      if (!existingPaths.contains(relPath)) {
        newChapters.add([chapter.path, imageFolder, relPath]);
        existingPaths.add(relPath);
      }
    }
  }

  final titleEntities = await _listLocalDirectory(
    dir,
    logContext: '_scanDirectory root',
  );
  final titleFolders = await _localDirectories(
    titleEntities,
    logContext: '_scanDirectory root',
  );
  debugPrint(
    '[LocalLibraryScanner] _scanDirectory root entries: '
    'path=$resolvedDirPath, total=${titleEntities.length}, '
    'folders=${titleFolders.length}, '
    'preview=${_debugEntityPreview(titleEntities)}',
  );

  // Iterate over each sub-directory (each representing a title, Manga or Anime)
  for (final folder in titleFolders) {
    final title = p.basename(folder.path); // Anime/Manga title
    String relativePath = getLocalVirtualPath(localFolder, folder.path);

    // List all folders and files inside a Manga/Anime title
    final children = await _listLocalDirectory(
      folder,
      logContext: '_scanDirectory title',
    );
    final subDirs = await _localDirectories(
      children,
      logContext: '_scanDirectory title=$title',
    );
    final files = await _localFiles(
      children,
      logContext: '_scanDirectory title=$title',
    );

    // Determine itemtype. Only directories with image files are manga chapters;
    // subtitle/temp folders must not make anime entries look like manga.
    final imageChapterDirs = <Directory>[];
    for (final subDir in subDirs) {
      if (_isIgnoredLocalSubDirectory(subDir)) continue;
      if (await _firstImageFileInDirectory(subDir) != null) {
        imageChapterDirs.add(subDir);
      }
    }
    final hasImagesFolders = imageChapterDirs.isNotEmpty;
    final hasArchives = files.any((f) => _isArchive(f.path));
    final hasVideos = files.any((f) => _isVideo(f.path));
    final hasEpubs = files.any((f) => _isEpub(f.path));
    debugPrint(
      '[LocalLibraryScanner] _scanDirectory title scan: '
      'title=$title, relativePath=$relativePath, children=${children.length}, '
      'folders=${subDirs.length}, files=${files.length}, '
      'imageFolders=${imageChapterDirs.length}, archives=$hasArchives, '
      'videos=$hasVideos, epubs=$hasEpubs, '
      'preview=${_debugEntityPreview(children)}',
    );
    late ItemType itemType;
    if (hasImagesFolders || hasArchives) {
      itemType = ItemType.manga;
    } else if (hasVideos) {
      itemType = ItemType.anime;
    } else if (hasEpubs) {
      itemType = ItemType.novel;
    } else {
      debugPrint(
        '[LocalLibraryScanner] _scanDirectory title skipped: '
        'no supported local content found for $title',
      );
      continue; // nothing to import from this folder
    }
    // Does Manga/Anime already exist in library?
    bool existingManga = mangaMap.containsKey(relativePath);

    // Create new Manga entry if it doesn't already exist
    Manga manga;
    if (existingManga) {
      manga = mangaMap[relativePath]!;
      if (manga.link != relativePath) {
        manga.link = relativePath;
        manga.lastUpdate = dateNow;
      }
    } else {
      manga = Manga(
        favorite: false,
        source: 'local',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: '',
        link: relativePath,
        name: title,
        status: Status.unknown,
        description: '',
        isLocalArchive: true,
        itemType: itemType,
        dateAdded: dateNow,
        lastUpdate: dateNow,
        sourceId: null,
      );
      newMangas++;
    }

    // Detect a cover in the item root, otherwise derive one from the first
    // local chapter so local-only folders do not fall back to the blank image.
    final imageFiles = files.where((f) => _isImage(f.path)).toList();
    final coverFile = _findCoverFile(imageFiles);
    Uint8List? coverBytes;
    if (coverFile != null) {
      try {
        coverBytes = await coverFile.readAsBytes();
        if (itemType == ItemType.manga &&
            await _isMostlyBlankWhiteImage(coverBytes)) {
          coverBytes = await _readMangaFolderCover(ref, subDirs, files);
        }
      } catch (e) {
        BotToast.showText(
          text: localizedMessage((l10n) => l10n.error_reading_cover_image(e)),
        );
      }
    } else if (itemType == ItemType.manga && manga.customCoverImage == null) {
      coverBytes = await _readMangaFolderCover(ref, subDirs, files);
    }

    if (coverBytes != null) {
      final coverImage = coverBytes.getCoverImage;
      if (coverImage != null &&
          !_sameBytes(manga.customCoverImage, coverImage)) {
        manga.customCoverImage = coverImage;
        manga.lastUpdate = dateNow;
      }
    } else if (itemType != ItemType.manga &&
        imageFiles.isEmpty &&
        manga.customCoverImage != null) {
      manga.customCoverImage = null;
    }

    final jsonFiles = files.where((f) => _isJson(f.path)).toList();
    if (jsonFiles.isNotEmpty) {
      try {
        final str = await File(jsonFiles.first.path).readAsString();
        final data = jsonDecode(str) as Map<String, dynamic>?;
        manga.name = data?["name"];
        manga.description = data?["description"];
        manga.artist = data?["artist"];
        manga.author = data?["author"];
        manga.genre = data?["genre"]?.cast<String>();
        manga.status = data?["status"] != null
            ? Status.values[data!["status"]]
            : Status.unknown;
        manga.lastUpdate = dateNow;
      } catch (e) {
        BotToast.showText(
          text: localizedMessage((l10n) => l10n.error_reading_metadata(e)),
        );
      }
    }

    processedMangas.add(manga);

    // Scan chapters/episodes
    if (hasImagesFolders) {
      // Each subdirectory is a chapter
      addNewChapters(imageChapterDirs, hasImagesFolders);
    } // Possible that image folders and archives are mixed in one manga
    if (hasArchives) {
      // Each .cbz/.zip file is a chapter
      final archives = files.where((f) => _isArchive(f.path)).toList();
      addNewChapters(archives, false);
    }
    if (hasVideos) {
      // Each .mp4 is an episode
      final videos = files.where((f) => _isVideo(f.path)).toList();
      addNewChapters(videos, false);
    }
    if (hasEpubs) {
      // Each .epub
      final epubs = files.where((f) => _isEpub(f.path)).toList();
      addNewChapters(epubs, false);
    }
  }

  debugPrint(
    '[LocalLibraryScanner] _scanDirectory scan summary: '
    'folder=$resolvedDirPath, processedMangas=${processedMangas.length}, '
    'newMangas=$newMangas, newChapters=${newChapters.length}',
  );

  final changedMangas = <Manga>[];
  for (var manga in processedMangas) {
    if (manga.lastUpdate == dateNow) {
      // Filter out items that haven't been changed
      changedMangas.add(manga);
    }
  }
  try {
    // Save all new and changed items to the library
    await isar.writeTxn(() async => await isar.mangas.putAll(changedMangas));
  } catch (e) {
    BotToast.showText(
      text: "Database write error. Manga/Anime couldn't be saved: $e",
    );
  }

  // If new Mangas have been added (no Id to save Chapters)
  if (newMangas > 0) {
    // Copy processedMangas
    List<Manga> newAddedMangas = processedMangas;
    // Fetch all existing mangas in library that are in /local (or \local)
    final savedMangas = await isar.mangas
        .filter()
        .sourceEqualTo("local")
        .or()
        .linkContains("Mangayomi/local")
        .or()
        .linkContains("Mangayomi\\local")
        .findAll();
    // Save all retrieved Manga objects (now with id) matching the processedMangas list
    newAddedMangas = savedMangas
        .where(
          (m) => processedMangas.any(
            (newManga) =>
                localVirtualPathFromStoredPath(newManga.link, localFolders) ==
                localVirtualPathFromStoredPath(m.link, localFolders),
          ),
        )
        .toList();
    processedMangas.clear();
    processedMangas = newAddedMangas;
  }

  final chaptersToSave = <Chapter>[];
  int saveManga = 0; // Just to update the lastUpdate value of not new Mangas
  final mangaByPath = {
    for (var m in processedMangas)
      localVirtualPathFromStoredPath(m.link, localFolders): m,
  };

  // iterate through newChapters elements, which are: ["full_path/to/chapter1", "true"]
  for (var pathBool in newChapters) {
    final chapterPath = pathBool[0] as String;
    final virtualChapterPath = pathBool[2] as String;
    // pathBool[0] = first element of list (path)
    // dirname = remove last part of path (chapter name), = "full_path/to"
    // basename = remove everything except last (manga name) = "to"
    final mangaPath = p.posix.dirname(virtualChapterPath);
    final manga = mangaByPath[mangaPath];
    if (manga != null) {
      if (manga.itemType == ItemType.novel) {
        final book = await parseEpubFromPath(
          epubPath: chapterPath,
          fullData: true,
        );

        if (book.cover != null) {
          manga.customCoverImage = book.cover!.getCoverImage;
          saveManga++;
        }
        final chaps = book.chapters;
        if (chaps.isNotEmpty) {
          for (int i = 0; i < chaps.length; i++) {
            final epubChapter = chaps[i];
            chaptersToSave.add(
              Chapter(
                mangaId: manga.id,
                name: epubChapter.name,
                archivePath: virtualChapterPath,
                url: epubChapter.path,
                downloadSize: null,
              )..manga.value = manga,
            );
          }
        } else {
          chaptersToSave.add(
            Chapter(
              mangaId: manga.id,
              name: book.name,
              archivePath: virtualChapterPath,
              downloadSize: null,
            )..manga.value = manga,
          );
        }
      } else {
        final chapterFile = File(chapterPath);
        final chap = Chapter(
          mangaId: manga.id,
          name:
              pathBool[1] // If Chapter is an image folder or archive/video
              ? p.basename(chapterPath)
              : p.basenameWithoutExtension(chapterPath),
          dateUpload: dateNow.toString(),
          archivePath: virtualChapterPath,
          downloadSize: chapterFile.existsSync()
              ? chapterFile.lengthSync().formattedFileSize()
              : null,
        );
        chaptersToSave.add(chap);
      }
      if (manga.lastUpdate != dateNow) {
        manga.lastUpdate = dateNow;
        saveManga++;
      }
    }
  }
  try {
    if (saveManga > 0) {
      // Just to update the lastUpdate value of not new Mangas
      await isar.writeTxn(
        () async => await isar.mangas.putAll(processedMangas),
      );
    }
  } catch (e) {
    BotToast.showText(
      text: localizedMessage(
        (l10n) => l10n.error_saving_chapter_episode_to_library(e),
      ),
    );
  }
  try {
    if (chaptersToSave.isNotEmpty) {
      final mangaMap = {for (final m in processedMangas) m.id: m};
      await isar.writeTxn(() async {
        for (final chap in chaptersToSave) {
          final manga = mangaMap[chap.mangaId];
          if (manga != null) {
            chap.manga.value = manga;
          }
        }
        // insert chapters
        await isar.chapters.putAll(chaptersToSave);

        // save link references
        for (final chap in chaptersToSave) {
          await chap.manga.save();
        }
      });
    }
  } catch (e) {
    BotToast.showText(
      text: "Database write error. Manga/Anime couldn't be saved: $e",
    );
  }
}

File? _findCoverFile(List<File> imageFiles) {
  if (imageFiles.isEmpty) return null;
  final sorted = [...imageFiles]..sort((a, b) => a.path.compareTo(b.path));
  final namedCover = sorted.where((file) {
    final name = p.basenameWithoutExtension(file.path).toLowerCase();
    return name == 'cover' ||
        name == 'folder' ||
        name == 'poster' ||
        name == 'thumbnail' ||
        name.contains('cover');
  }).firstOrNull;
  return namedCover ?? (sorted.length == 1 ? sorted.first : null);
}

Future<Uint8List?> _readMangaFolderCover(
  Ref ref,
  List<Directory> subDirs,
  List<File> files,
) async {
  final chapterDirs =
      subDirs.where((dir) => !dir.path.endsWith("_subtitles")).toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final dir in chapterDirs) {
    final imageFile = await _firstImageFileInDirectory(dir);
    if (imageFile == null) continue;
    try {
      return await imageFile.readAsBytes();
    } catch (e) {
      BotToast.showText(
        text: localizedMessage(
          (l10n) => l10n.error_reading_chapter_cover_image(e),
        ),
      );
    }
  }

  final archives = files.where((file) => _isArchive(file.path)).toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  for (final archive in archives) {
    try {
      final data = await ref.read(
        getArchivesDataFromFileProvider(archive.path).future,
      );
      return data.$3;
    } catch (e) {
      BotToast.showText(
        text: localizedMessage(
          (l10n) => l10n.error_reading_archive_cover_image(e),
        ),
      );
    }
  }
  return null;
}

Future<File?> _firstImageFileInDirectory(Directory dir) async {
  try {
    final entities = await _listLocalDirectory(
      dir,
      logContext: '_firstImageFileInDirectory',
    );
    final imageFiles =
        (await _localFiles(
            entities,
            logContext: '_firstImageFileInDirectory',
          )).where((file) => _isImage(file.path)).toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    return imageFiles.firstOrNull;
  } catch (e) {
    debugPrint(
      '[LocalLibraryScanner] _firstImageFileInDirectory failed: '
      'path=${dir.path}, error=$e',
    );
    return null;
  }
}

bool _isIgnoredLocalSubDirectory(Directory dir) {
  final name = p.basename(dir.path);
  return name.startsWith('.') || name.endsWith('_subtitles');
}

bool _sameBytes(List<int>? a, List<int> b) {
  if (a == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Future<bool> _isMostlyBlankWhiteImage(Uint8List bytes) async {
  try {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: 12,
      targetHeight: 12,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    codec.dispose();
    if (byteData == null) return false;

    final data = byteData.buffer.asUint8List();
    var total = 0;
    var white = 0;
    for (var i = 0; i + 3 < data.length; i += 4) {
      total++;
      if (data[i] >= 250 &&
          data[i + 1] >= 250 &&
          data[i + 2] >= 250 &&
          data[i + 3] >= 250) {
        white++;
      }
    }
    return total > 0 && white / total > 0.95;
  } catch (_) {
    return false;
  }
}

/// Returns the `/local` directory inside the app's default storage.
Future<Directory?> getLocalLibrary() async {
  try {
    final dir = await StorageProvider().getDefaultDirectory();
    return dir == null ? null : Directory(p.join(dir.path, 'local'));
  } catch (e) {
    BotToast.showText(
      text: localizedMessage((l10n) => l10n.error_getting_local_library(e)),
    );
    return null;
  }
}

Future<LocalFolder?> getDefaultLocalFolder() async {
  final dir = await getLocalLibrary();
  if (dir == null) return null;
  return LocalFolder(name: 'local', path: dir.path);
}

Future<List<LocalFolder>> getAllLocalFolders({
  bool includeDefault = true,
}) async {
  final settings = isar.settings.getSync(227)!;
  final folders = _normalizeLocalFolders(
    settings.namedLocalFolders ??
        settings.localFolders
            ?.map((e) => LocalFolder.fromPath(path: e))
            .toList() ??
        [],
  );
  if (!includeDefault) return folders;
  final defaultFolder = await getDefaultLocalFolder();
  return [?defaultFolder, ...folders];
}

Future<LocalFolder?> getDownloadLocalFolder() async {
  final folders = await getAllLocalFolders();
  if (folders.isEmpty) return null;
  final settings = isar.settings.getSync(227)!;
  final name = _resolveDownloadFolderName(
    settings.downloadLocalFolderName,
    folders,
  );
  return folders.firstWhere((folder) => folder.name == name);
}

void setDownloadLocalFolderName(String? name) {
  final settings = isar.settings.getSync(227)!;
  isar.writeTxnSync(
    () => isar.settings.putSync(
      settings
        ..downloadLocalFolderName = name
        ..updatedAt = DateTime.now().millisecondsSinceEpoch,
    ),
  );
}

String getLocalVirtualPath(LocalFolder folder, String entityPath) {
  final folderName = folder.name?.trim();
  final folderPath = folder.path;
  if (folderName == null ||
      folderName.isEmpty ||
      folderPath == null ||
      folderPath.isEmpty) {
    return _normalizePath(entityPath);
  }
  final relative = p.relative(entityPath, from: folderPath);
  if (relative == '.') return folderName;
  return p.posix.join(folderName, _normalizePath(relative));
}

String localVirtualPathFromStoredPath(
  String? storedPath,
  List<LocalFolder> folders,
) {
  if (storedPath == null || storedPath.trim().isEmpty) return '';
  final normalized = _normalizePath(storedPath);
  final firstSegment = normalized.split('/').firstOrNull;
  if (firstSegment != null &&
      folders.any((folder) => folder.name == firstSegment)) {
    return normalized;
  }

  for (final folder in folders) {
    final folderPath = folder.path;
    if (folderPath == null || folderPath.isEmpty) continue;
    final normalizedFolderPath = _normalizePath(folderPath);
    if (normalized == normalizedFolderPath ||
        normalized.startsWith('$normalizedFolderPath/')) {
      return getLocalVirtualPath(folder, storedPath);
    }
  }

  const legacyLocalPath = 'Mangayomi/local';
  final legacyIndex = normalized.indexOf(legacyLocalPath);
  if (legacyIndex != -1) {
    final relative = normalized
        .substring(legacyIndex + legacyLocalPath.length)
        .replaceFirst(RegExp('^/+'), '');
    return p.posix.join('local', relative);
  }

  return normalized;
}

Future<String> resolveLocalArchivePath(String archivePath) async {
  final folders = await getAllLocalFolders();
  final normalized = _normalizePath(archivePath);
  final parts = normalized.split('/');
  if (parts.length < 2) return archivePath;

  final folder = folders.firstWhere(
    (folder) => folder.name == parts.first,
    orElse: () => LocalFolder(),
  );
  if (folder.path == null || folder.path!.isEmpty) return archivePath;
  final resolvedFolder = await _resolveLocalDirectoryPath(
    folder.path!,
    logContext: 'resolveLocalArchivePath',
  );
  return p.joinAll([resolvedFolder.path, ...parts.skip(1)]);
}

List<LocalFolder> _normalizeLocalFolders(List<LocalFolder> folders) {
  final usedNames = <String>{'local'};
  return folders
      .where((folder) => (folder.path?.trim().isNotEmpty ?? false))
      .map((folder) {
        final name = _uniqueLocalFolderName(
          folder.name?.trim().isNotEmpty ?? false
              ? folder.name!.trim()
              : LocalFolder.fromPath(path: folder.path!).name ?? 'Local',
          usedNames,
        );
        usedNames.add(name);
        return LocalFolder(name: name, path: folder.path!.trim());
      })
      .toList();
}

String _uniqueLocalFolderName(String value, Set<String> usedNames) {
  final normalized = value.replaceAll('/', '_').replaceAll('\\', '_').trim();
  final base = normalized.isEmpty ? 'Local' : normalized;
  var name = base == 'local' ? 'Local' : base;
  var index = 2;
  while (usedNames.contains(name)) {
    name = '$base $index';
    index++;
  }
  return name;
}

String? _resolveDownloadFolderName(String? name, List<LocalFolder> folders) {
  if (name != null && folders.any((folder) => folder.name == name)) {
    return name;
  }
  return folders.firstOrNull?.name;
}

Future<List<FileSystemEntity>> _listLocalDirectory(
  Directory directory, {
  required String logContext,
}) async {
  if (Platform.isIOS) {
    try {
      final entries = await LocalDirectoryAccess.listDirectory(directory.path);
      if (entries != null) {
        debugPrint(
          '[LocalLibraryScanner] $logContext native iOS list: '
          'path=${directory.path}, entries=${entries.length}, '
          'preview=${entries.take(8).map((e) => '${e.type}:${p.basename(e.path)}').join(', ')}',
        );
        return entries.map((entry) {
          if (entry.isDirectory) return Directory(entry.path);
          if (entry.isFile) return File(entry.path);
          return FileSystemEntity.typeSync(entry.path) ==
                  FileSystemEntityType.directory
              ? Directory(entry.path)
              : File(entry.path);
        }).toList();
      }
    } catch (e, stackTrace) {
      debugPrint(
        '[LocalLibraryScanner] $logContext native iOS list failed: '
        'path=${directory.path}, error=$e\n$stackTrace',
      );
    }
  }

  try {
    return await directory.list(followLinks: true).toList();
  } catch (e, stackTrace) {
    debugPrint(
      '[LocalLibraryScanner] $logContext list failed: '
      'path=${directory.path}, error=$e\n$stackTrace',
    );
    return [];
  }
}

Future<List<Directory>> _localDirectories(
  List<FileSystemEntity> entities, {
  required String logContext,
}) async {
  final dirs = <Directory>[];
  for (final entity in entities) {
    if (entity is Directory ||
        await _localEntityType(entity, logContext: logContext) ==
            FileSystemEntityType.directory) {
      dirs.add(entity is Directory ? entity : Directory(entity.path));
    }
  }
  return dirs;
}

Future<List<File>> _localFiles(
  List<FileSystemEntity> entities, {
  required String logContext,
}) async {
  final files = <File>[];
  for (final entity in entities) {
    if (entity is File ||
        await _localEntityType(entity, logContext: logContext) ==
            FileSystemEntityType.file) {
      files.add(entity is File ? entity : File(entity.path));
    }
  }
  return files;
}

Future<FileSystemEntityType> _localEntityType(
  FileSystemEntity entity, {
  required String logContext,
}) async {
  try {
    return await FileSystemEntity.type(entity.path, followLinks: true);
  } catch (e) {
    debugPrint(
      '[LocalLibraryScanner] $logContext entity type failed: '
      'path=${entity.path}, runtimeType=${entity.runtimeType}, error=$e',
    );
    return FileSystemEntityType.notFound;
  }
}

String _debugEntityPreview(List<FileSystemEntity> entities) {
  if (entities.isEmpty) return '<empty>';
  return entities
      .take(8)
      .map((entity) => '${entity.runtimeType}:${p.basename(entity.path)}')
      .join(', ');
}

List<LocalFolder> _replaceLocalFolder(
  List<LocalFolder> folders,
  String originalPath,
  LocalFolder replacement,
) {
  var replaced = false;
  final updated = folders.map((folder) {
    if (!replaced &&
        folder.name == replacement.name &&
        folder.path?.trim() == originalPath) {
      replaced = true;
      return replacement;
    }
    return folder;
  }).toList();
  return replaced ? updated : [replacement, ...updated];
}

Future<_ResolvedLocalDirectory> _resolveLocalDirectoryPath(
  String dirPath, {
  required String logContext,
}) async {
  var probe = await _probeLocalDirectory(dirPath);
  _logDirectoryProbe(logContext, 'initial', probe);
  if (probe.exists) {
    return _ResolvedLocalDirectory(path: dirPath, probe: probe);
  }

  if (Platform.isAndroid) {
    final permissionGranted = await StorageProvider().requestPermission();
    debugPrint(
      '[LocalLibraryScanner] $logContext Android storage permission retry: '
      'granted=$permissionGranted, path=$dirPath',
    );
    if (permissionGranted) {
      probe = await _probeLocalDirectory(dirPath);
      _logDirectoryProbe(logContext, 'after-permission', probe);
      if (probe.exists) {
        return _ResolvedLocalDirectory(path: dirPath, probe: probe);
      }
    }
  }

  final directCandidates = _directAndroidDirectoryCandidates(dirPath);
  debugPrint(
    '[LocalLibraryScanner] $logContext direct Android candidates: '
    '${directCandidates.isEmpty ? '<none>' : directCandidates.join(' | ')}',
  );
  for (final candidate in directCandidates) {
    final candidateProbe = await _probeLocalDirectory(candidate);
    _logDirectoryProbe(logContext, 'direct-android-candidate', candidateProbe);
    if (candidateProbe.exists) {
      return _ResolvedLocalDirectory(path: candidate, probe: candidateProbe);
    }
  }

  final externalPathCandidates = await _safeExternalPathDirectoryCandidates(
    dirPath,
    logContext: logContext,
  );
  for (final candidate in externalPathCandidates) {
    final candidateProbe = await _probeLocalDirectory(candidate);
    _logDirectoryProbe(logContext, 'external_path-candidate', candidateProbe);
    if (candidateProbe.exists) {
      return _ResolvedLocalDirectory(path: candidate, probe: candidateProbe);
    }
  }

  return _ResolvedLocalDirectory(path: dirPath, probe: probe);
}

Future<_DirectoryProbe> _probeLocalDirectory(String dirPath) async {
  final dir = Directory(dirPath);
  final parent = dir.parent;
  bool dirExists = false;
  bool parentExists = false;
  FileStat? dirStat;
  Object? dirExistsError;
  Object? parentExistsError;
  Object? dirStatError;
  try {
    dirExists = await dir.exists();
  } catch (e) {
    dirExistsError = e;
  }
  try {
    parentExists = await parent.exists();
  } catch (e) {
    parentExistsError = e;
  }
  try {
    dirStat = await dir.stat();
  } catch (e) {
    dirStatError = e;
  }
  return _DirectoryProbe(
    path: dirPath,
    absolutePath: dir.absolute.path,
    normalizedPath: _normalizePath(dirPath),
    parentPath: parent.path,
    exists: dirExists,
    parentExists: parentExists,
    stat: dirStat,
    existsError: dirExistsError,
    parentExistsError: parentExistsError,
    statError: dirStatError,
  );
}

void _logDirectoryProbe(
  String logContext,
  String stage,
  _DirectoryProbe probe,
) {
  debugPrint(
    '[LocalLibraryScanner] $logContext directory probe [$stage]: '
    'path=${probe.path}, '
    'absolutePath=${probe.absolutePath}, '
    'normalizedPath=${probe.normalizedPath}, '
    'parent=${probe.parentPath}, '
    'exists=${probe.exists}, '
    'parentExists=${probe.parentExists}, '
    'statType=${probe.stat?.type}, '
    'statMode=${probe.stat?.modeString()}, '
    'modified=${probe.stat?.modified.toIso8601String()}',
  );
  if (probe.existsError != null ||
      probe.parentExistsError != null ||
      probe.statError != null) {
    debugPrint(
      '[LocalLibraryScanner] $logContext directory probe errors [$stage]: '
      'existsError=${probe.existsError}, '
      'parentExistsError=${probe.parentExistsError}, '
      'statError=${probe.statError}',
    );
  }
}

Future<List<String>> _externalPathDirectoryCandidates(String dirPath) async {
  if (!Platform.isAndroid && !Platform.isIOS) return [];
  final roots = await _externalPathRoots();
  final normalizedOriginal = _normalizePath(dirPath);
  final suffixes = _externalPathSuffixes(dirPath);
  final candidates = <String>{};
  for (final root in roots) {
    final normalizedRoot = _normalizePath(root);
    if (normalizedOriginal == normalizedRoot) {
      candidates.add(root);
    }
    for (final suffix in suffixes) {
      candidates.add(p.join(root, suffix));
    }
  }
  return candidates
      .where((candidate) => _normalizePath(candidate) != normalizedOriginal)
      .toList();
}

Future<List<String>> _safeExternalPathDirectoryCandidates(
  String dirPath, {
  required String logContext,
}) async {
  try {
    final candidates = await _externalPathDirectoryCandidates(dirPath);
    debugPrint(
      '[LocalLibraryScanner] $logContext external_path candidates: '
      '${candidates.isEmpty ? '<none>' : candidates.join(' | ')}',
    );
    return candidates;
  } catch (e, stackTrace) {
    debugPrint(
      '[LocalLibraryScanner] $logContext external_path candidates failed: $e\n'
      '$stackTrace',
    );
    return [];
  }
}

List<String> _directAndroidDirectoryCandidates(String dirPath) {
  if (!Platform.isAndroid) return [];
  final normalizedOriginal = _normalizePath(dirPath);
  final parts = normalizedOriginal
      .split('/')
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.length < 3 || parts.first != 'storage') return [];

  final volume = parts[1];
  if (volume == 'emulated' || volume == 'self') return [];

  final suffix = p.joinAll(parts.skip(2));
  return [
        p.join('/mnt/media_rw', volume, suffix),
        p.join('/mnt/runtime/default', volume, suffix),
        p.join('/mnt/runtime/read', volume, suffix),
        p.join('/mnt/runtime/write', volume, suffix),
      ]
      .where((candidate) => _normalizePath(candidate) != normalizedOriginal)
      .toList();
}

Future<List<String>> _externalPathRoots() async {
  final roots = <String>{};
  try {
    roots.addAll(
      (await ExternalPath.getExternalStorageDirectories() ?? [])
          .map((path) => path.trim())
          .where((path) => path.isNotEmpty),
    );
  } catch (e) {
    debugPrint(
      '[LocalLibraryScanner] external_path getExternalStorageDirectories '
      'failed: $e',
    );
  }

  for (final type in _externalPathPublicDirectoryTypes()) {
    try {
      final path = await ExternalPath.getExternalStoragePublicDirectory(type);
      if (path.trim().isNotEmpty) roots.add(path.trim());
    } catch (e) {
      debugPrint(
        '[LocalLibraryScanner] external_path public directory failed: '
        'type=$type, error=$e',
      );
    }
  }
  debugPrint(
    '[LocalLibraryScanner] external_path roots: '
    '${roots.isEmpty ? '<none>' : roots.join(' | ')}',
  );
  return roots.toList();
}

List<String> _externalPathSuffixes(String dirPath) {
  final parts = _normalizePath(
    dirPath,
  ).split('/').where((part) => part.isNotEmpty).toList();
  final suffixes = <String>{};
  if (parts.length > 2 && parts[0] == 'storage') {
    suffixes.add(p.joinAll(parts.skip(2)));
  }
  if (parts.length > 3 && parts[0] == 'mnt' && parts[1] == 'media_rw') {
    suffixes.add(p.joinAll(parts.skip(3)));
  }
  if (parts.isNotEmpty) suffixes.add(parts.last);
  return suffixes.where((suffix) => suffix.trim().isNotEmpty).toList();
}

String _debugLocalFolder(LocalFolder folder) {
  final name = folder.name?.trim();
  final path = folder.path?.trim();
  return 'name=${name?.isNotEmpty == true ? name : '<empty>'}, '
      'path=${path?.isNotEmpty == true ? path : '<empty>'}';
}

List<String> _externalPathPublicDirectoryTypes() {
  if (Platform.isAndroid) {
    return [ExternalPath.DIRECTORY_DOCUMENTS, ExternalPath.DIRECTORY_DOWNLOAD];
  }
  if (Platform.isIOS) {
    return [
      ExternalPath.DIRECTORY_DOCUMENTS,
      ExternalPath.DIRECTORY_DOWNLOAD,
      ExternalPath.DIRECTORY_CACHES,
      ExternalPath.DIRECTORY_LIBRARY,
      ExternalPath.DIRECTORY_APPLICATION_SUPPORT,
    ];
  }
  return [];
}

class _ResolvedLocalDirectory {
  final String path;
  final _DirectoryProbe probe;

  const _ResolvedLocalDirectory({required this.path, required this.probe});
}

class _DirectoryProbe {
  final String path;
  final String absolutePath;
  final String normalizedPath;
  final String parentPath;
  final bool exists;
  final bool parentExists;
  final FileStat? stat;
  final Object? existsError;
  final Object? parentExistsError;
  final Object? statError;

  const _DirectoryProbe({
    required this.path,
    required this.absolutePath,
    required this.normalizedPath,
    required this.parentPath,
    required this.exists,
    required this.parentExists,
    required this.stat,
    required this.existsError,
    required this.parentExistsError,
    required this.statError,
  });
}

String _normalizePath(String path) {
  return path.replaceAll('\\', '/').replaceAll(RegExp('/+'), '/');
}

/// Returns if file is a json
bool _isJson(String path) {
  if (_isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.json';
}

/// Returns if file is an image
bool _isImage(String path) {
  if (_isHiddenSystemFile(path)) return false;
  return isRecognizedImageFile(path);
}

/// Returns if file is an archive
bool _isArchive(String path) {
  if (_isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.cbz' ||
      ext == '.zip' ||
      ext == '.cbt' ||
      ext == '.tar' ||
      ext == '.cbr' ||
      ext == '.rar';
}

/// Returns if file is a video
bool _isVideo(String path) {
  if (_isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  const videoExtensions = {
    '.mp4',
    '.mov',
    '.avi',
    '.flv',
    '.wmv',
    '.mpeg',
    '.mkv',
  };
  return videoExtensions.contains(ext);
}

/// Returns if file is an epub or html
bool _isEpub(String path) {
  if (_isHiddenSystemFile(path)) return false;
  final ext = p.extension(path).toLowerCase();
  return ext == '.epub';
}

bool _isHiddenSystemFile(String path) {
  final name = path.replaceAll('\\', '/').split('/').last;
  return name.startsWith('.');
}
