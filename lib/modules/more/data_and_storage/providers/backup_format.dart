// Detecting what kind of backup a file is, and previewing what restoring it
// would do, without writing anything to local storage. Kept apart from
// restore.dart (which actually performs the write) so a backup can be
// inspected - format, conflicts, counts - before the user commits to
// anything destructive.
import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:mangayomi/models/category.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupAniyomi.pb.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/proto/BackupMihon.pb.dart';
import 'package:mangayomi/repositories/category_repository.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/repositories/manga_repository.dart';
import 'package:mangayomi/repositories/source_repository.dart';
import 'package:protobuf/protobuf.dart';

enum BackupType { unknown, mangayomi, mihon, aniyomi, kotatsu, neko }

BackupType checkBackupType(String path, Archive archive) {
  if (path.toLowerCase().contains("mangayomi") &&
      (archive.files.firstOrNull?.name ?? "").endsWith(".backup.db")) {
    return BackupType.mangayomi;
  } else if (path.toLowerCase().contains("kotatsu") &&
      archive.files.where((f) {
            switch (f.name) {
              case "categories":
              case "favourites":
                return true;
              default:
                return false;
            }
          }).length ==
          2) {
    return BackupType.kotatsu;
  } else if (path.toLowerCase().endsWith(".tachibk") ||
      path.toLowerCase().endsWith(".proto.gz")) {
    return path.contains("xyz.jmir.tachiyomi.mi") || path.contains("aniyomi.mi")
        ? BackupType.aniyomi
        : path.contains("tachiyomi") ||
              path.contains("mihon") ||
              path.contains("komikku")
        ? BackupType.mihon
        : path.contains("neko")
        ? BackupType.neko
        : BackupType.unknown;
  }
  return BackupType.unknown;
}

BackupType peekBackupType(String path) {
  final inputStream = InputFileStream(path);
  try {
    final archive = ZipDecoder().decodeStream(inputStream);
    return checkBackupType(path, archive);
  } finally {
    inputStream.close();
  }
}

class TachiBkImportPreview {
  TachiBkImportPreview({
    required this.conflictingCategories,
    required this.unmatchedSourceNames,
    required this.newSeriesCount,
    required this.updatedSeriesCount,
    required this.newChapterCount,
  });

  final List<String> conflictingCategories;

  final Map<String, ItemType> unmatchedSourceNames;

  final int newSeriesCount;
  final int updatedSeriesCount;
  final int newChapterCount;
}

TachiBkImportPreview? previewTachiBkImport(String path) {
  final backupType = peekBackupType(path);
  if (backupType != BackupType.mihon &&
      backupType != BackupType.aniyomi &&
      backupType != BackupType.neko) {
    return null;
  }
  final inputStream = InputFileStream(path);
  final content = GZipDecoder().decodeBytes(inputStream.toUint8List());
  inputStream.close();
  final backup = BackupMihon.create();
  backup.mergeFromCodedBufferReader(
    CodedBufferReader(content, sizeLimit: 250 << 20),
  );

  final existingCategoryNames = categoryRepository
      .getAll()
      .map((c) => c.name)
      .whereType<String>()
      .toSet();
  final categoryNames = <String>{for (var c in backup.backupCategories) c.name};

  final installedSourceNames = sourceRepository
      .getAll()
      .where((s) => s.isAdded ?? false)
      .map((s) => (s.itemType, s.name?.toLowerCase()))
      .toSet();
  final unmatchedSources = <String, ItemType>{};

  final existingMangaByLink = {
    for (var m in mangaRepository.getByItemType(ItemType.manga))
      if (m.link != null) m.link!: m,
  };
  int newSeries = 0, updatedSeries = 0, newChapters = 0;
  for (var m in backup.backupManga) {
    final sourceId = protoInt(m.source);
    final srcName =
        backup.backupSources
            .firstWhereOrNull((s) => protoInt(s.sourceId) == sourceId)
            ?.name ??
        "Unknown";
    if (!installedSourceNames.contains((
      ItemType.manga,
      srcName.toLowerCase(),
    ))) {
      unmatchedSources[srcName] = ItemType.manga;
    }
    final existing = existingMangaByLink[m.url];
    if (existing != null) {
      updatedSeries++;
      final existingUrls = chapterRepository
          .getAllByMangaId(existing.id)
          .map((c) => c.url)
          .whereType<String>()
          .toSet();
      newChapters += m.chapters
          .where((c) => !existingUrls.contains(c.url))
          .length;
    } else {
      newSeries++;
      newChapters += m.chapters.length;
    }
  }

  if (backupType == BackupType.aniyomi) {
    final backupAnime = BackupAniyomi.fromBuffer(content);
    final animeCategories = backupAnime.backupAnimeCategories.isNotEmpty
        ? backupAnime.backupAnimeCategories
        : backupAnime.legacyBackupAnimeCategories;
    final animeEntries = backupAnime.backupAnime.isNotEmpty
        ? backupAnime.backupAnime
        : backupAnime.legacyBackupAnime;
    final animeSources = backupAnime.backupAnimeSources.isNotEmpty
        ? backupAnime.backupAnimeSources
        : backupAnime.legacyBackupAnimeSources;
    categoryNames.addAll(animeCategories.map((c) => c.name));
    final existingAnimeByLink = {
      for (var m in mangaRepository.getByItemType(ItemType.anime))
        if (m.link != null) m.link!: m,
    };
    for (var a in animeEntries) {
      final sourceId = protoInt(a.source);
      final srcName =
          animeSources
              .firstWhereOrNull((s) => protoInt(s.sourceId) == sourceId)
              ?.name ??
          "Unknown";
      if (!installedSourceNames.contains((
        ItemType.anime,
        srcName.toLowerCase(),
      ))) {
        unmatchedSources[srcName] = ItemType.anime;
      }
      final existing = existingAnimeByLink[a.url];
      if (existing != null) {
        updatedSeries++;
        final existingUrls = chapterRepository
            .getAllByMangaId(existing.id)
            .map((c) => c.url)
            .whereType<String>()
            .toSet();
        newChapters += a.episodes
            .where((c) => !existingUrls.contains(c.url))
            .length;
      } else {
        newSeries++;
        newChapters += a.episodes.length;
      }
    }
  }

  return TachiBkImportPreview(
    conflictingCategories: categoryNames
        .where(existingCategoryNames.contains)
        .toList(),
    unmatchedSourceNames: unmatchedSources,
    newSeriesCount: newSeries,
    updatedSeriesCount: updatedSeries,
    newChapterCount: newChapters,
  );
}

List<Source> installedSourcesFor(ItemType itemType) => sourceRepository
    .getAll()
    .where((s) => s.itemType == itemType && (s.isAdded ?? false))
    .toList();

/// Same preview shape as previewTachiBkImport, but for the native
/// mangayomi backup format - already-decoded (and, for encrypted backups,
/// already-decrypted) JSON rather than a path to re-read from disk.
TachiBkImportPreview previewMangayomiBackup(Map<String, dynamic> backup) {
  final mangaList = (backup["manga"] as List?)
      ?.map((e) => Manga.fromJson(e)..itemType = convertToItemType(e))
      .toList();
  final chapterList = (backup["chapters"] as List?)
      ?.map((e) => Chapter.fromJson(e))
      .toList();
  final categoryList = (backup["categories"] as List?)
      ?.map(
        (e) =>
            Category.fromJson(e)..forItemType = convertToItemTypeCategory(e),
      )
      .toList();

  final existingCategoryNames = categoryRepository
      .getAll()
      .map((c) => c.name)
      .whereType<String>()
      .toSet();
  final categoryNames = <String>{
    for (final c in categoryList ?? <Category>[])
      if (c.name != null) c.name!,
  };

  final installedSourceNames = sourceRepository
      .getAll()
      .where((s) => s.isAdded ?? false)
      .map((s) => (s.itemType, s.name?.toLowerCase()))
      .toSet();
  final unmatchedSources = <String, ItemType>{};

  final existingMangaByKey = {
    for (final m in mangaRepository.getAll())
      if (m.link != null) '${m.itemType.index}|${m.link}': m,
  };
  final chaptersByMangaId = <int, List<Chapter>>{};
  for (final c in chapterList ?? <Chapter>[]) {
    if (c.mangaId == null) continue;
    chaptersByMangaId.putIfAbsent(c.mangaId!, () => []).add(c);
  }

  int newSeries = 0, updatedSeries = 0, newChapters = 0;
  for (final m in mangaList ?? <Manga>[]) {
    final srcName = m.source ?? "Unknown";
    if (!installedSourceNames.contains((m.itemType, srcName.toLowerCase()))) {
      unmatchedSources[srcName] = m.itemType;
    }
    final key = '${m.itemType.index}|${m.link}';
    final existing = m.link != null ? existingMangaByKey[key] : null;
    final mangaChapters = m.id != null
        ? chaptersByMangaId[m.id!] ?? const <Chapter>[]
        : const <Chapter>[];
    if (existing != null) {
      updatedSeries++;
      final existingUrls = chapterRepository
          .getAllByMangaId(existing.id)
          .map((c) => c.url)
          .whereType<String>()
          .toSet();
      newChapters += mangaChapters
          .where((c) => c.url != null && !existingUrls.contains(c.url))
          .length;
    } else {
      newSeries++;
      newChapters += mangaChapters.length;
    }
  }

  return TachiBkImportPreview(
    conflictingCategories: categoryNames
        .where(existingCategoryNames.contains)
        .toList(),
    unmatchedSourceNames: unmatchedSources,
    newSeriesCount: newSeries,
    updatedSeriesCount: updatedSeries,
    newChapterCount: newChapters,
  );
}

int currentFavoriteMangaCount() => mangaRepository.countFavorites();

ItemType convertToItemType(Map<String, dynamic> backup) {
  final isManga = backup['isManga'];
  return isManga == null
      ? ItemType.values[backup['itemType'] ?? 0]
      : isManga
      ? ItemType.manga
      : ItemType.anime;
}

ItemType convertToItemTypeCategory(Map<String, dynamic> backup) {
  final forManga = backup['forManga'];
  return forManga == null
      ? ItemType.values[backup['forItemType'] ?? 0]
      : forManga
      ? ItemType.manga
      : ItemType.anime;
}

int protoInt(Object value) {
  if (value is int) {
    return value;
  }
  return (value as dynamic).toInt() as int;
}

int secondsToMillis(Object seconds) => protoInt(seconds) * 1000;

Status convertStatusFromTachiBk(int idx) {
  switch (idx) {
    case 1:
      return Status.ongoing;
    case 2:
      return Status.completed;
    case 4:
      return Status.publishingFinished;
    case 5:
      return Status.canceled;
    case 6:
      return Status.onHiatus;
    default:
      return Status.unknown;
  }
}
