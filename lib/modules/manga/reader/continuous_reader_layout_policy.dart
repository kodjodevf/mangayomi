import 'package:flutter/foundation.dart';
import 'package:mangayomi/models/settings.dart';

@immutable
class ContinuousReaderLayoutPolicy {
  final bool fillAvailableWidth;
  final int sidePaddingPercent;
  final bool showPageGaps;

  const ContinuousReaderLayoutPolicy.verticalContinuous({
    required ScaleType scaleType,
    required this.showPageGaps,
  }) : fillAvailableWidth = scaleType == ScaleType.fitWidth,
       sidePaddingPercent = 0;

  const ContinuousReaderLayoutPolicy.webtoon({required this.sidePaddingPercent})
    : fillAvailableWidth = false,
      showPageGaps = false;

  const ContinuousReaderLayoutPolicy.horizontal({required this.showPageGaps})
    : fillAvailableWidth = false,
      sidePaddingPercent = 0;
}
