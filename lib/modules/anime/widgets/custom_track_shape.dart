import 'package:flutter/material.dart';

/// Material Design 3 Slider Track Shape with support for buffer progress and chapter mark ticks.
class CustomTrackShape extends SliderTrackShape {
  final double maxValue;
  final double minValue;
  final double currentPosition;
  final double bufferPosition;
  final List<(String, int)> chapterMarks;
  final double chapterMarkWidth;
  double trackWidth;

  CustomTrackShape({
    required this.maxValue,
    required this.minValue,
    required this.currentPosition,
    required this.bufferPosition,
    required this.chapterMarks,
    this.chapterMarkWidth = 3,
    this.trackWidth = 5,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool? isEnabled,
    bool? isDiscrete,
  }) {
    final double thumbWidth = sliderTheme.thumbShape
            ?.getPreferredSize(isEnabled ?? true, isDiscrete ?? false)
            .width ??
        12.0;
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;

    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackLeft = offset.dx + thumbWidth / 2;
    trackWidth = parentBox.size.width - thumbWidth;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool? isEnabled,
    bool? isDiscrete,
    required TextDirection textDirection,
  }) {
    if (sliderTheme.trackHeight == 0) return;
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final double activeFraction = maxValue > 0 ? (currentPosition / maxValue).clamp(0.0, 1.0) : 0.0;
    final double bufferFraction = maxValue > 0 ? (bufferPosition / maxValue).clamp(0.0, 1.0) : 0.0;

    final double currentPositionWidth = trackWidth * activeFraction;
    final double bufferPositionWidth = trackWidth * bufferFraction;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    final canvas = context.canvas;

    // 1. Inactive full track (M3 base)
    final inactivePaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0x33FFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, trackRadius),
      inactivePaint,
    );

    // 2. Buffer track
    if (bufferPositionWidth > 0) {
      final bufferRect = Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        (trackRect.left + bufferPositionWidth).clamp(trackRect.left, trackRect.right),
        trackRect.bottom,
      );
      final bufferPaint = Paint()
        ..color = sliderTheme.secondaryActiveTrackColor ?? const Color(0x66FFFFFF)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(bufferRect, trackRadius),
        bufferPaint,
      );
    }

    // 3. Active track
    if (currentPositionWidth > 0) {
      final activeRect = Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        (trackRect.left + currentPositionWidth).clamp(trackRect.left, trackRect.right),
        trackRect.bottom,
      );
      final activePaint = Paint()
        ..color = sliderTheme.activeTrackColor ?? const Color(0xFFFFFFFF)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(activeRect, trackRadius),
        activePaint,
      );
    }

    // 4. Chapter Marks / Ticks
    if (chapterMarks.isNotEmpty && maxValue > 0) {
      final markPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.fill;

      for (final mark in chapterMarks) {
        final double markFraction = (mark.$2 / maxValue).clamp(0.0, 1.0);
        final double markX = trackRect.left + (trackWidth * markFraction);
        final markRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(
            markX - (chapterMarkWidth / 2),
            trackRect.top - 1.5,
            chapterMarkWidth,
            trackRect.height + 3.0,
          ),
          const Radius.circular(2),
        );
        canvas.drawRRect(markRect, markPaint);
      }
    }
  }
}
