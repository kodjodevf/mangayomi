import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

/// The "+10s" / "-10s" bubble shown while seeking by swipe or double tap.
Widget seekIndicatorTextWidget(Duration duration, Duration currentPosition) {
  final swipeDuration = duration.inSeconds;
  return Builder(
    builder: (ctx) {
      final accent = ctx.primaryColor;
      final colorScheme = Theme.of(ctx).colorScheme;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.90),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              swipeDuration > 0
                  ? "+${Duration(seconds: swipeDuration).label()}"
                  : "-${Duration(seconds: swipeDuration).label()}",
              style: TextStyle(
                fontSize: 20.0,
                color: accent,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      );
    },
  );
}
