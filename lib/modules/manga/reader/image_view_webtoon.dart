import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:mangayomi/models/settings.dart';

/// Main widget for virtual reading that replaces ScrollablePositionedList
class ImageViewWebtoon extends ConsumerStatefulWidget {
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
  final int webtoonSidePadding;
  final bool showPageGaps;
  final bool reverse;
  final bool zoomOutDisabled;
  final bool doubleTapZoomEnabled;

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
    this.webtoonSidePadding = 0,
    this.showPageGaps = true,
    this.reverse = false,
    this.zoomOutDisabled = false,
    this.doubleTapZoomEnabled = true,
    this.onImageLoaded,
  });

  final Function(int index, double width, double height)? onImageLoaded;

  @override
  ConsumerState<ImageViewWebtoon> createState() => _ImageViewWebtoonState();
}

class _ImageViewWebtoonState extends ConsumerState<ImageViewWebtoon>
    with TickerProviderStateMixin {
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _baseOffset = Offset.zero;
  Offset _pinchStartFocalPoint = Offset.zero;

  late final AnimationController _zoomAnimationController;

  double _animStartScale = 1.0;
  double _animTargetScale = 1.0;
  double _animFocalPointX = 0.0;
  double _animFocalPointY = 0.0;
  double _animStartOffsetDx = 0.0;
  double _animStartOffsetDy = 0.0;

  Set<int> _visibleIndices = {};
  Offset _doubleTapPosition = Offset.zero;
  final Map<int, ValueNotifier<bool>> _isVisibleNotifiers = {};

  @override
  void initState() {
    super.initState();
    final doubleTapAnimationValue = ref.read(
      doubleTapAnimationSpeedStateProvider,
    );
    _zoomAnimationController = AnimationController(
      vsync: this,
      duration: _durationForSpeed(doubleTapAnimationValue),
    );
    _zoomAnimationController.addListener(() {
      final t = _zoomAnimationController.value;
      final curveVal = Curves.easeOutCubic.transform(t);
      final currentScale =
          _animStartScale + (_animTargetScale - _animStartScale) * curveVal;

      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final targetDx =
          _animFocalPointX -
          (_animFocalPointX - _animStartOffsetDx) *
              (currentScale / _animStartScale);
      final targetDxVal = targetDx;
      final targetDy =
          _animFocalPointY -
          (_animFocalPointY - _animStartOffsetDy) *
              (currentScale / _animStartScale);
      final targetDyVal = targetDy;

      final maxDx = (screenWidth * (currentScale - 1)) / 2;
      final maxDy = (screenHeight * (currentScale - 1)) / 2;

      final clampedDx = currentScale > 1.0
          ? targetDxVal.clamp(-maxDx, maxDx)
          : 0.0;
      final clampedDy = currentScale > 1.0
          ? targetDyVal.clamp(-maxDy, maxDy)
          : 0.0;

      setState(() {
        _scale = currentScale;
        _offset = Offset(clampedDx, clampedDy);
      });
    });

    widget.itemPositionsListener.itemPositions.addListener(
      _updateVisibleIndices,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updateVisibleIndices();
    });
  }

  Duration _durationForSpeed(int speed) {
    return switch (speed) {
      0 => const Duration(milliseconds: 10),
      1 => const Duration(milliseconds: 800),
      _ => const Duration(milliseconds: 200),
    };
  }

  Duration _doubleTapAnimationDuration() {
    final doubleTapAnimationValue = ref.read(
      doubleTapAnimationSpeedStateProvider,
    );
    return _durationForSpeed(doubleTapAnimationValue);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (_zoomAnimationController.isAnimating) {
      _zoomAnimationController.stop();
    }
    _baseScale = _scale;
    _baseOffset = _offset;
    _pinchStartFocalPoint = details.localFocalPoint;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_zoomAnimationController.isAnimating) return;

    final newScale = (_baseScale * details.scale).clamp(
      widget.zoomOutDisabled ? 1.0 : 0.5,
      5.0,
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isVertical = widget.scrollDirection == Axis.vertical;

    double newDx;
    double newDy;

    final maxDx = (screenWidth * (newScale - 1)) / 2;
    final maxDy = (screenHeight * (newScale - 1)) / 2;

    if (details.pointerCount == 1) {
      final dragDeltaX = details.localFocalPoint.dx - _pinchStartFocalPoint.dx;
      final dragDeltaY = details.localFocalPoint.dy - _pinchStartFocalPoint.dy;

      final tempDx = _baseOffset.dx + dragDeltaX;
      final tempDy = _baseOffset.dy + dragDeltaY;

      if (isVertical) {
        newDx = tempDx.clamp(-maxDx, maxDx);

        if (tempDy > maxDy) {
          newDy = maxDy;
          final overflowY = tempDy - maxDy;
          try {
            widget.scrollOffsetController.animateScroll(
              offset: -overflowY,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          } catch (_) {}
        } else if (tempDy < -maxDy) {
          newDy = -maxDy;
          final overflowY = tempDy - (-maxDy);
          try {
            widget.scrollOffsetController.animateScroll(
              offset: -overflowY,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          } catch (_) {}
        } else {
          newDy = tempDy;
        }
      } else {
        newDy = tempDy.clamp(-maxDy, maxDy);

        if (tempDx > maxDx) {
          newDx = maxDx;
          final overflowX = tempDx - maxDx;
          try {
            widget.scrollOffsetController.animateScroll(
              offset: -overflowX,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          } catch (_) {}
        } else if (tempDx < -maxDx) {
          newDx = -maxDx;
          final overflowX = tempDx - (-maxDx);
          try {
            widget.scrollOffsetController.animateScroll(
              offset: -overflowX,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
            );
          } catch (_) {}
        } else {
          newDx = tempDx;
        }
      }
    } else {
      final focalX = details.localFocalPoint.dx - screenWidth / 2;
      final focalY = details.localFocalPoint.dy - screenHeight / 2;
      newDx = focalX - (focalX - _baseOffset.dx) * (newScale / _baseScale);
      newDy = focalY - (focalY - _baseOffset.dy) * (newScale / _baseScale);
    }

    final clampedDx = newScale > 1.0 ? newDx.clamp(-maxDx, maxDx) : 0.0;
    final clampedDy = newScale > 1.0 ? newDy.clamp(-maxDy, maxDy) : 0.0;

    setState(() {
      _scale = newScale;
      _offset = Offset(clampedDx, clampedDy);
    });
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (_scale < 1.0) {
      _animateZoom(
        1.0,
        Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 2,
        ),
      );
    }
  }

  void _animateZoom(double targetScale, Offset localFocalPoint) {
    if (_zoomAnimationController.isAnimating) {
      _zoomAnimationController.stop();
    }

    _animStartScale = _scale;
    _animTargetScale = targetScale;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    _animFocalPointX = localFocalPoint.dx - screenWidth / 2;
    _animFocalPointY = localFocalPoint.dy - screenHeight / 2;

    _animStartOffsetDx = _offset.dx;
    _animStartOffsetDy = _offset.dy;

    _zoomAnimationController.duration = _doubleTapAnimationDuration();
    _zoomAnimationController.forward(from: 0.0);
  }

  void _toggleScale(Offset localFocalPoint) {
    if (!widget.doubleTapZoomEnabled || !mounted) return;
    if (_zoomAnimationController.isAnimating) return;

    if (_scale == 1.0) {
      _animateZoom(2.0, localFocalPoint);
    } else {
      _animateZoom(1.0, localFocalPoint);
    }
  }

  void _updateVisibleIndices() {
    final positions = widget.itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    final newVisible = positions.map((p) => p.index).toSet();
    if (!setEquals(_visibleIndices, newVisible)) {
      setState(() {
        _visibleIndices = newVisible;
      });
      // Propagate visibility updates in O(1) to cached notifiers
      for (final index in _isVisibleNotifiers.keys) {
        _isVisibleNotifiers[index]?.value = newVisible.contains(index);
      }
    }
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    widget.itemPositionsListener.itemPositions.removeListener(
      _updateVisibleIndices,
    );
    for (final notifier in _isVisibleNotifiers.values) {
      notifier.dispose();
    }
    _isVisibleNotifiers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      onDoubleTapDown: (details) => _doubleTapPosition = details.localPosition,
      onDoubleTap: () => _toggleScale(_doubleTapPosition),
      child: Transform(
        transform: Matrix4.diagonal3Values(_scale, _scale, 1.0)
          ..setTranslationRaw(_offset.dx, _offset.dy, 0.0),
        alignment: Alignment.center,
        child: ScrollablePositionedList.separated(
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          minCacheExtent: widget.minCacheExtent,
          initialScrollIndex: widget.initialScrollIndex,
          itemCount: widget.pages.length,
          physics: widget.physics,
          itemScrollController: widget.itemScrollController,
          scrollOffsetController: widget.scrollOffsetController,
          itemPositionsListener: widget.itemPositionsListener,
          itemBuilder: (context, index) => _buildItem(context, index),
          separatorBuilder: _buildSeparator,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final currentPage = widget.pages[index];
    final uniqueKey = ValueKey(
      '${currentPage.chapter?.id ?? "trans"}-${currentPage.index ?? index}',
    );

    return KeyedSubtree(
      key: uniqueKey,
      child: (widget.isDoublePageMode && !widget.isHorizontalContinuous)
          ? _buildDoublePageItem(context, index)
          : _buildSinglePageItem(context, index),
    );
  }

  Widget _buildSinglePageItem(BuildContext context, int index) {
    final currentPage = widget.pages[index];
    final double sidePad = widget.webtoonSidePadding > 0
        ? MediaQuery.of(context).size.width * widget.webtoonSidePadding / 100
        : 0;

    if (currentPage.isTransitionPage) {
      return TransitionViewVertical(data: currentPage);
    }

    final bool isVisible = _visibleIndices.contains(index);
    final isVisibleNotifier = _isVisibleNotifiers.putIfAbsent(
      index,
      () => ValueNotifier<bool>(isVisible),
    );
    isVisibleNotifier.value = isVisible;

    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final dualPageRotateToFitInvert = ref.watch(
      dualPageRotateToFitInvertStateProvider,
    );
    int rotation = 0;
    if (dualPageRotateToFit &&
        currentPage.loadedWidth != null &&
        currentPage.loadedHeight != null &&
        currentPage.loadedWidth! > currentPage.loadedHeight!) {
      rotation = dualPageRotateToFitInvert ? 270 : 90;
    }

    return Padding(
      padding: widget.isHorizontalContinuous
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: sidePad),
      child: ImageViewVertical(
        data: currentPage,
        failedToLoadImage: widget.onFailedToLoadImage,
        onLongPressData: widget.onLongPressData,
        isHorizontal: widget.isHorizontalContinuous,
        isVisible: isVisibleNotifier,
        rotation: rotation,
        onImageLoaded: (width, height) {
          widget.onImageLoaded?.call(index, width, height);
        },
      ),
    );
  }

  Widget _buildDoublePageItem(BuildContext context, int index) {
    final pageLength = widget.pages.length;
    if (index >= pageLength) {
      return const SizedBox.shrink();
    }

    final int index1 = index * 2 - 1;
    final int index2 = index1 + 1;

    final List<UChapDataPreload?> datas = index == 0
        ? [widget.pages[0], null]
        : [
            index1 < pageLength ? widget.pages[index1] : null,
            index2 < pageLength ? widget.pages[index2] : null,
          ];

    return DoublePageView.vertical(
      pages: datas,
      backgroundColor: widget.backgroundColor,
      onFailedToLoadImage: widget.onFailedToLoadImage,
      onLongPressData: widget.onLongPressData,
    );
  }

  Widget _buildSeparator(BuildContext context, int index) {
    if (!widget.showPageGaps || widget.readerMode == ReaderMode.webtoon) {
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
