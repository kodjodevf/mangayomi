import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// A specialized [ScaleGestureRecognizer] for the webtoon reader.
///
/// When unzoomed ([canPanCallback] returns false), single-pointer pans are
/// rejected from the gesture arena so that normal 1-finger vertical scrolls
/// pass directly to the underlying scrollable widget without competition,
/// delay, or stutter.
///
/// Two-finger pinches (and 1-finger panning when already zoomed) are accepted
/// as normal scale gestures.
class WebtoonScaleGestureRecognizer extends ScaleGestureRecognizer {
  WebtoonScaleGestureRecognizer({
    super.debugOwner,
    super.supportedDevices,
    super.allowedButtonsFilter,
    this.canPanCallback,
  });

  bool Function()? canPanCallback;

  @visibleForTesting
  GestureDisposition resolveDisposition(GestureDisposition disposition) {
    if (disposition == GestureDisposition.accepted) {
      final canPan = canPanCallback?.call() ?? false;
      if (!canPan && pointerCount < 2) {
        return GestureDisposition.rejected;
      }
    }
    return disposition;
  }

  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(resolveDisposition(disposition));
  }
}

/// Main widget for virtual reading using SuperListView from super_sliver_list
class ImageViewWebtoon extends ConsumerStatefulWidget {
  final List<UChapDataPreload> pages;
  final ListController listController;
  final ScrollController scrollController;
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
    required this.listController,
    required this.scrollController,
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
    if (widget.initialScrollIndex > 0) {
      void jump([int attempt = 0]) {
        if (!mounted) return;
        if (widget.listController.isAttached &&
            widget.scrollController.hasClients) {
          // ignore: invalid_use_of_visible_for_testing_member
          final offset = widget.listController.getOffsetToReveal(
            widget.initialScrollIndex,
            0.0,
          );
          if (offset.isFinite && offset > 0) {
            final maxExtent = widget.scrollController.position.maxScrollExtent;
            if (maxExtent > 0) {
              widget.scrollController.jumpTo(offset.clamp(0.0, maxExtent));
              return;
            }
          }
          widget.listController.jumpToItem(
            index: widget.initialScrollIndex,
            scrollController: widget.scrollController,
            alignment: 0.0,
          );
          if (attempt < 5) {
            final range = widget.listController.visibleRange;
            if (range == null || range.$1 < widget.initialScrollIndex) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                jump(attempt + 1);
              });
            }
          }
        } else if (attempt < 5) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            jump(attempt + 1);
          });
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => jump());
    }
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
    if (details.pointerCount > 1) {
      _isQuickScaling = false;
    }
    _quickScaleLastDistance = -1.0;
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_zoomAnimationController.isAnimating) return;

    // If unzoomed and only 1 pointer is touching, ignore scale updates so
    // that normal scrolling remains 100% native without matrix recalculation.
    if (_scale <= 1.01 && details.pointerCount <= 1 && !_isQuickScaling) {
      return;
    }

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
          if (widget.scrollController.hasClients) {
            final target = (widget.scrollController.offset - overflowY * 0.1)
                .clamp(0.0, widget.scrollController.position.maxScrollExtent);
            widget.scrollController.jumpTo(target);
          }
        } else if (tempDy < -maxDy) {
          newDy = -maxDy;
          final overflowY = tempDy - (-maxDy);
          if (widget.scrollController.hasClients) {
            final target = (widget.scrollController.offset - overflowY * 0.1)
                .clamp(0.0, widget.scrollController.position.maxScrollExtent);
            widget.scrollController.jumpTo(target);
          }
        } else {
          newDy = tempDy;
        }
      } else {
        newDy = tempDy.clamp(-maxDy, maxDy);

        if (tempDx > maxDx) {
          newDx = maxDx;
          final overflowX = tempDx - maxDx;
          if (widget.scrollController.hasClients) {
            final target = (widget.scrollController.offset - overflowX * 0.1)
                .clamp(0.0, widget.scrollController.position.maxScrollExtent);
            widget.scrollController.jumpTo(target);
          }
        } else if (tempDx < -maxDx) {
          newDx = -maxDx;
          final overflowX = tempDx - (-maxDx);
          if (widget.scrollController.hasClients) {
            final target = (widget.scrollController.offset - overflowX * 0.1)
                .clamp(0.0, widget.scrollController.position.maxScrollExtent);
            widget.scrollController.jumpTo(target);
          }
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

    _isQuickScaling = false;

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

  int _calculateItemCount(bool singleFirst) {
    if (widget.isDoublePageMode && !widget.isHorizontalContinuous) {
      if (widget.pages.isEmpty) return 0;
      return ReaderPageIndexMath.buildSpreads(
        widget.pages,
        singleFirst: singleFirst,
      ).length;
    }
    return widget.pages.length;
  }

  @override
  Widget build(BuildContext context) {
    final singleFirst = ref.watch(doublePageSingleFirstPageStateProvider);
    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final dualPageRotateToFitInvert = ref.watch(
      dualPageRotateToFitInvertStateProvider,
    );
    final itemCount = _calculateItemCount(singleFirst);

    return RawGestureDetector(
      behavior: HitTestBehavior.translucent,
      gestures: <Type, GestureRecognizerFactory>{
        WebtoonScaleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<WebtoonScaleGestureRecognizer>(
              () => WebtoonScaleGestureRecognizer(),
              (instance) {
                instance.canPanCallback = () =>
                    _scale > 1.01 || _isQuickScaling;
                instance
                  ..onStart = _handleScaleStart
                  ..onUpdate = _handleScaleUpdate
                  ..onEnd = _handleScaleEnd;
              },
            ),
        if (widget.doubleTapZoomEnabled)
          DoubleTapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
                () => DoubleTapGestureRecognizer(),
                (instance) {
                  instance
                    ..onDoubleTapDown = _handleDoubleTapDown
                    ..onDoubleTap = () {
                      _toggleScale(_doubleTapPosition);
                    }
                    ..onDoubleTapCancel = () {
                      _isQuickScaling = false;
                    };
                },
              ),
      },
      child: ValueListenableBuilder<Matrix4>(
        valueListenable: _transformNotifier,
        child: SuperListView.builder(
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          cacheExtent: widget.minCacheExtent,
          itemCount: itemCount,
          physics: widget.physics,
          controller: widget.scrollController,
          listController: widget.listController,
          extentEstimation: _estimateExtent,
          itemBuilder: (context, index) => _buildItem(
            context,
            index,
            itemCount,
            singleFirst,
            dualPageRotateToFit,
            dualPageRotateToFitInvert,
          ),
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

  double _estimateExtent(int? index, double crossAxisExtent) {
    if (index != null && index >= 0 && index < widget.pages.length) {
      final page = widget.pages[index];
      if (page.loadedWidth != null &&
          page.loadedHeight != null &&
          page.loadedWidth! > 0) {
        if (widget.isHorizontalContinuous) {
          return crossAxisExtent * (page.loadedWidth! / page.loadedHeight!);
        } else {
          return crossAxisExtent * (page.loadedHeight! / page.loadedWidth!);
        }
      }
    }

    // Look for any loaded page in the chapter to use as aspect ratio heuristic
    double? sampleAspect;
    for (final p in widget.pages) {
      if (p.loadedWidth != null &&
          p.loadedHeight != null &&
          p.loadedWidth! > 0) {
        sampleAspect = p.loadedHeight! / p.loadedWidth!;
        break;
      }
    }

    if (widget.isHorizontalContinuous) {
      return crossAxisExtent *
          (sampleAspect != null ? (1.0 / sampleAspect) : 0.7);
    } else {
      if (sampleAspect != null) {
        return crossAxisExtent * sampleAspect;
      }
      return widget.readerMode == ReaderMode.webtoon
          ? crossAxisExtent * 2.5
          : crossAxisExtent * 1.4;
    }
  }

  Widget _buildItem(
    BuildContext context,
    int index,
    int itemCount,
    bool singleFirst,
    bool dualPageRotateToFit,
    bool dualPageRotateToFitInvert,
  ) {
    Widget item;
    if (widget.isDoublePageMode && !widget.isHorizontalContinuous) {
      item = _buildDoublePageItem(context, index, singleFirst);
    } else {
      final currentPage = widget.pages[index];
      final uniqueKey = ValueKey(
        '${currentPage.chapter?.id ?? "trans"}-${currentPage.index ?? index}',
      );

      item = KeyedSubtree(
        key: uniqueKey,
        child: _buildSinglePageItem(
          context,
          index,
          dualPageRotateToFit,
          dualPageRotateToFitInvert,
        ),
      );
    }

    if (widget.showPageGaps &&
        widget.readerMode != ReaderMode.webtoon &&
        index < itemCount - 1) {
      item = Padding(
        padding: widget.isHorizontalContinuous
            ? const EdgeInsets.only(right: 6)
            : const EdgeInsets.only(bottom: 6),
        child: item,
      );
    }

    return item;
  }

  Widget _buildSinglePageItem(
    BuildContext context,
    int index,
    bool dualPageRotateToFit,
    bool dualPageRotateToFitInvert,
  ) {
    final currentPage = widget.pages[index];
    final double sidePad = widget.webtoonSidePadding > 0
        ? MediaQuery.of(context).size.width * widget.webtoonSidePadding / 100
        : 0;

    if (currentPage.isTransitionPage) {
      return TransitionViewVertical(data: currentPage);
    }

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

  Widget _buildDoublePageItem(
    BuildContext context,
    int index,
    bool singleFirst,
  ) {
    final pageLength = widget.pages.length;
    final spreads = ReaderPageIndexMath.buildSpreads(
      widget.pages,
      singleFirst: singleFirst,
    );

    if (index >= spreads.length) {
      return const SizedBox.shrink();
    }

    final spread = spreads[index];
    final index1 = spread.firstIndex;
    final index2 = spread.secondIndex;

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
}
