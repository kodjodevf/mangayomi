import 'dart:async';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart';

class MinSubsamplingImage extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool cropBorders;
  final bool isHorizontal;
  final Function(bool) failedToLoadImage;
  final ValueNotifier<bool> isVisible;

  final Widget? Function(SubsamplingImageState)? loadStateChanged;
  final int rotation;
  final Function(double width, double height)? onImageLoaded;

  const MinSubsamplingImage({
    super.key,
    required this.data,
    required this.fit,
    this.color,
    this.colorBlendMode,
    required this.cropBorders,
    required this.isHorizontal,
    required this.failedToLoadImage,
    required this.isVisible,
    this.loadStateChanged,
    this.rotation = 0,
    this.onImageLoaded,
  });

  @override
  ConsumerState<MinSubsamplingImage> createState() =>
      _MinSubsamplingImageState();
}

class _MinSubsamplingImageState extends ConsumerState<MinSubsamplingImage> {
  ui.Image? _uiImage;
  bool _isLoading = true;
  bool _hasError = false;
  ImageStreamListener? _streamListener;
  ImageStream? _imageStream;
  ImageChunkEvent? _loadingProgress;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(MinSubsamplingImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.cropBorders != oldWidget.cropBorders) {
      _loadImage(refresh: true);
    }
  }

  @override
  void dispose() {
    _cleanStream();
    ffiImageDecoder.cancel(this);
    _uiImage?.dispose();
    super.dispose();
  }

  void _cleanStream() {
    if (_streamListener != null && _imageStream != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _streamListener = null;
    _imageStream = null;
  }

  Future<void> _loadImage({bool refresh = false}) async {
    _cleanStream();
    ffiImageDecoder.cancel(this);

    if (widget.data.decodedImage != null && !refresh) {
      _uiImage = widget.data.decodedImage!.clone();
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = false;
          _loadingProgress = null;
        });
        widget.failedToLoadImage(false);
      }
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _loadingProgress = null;
      });
    }

    final String? path = await widget.data.getLocalFilePath;
    if (path != null) {
      await _loadFromPath(path);
    } else {
      final provider = widget.data.getImageProvider(ref, true);
      _imageStream = provider.resolve(ImageConfiguration.empty);
      _streamListener = ImageStreamListener(
        (info, syncCall) async {
          _cleanStream();
          final cachedPath = await widget.data.getLocalFilePath;
          if (cachedPath != null) {
            await _loadFromPath(cachedPath);
          } else {
            if (mounted) {
              widget.data.decodedImage = info.image.clone();
              setState(() {
                _uiImage = info.image.clone();
                _isLoading = false;
                _loadingProgress = null;
              });
              widget.failedToLoadImage(false);
            }
          }
        },
        onChunk: (ImageChunkEvent event) {
          if (mounted) {
            setState(() {
              _loadingProgress = event;
            });
          }
        },
        onError: (err, stack) {
          _cleanStream();
          if (mounted) {
            setState(() {
              _hasError = true;
              _isLoading = false;
              _loadingProgress = null;
            });
            widget.failedToLoadImage(true);
          }
        },
      );
      _imageStream!.addListener(_streamListener!);
    }
  }

  Future<void> _loadFromPath(String path) async {
    if (!mounted) return;

    try {
      final dims = await ffiImageDecoder.getImageDimensionsAsync(
        path,
        cropBorders: widget.cropBorders,
        cancelToken: this,
      );

      if (dims == null || dims.length < 2) {
        throw Exception("Failed to get dimensions");
      }

      final int croppedWidth = dims[0];
      final int croppedHeight = dims[1];

      if (!mounted) return;

      final bool isRotated = widget.rotation == 90 || widget.rotation == 270;
      final double aspect = isRotated
          ? (croppedHeight / croppedWidth)
          : (croppedWidth / croppedHeight);
      double targetWidth;
      double targetHeight;

      if (widget.isHorizontal) {
        final screenHeight =
            MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom;
        targetHeight = screenHeight;
        targetWidth = screenHeight * aspect;
      } else {
        final screenWidth = MediaQuery.of(context).size.width;
        targetWidth = screenWidth;
        targetHeight = screenWidth / aspect;
      }

      widget.data.loadedWidth = targetWidth;
      widget.data.loadedHeight = targetHeight;

      const int sampleSize = 1;

      final result = await ffiImageDecoder.decodeRegionAsync(
        DecodeParams(
          filePath: path,
          left: 0,
          top: 0,
          right: croppedWidth,
          bottom: croppedHeight,
          sampleSize: sampleSize,
          cropBorders: widget.cropBorders,
        ),
        cancelToken: this,
      );

      if (result == null ||
          result.pointerAddress == null ||
          result.error != null) {
        throw Exception(result?.error ?? "Failed to decode region");
      }

      final decodedWidth = croppedWidth ~/ sampleSize;
      final decodedHeight = croppedHeight ~/ sampleSize;

      final pointer = Pointer<Uint8>.fromAddress(result.pointerAddress!);
      final bytes = pointer.asTypedList(decodedWidth * decodedHeight * 4);

      final Completer<ui.Image> completer = Completer<ui.Image>();
      try {
        ui.decodeImageFromPixels(
          bytes,
          decodedWidth,
          decodedHeight,
          ui.PixelFormat.rgba8888,
          (ui.Image img) {
            calloc.free(pointer);
            completer.complete(img);
          },
        );
      } catch (e) {
        calloc.free(pointer);
        rethrow;
      }

      final ui.Image img = await completer.future;

      if (mounted) {
        widget.data.decodedImage = img.clone();
        setState(() {
          _uiImage = img;
          _isLoading = false;
        });
        widget.failedToLoadImage(false);
        widget.onImageLoaded?.call(
          croppedWidth.toDouble(),
          croppedHeight.toDouble(),
        );
      } else {
        img.dispose();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _loadingProgress = null;
        });
        widget.failedToLoadImage(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final subsamplingState = SubsamplingImageState(
      loadState: _isLoading
          ? LoadState.loading
          : _hasError
          ? LoadState.failed
          : LoadState.completed,
      loadingProgress: _loadingProgress,
      reLoadCallback: _loadImage,
    );

    if (widget.loadStateChanged != null) {
      final customWidget = widget.loadStateChanged!(subsamplingState);
      if (customWidget != null) return customWidget;
    }

    final placeholderHeight = widget.data.loadedHeight ?? context.height(0.8);
    final placeholderWidth = widget.isHorizontal
        ? (widget.data.loadedWidth ?? context.width(0.8))
        : null;

    if (_isLoading && _uiImage == null) {
      final double progress = _loadingProgress?.expectedTotalBytes != null
          ? _loadingProgress!.cumulativeBytesLoaded /
                _loadingProgress!.expectedTotalBytes!
          : 0;
      return Container(
        color: getBackgroundColor(backgroundColor),
        height: placeholderHeight,
        width: placeholderWidth,
        child: CircularProgressIndicatorAnimateRotate(progress: progress),
      );
    }

    if (_hasError || _uiImage == null) {
      final l10n = l10nLocalizations(context)!;
      return Container(
        color: getBackgroundColor(backgroundColor),
        height: placeholderHeight,
        width: placeholderWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.image_loading_error,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _loadImage,
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

    final Widget rawImage = RawImage(
      image: _uiImage,
      fit: widget.fit,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
      filterQuality: FilterQuality.medium,
    );

    if (widget.rotation != 0) {
      final quarterTurns = (widget.rotation ~/ 90) % 4;
      if (quarterTurns != 0) {
        return RotatedBox(quarterTurns: quarterTurns, child: rawImage);
      }
    }

    return rawImage;
  }
}
