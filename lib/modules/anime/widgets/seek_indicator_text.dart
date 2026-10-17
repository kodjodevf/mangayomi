import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_overlay_surface.dart';
import 'package:shiori/shiori.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

/// The "+10s" / "-10s" bubble shown while seeking by swipe or double tap.
Widget seekIndicatorTextWidget(Duration duration, Duration currentPosition) {
  final swipeDuration = duration.inSeconds;
  return Builder(
    builder: (ctx) => PlayerOverlaySurface(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s24,
        vertical: ShioriSpace.s8,
      ),
      child: Text(
        swipeDuration > 0
            ? "+${Duration(seconds: swipeDuration).label()}"
            : "-${Duration(seconds: swipeDuration).label()}",
        style: TextStyle(fontSize: ctx.shiori.text.seriesTitle.fontSize),
      ),
    ),
  );
}
