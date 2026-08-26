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
  final Function(int index, bool failed) onFailedToLoadImage;
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
  int _previousPointerCount = 0;

  // QuickScale (one-finger double-tap and drag zoom)
  bool _isQuickScaling = false;
  double _quickScaleLastY = 0.0;
  double _quickScaleLastDistance = -1.0;
  Offset? _quickScaleCenter;

  late final ValueNotifier<Matrix4> _transformNotifier;
  late final AnimationController _zoomAnimationController;

  double _animStartScale = 1.0;
  double _animTargetScale = 1.0;
  Offset _animStartOffset = Offset.zero;
  Offset _animTargetOffset = Offset.zero;

  Offset _doubleTapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _transformNotifier = ValueNotifier(Matrix4.identity());
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
      _scale =
          _animStartScale + (_animTargetScale - _animStartScale) * curveVal;
      _offset =
          Offset.lerp(_animStartOffset, _animTargetOffset, curveVal) ?? _offset;
      _updateMatrix();
    });
  }

  void _updateMatrix() {
    _transformNotifier.value = Matrix4.diagonal3Values(_scale, _scale, 1.0)
      ..setTranslationRaw(_offset.dx, _offset.dy, 0.0);
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

  void _animateTo(
    double targetScale,
    Offset targetOffset, {
    Duration? duration,
  }) {
    if (_zoomAnimationController.isAnimating) {
      _zoomAnimationController.stop();
    }
    _animStartScale = _scale;
    _animTargetScale = targetScale;
    _animStartOffset = _offset;
    _animTargetOffset = targetOffset;

    _zoomAnimationController.duration =
        duration ?? _doubleTapAnimationDuration();
    _zoomAnimationController.forward(from: 0.0);
  }

  void _animateZoomToFocalPoint(double targetScale, Offset localFocalPoint) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final focalX = localFocalPoint.dx - screenWidth / 2;
    final focalY = localFocalPoint.dy - screenHeight / 2;

    double targetDx;
    double targetDy;

    if (targetScale <= 1.0) {
      targetDx = 0.0;
      targetDy = 0.0;
    } else {
      targetDx = focalX - (focalX - _offset.dx) * (targetScale / _scale);
      targetDy = focalY - (focalY - _offset.dy) * (targetScale / _scale);

      final maxDx = (screenWidth * (targetScale - 1)) / 2;
      final maxDy = (screenHeight * (targetScale - 1)) / 2;

      targetDx = targetDx.clamp(-maxDx, maxDx);
      targetDy = targetDy.clamp(-maxDy, maxDy);
    }

    _animateTo(targetScale, Offset(targetDx, targetDy));
  }

  void _handleScaleStart(ScaleStartDetails details) {
    if (_zoomAnimationController.isAnimating) {
      _zoomAnimationController.stop();
    }
    _baseScale = _scale;
    _baseOffset = _offset;
    _pinchStartFocalPoint = details.localFocalPoint;
    _previousPointerCount = details.pointerCount;
    _isQuickScaling = false;
    _quickScaleLastDistance = -1.0;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_zoomAnimationController.isAnimating) return;

    if (details.pointerCount != _previousPointerCount) {
      _baseScale = _scale;
      _baseOffset = _offset;
      _pinchStartFocalPoint = details.localFocalPoint;
      _previousPointerCount = details.pointerCount;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isVertical = widget.scrollDirection == Axis.vertical;

    double newScale = _scale;
    double newDx = _offset.dx;
    double newDy = _offset.dy;

    if (_isQuickScaling && _quickScaleCenter != null) {
      final double dy = details.localFocalPoint.dy;
      final double dist = (dy - _pinchStartFocalPoint.dy).abs() * 2 + 20;

      if (_quickScaleLastDistance < 0) _quickScaleLastDistance = dist;
      final bool isUpwards = dy < _quickScaleLastY;
      _quickScaleLastY = dy;

      final double spanDiff =
          (1 - (dist / _quickScaleLastDistance)).abs() * 0.5;
      if (spanDiff > 0.02) {
        final double multiplier = isUpwards ? (1 + spanDiff) : (1 - spanDiff);
        newScale = (_scale * multiplier).clamp(
          widget.zoomOutDisabled ? 1.0 : 0.5,
          5.0,
        );

        final focalX = _quickScaleCenter!.dx - screenWidth / 2;
        final focalY = _quickScaleCenter!.dy - screenHeight / 2;
        newDx = focalX - (focalX - _baseOffset.dx) * (newScale / _baseScale);
        newDy = focalY - (focalY - _baseOffset.dy) * (newScale / _baseScale);
      }
      _quickScaleLastDistance = dist;
    } else if (details.pointerCount > 1 && details.scale != 1.0) {
      newScale = (_baseScale * details.scale).clamp(
        widget.zoomOutDisabled ? 1.0 : 0.5,
        5.0,
      );

      final focalX = details.localFocalPoint.dx - screenWidth / 2;
      final focalY = details.localFocalPoint.dy - screenHeight / 2;
      newDx = focalX - (focalX - _baseOffset.dx) * (newScale / _baseScale);
      newDy = focalY - (focalY - _baseOffset.dy) * (newScale / _baseScale);
    } else if (details.pointerCount == 1 && !_isQuickScaling) {
      final dragDeltaX = details.localFocalPoint.dx - _pinchStartFocalPoint.dx;
      final dragDeltaY = details.localFocalPoint.dy - _pinchStartFocalPoint.dy;

      final tempDx = _baseOffset.dx + dragDeltaX;
      final tempDy = _baseOffset.dy + dragDeltaY;

      final maxDx = (screenWidth * (_scale - 1)) / 2;
      final maxDy = (screenHeight * (_scale - 1)) / 2;

      if (_scale <= 1.0) {
        newDx = 0.0;
        newDy = 0.0;
      } else if (isVertical) {
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
    }

    final maxDx = (screenWidth * (newScale - 1)) / 2;
    final maxDy = (screenHeight * (newScale - 1)) / 2;

    final clampedDx = newScale > 1.0 ? newDx.clamp(-maxDx, maxDx) : 0.0;
    final clampedDy = newScale > 1.0 ? newDy.clamp(-maxDy, maxDy) : 0.0;

    _scale = newScale;
    _offset = Offset(clampedDx, clampedDy);
    _updateMatrix();
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _isQuickScaling = false;

    // 1. Rebound spring if zoomed out below 1.0
    if (_scale < 1.0) {
      _animateTo(1.0, Offset.zero, duration: const Duration(milliseconds: 250));
      return;
    }

    // 2. Fling inertia momentum if panning while zoomed
    if (_scale > 1.0) {
      final velocity = details.velocity.pixelsPerSecond;
      if (velocity.distance > 350) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final maxDx = (screenWidth * (_scale - 1)) / 2;
        final maxDy = (screenHeight * (_scale - 1)) / 2;

        final targetDx = (_offset.dx + velocity.dx * 0.15).clamp(-maxDx, maxDx);
        final targetDy = (_offset.dy + velocity.dy * 0.15).clamp(-maxDy, maxDy);

        if ((Offset(targetDx, targetDy) - _offset).distance > 8) {
          _animateTo(
            _scale,
            Offset(targetDx, targetDy),
            duration: const Duration(milliseconds: 400),
          );
        }
      }
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapPosition = details.localPosition;
    _isQuickScaling = true;
    _quickScaleLastY = details.localPosition.dy;
    _quickScaleLastDistance = -1.0;
    _quickScaleCenter = details.localPosition;
  }

  void _toggleScale(Offset localFocalPoint) {
    if (!widget.doubleTapZoomEnabled || !mounted) return;
    if (_zoomAnimationController.isAnimating) return;

    if (_scale <= 1.05) {
      _animateZoomToFocalPoint(2.5, localFocalPoint);
    } else {
      _animateZoomToFocalPoint(1.0, localFocalPoint);
    }
  }

  @override
  void dispose() {
    _zoomAnimationController.dispose();
    _transformNotifier.dispose();
    super.dispose();
  }

  int get _itemCount {
    if (widget.isDoublePageMode && !widget.isHorizontalContinuous) {
      if (widget.pages.isEmpty) return 0;
      final singleFirst = ref.watch(doublePageSingleFirstPageStateProvider);
      if (singleFirst) {
        return 1 + ((widget.pages.length - 1) / 2).ceil();
      }
      return (widget.pages.length / 2).ceil();
    }
    return widget.pages.length;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: () => _toggleScale(_doubleTapPosition),
      child: ValueListenableBuilder<Matrix4>(
        valueListenable: _transformNotifier,
        child: ScrollablePositionedList.separated(
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          minCacheExtent: widget.minCacheExtent,
          initialScrollIndex: widget.initialScrollIndex,
          itemCount: _itemCount,
          physics: widget.physics,
          itemScrollController: widget.itemScrollController,
          scrollOffsetController: widget.scrollOffsetController,
          itemPositionsListener: widget.itemPositionsListener,
          itemBuilder: (context, index) => _buildItem(context, index),
          separatorBuilder: _buildSeparator,
        ),
        builder: (context, matrix, child) {
          return Transform(
            transform: matrix,
            alignment: Alignment.center,
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (widget.isDoublePageMode && !widget.isHorizontalContinuous) {
      return _buildDoublePageItem(context, index);
    }
    final currentPage = widget.pages[index];
    final uniqueKey = ValueKey(
      '${currentPage.chapter?.id ?? "trans"}-${currentPage.index ?? index}',
    );

    return KeyedSubtree(
      key: uniqueKey,
      child: _buildSinglePageItem(context, index),
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
        failedToLoadImage: (failed) =>
            widget.onFailedToLoadImage(index, failed),
        onLongPressData: widget.onLongPressData,
        isHorizontal: widget.isHorizontalContinuous,
        rotation: rotation,
        onImageLoaded: (width, height) {
          widget.onImageLoaded?.call(index, width, height);
        },
      ),
    );
  }

  Widget _buildDoublePageItem(BuildContext context, int index) {
    final pageLength = widget.pages.length;
    final singleFirst = ref.watch(doublePageSingleFirstPageStateProvider);

    int index1;
    int? index2;
    if (singleFirst) {
      if (index == 0) {
        index1 = 0;
        index2 = null;
      } else {
        index1 = index * 2 - 1;
        index2 = index1 + 1;
      }
    } else {
      index1 = index * 2;
      index2 = index1 + 1;
    }

    if (index1 >= pageLength) {
      return const SizedBox.shrink();
    }

    final page1 = widget.pages[index1];
    final page2 = (index2 != null && index2 < pageLength)
        ? widget.pages[index2]
        : null;

    final List<UChapDataPreload?> datas = [page1, page2];

    final uniqueKey = ValueKey(
      'double-${page1.chapter?.id ?? "trans"}-${page1.index ?? index1}-${page2?.index ?? "none"}',
    );

    return KeyedSubtree(
      key: uniqueKey,
      child: DoublePageView.vertical(
        pages: datas,
        backgroundColor: widget.backgroundColor,
        onFailedToLoadImage: (failed) =>
            widget.onFailedToLoadImage(index1, failed),
        onLongPressData: widget.onLongPressData,
      ),
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
