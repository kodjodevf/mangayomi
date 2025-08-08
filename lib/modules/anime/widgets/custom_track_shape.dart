import 'dart:math';

import 'package:flutter/material.dart';

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
    final double thumbWidth = sliderTheme.thumbShape!
        .getPreferredSize(isEnabled ?? true, isDiscrete ?? false)
        .width;
    final double trackHeight = sliderTheme.trackHeight!;

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
    double currentPositionWidth = (trackWidth / maxValue) * currentPosition;
    double bufferPositionWidth = (trackWidth / maxValue) * bufferPosition;

    _drawActiveThumb(context, sliderTheme, trackRect, currentPositionWidth);
    _drawBufferThumb(
      context,
      sliderTheme,
      trackRect,
      currentPositionWidth,
      bufferPositionWidth,
    );
    _drawInactiveThumb(context, sliderTheme, trackRect, currentPositionWidth);

    for (final mark in chapterMarks) {
      double markPositionWidth = (trackWidth / maxValue) * mark.$2;
      _drawChapterMark(context, sliderTheme, trackRect, markPositionWidth);
    }
  }

  void _drawActiveThumb(
    PaintingContext context,
    SliderThemeData sliderTheme,
    Rect trackRect,
    double currentPositionWidth,
  ) {
    final Paint defaultPathPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final defaultPathSegment = Path()
      ..addRect(
        Rect.fromPoints(
          Offset(trackRect.left, trackRect.top),
          Offset(trackRect.left + currentPositionWidth, trackRect.bottom),
        ),
      )
      ..lineTo(trackRect.left, trackRect.bottom)
      ..arcTo(
        Rect.fromPoints(
          Offset(trackRect.left + 5, trackRect.top),
          Offset(trackRect.left - 5, trackRect.bottom),
        ),
        -pi * 3 / 2,
        pi,
        false,
      );

    context.canvas.drawPath(defaultPathSegment, defaultPathPaint);
  }

  void _drawBufferThumb(
    PaintingContext context,
    SliderThemeData sliderTheme,
    Rect trackRect,
    double currentPositionWidth,
    double bufferPositionWidth,
  ) {
    final Paint defaultPathPaint = Paint()
      ..color = sliderTheme.secondaryActiveTrackColor!
      ..style = PaintingStyle.fill;

    final defaultPathSegment = Path()
      ..addRect(
        Rect.fromPoints(
          Offset(trackRect.left + currentPositionWidth, trackRect.top),
          Offset(trackRect.left + bufferPositionWidth, trackRect.bottom),
        ),
      )
      ..lineTo(trackRect.left, trackRect.bottom)
      ..arcTo(
        Rect.fromPoints(
          Offset(trackRect.left + 5, trackRect.top),
          Offset(trackRect.left - 5, trackRect.bottom),
        ),
        -pi * 3 / 2,
        pi,
        false,
      );

    context.canvas.drawPath(defaultPathSegment, defaultPathPaint);
  }

  void _drawInactiveThumb(
    PaintingContext context,
    SliderThemeData sliderTheme,
    Rect trackRect,
    double currentPositionWidth,
  ) {
    final unselectedPathPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = sliderTheme.inactiveTrackColor!;

    final unselectedPathSegment = Path()
      ..addRect(
        Rect.fromPoints(
          Offset(trackRect.right, trackRect.top),
          Offset(trackRect.left + currentPositionWidth, trackRect.bottom),
        ),
      )
      ..addArc(
        Rect.fromPoints(
          Offset(trackRect.right - 5, trackRect.bottom),
          Offset(trackRect.right + 5, trackRect.top),
        ),
        -pi / 2,
        pi,
      );

    context.canvas.drawPath(unselectedPathSegment, unselectedPathPaint);
  }

  void _drawChapterMark(
    PaintingContext context,
    SliderThemeData sliderTheme,
    Rect trackRect,
    double markPositionWidth,
  ) {
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final pathSegmentSelected = Path()
      ..addRect(
        Rect.fromPoints(
          Offset(trackRect.left + markPositionWidth, trackRect.top),
          Offset(
            trackRect.left + markPositionWidth + chapterMarkWidth,
            trackRect.bottom,
          ),
        ),
      );

    context.canvas.drawPath(pathSegmentSelected, borderPaint);
  }
}
