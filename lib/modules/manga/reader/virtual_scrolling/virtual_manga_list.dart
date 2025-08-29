import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/virtual_scrolling/virtual_page_manager.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/double_columm_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Widget for displaying manga pages in a virtual scrolling list
class VirtualMangaList extends ConsumerStatefulWidget {
  final VirtualPageManager pageManager;
  final ItemScrollController itemScrollController;
  final ScrollOffsetController scrollOffsetController;
  final ItemPositionsListener itemPositionsListener;
  final Axis scrollDirection;
  final double minCacheExtent;
  final int initialScrollIndex;
  final ScrollPhysics physics;
  final Function(UChapDataPreload data) onLongPressData;
  final Function(bool) onFailedToLoadImage;
  final BackgroundColor backgroundColor;
  final bool isDoublePageMode;
  final bool isHorizontalContinuous;
  final ReaderMode readerMode;
  final Function(Offset) onDoubleTapDown;
  final VoidCallback onDoubleTap;
  final Function(Chapter chapter)? onChapterChanged;
  final Function(int lastPageIndex)? onReachedLastPage;
  final Function(int index)? onPageChanged;

  const VirtualMangaList({
    super.key,
    required this.pageManager,
    required this.itemScrollController,
    required this.scrollOffsetController,
    required this.itemPositionsListener,
    required this.scrollDirection,
    required this.minCacheExtent,
    required this.initialScrollIndex,
    required this.physics,
    required this.onLongPressData,
    required this.onFailedToLoadImage,
    required this.backgroundColor,
    required this.isDoublePageMode,
    required this.isHorizontalContinuous,
    required this.readerMode,
    required this.onDoubleTapDown,
    required this.onDoubleTap,
    this.onChapterChanged,
    this.onReachedLastPage,
    this.onPageChanged,
  });

  @override
  ConsumerState<VirtualMangaList> createState() => _VirtualMangaListState();
}

class _VirtualMangaListState extends ConsumerState<VirtualMangaList> {
  Chapter? _currentChapter;
  int? _currentIndex;

  @override
  void initState() {
    super.initState();

    // Listen to item positions to update virtual page manager
    widget.itemPositionsListener.itemPositions.addListener(_onPositionChanged);

    // Initialize current chapter
    if (widget.pageManager.pageCount > 0) {
      final firstPage = widget.pageManager.getOriginalPage(
        widget.initialScrollIndex,
      );
      _currentChapter = firstPage?.chapter;
    }
  }

  @override
  void dispose() {
    widget.itemPositionsListener.itemPositions.removeListener(
      _onPositionChanged,
    );
    super.dispose();
  }

  void _onPositionChanged() {
    final positions = widget.itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      // Get the first visible item
      final firstVisibleIndex = positions.first.index;
      final lastVisibleIndex = positions.last.index;

      // Update virtual page manager
      widget.pageManager.updateVisibleIndex(firstVisibleIndex);

      // Calculate actual page lengths considering page mode
      int pagesLength =
          widget.isDoublePageMode && !widget.isHorizontalContinuous
          ? (widget.pageManager.pageCount / 2).ceil() + 1
          : widget.pageManager.pageCount;

      // Check if index is valid
      if (firstVisibleIndex >= 0 && firstVisibleIndex < pagesLength) {
        final currentPage = widget.pageManager.getOriginalPage(
          firstVisibleIndex,
        );

        if (currentPage != null) {
          // Check for chapter change
          if (_currentChapter?.id != currentPage.chapter?.id &&
              currentPage.chapter != null) {
            _currentChapter = currentPage.chapter;
            widget.onChapterChanged?.call(currentPage.chapter!);
          }

          // Update current index
          if (_currentIndex != firstVisibleIndex) {
            _currentIndex = firstVisibleIndex;
            widget.onPageChanged?.call(firstVisibleIndex);
          }
        }

        // Check if reached last page to trigger next chapter preload
        if (lastVisibleIndex >= pagesLength - 1) {
          widget.onReachedLastPage?.call(lastVisibleIndex);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.pageManager,
      builder: (context, child) {
        final itemCount =
            widget.isDoublePageMode && !widget.isHorizontalContinuous
            ? (widget.pageManager.pageCount / 2).ceil() + 1
            : widget.pageManager.pageCount;

        return ScrollablePositionedList.separated(
          scrollDirection: widget.scrollDirection,
          minCacheExtent: widget.minCacheExtent,
          initialScrollIndex: widget.initialScrollIndex,
          itemCount: itemCount,
          physics: widget.physics,
          itemScrollController: widget.itemScrollController,
          scrollOffsetController: widget.scrollOffsetController,
          itemPositionsListener: widget.itemPositionsListener,
          itemBuilder: (context, index) => _buildItem(context, index),
          separatorBuilder: _buildSeparator,
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (widget.isDoublePageMode && !widget.isHorizontalContinuous) {
      return _buildDoublePageItem(context, index);
    } else {
      return _buildSinglePageItem(context, index);
    }
  }

  Widget _buildSinglePageItem(BuildContext context, int index) {
    final originalPage = widget.pageManager.getOriginalPage(index);
    if (originalPage == null) {
      return const SizedBox.shrink();
    }

    // Check if page should be loaded
    final pageInfo = widget.pageManager.getPageInfo(index);
    final shouldLoad = widget.pageManager.shouldPageBeLoaded(index);

    if (!shouldLoad &&
        (pageInfo?.loadState == PageLoadState.notLoaded || pageInfo == null)) {
      // Return placeholder for unloaded pages
      return _buildPlaceholder(context);
    }

    if (originalPage.isTransitionPage) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTapDown: (details) =>
            widget.onDoubleTapDown(details.globalPosition),
        onDoubleTap: widget.onDoubleTap,
        child: TransitionViewVertical(data: originalPage),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTapDown: (details) =>
          widget.onDoubleTapDown(details.globalPosition),
      onDoubleTap: widget.onDoubleTap,
      child: ImageViewVertical(
        data: originalPage,
        failedToLoadImage: widget.onFailedToLoadImage,
        onLongPressData: widget.onLongPressData,
        isHorizontal: widget.isHorizontalContinuous,
      ),
    );
  }

  Widget _buildDoublePageItem(BuildContext context, int index) {
    if (index >= widget.pageManager.pageCount) {
      return const SizedBox.shrink();
    }

    final int index1 = index * 2 - 1;
    final int index2 = index1 + 1;

    final List<UChapDataPreload?> datas = index == 0
        ? [widget.pageManager.getOriginalPage(0), null]
        : [
            index1 < widget.pageManager.pageCount
                ? widget.pageManager.getOriginalPage(index1)
                : null,
            index2 < widget.pageManager.pageCount
                ? widget.pageManager.getOriginalPage(index2)
                : null,
          ];

    // Check if pages should be loaded
    final shouldLoad1 = index1 >= 0
        ? widget.pageManager.shouldPageBeLoaded(index1)
        : false;
    final shouldLoad2 = index2 < widget.pageManager.pageCount
        ? widget.pageManager.shouldPageBeLoaded(index2)
        : false;

    if (!shouldLoad1 && !shouldLoad2) {
      return _buildPlaceholder(context);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTapDown: (details) =>
          widget.onDoubleTapDown(details.globalPosition),
      onDoubleTap: widget.onDoubleTap,
      child: DoubleColummVerticalView(
        datas: datas,
        backgroundColor: widget.backgroundColor,
        isFailedToLoadImage: widget.onFailedToLoadImage,
        onLongPressData: widget.onLongPressData,
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: context.height(0.8),
      color: getBackgroundColor(widget.backgroundColor),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    if (widget.readerMode == ReaderMode.webtoon) {
      return const SizedBox.shrink();
    }

    if (widget.isHorizontalContinuous) {
      return VerticalDivider(
        color: getBackgroundColor(widget.backgroundColor),
        width: 6,
      );
    } else {
      return Divider(
        color: getBackgroundColor(widget.backgroundColor),
        height: 6,
      );
    }
  }
}

/// Debug widget to show virtual page manager statistics
class VirtualPageManagerDebugInfo extends ConsumerWidget {
  final VirtualPageManager pageManager;

  const VirtualPageManagerDebugInfo({super.key, required this.pageManager});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: pageManager,
      builder: (context, child) {
        final stats = pageManager.getMemoryStats();

        return Positioned(
          top: 100,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Virtual Page Manager',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Current: ${stats['currentIndex']}/${stats['totalPages']}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Loaded: ${stats['loadedPages']}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Cached: ${stats['cachedPages']}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Errors: ${stats['errorPages']}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Queue: ${stats['preloadQueueSize']}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
