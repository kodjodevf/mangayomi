import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/double_columm_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mangayomi/models/settings.dart';

/// Main widget for virtual reading that replaces ScrollablePositionedList
class ImageViewWebtoon extends StatelessWidget {
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

  const ImageViewWebtoon({
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
  });

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      itemCount: 1,
      builder: (_, _) => PhotoViewGalleryPageOptions.customChild(
        controller: photoViewController,
        scaleStateController: photoViewScaleStateController,
        basePosition: scalePosition,
        onScaleEnd: (context, details, controllerValue) => onScaleEnd(details),
        child: ScrollablePositionedList.separated(
          scrollDirection: scrollDirection,
          minCacheExtent: minCacheExtent,
          initialScrollIndex: initialScrollIndex,
          itemCount: pages.length,
          physics: physics,
          itemScrollController: itemScrollController,
          scrollOffsetController: scrollOffsetController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) => _buildItem(context, index),
          separatorBuilder: _buildSeparator,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (isDoublePageMode && !isHorizontalContinuous) {
      return _buildDoublePageItem(context, index);
    } else {
      return _buildSinglePageItem(context, index);
    }
  }

  Widget _buildSinglePageItem(BuildContext context, int index) {
    final currentPage = pages[index];

    if (currentPage.isTransitionPage) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTapDown: (details) => onDoubleTapDown(details.globalPosition),
        onDoubleTap: onDoubleTap,
        child: TransitionViewVertical(data: currentPage),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTapDown: (details) => onDoubleTapDown(details.globalPosition),
      onDoubleTap: onDoubleTap,
      child: ImageViewVertical(
        data: currentPage,
        failedToLoadImage: onFailedToLoadImage,
        onLongPressData: onLongPressData,
        isHorizontal: isHorizontalContinuous,
      ),
    );
  }

  Widget _buildDoublePageItem(BuildContext context, int index) {
    final pageLength = pages.length;
    if (index >= pageLength) {
      return const SizedBox.shrink();
    }

    final int index1 = index * 2 - 1;
    final int index2 = index1 + 1;

    final List<UChapDataPreload?> datas = index == 0
        ? [pages[0], null]
        : [
            index1 < pageLength ? pages[index1] : null,
            index2 < pageLength ? pages[index2] : null,
          ];

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTapDown: (details) => onDoubleTapDown(details.globalPosition),
      onDoubleTap: onDoubleTap,
      child: DoubleColummVerticalView(
        datas: datas,
        backgroundColor: backgroundColor,
        isFailedToLoadImage: onFailedToLoadImage,
        onLongPressData: onLongPressData,
      ),
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    if (readerMode == ReaderMode.webtoon) {
      return const SizedBox.shrink();
    }

    if (isHorizontalContinuous) {
      return VerticalDivider(
        color: getBackgroundColor(backgroundColor),
        width: 6,
      );
    } else {
      return Divider(color: getBackgroundColor(backgroundColor), height: 6);
    }
  }
}
