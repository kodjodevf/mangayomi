import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';

/// Page loading states for virtual scrolling
enum PageLoadState { notLoaded, loaded, error, cached }

/// Virtual page information for tracking state
class VirtualPageInfo {
  final int index;
  final UChapDataPreload originalData;
  PageLoadState loadState;
  DateTime? lastAccessTime;
  Object? error;

  VirtualPageInfo({
    required this.index,
    required this.originalData,
    this.loadState = PageLoadState.notLoaded,
    this.lastAccessTime,
    this.error,
  });

  bool get isVisible =>
      loadState == PageLoadState.loaded || loadState == PageLoadState.cached;
  bool get needsLoading => loadState == PageLoadState.notLoaded;
  bool get hasError => loadState == PageLoadState.error;

  void markAccessed() {
    lastAccessTime = DateTime.now();
  }

  Duration get timeSinceAccess {
    if (lastAccessTime == null) return Duration.zero;
    return DateTime.now().difference(lastAccessTime!);
  }
}

/// Configuration for virtual page manager
class VirtualPageConfig {
  final int preloadDistance;
  final int maxCachedPages;
  final Duration cacheTimeout;
  final bool enableMemoryOptimization;

  const VirtualPageConfig({
    this.preloadDistance = 3,
    this.maxCachedPages = 10,
    this.cacheTimeout = const Duration(minutes: 5),
    this.enableMemoryOptimization = true,
  });
}

/// Manages virtual page loading and memory optimization
class VirtualPageManager extends ChangeNotifier {
  final List<UChapDataPreload> _originalPages;
  final VirtualPageConfig config;
  final Map<int, VirtualPageInfo> _pageInfoMap = {};
  final Set<int> _preloadQueue = {};

  int _currentVisibleIndex = 0;
  Timer? _cleanupTimer;

  VirtualPageManager({
    required List<UChapDataPreload> pages,
    this.config = const VirtualPageConfig(),
  }) : _originalPages = List.from(pages) {
    _initializePages();
    _startCleanupTimer();
  }

  void _initializePages() {
    for (int i = 0; i < _originalPages.length; i++) {
      _pageInfoMap[i] = VirtualPageInfo(
        index: i,
        originalData: _originalPages[i],
      );
    }
  }

  void _startCleanupTimer() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performMemoryCleanup(),
    );
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }

  /// Get page count
  int get pageCount => _originalPages.length;

  /// Get page info for a specific index
  VirtualPageInfo? getPageInfo(int index) {
    if (index < 0 || index >= _originalPages.length) return null;
    return _pageInfoMap[index];
  }

  /// Get original page data
  UChapDataPreload? getOriginalPage(int index) {
    if (index < 0 || index >= _originalPages.length) return null;
    return _originalPages[index];
  }

  /// Update visible page index and trigger preloading
  void updateVisibleIndex(int index) {
    if (index == _currentVisibleIndex) return;

    _currentVisibleIndex = index.clamp(0, _originalPages.length - 1);
    _pageInfoMap[_currentVisibleIndex]?.markAccessed();

    _schedulePreloading();
    notifyListeners();
  }

  /// Check if a page should be visible/loaded
  bool shouldPageBeLoaded(int index) {
    final distance = (index - _currentVisibleIndex).abs();
    return distance <= config.preloadDistance;
  }

  /// Schedule preloading for nearby pages
  void _schedulePreloading() {
    _preloadQueue.clear();

    // Add pages within preload distance
    for (int i = 0; i < _originalPages.length; i++) {
      if (shouldPageBeLoaded(i)) {
        final pageInfo = _pageInfoMap[i]!;
        if (pageInfo.needsLoading) {
          _preloadQueue.add(i);
        }
      }
    }
  }

  /// Perform memory cleanup
  void _performMemoryCleanup() {
    if (!config.enableMemoryOptimization) return;

    final pageEntries = _pageInfoMap.entries.toList();

    // Sort by last access time and distance from current page
    pageEntries.sort((a, b) {
      final aDistance = (a.key - _currentVisibleIndex).abs();
      final bDistance = (b.key - _currentVisibleIndex).abs();
      final aTime =
          a.value.lastAccessTime ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime =
          b.value.lastAccessTime ?? DateTime.fromMillisecondsSinceEpoch(0);

      // First sort by distance, then by access time
      final distanceComparison = aDistance.compareTo(bDistance);
      return distanceComparison != 0
          ? distanceComparison
          : aTime.compareTo(bTime);
    });

    int cachedCount = pageEntries.where((e) => e.value.isVisible).length;

    // Remove old cached pages if we exceed the limit
    for (final entry in pageEntries) {
      if (cachedCount <= config.maxCachedPages) break;

      final pageInfo = entry.value;
      final distance = (entry.key - _currentVisibleIndex).abs();

      // Don't unload pages within preload distance
      if (distance <= config.preloadDistance) continue;

      // Don't unload recently accessed pages
      if (pageInfo.timeSinceAccess < config.cacheTimeout) continue;

      if (pageInfo.isVisible) {
        pageInfo.loadState = PageLoadState.notLoaded;
        pageInfo.error = null;
        cachedCount--;
      }
    }

    if (cachedCount != pageEntries.where((e) => e.value.isVisible).length) {
      notifyListeners();
    }
  }

  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    final loadedCount = _pageInfoMap.values
        .where((p) => p.loadState == PageLoadState.loaded)
        .length;
    final cachedCount = _pageInfoMap.values
        .where((p) => p.loadState == PageLoadState.cached)
        .length;
    final errorCount = _pageInfoMap.values.where((p) => p.hasError).length;

    return {
      'totalPages': _originalPages.length,
      'loadedPages': loadedCount,
      'cachedPages': cachedCount,
      'errorPages': errorCount,
      'currentIndex': _currentVisibleIndex,
      'preloadQueueSize': _preloadQueue.length,
    };
  }
}
