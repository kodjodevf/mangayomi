import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';

/// Manages the preloading and memory of chapters in the manga reader.
///
/// Supports bidirectional preloading (previous + next chapters) following
/// adjacent chapters are loaded proactively and their
/// pages are seamlessly merged into the reader's page list.
class ChapterPreloadManager {
  /// The list of preloaded chapter data
  final List<UChapDataPreload> _pages = [];

  /// Set of chapter IDs currently in memory
  final Set<String> _loadedChapterIds = {};

  /// Queue of chapter IDs in order of loading (for LRU eviction)
  final Queue<String> _chapterLoadOrder = Queue();

  /// Current reading index
  int _currentIndex = 0;

  /// Separate flags to allow concurrent prev/next preloading
  bool _isPreloadingNext = false;
  bool _isPreloadingPrev = false;

  /// Callbacks
  void Function()? onPagesUpdated;

  /// Gets the list of pages (read-only)
  List<UChapDataPreload> get pages => List.unmodifiable(_pages);

  /// Gets the current number of pages
  int get pageCount => _pages.length;

  /// Gets the current index
  int get currentIndex => _currentIndex;

  /// Gets the loaded chapter count
  int get loadedChapterCount => _loadedChapterIds.length;

  /// Whether a previous chapter preload is in progress.
  bool get isPreloadingPrev => _isPreloadingPrev;

  /// Whether a next chapter preload is in progress.
  bool get isPreloadingNext => _isPreloadingNext;

  /// Sets the current reading index
  set currentIndex(int value) {
    if (value >= 0 && value < _pages.length) {
      _currentIndex = value;
    }
  }

  /// Returns `true` if pages from [chapter] are already in memory.
  bool isChapterLoaded(Chapter? chapter) {
    final id = _getChapterIdentifier(chapter);
    return id != null && _loadedChapterIds.contains(id);
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

  // ── Next-chapter preloading (append) ──

  /// Preloads the next chapter's pages by appending them.
  ///
  /// Returns true if preloading was successful, false otherwise.
  Future<bool> preloadNextChapter(
    GetChapterPagesModel chapterData,
    Chapter currentChapter,
  ) async {
    if (_isPreloadingNext) {
      if (kDebugMode) {
        debugPrint('[ChapterPreload] Already preloading next, skipping');
      }
      return false;
    }

    _isPreloadingNext = true;

    try {
      if (chapterData.uChapDataPreload.isEmpty) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] No pages in next chapter data');
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
          debugPrint(
            '[ChapterPreload] Next chapter already loaded: $chapterId',
          );
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

      // Notify listeners
      onPagesUpdated?.call();

      if (kDebugMode) {
        debugPrint(
          '[ChapterPreload] Appended ${newPages.length} pages from next chapter',
        );
        debugPrint(
          '[ChapterPreload] Total pages: ${_pages.length}, Chapters: ${_loadedChapterIds.length}',
        );
      }

      return true;
    } finally {
      _isPreloadingNext = false;
    }
  }

  // ── Previous-chapter preloading (prepend) ──

  /// Preloads the previous chapter's pages by prepending them.
  ///
  /// Returns the number of pages prepended (including transition page),
  /// or 0 if preloading was skipped / failed.
  /// The caller **must** adjust the scroll / page index by the returned count.
  Future<int> preloadPrevChapter(
    GetChapterPagesModel chapterData,
    Chapter currentChapter,
  ) async {
    if (_isPreloadingPrev) {
      if (kDebugMode) {
        debugPrint('[ChapterPreload] Already preloading prev, skipping');
      }
      return 0;
    }

    _isPreloadingPrev = true;

    try {
      if (chapterData.uChapDataPreload.isEmpty) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] No pages in prev chapter data');
        }
        return 0;
      }

      final firstPage = chapterData.uChapDataPreload.first;
      if (firstPage.chapter == null) {
        if (kDebugMode) {
          debugPrint('[ChapterPreload] No chapter in prev first page');
        }
        return 0;
      }

      final chapterId = _getChapterIdentifier(firstPage.chapter);
      if (chapterId != null && _loadedChapterIds.contains(chapterId)) {
        if (kDebugMode) {
          debugPrint(
            '[ChapterPreload] Prev chapter already loaded: $chapterId',
          );
        }
        return 0;
      }

      // Transition page: marks end of prev chapter → start of current chapter
      final transitionPage = UChapDataPreload.transition(
        currentChapter: firstPage.chapter!,
        nextChapter: currentChapter,
        mangaName: currentChapter.manga.value?.name ?? '',
        pageIndex: 0, // recalculated below
      );

      // Build prepend list: prev chapter pages + transition page
      final prevPages = chapterData.uChapDataPreload.toList();
      final prependList = [...prevPages, transitionPage];
      final prependCount = prependList.length;

      // Assign pageIndex to prepended pages (0 .. prependCount-1)
      for (int i = 0; i < prependList.length; i++) {
        prependList[i].pageIndex = i;
      }

      // Shift pageIndex of all existing pages
      for (int i = 0; i < _pages.length; i++) {
        if (_pages[i].pageIndex != null) {
          _pages[i].pageIndex = _pages[i].pageIndex! + prependCount;
        }
      }

      // Prepend to pages list
      _pages.insertAll(0, prependList);

      // Track the new chapter
      if (chapterId != null) {
        _loadedChapterIds.add(chapterId);
        _chapterLoadOrder.addFirst(chapterId);
      }

      // Notify listeners
      onPagesUpdated?.call();

      if (kDebugMode) {
        debugPrint(
          '[ChapterPreload] Prepended ${prevPages.length} pages from prev chapter',
        );
        debugPrint(
          '[ChapterPreload] Total pages: ${_pages.length}, Chapters: ${_loadedChapterIds.length}',
        );
      }

      return prependCount;
    } finally {
      _isPreloadingPrev = false;
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

  /// Updates the cropImage for a page at the given index.
  void updatePageCropImage(int index, Uint8List? cropImage) {
    if (index >= 0 && index < _pages.length) {
      _pages[index].cropImage = cropImage;
      onPagesUpdated?.call();
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

    if (kDebugMode) {
      debugPrint('[ChapterPreload] Disposed');
    }
  }
}
