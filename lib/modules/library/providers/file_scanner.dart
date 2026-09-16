import 'dart:convert';
import 'dart:io'; // For I/O-operations
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/modules/library/providers/local_directory_resolver.dart';
import 'package:mangayomi/modules/library/providers/local_file_classifier.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/localized_message.dart';
import 'package:path/path.dart' as p; // For manipulating file system paths
import 'package:bot_toast/bot_toast.dart'; // For Exceptions
import 'package:mangayomi/models/manga.dart'; // Has Manga model and ItemType enum
import 'package:mangayomi/models/chapter.dart'; // Has Chapter model with archivePath
import 'package:mangayomi/providers/storage_provider.dart'; // Provides storage directory selection
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; // Annotations for code generation
part 'file_scanner.g.dart';

@riverpod
class LocalFoldersState extends _$LocalFoldersState {
  @override
  List<LocalFolder> build() {
    final settings = settingsRepository.current;
    return _normalizeLocalFolders(
      settings.namedLocalFolders ??
          settings.localFolders
              ?.map((e) => LocalFolder.fromPath(path: e))
              .toList() ??
          [],
    );
  }

  void set(List<LocalFolder> value) {
    final currentDownloadFolderName =
        settingsRepository.current.downloadLocalFolderName;
    state = _normalizeLocalFolders(value);
    final downloadFolderName = _resolveDownloadFolderName(
      currentDownloadFolderName,
      [LocalFolder(name: 'local'), ...state],
    );
    settingsRepository.update((s) {
      s
        ..localFolders = state.map((e) => e.path ?? '').toList()
        ..namedLocalFolders = state
        ..downloadLocalFolderName = downloadFolderName;
    });
  }
}

@riverpod
class DownloadLocalFolderNameState extends _$DownloadLocalFolderNameState {
  @override
  String? build() {
    return settingsRepository.current.downloadLocalFolderName;
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

  final resolvedDirectory = await resolveLocalDirectoryPath(
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
  final List<Manga> existingMangas = await mangaRepository.getAllLocal();
  final mangaMap = {
    for (var m in existingMangas)
      localVirtualPathFromStoredPath(m.link!, localFolders): m,
  };

  // Fetch all chapters for existing mangas
  final existingMangaIds = existingMangas.map((m) => m.id);
  final existingChapters = await chapterRepository.getAllByMangaIds(
    existingMangaIds,
  );

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

  final titleEntities = await listLocalDirectory(
    dir,
    logContext: '_scanDirectory root',
  );
  final titleFolders = await localDirectories(
    titleEntities,
    logContext: '_scanDirectory root',
  );
  debugPrint(
    '[LocalLibraryScanner] _scanDirectory root entries: '
    'path=$resolvedDirPath, total=${titleEntities.length}, '
    'folders=${titleFolders.length}, '
    'preview=${debugEntityPreview(titleEntities)}',
  );

  // Iterate over each sub-directory (each representing a title, Manga or Anime)
  for (final folder in titleFolders) {
    final title = p.basename(folder.path); // Anime/Manga title
    String relativePath = getLocalVirtualPath(localFolder, folder.path);

    // List all folders and files inside a Manga/Anime title
    final children = await listLocalDirectory(
      folder,
      logContext: '_scanDirectory title',
    );
    final subDirs = await localDirectories(
      children,
      logContext: '_scanDirectory title=$title',
    );
    final files = await localFiles(
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
    final hasArchives = files.any((f) => isArchiveFile(f.path));
    final hasVideos = files.any((f) => isVideoFile(f.path));
    final hasEpubs = files.any((f) => isEpubFile(f.path));
    debugPrint(
      '[LocalLibraryScanner] _scanDirectory title scan: '
      'title=$title, relativePath=$relativePath, children=${children.length}, '
      'folders=${subDirs.length}, files=${files.length}, '
      'imageFolders=${imageChapterDirs.length}, archives=$hasArchives, '
      'videos=$hasVideos, epubs=$hasEpubs, '
      'preview=${debugEntityPreview(children)}',
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
    final imageFiles = files.where((f) => isLocalImageFile(f.path)).toList();
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

    final jsonFiles = files.where((f) => isJsonFile(f.path)).toList();
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
      final archives = files.where((f) => isArchiveFile(f.path)).toList();
      addNewChapters(archives, false);
    }
    if (hasVideos) {
      // Each .mp4 is an episode
      final videos = files.where((f) => isVideoFile(f.path)).toList();
      addNewChapters(videos, false);
    }
    if (hasEpubs) {
      // Each .epub
      final epubs = files.where((f) => isEpubFile(f.path)).toList();
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
    await mangaRepository.putAll(changedMangas);
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
    final savedMangas = await mangaRepository.getAllLocal();
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
      await mangaRepository.putAll(processedMangas);
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
      await chapterRepository.writeTransactionAsync(() async {
        for (final chap in chaptersToSave) {
          final manga = mangaMap[chap.mangaId];
          if (manga != null) {
            chap.manga.value = manga;
          }
        }
        // insert chapters
        await chapterRepository.putAllAsync(chaptersToSave);

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

  final archives = files.where((file) => isArchiveFile(file.path)).toList()
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
    final entities = await listLocalDirectory(
      dir,
      logContext: '_firstImageFileInDirectory',
    );
    final imageFiles =
        (await localFiles(
            entities,
            logContext: '_firstImageFileInDirectory',
          )).where((file) => isLocalImageFile(file.path)).toList()
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
  final settings = settingsRepository.current;
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
  final settings = settingsRepository.current;
  final name = _resolveDownloadFolderName(
    settings.downloadLocalFolderName,
    folders,
  );
  return folders.firstWhere((folder) => folder.name == name);
}

void setDownloadLocalFolderName(String? name) {
  settingsRepository.update((s) => s.downloadLocalFolderName = name);
}

String getLocalVirtualPath(LocalFolder folder, String entityPath) {
  final folderName = folder.name?.trim();
  final folderPath = folder.path;
  if (folderName == null ||
      folderName.isEmpty ||
      folderPath == null ||
      folderPath.isEmpty) {
    return normalizePath(entityPath);
  }
  final relative = p.relative(entityPath, from: folderPath);
  if (relative == '.') return folderName;
  return p.posix.join(folderName, normalizePath(relative));
}

String localVirtualPathFromStoredPath(
  String? storedPath,
  List<LocalFolder> folders,
) {
  if (storedPath == null || storedPath.trim().isEmpty) return '';
  final normalized = normalizePath(storedPath);
  final firstSegment = normalized.split('/').firstOrNull;
  if (firstSegment != null &&
      folders.any((folder) => folder.name == firstSegment)) {
    return normalized;
  }

  for (final folder in folders) {
    final folderPath = folder.path;
    if (folderPath == null || folderPath.isEmpty) continue;
    final normalizedFolderPath = normalizePath(folderPath);
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
  final normalized = normalizePath(archivePath);
  final parts = normalized.split('/');
  if (parts.length < 2) return archivePath;

  final folder = folders.firstWhere(
    (folder) => folder.name == parts.first,
    orElse: () => LocalFolder(),
  );
  if (folder.path == null || folder.path!.isEmpty) return archivePath;
  final resolvedFolder = await resolveLocalDirectoryPath(
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

String _debugLocalFolder(LocalFolder folder) {
  final name = folder.name?.trim();
  final path = folder.path?.trim();
  return 'name=${name?.isNotEmpty == true ? name : '<empty>'}, '
      'path=${path?.isNotEmpty == true ? path : '<empty>'}';
}

