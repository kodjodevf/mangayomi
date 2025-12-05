import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

/// Manages the preloading and memory of chapters in the manga reader.
class ChapterPreloadManager {
  /// Maximum number of chapters to keep in memory
  static const int maxChaptersInMemory = 3;

  /// Maximum number of pages to keep in the preload list
  static const int maxPagesInMemory = 200;

  /// Buffer size around current index to keep
  static const int pageBufferBefore = 30;
  static const int pageBufferAfter = 70;

  /// The list of preloaded chapter data
  final List<UChapDataPreload> _pages = [];

  /// Set of chapter IDs currently in memory
  final Set<String> _loadedChapterIds = {};

  /// Queue of chapter IDs in order of loading (for LRU eviction)
  final Queue<String> _chapterLoadOrder = Queue();

  /// Current reading index
  int _currentIndex = 0;

  /// Flag to prevent concurrent preloading
  bool _isPreloading = false;

  /// Callbacks
  void Function()? onPagesUpdated;
  void Function(int)? onIndexAdjusted;

  /// Gets the list of pages (read-only)
  List<UChapDataPreload> get pages => List.unmodifiable(_pages);

  /// Gets the current number of pages
  int get pageCount => _pages.length;

  /// Gets the current index
  int get currentIndex => _currentIndex;

  /// Gets the loaded chapter count
  int get loadedChapterCount => _loadedChapterIds.length;

  /// Sets the current reading index
  set currentIndex(int value) {
    if (value >= 0 && value < _pages.length) {
      _currentIndex = value;
    }
  }

  /// Initializes the manager with the first chapter's pages.
  void initialize(List<UChapDataPreload> initialPages, int startIndex) {
    _pages.clear();
    _loadedChapterIds.clear();
    _chapterLoadOrder.clear();

    _pages.addAll(initialPages);
    _currentIndex = startIndex;

    // Track the initial chapter
    if (initialPages.isNotEmpty) {
      final chapterId = _getChapterIdentifier(initialPages.first.chapter);
      if (chapterId != null) {
        _loadedChapterIds.add(chapterId);
        _chapterLoadOrder.add(chapterId);
      }
    }

    if (kDebugMode) {
      debugPrint(
        '[ChapterPreload] Initialized with ${initialPages.length} pages',
      );
    }
  }

  /// Adds a transition page between chapters.
  UChapDataPreload createTransitionPage({
    required Chapter currentChapter,
    required Chapter? nextChapter,
    required String mangaName,
    bool isLastChapter = false,
  }) {
    return UChapDataPreload.transition(
      currentChapter: currentChapter,
      nextChapter: nextChapter,
      mangaName: mangaName,
      pageIndex: _pages.length,
      isLastChapter: isLastChapter,
    );
  }

  /// Preloads the next chapter's pages.
  ///
  /// Returns true if preloading was successful, false otherwise.
  Future<bool> preloadNextChapter(
    GetChapterPagesModel chapterData,
    Chapter currentChapter,
  ) async {
    if (_isPreloading) {
      if (kDebugMode) {
        debugPrint('[ChapterPreload] Already preloading, skipping');
      }
      return false;
    }

    _isPreloading = true;

    try {
      if (chapterData.uChapDataPreload.isEmpty) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] No pages in chapter data');
        }
        return false;
      }

      final firstPage = chapterData.uChapDataPreload.first;
      if (firstPage.chapter == null) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] No chapter in first page');
        }
        return false;
      }

      final chapterId = _getChapterIdentifier(firstPage.chapter);
      if (chapterId != null && _loadedChapterIds.contains(chapterId)) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] Chapter already loaded: $chapterId');
        }
        return false;
      }

      // Create transition page
      final transitionPage = createTransitionPage(
        currentChapter: currentChapter,
        nextChapter: firstPage.chapter,
        mangaName: currentChapter.manga.value?.name ?? '',
      );

      // Update page indices for new pages
      final startIndex = _pages.length + 1;
      final newPages = chapterData.uChapDataPreload.asMap().entries.map((
        entry,
      ) {
        return entry.value..pageIndex = startIndex + entry.key;
      }).toList();

      // Add to pages list
      _pages.add(transitionPage);
      _pages.addAll(newPages);

      // Track the new chapter
      if (chapterId != null) {
        _loadedChapterIds.add(chapterId);
        _chapterLoadOrder.add(chapterId);
      }

      // Evict old chapters if necessary
      await _evictOldChaptersIfNeeded();

      // Notify listeners
      onPagesUpdated?.call();

      if (kDebugMode) {
        debugPrint(
          '[ChapterPreload] Added ${newPages.length} pages from next chapter',
        );
        debugPrint(
          '[ChapterPreload] Total pages: ${_pages.length}, Chapters: ${_loadedChapterIds.length}',
        );
      }

      return true;
    } finally {
      _isPreloading = false;
    }
  }

  /// Adds a "last chapter" transition page.
  bool addLastChapterTransition(Chapter chapter) {
    // Check if already added
    if (_pages.isNotEmpty && (_pages.last.isLastChapter ?? false)) {
      return false;
    }

    final transitionPage = createTransitionPage(
      currentChapter: chapter,
      nextChapter: null,
      mangaName: chapter.manga.value?.name ?? '',
      isLastChapter: true,
    );

    _pages.add(transitionPage);
    onPagesUpdated?.call();

    if (kDebugMode) {
      debugPrint('[ChapterPreload] Added last chapter transition');
    }

    return true;
  }

  /// Evicts old chapters to stay within memory limits.
  Future<void> _evictOldChaptersIfNeeded() async {
    // Evict by chapter count
    while (_loadedChapterIds.length > maxChaptersInMemory &&
        _chapterLoadOrder.isNotEmpty) {
      final oldestChapterId = _chapterLoadOrder.first;

      // Don't evict if current page is in this chapter
      final currentPage = _currentIndex < _pages.length
          ? _pages[_currentIndex]
          : null;
      final currentChapterId = currentPage != null
          ? _getChapterIdentifier(currentPage.chapter)
          : null;

      if (oldestChapterId == currentChapterId) {
        // Can't evict current chapter, try next
        if (_chapterLoadOrder.length > 1) {
          _chapterLoadOrder.removeFirst();
          _chapterLoadOrder.add(oldestChapterId);
          continue;
        }
        break;
      }

      await _evictChapter(oldestChapterId);
    }

    // Evict by page count if still too many
    if (_pages.length > maxPagesInMemory) {
      await _trimPagesToBuffer();
    }
  }

  /// Evicts a specific chapter from memory.
  Future<void> _evictChapter(String chapterId) async {
    final pagesToRemove = <int>[];
    final keysToRemoveFromCache = <String>[];

    for (var i = 0; i < _pages.length; i++) {
      final page = _pages[i];
      if (_getChapterIdentifier(page.chapter) == chapterId) {
        pagesToRemove.add(i);

        // Clear the cropImage to free memory
        page.cropImage = null;

        // Build cache key for image cache removal
        if (page.pageUrl?.url != null) {
          keysToRemoveFromCache.add(page.pageUrl!.url);
        }
      }
    }

    // Remove pages from the end to avoid index shifting issues
    for (var i = pagesToRemove.length - 1; i >= 0; i--) {
      final index = pagesToRemove[i];
      _pages.removeAt(index);

      // Adjust current index if needed
      if (_currentIndex > index) {
        _currentIndex--;
      }
    }

    // Remove from tracking
    _loadedChapterIds.remove(chapterId);
    _chapterLoadOrder.remove(chapterId);

    // Notify about index adjustment
    onIndexAdjusted?.call(_currentIndex);

    if (kDebugMode) {
      debugPrint(
        '[ChapterPreload] Evicted chapter: $chapterId, '
        'Removed ${pagesToRemove.length} pages',
      );
    }
  }

  /// Trims pages to keep only those within the buffer range.
  Future<void> _trimPagesToBuffer() async {
    if (_pages.length <= maxPagesInMemory) return;

    final startKeep = (_currentIndex - pageBufferBefore).clamp(
      0,
      _pages.length,
    );
    final endKeep = (_currentIndex + pageBufferAfter).clamp(0, _pages.length);

    final pagesToRemoveFromStart = startKeep;
    final pagesToRemoveFromEnd = _pages.length - endKeep;

    // Remove from end first
    if (pagesToRemoveFromEnd > 0) {
      final keysToRemove = <String>[];
      for (var i = _pages.length - 1; i >= endKeep; i--) {
        final page = _pages[i];
        page.cropImage = null;
        if (page.pageUrl?.url != null) {
          keysToRemove.add(page.pageUrl!.url);
        }
      }
      _pages.removeRange(endKeep, _pages.length);
    }

    // Remove from start
    if (pagesToRemoveFromStart > 0) {
      final keysToRemove = <String>[];
      for (var i = 0; i < pagesToRemoveFromStart; i++) {
        final page = _pages[i];
        page.cropImage = null;
        if (page.pageUrl?.url != null) {
          keysToRemove.add(page.pageUrl!.url);
        }
      }
      _pages.removeRange(0, pagesToRemoveFromStart);
      _currentIndex -= pagesToRemoveFromStart;

      onIndexAdjusted?.call(_currentIndex);
    }

    if (kDebugMode) {
      debugPrint(
        '[ChapterPreload] Trimmed pages, '
        'New count: ${_pages.length}, Index: $_currentIndex',
      );
    }
  }

  /// Gets a unique identifier for a chapter.
  String? _getChapterIdentifier(Chapter? chapter) {
    if (chapter == null) return null;

    final url = chapter.url?.trim() ?? '';
    final archivePath = chapter.archivePath?.trim() ?? '';

    if (url.isNotEmpty) return 'url:$url';
    if (archivePath.isNotEmpty) return 'archive:$archivePath';

    return 'id:${chapter.id}';
  }

  /// Disposes of all resources.
  Future<void> dispose() async {
    // Clear pages
    _pages.clear();
    _loadedChapterIds.clear();
    _chapterLoadOrder.clear();

    // Clear callbacks
    onPagesUpdated = null;
    onIndexAdjusted = null;

    if (kDebugMode) {
      debugPrint('[ChapterPreload] Disposed');
    }
  }
}
