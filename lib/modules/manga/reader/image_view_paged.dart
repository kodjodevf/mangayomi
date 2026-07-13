import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/color_filter_widget.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';

class ImageViewPaged extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final Function(UChapDataPreload data) onLongPressData;
  final Widget? Function(ssiv.SubsamplingImageState state) loadStateChanged;
  final bool zoomEnabled;
  final bool panEnabled;
  final void Function(int width, int height)? onImageLoaded;
  final PageController? pageController;
  final ssiv.SubsamplingScaleImageViewController? controller;
  final bool isVisible;

  const ImageViewPaged({
    super.key,
    required this.data,
    required this.onLongPressData,
    required this.loadStateChanged,
    this.zoomEnabled = true,
    this.panEnabled = true,
    this.onImageLoaded,
    this.pageController,
    this.controller,
    this.isVisible = true,
  });

  @override
  ConsumerState<ImageViewPaged> createState() => _ImageViewPagedState();
}

class _ImageViewPagedState extends ConsumerState<ImageViewPaged> {
  Color? _autoBgColor;
  bool _isDetecting = false;

  bool _hasLandscapeZoomed = false;

  String? _resolvedFilePath;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
    _resolvedFilePath = widget.data.resolvedFilePath;
    _resolveFilePath();
  }

  @override
  void didUpdateWidget(covariant ImageViewPaged oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
    if (widget.data != oldWidget.data) {
      _hasLandscapeZoomed = false;
      _resolvedFilePath = widget.data.resolvedFilePath;
      _resolveFilePath();
    }
    if (widget.isVisible && !oldWidget.isVisible) {
      _checkLandscapeZoom();
    }
  }

  Future<void> _resolveFilePath() async {
    if (widget.data.resolvedFilePath != null) {
      if (mounted) {
        setState(() {
          _resolvedFilePath = widget.data.resolvedFilePath;
        });
      }
      return;
    }
    final path = await widget.data.getLocalFilePath;
    if (path != null) {
      widget.data.resolvedFilePath = path;
      if (mounted) {
        setState(() {
          _resolvedFilePath = path;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.isVisible) {
      _checkLandscapeZoom();
    }
  }

  void _checkLandscapeZoom() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _performLandscapeZoom();
    });
  }

  void _performLandscapeZoom() {
    final controller = widget.controller;
    if (controller == null ||
        !controller.isReady ||
        !widget.isVisible ||
        !mounted) {
      return;
    }
    if (_hasLandscapeZoomed) return;

    final landscapeZoom = ref.read(landscapeZoomStateProvider);
    if (!landscapeZoom) return;

    final scaleType = ref.read(scaleTypeStateProvider);
    if (scaleType != ScaleType.fitScreen) return;

    final sWidth = controller.sWidth;
    final sHeight = controller.sHeight;
    if (sWidth <= sHeight) return;

    final currentScale = controller.scale;
    final minScale = controller.minScale;
    if (minScale <= 0.0) return;
    if ((currentScale - minScale).abs() > 0.01) return;

    final viewHeight =
        context.size?.height ?? MediaQuery.of(context).size.height;
    final targetScale = viewHeight / sHeight;

    final zoomStart = ref.read(zoomStartPositionStateProvider);
    final readerMode = ref
        .read(readerControllerProvider(chapter: widget.data.chapter!).notifier)
        .getReaderMode();
    final isRightToLeft = readerMode == ReaderMode.rtl;

    Offset targetPoint;
    if (zoomStart == 0) {
      targetPoint = const Offset(0, 0);
    } else if (zoomStart == 1) {
      targetPoint = Offset(sWidth.toDouble(), 0);
    } else if (zoomStart == 2) {
      targetPoint = Offset(sWidth / 2, sHeight / 2);
    } else {
      targetPoint = isRightToLeft
          ? Offset(sWidth.toDouble(), 0)
          : const Offset(0, 0);
    }

    _hasLandscapeZoomed = true;
    if (mounted) {
      controller.animateScaleAndCenter(
        targetScale,
        targetPoint,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  Duration _doubleTapAnimationDuration() {
    final doubleTapAnimationValue =
        isar.settings.getSync(227)?.doubleTapAnimationSpeed ?? 1;
    return switch (doubleTapAnimationValue) {
      0 => const Duration(milliseconds: 10),
      1 => const Duration(milliseconds: 800),
      _ => const Duration(milliseconds: 200),
    };
  }

  void _detectBgColor(ImageProvider provider) async {
    if (_isDetecting || _autoBgColor != null) return;
    _isDetecting = true;
    try {
      final ImageStream stream = provider.resolve(ImageConfiguration.empty);
      ImageStreamListener? listener;
      listener = ImageStreamListener(
        (ImageInfo info, bool syncCall) async {
          try {
            final byteData = await info.image.toByteData(
              format: ui.ImageByteFormat.rawRgba,
            );
            if (byteData != null && byteData.lengthInBytes >= 4) {
              final int r = byteData.getUint8(0);
              final int g = byteData.getUint8(1);
              final int b = byteData.getUint8(2);
              final double brightness =
                  (r * 0.299 + g * 0.587 + b * 0.114) / 255.0;
              if (mounted) {
                setState(() {
                  _autoBgColor = brightness > 0.5 ? Colors.white : Colors.black;
                });
              }
            }
          } catch (_) {}
          stream.removeListener(listener!);
        },
        onError: (err, stack) {
          stream.removeListener(listener!);
        },
      );
      stream.addListener(listener);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final scaleType = ref.watch(scaleTypeStateProvider);
    final image = widget.data.getImageProvider(ref, true);
    final (colorBlendMode, color) = chapterColorFIlterValues(context, ref);
    final cropBorders = ref.watch(cropBordersStateProvider);
    final automaticBackground = ref.watch(automaticBackgroundStateProvider);
    final dualPageRotateToFit = ref.watch(dualPageRotateToFitStateProvider);
    final dualPageRotateToFitInvert = ref.watch(
      dualPageRotateToFitInvertStateProvider,
    );

    if (automaticBackground) {
      _detectBgColor(image);
    }

    // Determine background color
    Color? pageBgColor = _autoBgColor;

    // rotation calculation
    int rotation = 0;
    if (dualPageRotateToFit &&
        widget.data.loadedWidth != null &&
        widget.data.loadedHeight != null) {
      if (widget.data.loadedWidth! > widget.data.loadedHeight!) {
        rotation = dualPageRotateToFitInvert ? 270 : 90;
      }
    }

    // Mappe le scaleType de Mangayomi vers le BoxFit
    final effectiveFit = switch (scaleType) {
      ScaleType.fitWidth => BoxFit.fitWidth,
      ScaleType.fitHeight => BoxFit.fitHeight,
      ScaleType.stretch => BoxFit.fill,
      _ => BoxFit.contain,
    };

    // Détection de GIF animé pour contourner le visualiseur de tuiles statiques
    bool isAnimated = false;
    if (widget.data.archiveImage != null &&
        widget.data.archiveImage!.length > 3) {
      final bytes = widget.data.archiveImage!;
      if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46) {
        isAnimated = true;
      }
    }
    final url = widget.data.pageUrl?.url.trim().toLowerCase() ?? '';
    if (url.contains('.gif')) isAnimated = true;
    if (!isAnimated &&
        widget.data.directory != null &&
        widget.data.index != null) {
      try {
        final file = File(
          '${widget.data.directory!.path}/${padIndex(widget.data.index!)}.jpg',
        );
        if (file.existsSync()) {
          final raf = file.openSync();
          try {
            final fBytes = raf.readSync(3);
            if (fBytes.length > 2 &&
                fBytes[0] == 0x47 &&
                fBytes[1] == 0x49 &&
                fBytes[2] == 0x46) {
              isAnimated = true;
            }
          } finally {
            raf.closeSync();
          }
        }
      } catch (_) {}
    }

    if (_resolvedFilePath == null && !isAnimated) {
      final Color bg =
          pageBgColor ??
          getBackgroundColor(ref.watch(backgroundColorStateProvider)) ??
          Colors.black;
      return Container(
        color: bg,
        child: const Center(
          child: CircularProgressIndicatorAnimateRotate(progress: 0),
        ),
      );
    }

    final ssivScaleType = switch (scaleType) {
      ScaleType.fitScreen => ssiv.ScaleType.centerInside,
      ScaleType.stretch => ssiv.ScaleType.centerCrop,
      ScaleType.fitWidth => ssiv.ScaleType.fitWidth,
      ScaleType.fitHeight => ssiv.ScaleType.fitHeight,
      ScaleType.originalSize => ssiv.ScaleType.originalSize,
      ScaleType.smartFit => ssiv.ScaleType.smartFit,
    };

    Widget content;
    if (isAnimated) {
      content = Image(
        image: image,
        fit: effectiveFit,
        color: color,
        colorBlendMode: colorBlendMode,
      );
    } else {
      content = ssiv.SubsamplingScaleImageView(
        image: image,
        resolvedFilePath: _resolvedFilePath,
        preloadData: widget.data,
        colorBlendMode: colorBlendMode,
        color: color,
        minimumScaleType: ssivScaleType,
        filterQuality: FilterQuality.medium,
        zoomEnabled: widget.zoomEnabled,
        panEnabled: widget.panEnabled,
        cropBorders: cropBorders,
        srcRect: widget.data.srcRect,
        onImageLoaded: widget.onImageLoaded,
        loadStateChanged: widget.loadStateChanged,
        pageController: widget.pageController,
        rotation: rotation,
        controller: widget.controller,
        isVisible: widget.isVisible,
        doubleTapZoomDuration: _doubleTapAnimationDuration(),
        onReady: _checkLandscapeZoom,
      );
    }

    if (pageBgColor != null) {
      content = Container(color: pageBgColor, child: content);
    }

    return applyReaderColorFilter(
      GestureDetector(
        onLongPress: () => widget.onLongPressData.call(widget.data),
        child: content,
      ),
      ref,
    );
  }
}
