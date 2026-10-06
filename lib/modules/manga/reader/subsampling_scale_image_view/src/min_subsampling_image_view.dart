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
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';

class MinSubsamplingImage extends ConsumerStatefulWidget {
  final UChapDataPreload data;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool cropBorders;
  final bool isHorizontal;
  final Function(bool) failedToLoadImage;

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
  int _autoRetryCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.data.decodedImage != null) {
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
    } else {
      _loadImage();
    }
  }

  @override
  void didUpdateWidget(MinSubsamplingImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool dataChanged = widget.data != oldWidget.data;
    if (dataChanged) {
      _cleanStream();
      ffiImageDecoder.cancel(this);
      _uiImage?.dispose();
      _uiImage = null;
      _isLoading = true;
      _hasError = false;
      _loadingProgress = null;
      _autoRetryCount = 0;
      if (widget.data.decodedImage != null) {
        _uiImage = widget.data.decodedImage!.clone();
        _isLoading = false;
        _hasError = false;
        return;
      }
      _loadImage(refresh: false);
      return;
    }
    if (widget.cropBorders != oldWidget.cropBorders) {
      _isLoading = true;
      _hasError = false;
      _loadImage(refresh: true, evictCache: false);
      return;
    }
    final bool imageLoaded =
        _uiImage == null && widget.data.decodedImage != null;
    if (imageLoaded) {
      _uiImage?.dispose();
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
      return;
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

  Future<void> _loadImage({
    bool refresh = false,
    bool evictCache = false,
  }) async {
    _cleanStream();
    ffiImageDecoder.cancel(this);

    if (evictCache) {
      widget.data.decodedImage?.dispose();
      widget.data.decodedImage = null;
      widget.data.resolvedFilePath = null;
      _uiImage?.dispose();
      _uiImage = null;
      try {
        final provider = widget.data.getImageProvider(ref, true);
        await provider.evict();
      } catch (_) {}
      _autoRetryCount = 0;
    } else if (refresh) {
      widget.data.decodedImage?.dispose();
      widget.data.decodedImage = null;
      _autoRetryCount = 0;
    }

    if (widget.data.decodedImage != null && !refresh && !evictCache) {
      _uiImage ??= widget.data.decodedImage!.clone();
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

    final String? path =
        widget.data.resolvedFilePath ?? await widget.data.getLocalFilePath;
    if (path != null) {
      widget.data.resolvedFilePath = path;
    }
    if (path != null && widget.cropBorders) {
      await _loadFromPath(path);
    } else {
      final provider = widget.data.getImageProvider(ref, true);
      _imageStream = provider.resolve(ImageConfiguration.empty);
      _streamListener = ImageStreamListener(
        (info, syncCall) async {
          _cleanStream();
          final cachedPath =
              widget.data.resolvedFilePath ??
              await widget.data.getLocalFilePath;
          if (cachedPath != null) {
            widget.data.resolvedFilePath = cachedPath;
          }
          if (widget.cropBorders) {
            if (cachedPath != null) {
              await _loadFromPath(cachedPath);
              return;
            }
          }
          if (mounted) {
            _autoRetryCount = 0;
            widget.data.loadedWidth = info.image.width.toDouble();
            widget.data.loadedHeight = info.image.height.toDouble();
            widget.data.decodedImage?.dispose();
            widget.data.decodedImage = info.image.clone();
            final old = _uiImage;
            setState(() {
              _uiImage = info.image.clone();
              _isLoading = false;
              _loadingProgress = null;
            });
            old?.dispose();
            widget.failedToLoadImage(false);
            widget.onImageLoaded?.call(
              info.image.width.toDouble(),
              info.image.height.toDouble(),
            );
          }
        },
        onChunk: (ImageChunkEvent event) {
          if (mounted) {
            setState(() {
              _loadingProgress = event;
            });
          }
        },
        onError: (err, stack) async {
          _cleanStream();
          if (mounted) {
            if (_autoRetryCount < 3) {
              _autoRetryCount++;
              try {
                final provider = widget.data.getImageProvider(ref, true);
                await provider.evict();
              } catch (_) {}
              Future.delayed(Duration(milliseconds: 300 * _autoRetryCount), () {
                if (mounted) {
                  _loadImage(refresh: true, evictCache: false);
                }
              });
              return;
            }
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
        // If operation was cancelled by a quick toggle, return quietly without error
        return;
      }

      final int croppedWidth = dims[0];
      final int croppedHeight = dims[1];

      if (!mounted) return;

      widget.data.loadedWidth = croppedWidth.toDouble();
      widget.data.loadedHeight = croppedHeight.toDouble();

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

      if (result == null || result.error == 'Cancelled') {
        return;
      }

      if (result.pointerAddress == null || result.error != null) {
        throw Exception(result.error ?? "Failed to decode region");
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
        _autoRetryCount = 0;
        widget.data.resolvedFilePath = path;
        widget.data.decodedImage?.dispose();
        widget.data.decodedImage = img.clone();
        final old = _uiImage;
        setState(() {
          _uiImage = img;
          _isLoading = false;
          _hasError = false;
        });
        old?.dispose();
        widget.failedToLoadImage(false);
        widget.onImageLoaded?.call(
          croppedWidth.toDouble(),
          croppedHeight.toDouble(),
        );
      } else {
        img.dispose();
      }
    } catch (e) {
      if (e.toString().contains('Cancelled')) return;
      if (mounted) {
        if (_autoRetryCount < 3) {
          _autoRetryCount++;
          Future.delayed(Duration(milliseconds: 300 * _autoRetryCount), () {
            if (mounted) {
              _loadImage(refresh: true, evictCache: false);
            }
          });
          return;
        }
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
    if (_uiImage == null && widget.data.decodedImage != null) {
      _uiImage?.dispose();
      _uiImage = widget.data.decodedImage!.clone();
      _isLoading = false;
      _hasError = false;
    }

    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final subsamplingState = SubsamplingImageState(
      loadState: _hasError
          ? LoadState.failed
          : (_isLoading || _uiImage == null)
              ? LoadState.loading
              : LoadState.completed,
      loadingProgress: _loadingProgress,
      reLoadCallback: () {
        widget.failedToLoadImage(false);
        _loadImage(refresh: true, evictCache: true);
      },
    );

    if (widget.loadStateChanged != null) {
      final customWidget = widget.loadStateChanged!(subsamplingState);
      if (customWidget != null) return customWidget;
    }

    final hasDimensions =
        widget.data.loadedHeight != null &&
        widget.data.loadedWidth != null &&
        widget.data.loadedWidth! > 0 &&
        widget.data.loadedHeight! > 0;

    final isRotated = widget.rotation == 90 || widget.rotation == 270;
    final effW = isRotated ? widget.data.loadedHeight : widget.data.loadedWidth;
    final effH = isRotated ? widget.data.loadedWidth : widget.data.loadedHeight;

    final placeholderHeight = hasDimensions
        ? (widget.isHorizontal
              ? context.height(0.8)
              : MediaQuery.of(context).size.width * (effH! / effW!))
        : context.height(0.8);
    final placeholderWidth = widget.isHorizontal
        ? (hasDimensions
              ? context.height(0.8) * (effW! / effH!)
              : (effW ?? context.width(0.8)))
        : double.infinity;

    if (_hasError) {
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
              child: ReaderInteractiveRegion(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                  onPressed: () {
                    widget.failedToLoadImage(false);
                    _loadImage(refresh: true, evictCache: true);
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(l10n.retry),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading || _uiImage == null) {
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
