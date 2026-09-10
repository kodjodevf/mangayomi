import 'dart:async';
import 'dart:math';

import 'package:mangayomi/utils/platform_utils.dart';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/custom_track_shape.dart';
import 'package:mangayomi/modules/anime/widgets/player_theme.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

class CustomSeekBar extends StatefulWidget {
  final Player player;
  final Duration? delta;
  final Function(Duration)? onSeekStart;
  final Function(Duration)? onSeekEnd;
  final ValueNotifier<List<(String, int)>> chapterMarks;
  final ValueChanged<bool>? onHoverChanged;

  const CustomSeekBar({
    super.key,
    this.onSeekStart,
    this.onSeekEnd,
    required this.player,
    this.delta,
    required this.chapterMarks,
    this.onHoverChanged,
  });

  @override
  CustomSeekBarState createState() => CustomSeekBarState();
}

class CustomSeekBarState extends State<CustomSeekBar> {
  Duration? tempPosition;
  late Player player = widget.player;
  Duration position = Duration.zero;
  late Duration duration = player.state.duration;
  Duration buffer = Duration.zero;

  bool _dragging = false;
  // Mouse-only: moving the cursor over the track previews the timecode there
  // without touching playback, same as dragging does — just without a seek.
  bool _hovering = false;
  double? _hoverFraction;
  Duration? _hoverPosition;

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<Duration>? _bufferSubscription;

  @override
  void initState() {
    super.initState();
    _positionSubscription = player.stream.position.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });
    _durationSubscription = player.stream.duration.listen((event) {
      if (mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    _bufferSubscription = player.stream.buffer.listen((event) {
      if (mounted) {
        setState(() {
          buffer = event;
        });
      }
    });
    position = player.state.position;
    duration = player.state.duration;
    buffer = player.state.buffer;
  }

  @override
  void dispose() {
    if (_hovering) widget.onHoverChanged?.call(false);
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _bufferSubscription?.cancel();
    super.dispose();
  }

  void _onTrackHover(double localDx, double trackWidth) {
    if (trackWidth <= 0 || duration <= Duration.zero) return;
    final wasHovering = _hovering;
    if (!wasHovering) widget.onHoverChanged?.call(true);
    final fraction = (localDx / trackWidth).clamp(0.0, 1.0);
    final target = Duration(
      milliseconds: (fraction * duration.inMilliseconds).round(),
    );
    setState(() {
      _hovering = true;
      _hoverFraction = fraction;
      _hoverPosition = target;
    });
  }

  void _onTrackHoverExit() {
    if (_hovering) widget.onHoverChanged?.call(false);
    if (!mounted) return;
    setState(() {
      _hovering = false;
      _hoverFraction = null;
      _hoverPosition = null;
    });
  }

  String? _chapterLabelAt(int positionMs) {
    final marks = widget.chapterMarks.value;
    if (marks.isEmpty) return null;
    (String, int)? current;
    for (final mark in marks) {
      if (mark.$2 <= positionMs) {
        current = mark;
      } else {
        break;
      }
    }
    return current?.$1;
  }

  @override
  Widget build(BuildContext context) {
    final maxValue = max(duration.inMilliseconds.toDouble(), 0).toDouble();
    final rawValue = (widget.delta ?? tempPosition ?? position).inMilliseconds
        .toDouble();
    final clampedValue = rawValue.clamp(0, maxValue).toDouble();
    final previewPosition = widget.delta ?? tempPosition ?? position;
    final fraction = maxValue > 0 ? (clampedValue / maxValue) : 0.0;
    // While dragging, the bubble tracks the drag; while only hovering (mouse,
    // no button down), it tracks the cursor instead — dragging always wins if
    // somehow both are true (e.g. mouse-down before the hover state cleared).
    final bubbleFraction = _dragging ? fraction : (_hoverFraction ?? fraction);
    final bubblePosition = _dragging
        ? previewPosition
        : (_hoverPosition ?? previewPosition);
    final showBubble = _dragging || _hovering;
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          if (!isDesktop)
            SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  (widget.delta ?? tempPosition ?? position).label(
                    reference: duration,
                  ),
                  style: PlayerTheme.timecode,
                ),
              ),
            ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => MouseRegion(
                opaque: true,
                hitTestBehavior: HitTestBehavior.opaque,
                onHover: (event) =>
                    _onTrackHover(event.localPosition.dx, constraints.maxWidth),
                onExit: (_) {
                  _onTrackHoverExit();
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: isDesktop ? null : 3,
                        activeTrackColor: context.primaryColor,
                        inactiveTrackColor: PlayerTheme.trackIdle,
                        secondaryActiveTrackColor: PlayerTheme.trackBuffer,
                        overlayColor: context.primaryColor.withValues(
                          alpha: 0.16,
                        ),
                        thumbShape: const _CapsuleThumbShape(),
                        trackShape: CustomTrackShape(
                          currentPosition: clampedValue,
                          bufferPosition: max(
                            buffer.inMilliseconds.toDouble(),
                            0,
                          ),
                          maxValue: maxValue < 1 ? 1 : maxValue,
                          minValue: 0,
                          chapterMarks: widget.chapterMarks.value,
                          chapterMarkWidth: 10,
                        ),
                      ),
                      child: Slider(
                        max: maxValue,
                        value: clampedValue,
                        secondaryTrackValue: max(
                          buffer.inMilliseconds.toDouble(),
                          0,
                        ),
                        onChangeStart: (value) {
                          setState(() => _dragging = true);
                        },
                        onChanged: (value) {
                          widget.onSeekStart?.call(
                            Duration(
                              milliseconds:
                                  value.toInt() - position.inMilliseconds,
                            ),
                          );
                          if (mounted) {
                            setState(() {
                              tempPosition = Duration(
                                milliseconds: value.toInt(),
                              );
                            });
                          }
                        },
                        onChangeEnd: (value) async {
                          widget.onSeekEnd?.call(
                            Duration(
                              milliseconds:
                                  value.toInt() - position.inMilliseconds,
                            ),
                          );
                          widget.player.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                          setState(() {
                            _dragging = false;
                          });
                        },
                      ),
                    ),
                    if (showBubble)
                      Positioned(
                        bottom: 26,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment(
                              (bubbleFraction * 2 - 1).clamp(-1.0, 1.0),
                              0,
                            ),
                            child: _ScrubPreviewBubble(
                              label: bubblePosition.label(reference: duration),
                              chapterLabel: _chapterLabelAt(
                                bubblePosition.inMilliseconds,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (!isDesktop)
            SizedBox(
              width: 70,
              child: Center(
                child: Text(
                  duration.label(reference: duration),
                  style: PlayerTheme.timecode,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The floating bubble shown above the thumb while scrubbing: shows the
/// target timecode (and the chapter it falls in, if any).
class _ScrubPreviewBubble extends StatelessWidget {
  final String label;
  final String? chapterLabel;

  const _ScrubPreviewBubble({required this.label, this.chapterLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: PlayerTheme.glassStrong,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: PlayerTheme.timecode.copyWith(fontWeight: FontWeight.w600),
          ),
          if (chapterLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                chapterLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5, color: context.primaryColor),
              ),
            ),
        ],
      ),
    );
  }
}

/// A slim white capsule with a soft amber halo, replacing the default round
/// Material thumb — it reads as one object with the richly-painted
/// [CustomTrackShape] instead of a generic slider blob dropped on top of it.
class _CapsuleThumbShape extends SliderComponentShape {
  const _CapsuleThumbShape();

  static const double _width = 4.0;
  static const double _height = 14.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(_width, _height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final haloRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: _width + 6, height: _height + 6),
      const Radius.circular(5),
    );
    final accentColor = sliderTheme.activeTrackColor ?? PlayerTheme.accent;
    canvas.drawRRect(
      haloRect,
      Paint()..color = accentColor.withValues(alpha: 0.28),
    );
    final thumbRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: _width, height: _height),
      const Radius.circular(2),
    );
    canvas.drawRRect(thumbRect, Paint()..color = Colors.white);
  }
}
