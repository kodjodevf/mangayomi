import 'package:flutter/foundation.dart';
import 'package:mangayomi/modules/manga/reader/managers/chapter_preload_manager.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/models/chapter.dart';

mixin ReaderMemoryManagement {
  /// The preload manager that handles memory-bounded chapter caching.
  late final ChapterPreloadManager _preloadManager = ChapterPreloadManager();

  /// Whether the preload manager has been initialized.
  bool _isPreloadManagerInitialized = false;

  /// Gets the preload manager.
  ChapterPreloadManager get preloadManager => _preloadManager;

  /// Gets all currently loaded pages.
  List<UChapDataPreload> get pages => _preloadManager.pages;

  /// Gets the total page count.
  int get pageCount => _preloadManager.pageCount;

  /// Gets the current page index.
  int get currentPageIndex => _preloadManager.currentIndex;

  /// Sets the current page index.
  set currentPageIndex(int value) {
    _preloadManager.currentIndex = value;
  }

  /// Initializes the preload manager with initial chapter data.
  ///
  /// [chapterData] - The initial chapter pages to load.
  /// [startIndex] - The initial page index (default: 0).
  /// [onPagesUpdated] - Callback when pages are added/removed.
  /// [onIndexAdjusted] - Callback when current index needs adjustment.
  void initializePreloadManager(
    GetChapterPagesModel chapterData, {
    int startIndex = 0,
    VoidCallback? onPagesUpdated,
    void Function(int)? onIndexAdjusted,
  }) {
    if (_isPreloadManagerInitialized) {
      if (kDebugMode) {
        debugPrint('[ReaderMemoryManagement] Already initialized, skipping');
      }
      return;
    }

    _preloadManager.onPagesUpdated = onPagesUpdated;
    _preloadManager.onIndexAdjusted = onIndexAdjusted;

    _preloadManager.initialize(chapterData.uChapDataPreload, startIndex);

    _isPreloadManagerInitialized = true;

    if (kDebugMode) {
      debugPrint(
        '[ReaderMemoryManagement] Initialized with ${chapterData.uChapDataPreload.length} pages',
      );
    }
  }

  /// Preloads the next chapter with automatic memory management.
  ///
  /// Unlike the old implementation, this method will automatically
  /// evict old chapters when the limit is reached.
  ///
  /// [chapterData] - The chapter data to preload.
  /// [currentChapter] - The current chapter (for transition page).
  ///
  /// Returns a Future that completes with `true` if the chapter was preloaded,
  /// `false` if it was already loaded or if preloading failed.
  Future<bool> preloadNextChapter(
    GetChapterPagesModel chapterData,
    Chapter currentChapter,
  ) async {
    return await _preloadManager.preloadNextChapter(
      chapterData,
      currentChapter,
    );
  }

  /// Adds a "last chapter" transition page.
  ///
  /// Returns `true` if added successfully, `false` if already added.
  bool addLastChapterTransition(Chapter chapter) {
    return _preloadManager.addLastChapterTransition(chapter);
  }

  /// Disposes the preload manager and clears all cached data.
  Future<void> disposePreloadManager() async {
    if (!_isPreloadManagerInitialized) return;

    await _preloadManager.dispose();
    _isPreloadManagerInitialized = false;

    if (kDebugMode) {
      debugPrint('[ReaderMemoryManagement] Disposed');
    }
  }
}
