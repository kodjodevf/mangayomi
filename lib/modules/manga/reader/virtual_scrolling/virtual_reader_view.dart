import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/modules/manga/reader/virtual_scrolling/virtual_page_manager.dart';
import 'package:mangayomi/modules/manga/reader/virtual_scrolling/virtual_manga_list.dart';

/// Provides virtual page manager instances
final virtualPageManagerProvider =
    Provider.family<VirtualPageManager, List<UChapDataPreload>>((
      ref,
      pages,
    ) {
      return VirtualPageManager(pages: pages);
    });

/// Main widget for virtual reading that replaces ScrollablePositionedList
class VirtualReaderView extends ConsumerStatefulWidget {
  final List<UChapDataPreload> pages;
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
  final PhotoViewController photoViewController;
  final PhotoViewScaleStateController photoViewScaleStateController;
  final Alignment scalePosition;
  final Function(ScaleEndDetails) onScaleEnd;
  final Function(Offset) onDoubleTapDown;
  final VoidCallback onDoubleTap;
  final bool showDebugInfo;
  // Callbacks pour gérer les transitions entre chapitres
  final Function(Chapter chapter)? onChapterChanged;
  final Function(int lastPageIndex)? onReachedLastPage;

  const VirtualReaderView({
    super.key,
    required this.pages,
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
    required this.photoViewController,
    required this.photoViewScaleStateController,
    required this.scalePosition,
    required this.onScaleEnd,
    required this.onDoubleTapDown,
    required this.onDoubleTap,
    this.showDebugInfo = false,
    this.onChapterChanged,
    this.onReachedLastPage,
  });

  @override
  ConsumerState<VirtualReaderView> createState() => _VirtualReaderViewState();
}

class _VirtualReaderViewState extends ConsumerState<VirtualReaderView> {
  late VirtualPageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = VirtualPageManager(pages: widget.pages);

    // Set initial visible index
    _pageManager.updateVisibleIndex(widget.initialScrollIndex);
  }

  @override
  void didUpdateWidget(VirtualReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update page manager if pages changed
    if (widget.pages != oldWidget.pages) {
      _pageManager.dispose();
      _pageManager = VirtualPageManager(pages: widget.pages);
      _pageManager.updateVisibleIndex(widget.initialScrollIndex);
    }
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pageManager.pageCount < widget.pages.length) {
      _pageManager = VirtualPageManager(pages: widget.pages);
    }
    return Stack(
      children: [
        PhotoViewGallery.builder(
          itemCount: 1,
          builder: (_, _) => PhotoViewGalleryPageOptions.customChild(
            controller: widget.photoViewController,
            scaleStateController: widget.photoViewScaleStateController,
            basePosition: widget.scalePosition,
            onScaleEnd: (context, details, controllerValue) =>
                widget.onScaleEnd(details),
            child: VirtualMangaList(
              pageManager: _pageManager,
              itemScrollController: widget.itemScrollController,
              scrollOffsetController: widget.scrollOffsetController,
              itemPositionsListener: widget.itemPositionsListener,
              scrollDirection: widget.scrollDirection,
              minCacheExtent: widget.minCacheExtent,
              initialScrollIndex: widget.initialScrollIndex,
              physics: widget.physics,
              onLongPressData: widget.onLongPressData,
              onFailedToLoadImage: widget.onFailedToLoadImage,
              backgroundColor: widget.backgroundColor,
              isDoublePageMode: widget.isDoublePageMode,
              isHorizontalContinuous: widget.isHorizontalContinuous,
              readerMode: widget.readerMode,
              onDoubleTapDown: widget.onDoubleTapDown,
              onDoubleTap: widget.onDoubleTap,
              // Passer les callbacks pour les transitions entre chapitres
              onChapterChanged: widget.onChapterChanged,
              onReachedLastPage: widget.onReachedLastPage,
              onPageChanged: (index) {
                // Ici on peut ajouter une logique supplémentaire si nécessaire
                // Par exemple, précaching d'images
                _pageManager.updateVisibleIndex(index);
              },
            ),
          ),
        ),

        // Debug info overlay
        if (widget.showDebugInfo)
          VirtualPageManagerDebugInfo(pageManager: _pageManager),
      ],
    );
  }
}

/// Mixin to add virtual page manager capabilities to existing widgets
mixin VirtualPageManagerMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  VirtualPageManager? _virtualPageManager;

  VirtualPageManager get virtualPageManager {
    _virtualPageManager ??= VirtualPageManager(pages: getPages());
    return _virtualPageManager!;
  }

  /// Override this method to provide the pages list
  List<UChapDataPreload> getPages();

  /// Call this when pages change
  void updateVirtualPages(List<UChapDataPreload> newPages) {
    _virtualPageManager?.dispose();
    _virtualPageManager = VirtualPageManager(pages: newPages);
  }

  /// Call this when the visible page changes
  void updateVisiblePage(int index) {
    virtualPageManager.updateVisibleIndex(index);
  }

  @override
  void dispose() {
    _virtualPageManager?.dispose();
    super.dispose();
  }
}

/// Configuration provider for virtual page manager
final virtualPageConfigProvider = Provider<VirtualPageConfig>((ref) {
  // Get user preferences for virtual scrolling configuration
  final preloadAmount = ref.watch(readerPagePreloadAmountStateProvider);

  return VirtualPageConfig(
    preloadDistance: preloadAmount,
    maxCachedPages: preloadAmount * 3,
    cacheTimeout: const Duration(minutes: 5),
    enableMemoryOptimization: true,
  );
});

/// Provider for page preload amount (renamed to avoid conflicts)
final readerPagePreloadAmountStateProvider = StateProvider<int>((ref) => 3);

/// Extension to convert ReaderMode to virtual scrolling parameters
extension ReaderModeExtension on ReaderMode {
  bool get isContinuous {
    return this == ReaderMode.verticalContinuous ||
        this == ReaderMode.webtoon ||
        this == ReaderMode.horizontalContinuous;
  }

  Axis get scrollDirection {
    return this == ReaderMode.horizontalContinuous
        ? Axis.horizontal
        : Axis.vertical;
  }

  bool get isHorizontalContinuous {
    return this == ReaderMode.horizontalContinuous;
  }
}
