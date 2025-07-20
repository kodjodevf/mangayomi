import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/reader_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_paged.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class DoubleColummView extends StatefulWidget {
  final List<UChapDataPreload?> datas;
  final Function(UChapDataPreload datas) onLongPressData;
  final BackgroundColor backgroundColor;
  final Function(bool) isFailedToLoadImage;
  const DoubleColummView({
    super.key,
    required this.datas,
    required this.onLongPressData,
    required this.backgroundColor,
    required this.isFailedToLoadImage,
  });

  @override
  State<DoubleColummView> createState() => _DoubleColummViewState();
}

class _DoubleColummViewState extends State<DoubleColummView>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();
  Duration? _doubleTapAnimationDuration() {
    int doubleTapAnimationValue = isar.settings
        .getSync(227)!
        .doubleTapAnimationSpeed!;
    if (doubleTapAnimationValue == 0) {
      return const Duration(milliseconds: 10);
    } else if (doubleTapAnimationValue == 1) {
      return const Duration(milliseconds: 800);
    }
    return const Duration(milliseconds: 200);
  }

  void _onScaleEnd(
    BuildContext context,
    ScaleEndDetails details,
    PhotoViewControllerValue controllerValue,
  ) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  double get pixelRatio => View.of(context).devicePixelRatio;
  Size get size => View.of(context).physicalSize / pixelRatio;
  Alignment _computeAlignmentByTapOffset(Offset offset) {
    return Alignment(
      (offset.dx - size.width / 2) / (size.width / 2),
      (offset.dy - size.height / 2) / (size.height / 2),
    );
  }

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(
      duration: _doubleTapAnimationDuration(),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController),
    );
    _animation.addListener(() {
      _photoViewController.scale = _animation.value;
    });
  }

  @override
  void dispose() {
    _scaleAnimationController.dispose();
    super.dispose();
  }

  void _toggleScale(Offset tapPosition) {
    if (mounted) {
      setState(() {
        if (_scaleAnimationController.isAnimating) {
          return;
        }

        if (_photoViewController.scale == 1.0) {
          _scalePosition = _computeAlignmentByTapOffset(tapPosition);

          if (_scaleAnimationController.isCompleted) {
            _scaleAnimationController.reset();
          }

          _scaleAnimationController.forward();
          return;
        }

        if (_photoViewController.scale == 2.0) {
          _scaleAnimationController.reverse();
          return;
        }

        _photoViewScaleStateController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas[0]?.isTransitionPage ?? false) {
      return TransitionViewPaged(data: widget.datas[0]!);
    }
    if (widget.datas.length > 1 &&
        (widget.datas[1]?.isTransitionPage ?? false)) {
      return TransitionViewPaged(data: widget.datas[1]!);
    }

    return PhotoViewGallery.builder(
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      itemCount: 1,
      builder: (context, _) {
        final l10n = l10nLocalizations(context)!;
        return PhotoViewGalleryPageOptions.customChild(
          controller: _photoViewController,
          scaleStateController: _photoViewScaleStateController,
          basePosition: _scalePosition,
          onScaleEnd: _onScaleEnd,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTapDown: (TapDownDetails details) {
              _toggleScale(details.globalPosition);
            },
            onDoubleTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.datas[0] != null)
                  Flexible(
                    child: ImageViewPaged(
                      data: widget.datas[0]!,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          final ImageChunkEvent? loadingProgress =
                              state.loadingProgress;
                          final double progress =
                              loadingProgress?.expectedTotalBytes != null
                              ? loadingProgress!.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : 0;
                          return Container(
                            color: getBackgroundColor(widget.backgroundColor),
                            height: context.height(0.8),
                            child: CircularProgressIndicatorAnimateRotate(
                              progress: progress,
                            ),
                          );
                        }
                        if (state.extendedImageLoadState ==
                            LoadState.completed) {
                          widget.isFailedToLoadImage(false);
                          return Image(image: state.imageProvider);
                        }
                        if (state.extendedImageLoadState == LoadState.failed) {
                          widget.isFailedToLoadImage(true);
                          return Container(
                            color: getBackgroundColor(widget.backgroundColor),
                            height: context.height(0.8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.image_loading_error,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      state.reLoadImage();
                                      widget.isFailedToLoadImage(false);
                                    },
                                    onTap: () {
                                      state.reLoadImage();
                                      widget.isFailedToLoadImage(false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.primaryColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        child: Text(l10n.retry),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return null;
                      },
                      onLongPressData: (datas) =>
                          widget.onLongPressData.call(datas),
                    ),
                  ),
                // if (widget.datas[1] != null) const SizedBox(width: 10),
                if (widget.datas[1] != null)
                  Flexible(
                    child: ImageViewPaged(
                      data: widget.datas[1]!,
                      loadStateChanged: (state) {
                        if (state.extendedImageLoadState == LoadState.loading) {
                          final ImageChunkEvent? loadingProgress =
                              state.loadingProgress;
                          final double progress =
                              loadingProgress?.expectedTotalBytes != null
                              ? loadingProgress!.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : 0;
                          return Container(
                            color: getBackgroundColor(widget.backgroundColor),
                            height: context.height(0.8),
                            child: CircularProgressIndicatorAnimateRotate(
                              progress: progress,
                            ),
                          );
                        }
                        if (state.extendedImageLoadState ==
                            LoadState.completed) {
                          widget.isFailedToLoadImage(false);
                          return Image(image: state.imageProvider);
                        }
                        if (state.extendedImageLoadState == LoadState.failed) {
                          widget.isFailedToLoadImage(true);
                          return Container(
                            color: getBackgroundColor(widget.backgroundColor),
                            height: context.height(0.8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.image_loading_error,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onLongPress: () {
                                      state.reLoadImage();
                                      widget.isFailedToLoadImage(false);
                                    },
                                    onTap: () {
                                      state.reLoadImage();
                                      widget.isFailedToLoadImage(false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: context.primaryColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 16,
                                        ),
                                        child: Text(l10n.retry),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return null;
                      },
                      onLongPressData: (datas) =>
                          widget.onLongPressData.call(datas),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
