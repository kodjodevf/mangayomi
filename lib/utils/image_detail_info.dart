import 'dart:math';
import 'package:flutter/material.dart' hide Image;

class ImageDetailInfo {
  ImageDetailInfo({
    required this.imageDRect,
    required this.pageSize,
    required this.imageInfo,
  });
  final GlobalKey<State<StatefulWidget>> key = GlobalKey<State>();

  final Rect imageDRect;

  final Size pageSize;

  final ImageInfo imageInfo;

  double? _maxImageDetailY;
  double get imageBottom => imageDRect.bottom - 20;
  double get maxImageDetailY {
    try {
      //
      return _maxImageDetailY ??= max(
          key.currentContext!.size!.height - (pageSize.height - imageBottom),
          0.1);
    } catch (e) {
      //currentContext is not ready
      return 100.0;
    }
  }
}
