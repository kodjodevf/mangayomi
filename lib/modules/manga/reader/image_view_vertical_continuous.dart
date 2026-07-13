import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/continuous_reader_layout_policy.dart';
import 'package:mangayomi/modules/manga/reader/image_view_continuous.dart';

class ImageViewVerticalContinuous extends ImageViewContinuous {
  ImageViewVerticalContinuous({
    super.key,
    required super.pages,
    required super.itemScrollController,
    required super.scrollOffsetController,
    required super.itemPositionsListener,
    required super.minCacheExtent,
    required super.initialScrollIndex,
    required super.physics,
    required super.onLongPressData,
    required super.onFailedToLoadImage,
    required super.backgroundColor,
    required super.isDoublePageMode,
    required super.photoViewController,
    required super.photoViewScaleStateController,
    required super.scalePosition,
    required super.onScaleEnd,
    required super.onDoubleTapDown,
    required super.onDoubleTap,
    required super.isScrolling,
    required ScaleType scaleType,
    required bool showPageGaps,
  }) : super(
         scrollDirection: Axis.vertical,
         isHorizontalContinuous: false,
         reverse: false,
         layoutPolicy: ContinuousReaderLayoutPolicy.verticalContinuous(
           scaleType: scaleType,
           showPageGaps: showPageGaps,
         ),
       );
}
