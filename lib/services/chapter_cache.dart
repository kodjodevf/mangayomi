import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/utils/extensions/others.dart';

/// Service managing the disk cache for chapter page lists
///
/// Instead of storing dynamic and transient page URLs in the user settings database,
/// this service caches page lists in the application cache directory (`chapter_disk_cache`).
///
/// The cache key strictly combines `${chapter.mangaId}_${chapter.url}` so that any change
/// to the chapter's URL immediately misses the cache and fetches fresh URLs from the source.
class ChapterCache {
  static final ChapterCache _instance = ChapterCache._internal();
  ChapterCache._internal();
  factory ChapterCache() => _instance;

  static const String cacheFolderName = 'chapter_disk_cache';

  @visibleForTesting
  Directory? customCacheDir;

  Future<Directory> _getCacheDirectory() async {
    if (customCacheDir != null) {
      if (!await customCacheDir!.exists()) {
        await customCacheDir!.create(recursive: true);
      }
      return customCacheDir!;
    }
    final dir = await StorageProvider().getCacheDirectory(cacheFolderName);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Builds a deterministic cache key for a chapter matching Mihon's model.
  String getKey(Chapter chapter) {
    return '${chapter.mangaId}_${chapter.url}';
  }

  Future<File> _getCacheFile(Chapter chapter) async {
    final dir = await _getCacheDirectory();
    final hash = keyToMd5(getKey(chapter));
    return File('${dir.path}/$hash.json');
  }

  /// Retrieves the cached page list for [chapter], if present.
  ///
  /// Returns `null` if the cache file is missing or corrupt.
  Future<List<PageUrl>?> getPageListFromCache(Chapter chapter) async {
    try {
      final file = await _getCacheFile(chapter);
      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      if (content.isEmpty) return null;

      final dynamic decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic>) return null;

      final pagesRaw = decoded['pages'] as List?;
      if (pagesRaw == null || pagesRaw.isEmpty) return null;

      final pageUrls = <PageUrl>[];
      for (final item in pagesRaw) {
        if (item is Map<String, dynamic>) {
          final url = item['url'] as String? ?? '';
          final headers = (item['headers'] as Map?)?.cast<String, String>();
          pageUrls.add(PageUrl(url, headers: headers));
        } else if (item is String) {
          pageUrls.add(PageUrl(item));
        }
      }

      return pageUrls.isNotEmpty ? pageUrls : null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ChapterCache.getPageListFromCache error: $e');
      }
      return null;
    }
  }

  /// Writes [pages] for [chapter] to the disk cache.
  Future<void> putPageListToCache(Chapter chapter, List<PageUrl> pages) async {
    try {
      // Do not cache empty or placeholder page lists
      if (pages.isEmpty || pages.every((p) => p.url.isEmpty)) return;

      final file = await _getCacheFile(chapter);
      final data = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'chapterUrl': chapter.url,
        'pages': pages
            .map(
              (p) => {
                'url': p.url,
                if (p.headers != null) 'headers': p.headers,
              },
            )
            .toList(),
      };

      await file.writeAsString(jsonEncode(data), flush: true);
      // Evict oldest entries if total cache size exceeds 100 MB
      await trimCache();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ChapterCache.putPageListToCache error: $e');
      }
    }
  }

  /// Maximum cache size on disk matching Mihon's PARAMETER_CACHE_SIZE (100 MB).
  static const int maxCacheSizeBytes = 100 * 1024 * 1024;

  /// Removes the cached page list for [chapter].
  Future<void> remove(Chapter chapter) async {
    try {
      final file = await _getCacheFile(chapter);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }

  /// Trims the cache directory using an LRU policy (deleting least-recently modified files)
  /// until the total size is below [maxBytes].
  Future<void> trimCache({int maxBytes = maxCacheSizeBytes}) async {
    try {
      final dir = await _getCacheDirectory();
      if (!await dir.exists()) return;

      final files = dir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.json'))
          .toList();

      int currentSize = 0;
      final fileStats = <({File file, int size, DateTime modified})>[];

      for (final file in files) {
        try {
          final stat = file.statSync();
          currentSize += stat.size;
          fileStats.add((file: file, size: stat.size, modified: stat.modified));
        } catch (_) {}
      }

      if (currentSize <= maxBytes) return;

      // Sort ascending by last modified date (oldest first for LRU eviction)
      fileStats.sort((a, b) => a.modified.compareTo(b.modified));

      for (final item in fileStats) {
        if (currentSize <= maxBytes) break;
        try {
          await item.file.delete();
          currentSize -= item.size;
        } catch (_) {}
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('ChapterCache.trimCache error: $e');
      }
    }
  }

  /// Clears all cached chapter page lists from the cache directory.
  Future<int> clear() async {
    int deletedCount = 0;
    try {
      final dir = await _getCacheDirectory();
      if (await dir.exists()) {
        final files = dir.listSync();
        for (final entity in files) {
          if (entity is File && entity.path.endsWith('.json')) {
            try {
              await entity.delete();
              deletedCount++;
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return deletedCount;
  }
}
