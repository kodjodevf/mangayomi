import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_vertical.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Unified double page view for both paged and continuous reading modes.
///
/// This replaces both `DoubleColummView` and `DoubleColummVerticalView`
/// to eliminate code duplication (previously ~80% identical code).
class DoublePageView extends StatefulWidget {
  /// The two pages to display side by side.
  final List<UChapDataPreload?> pages;

  /// Callback when an image is long-pressed.
  final Function(UChapDataPreload data)? onLongPressData;

  /// Background color setting.
  final BackgroundColor backgroundColor;

  /// Callback for image load failure state.
  final Function(bool)? onFailedToLoadImage;

  /// Whether to use the paged mode (with PhotoView zoom) or vertical mode.
  ///
  /// - `true`: Paged mode with pinch-to-zoom support (uses PhotoViewGallery)
  /// - `false`: Vertical/Continuous mode (simple Column layout)
  final bool isPagedMode;

  /// Whether to add top padding for the first page (vertical mode only).
  final bool addTopPadding;

  const DoublePageView({
    super.key,
    required this.pages,
    required this.backgroundColor,
    this.onLongPressData,
    this.onFailedToLoadImage,
    this.isPagedMode = true,
    this.addTopPadding = true,
  });

  /// Creates a paged mode double page view.
  const DoublePageView.paged({
    super.key,
    required this.pages,
    required this.backgroundColor,
    this.onLongPressData,
    this.onFailedToLoadImage,
  }) : isPagedMode = true,
       addTopPadding = false;

  /// Creates a vertical/continuous mode double page view.
  const DoublePageView.vertical({
    super.key,
    required this.pages,
    required this.backgroundColor,
    this.onLongPressData,
    this.onFailedToLoadImage,
    this.addTopPadding = true,
  }) : isPagedMode = false;

  @override
  State<DoublePageView> createState() => _DoublePageViewState();
}

class _DoublePageViewState extends State<DoublePageView>
    with TickerProviderStateMixin {
  // Controllers for paged mode zoom
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();

  Duration _doubleTapAnimationDuration() {
    final doubleTapAnimationValue =
        isar.settings.getSync(227)?.doubleTapAnimationSpeed ?? 1;
    return switch (doubleTapAnimationValue) {
      0 => const Duration(milliseconds: 10),
      1 => const Duration(milliseconds: 800),
      _ => const Duration(milliseconds: 200),
    };
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
    if (widget.isPagedMode) {
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
  }

  @override
  void dispose() {
    if (widget.isPagedMode) {
      _scaleAnimationController.dispose();
      _photoViewController.dispose();
      _photoViewScaleStateController.dispose();
    }
    super.dispose();
  }

  void _toggleScale(Offset tapPosition) {
    if (!widget.isPagedMode || !mounted) return;

    setState(() {
      if (_scaleAnimationController.isAnimating) return;

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

  @override
  Widget build(BuildContext context) {
    // Check for transition pages
    if (_isTransitionPage()) {
      return _buildTransitionPage();
    }

    return widget.isPagedMode ? _buildPagedMode() : _buildVerticalMode();
  }

  bool _isTransitionPage() {
    return (widget.pages.isNotEmpty &&
            (widget.pages[0]?.isTransitionPage ?? false)) ||
        (widget.pages.length > 1 &&
            (widget.pages[1]?.isTransitionPage ?? false));
  }

  Widget _buildTransitionPage() {
    final transitionPage = widget.pages.firstWhere(
      (p) => p?.isTransitionPage ?? false,
      orElse: () => null,
    );

    if (transitionPage == null) return const SizedBox.shrink();

    return widget.isPagedMode
        ? TransitionViewPaged(data: transitionPage)
        : TransitionViewVertical(data: transitionPage);
  }

  Widget _buildPagedMode() {
    return PhotoViewGallery.builder(
      backgroundDecoration: const BoxDecoration(color: Colors.transparent),
      itemCount: 1,
      builder: (context, _) {
        return PhotoViewGalleryPageOptions.customChild(
          controller: _photoViewController,
          scaleStateController: _photoViewScaleStateController,
          basePosition: _scalePosition,
          onScaleEnd: _onScaleEnd,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onDoubleTapDown: (details) => _toggleScale(details.globalPosition),
            onDoubleTap: () {},
            child: _buildPageRow(),
          ),
        );
      },
    );
  }

  Widget _buildVerticalMode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add top padding for first page
        if (widget.addTopPadding && widget.pages[0]?.index == 0)
          SizedBox(height: MediaQuery.of(context).padding.top),
        _buildPageRow(),
      ],
    );
  }

  Widget _buildPageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.pages.isNotEmpty && widget.pages[0] != null)
          Flexible(child: _buildPageImage(widget.pages[0]!)),
        if (widget.pages.length > 1 && widget.pages[1] != null)
          Flexible(child: _buildPageImage(widget.pages[1]!)),
      ],
    );
  }

  Widget _buildPageImage(UChapDataPreload pageData) {
    final l10n = l10nLocalizations(context)!;
    final onLongPress = widget.onLongPressData ?? (_) {};

    return ImageViewPaged(
      data: pageData,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return _buildLoadingState(state);
          case LoadState.completed:
            return _buildCompletedState(state);
          case LoadState.failed:
            return _buildFailedState(state, l10n);
        }
      },
      onLongPressData: onLongPress,
    );
  }

  Widget _buildLoadingState(ExtendedImageState state) {
    final loadingProgress = state.loadingProgress;
    final progress = loadingProgress?.expectedTotalBytes != null
        ? loadingProgress!.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
        : 0.0;

    return Container(
      color: getBackgroundColor(widget.backgroundColor),
      height: context.height(0.8),
      child: CircularProgressIndicatorAnimateRotate(progress: progress),
    );
  }

  Widget _buildCompletedState(ExtendedImageState state) {
    widget.onFailedToLoadImage?.call(false);
    return Image(image: state.imageProvider);
  }

  Widget _buildFailedState(ExtendedImageState state, dynamic l10n) {
    widget.onFailedToLoadImage?.call(true);

    return Container(
      color: getBackgroundColor(widget.backgroundColor),
      height: context.height(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.image_loading_error,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildRetryButton(state, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(ExtendedImageState state, dynamic l10n) {
    return GestureDetector(
      onLongPress: () {
        state.reLoadImage();
        widget.onFailedToLoadImage?.call(false);
      },
      onTap: () {
        state.reLoadImage();
        widget.onFailedToLoadImage?.call(false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(l10n.retry),
      ),
    );
  }
}
