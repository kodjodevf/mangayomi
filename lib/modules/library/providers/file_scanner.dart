import 'dart:convert';
import 'dart:io'; // For I/O-operations
import 'dart:typed_data';
import 'package:isar_community/isar.dart'; // Isar database package for local storage
import 'package:mangayomi/main.dart'; // Exposes the global `isar` instance
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/library/providers/local_archive.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/extensions/others.dart';
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
  List<String> build() {
    return isar.settings.getSync(227)!.localFolders ?? [];
  }

  void set(List<String> value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..localFolders = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
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
  final localDir = await getLocalLibrary();
  await _scanDirectory(ref, localDir);
  final customDirs = ref.read(localFoldersStateProvider);
  for (final dir in customDirs) {
    await _scanDirectory(ref, Directory(dir));
  }
}

Future<void> _scanDirectory(Ref ref, Directory? dir) async {
  // Don't do anything if /local doesn't exist
  if (dir == null || !await dir.exists()) return;

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
  final mangaMap = {for (var m in existingMangas) _getRelativePath(m.link!): m};

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
    String path = _getRelativePath(chap.archivePath!);
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
      final relPath = _getRelativePath(chapter.path).trim();
      // Skip if the relative path is empty (invalid entry).
      if (relPath.isEmpty) continue;

      if (!existingPaths.contains(relPath)) {
        newChapters.add([chapter.path, imageFolder]);
        existingPaths.add(relPath);
      }
    }
  }

  // Iterate over each sub-directory (each representing a title, Manga or Anime)
  await for (final folder in dir.list()) {
    if (folder is! Directory) continue;
    final title = p.basename(folder.path); // Anime/Manga title
    String relativePath = _getRelativePath(folder.path);

    // List all folders and files inside a Manga/Anime title
    final children = await folder.list().toList();
    final subDirs = children.whereType<Directory>().toList();
    final files = children.whereType<File>().toList();

    // Determine itemtype
    final hasImagesFolders = subDirs
        .where((e) => !e.path.endsWith("_subtitles"))
        .isNotEmpty;
    final hasArchives = files.any((f) => _isArchive(f.path));
    final hasVideos = files.any((f) => _isVideo(f.path));
    final hasEpubs = files.any((f) => _isEpub(f.path));
    late ItemType itemType;
    if (hasImagesFolders || hasArchives) {
      itemType = ItemType.manga;
    } else if (hasVideos) {
      itemType = ItemType.anime;
    } else if (hasEpubs) {
      itemType = ItemType.novel;
    } else {
      continue; // nothing to import from this folder
    }
    // Does Manga/Anime already exist in library?
    bool existingManga = mangaMap.containsKey(relativePath);

    // Create new Manga entry if it doesn't already exist
    Manga manga;
    if (existingManga) {
      manga = mangaMap[relativePath]!;
    } else {
      manga = Manga(
        favorite: false,
        source: 'local',
        author: '',
        artist: '',
        genre: [],
        imageUrl: '',
        lang: '',
        link: folder.path,
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

    // Detect a single image in item's root and use it as custom cover
    final imageFiles = files.where((f) => _isImage(f.path)).toList();
    if (imageFiles.length == 1) {
      try {
        final bytes = await File(imageFiles.first.path).readAsBytes();
        final byteList = bytes.toList();
        if (manga.customCoverImage != byteList) {
          manga.customCoverImage = Uint8List.fromList(byteList).getCoverImage;
          manga.lastUpdate = dateNow;
        }
      } catch (e) {
        BotToast.showText(text: "Error reading cover image: $e");
      }
    } else if (imageFiles.isEmpty && manga.customCoverImage != null) {
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
        BotToast.showText(text: "Error reading metadata: $e");
      }
    }

    processedMangas.add(manga);

    // Scan chapters/episodes
    if (hasImagesFolders) {
      // Each subdirectory is a chapter
      addNewChapters(subDirs, hasImagesFolders);
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
                _getRelativePath(newManga.link) == _getRelativePath(m.link),
          ),
        )
        .toList();
    processedMangas.clear();
    processedMangas = newAddedMangas;
  }

  final chaptersToSave = <Chapter>[];
  int saveManga = 0; // Just to update the lastUpdate value of not new Mangas
  final mangaByName = {for (var m in processedMangas) p.basename(m.link!): m};

  // iterate through newChapters elements, which are: ["full_path/to/chapter1", "true"]
  for (var pathBool in newChapters) {
    final chapterPath = pathBool[0];
    // pathBool[0] = first element of list (path)
    // dirname = remove last part of path (chapter name), = "full_path/to"
    // basename = remove everything except last (manga name) = "to"
    final itemName = p.basename(p.dirname(chapterPath));
    final manga = mangaByName[itemName];
    if (manga != null) {
      if (manga.itemType == ItemType.novel) {
        final book = await parseEpubFromPath(
          epubPath: chapterPath,
          fullData: false,
        );

        if (book.cover != null) {
          manga.customCoverImage = book.cover!.getCoverImage;
          saveManga++;
        }
        chaptersToSave.add(
          Chapter(
            mangaId: manga.id,
            name: book.name,
            archivePath: chapterPath,
            downloadSize: null,
          )..manga.value = manga,
        );
      } else {
        final chapterFile = File(chapterPath);
        final chap = Chapter(
          mangaId: manga.id,
          name:
              pathBool[1] // If Chapter is an image folder or archive/video
              ? p.basename(chapterPath)
              : p.basenameWithoutExtension(chapterPath),
          dateUpload: dateNow.toString(),
          archivePath: chapterPath,
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
    BotToast.showText(text: "Error saving chapter/episode to library: $e");
  }
  try {
    if (chaptersToSave.isNotEmpty) {
      await isar.writeTxn(() async {
        // insert chapters
        await isar.chapters.putAll(chaptersToSave);

        // for each one, set its link and save it
        for (final chap in chaptersToSave) {
          chap.manga.value = processedMangas.firstWhere(
            (m) => m.id == chap.mangaId,
          );
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

/// Returns the `/local` directory inside the app's default storage.
Future<Directory?> getLocalLibrary() async {
  try {
    final dir = await StorageProvider().getDefaultDirectory();
    return dir == null ? null : Directory(p.join(dir.path, 'local'));
  } catch (e) {
    BotToast.showText(text: "Error getting local library: $e");
    return null;
  }
}

/// Finds the String 'Mangayomi/local' and extract path after
/// ```
/// "C:\Users\user\Documents\Mangayomi\local\Manga 1\chapter1.zip"
/// becomes:
/// "Manga 1/chapter1.zip"
/// ```
String _getRelativePath(dynamic dir) {
  String relativePath;

  if (dir is Directory) {
    relativePath = dir.path;
  } else if (dir is String) {
    relativePath = dir;
  } else {
    throw ArgumentError("Input must be a Directory or a String");
  }

  // Normalize path separators
  relativePath = relativePath.replaceAll("\\", "/");
  int index = relativePath.indexOf("Mangayomi/local");
  if (index != -1) {
    return relativePath.substring(index + "Mangayomi/local/".length);
  } else {
    return relativePath;
  }
}

/// Returns if file is a json
bool _isJson(String path) {
  final ext = p.extension(path).toLowerCase();
  return ext == '.json';
}

/// Returns if file is an image
bool _isImage(String path) {
  final ext = p.extension(path).toLowerCase();
  return ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.webp';
}

/// Returns if file is an archive
bool _isArchive(String path) {
  final ext = p.extension(path).toLowerCase();
  return ext == '.cbz' || ext == '.zip' || ext == '.cbt' || ext == '.tar';
}

/// Returns if file is a video
bool _isVideo(String path) {
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
  final ext = p.extension(path).toLowerCase();
  return ext == '.epub';
}
