import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/headers.dart';
import 'package:mangayomi/utils/reg_exp_matcher.dart';

class ImageViewHorizontal extends StatefulWidget {
  final int length;
  final String url;
  final int index;
  final String titleManga;
  final String source;
  final String chapter;
  final Directory path;
  final Widget? Function(ExtendedImageState state) loadStateChanged;
  final Function(ExtendedImageGestureState state) onDoubleTap;
  final GestureConfig Function(ExtendedImageState state)
      initGestureConfigHandler;
  const ImageViewHorizontal({
    super.key,
    required this.url,
    required this.chapter,
    required this.index,
    required this.path,
    required this.titleManga,
    required this.source,
    required this.length,
    required this.loadStateChanged,
    required this.onDoubleTap,
    required this.initGestureConfigHandler,
  });

  @override
  State createState() => _ImageViewHorizontalState();
}

typedef DoubleClickAnimationListener = void Function();

class _ImageViewHorizontalState extends State<ImageViewHorizontal> {
  @override
  void initState() {
    _localCheck();
    super.initState();
  }

  _localCheck() async {
    if (await File("${widget.path.path}" "${padIndex(widget.index + 1)}.jpg")
        .exists()) {
      if (mounted) {
        setState(() {
          _isLocale = true;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLocale = false;
          _isLoading = false;
        });
      }
    }
  }

  bool _isLoading = true;
  bool _isLocale = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _isLocale
            ? ExtendedImage.file(
                File("${widget.path.path}" "${padIndex(widget.index + 1)}.jpg"),
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: widget.initGestureConfigHandler,
                onDoubleTap: widget.onDoubleTap,
                loadStateChanged: widget.loadStateChanged,
              )
            : ExtendedImage.network(
                widget.url,
                cache: true,
                clearMemoryCacheWhenDispose: true,
                enableMemoryCache: false,
                cacheMaxAge: const Duration(days: 7),
                headers: headers(widget.source),
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: widget.initGestureConfigHandler,
                onDoubleTap: widget.onDoubleTap,
                handleLoadingProgress: true,
                loadStateChanged: widget.loadStateChanged,
              );
  }
}
