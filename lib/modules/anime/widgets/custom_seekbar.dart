import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';

class CustomSeekBar extends StatefulWidget {
  final Player player;
  final Duration? delta;
  final Function(Duration)? onSeekStart;
  final Function(Duration)? onSeekEnd;
  final Function(bool) isDragging;
  final Function(double?) dragPosition;
  final Function(Duration) onDragDuration;

  const CustomSeekBar(
      {super.key,
      this.onSeekStart,
      this.onSeekEnd,
      required this.player,
      this.delta,
      required this.isDragging,
      required this.dragPosition,
      required this.onDragDuration});

  @override
  CustomSeekBarState createState() => CustomSeekBarState();
}

class CustomSeekBarState extends State<CustomSeekBar> {
  Duration? tempPosition;
  late Player player = widget.player;
  Duration position = Duration.zero;
  late Duration duration = player.state.duration;
  Duration buffer = Duration.zero;

  @override
  void initState() {
    player.stream.position.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });
    player.stream.duration.listen((event) {
      if (mounted) {
        setState(() {
          duration = event;
        });
      }
    });
    player.stream.buffer.listen((event) {
      if (mounted) {
        setState(() {
          buffer = event;
        });
      }
    });
    position = player.state.position;
    duration = player.state.duration;
    buffer = player.state.buffer;
    super.initState();
  }

  final isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  final GlobalKey _sliderKey = GlobalKey();

  void _onMove(PointerEvent details) {
    final RenderBox box =
        _sliderKey.currentContext!.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.position);

    if (localOffset.dx >= 0 && localOffset.dx <= box.size.width) {
      final pourcentage = (localOffset.dx.ceil() / box.size.width.ceil()) * 100;
      widget.onDragDuration.call(
          Duration(seconds: ((pourcentage / 100) * duration.inSeconds).ceil()));
      widget.isDragging.call(true);
      widget.dragPosition.call(localOffset.dx);
      Future.delayed(const Duration(milliseconds: 50))
          .then((e) => widget.isDragging(false));
    } else {
      widget.isDragging.call(true);
      widget.dragPosition.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          if (!isDesktop)
            SizedBox(
                width: 70,
                child: Center(
                    child: Text(
                  (widget.delta ?? tempPosition ?? position)
                      .label(reference: duration),
                  style: const TextStyle(
                    height: 1.0,
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ))),
          Expanded(
            child: Listener(
              onPointerMove: (details) {
                _onMove(details);
              },
              child: MouseRegion(
                onExit: (_) {
                  widget.isDragging.call(false);
                  widget.dragPosition.call(null);
                },
                onHover: (details) {
                  _onMove(details);
                },
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: isDesktop ? null : 3,
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 5.0),
                  ),
                  child: Slider(
                    key: _sliderKey,
                    max: max(duration.inMilliseconds.toDouble(), 0),
                    value: max(
                        (widget.delta ?? tempPosition ?? position)
                            .inMilliseconds
                            .toDouble(),
                        0),
                    secondaryTrackValue:
                        max(buffer.inMilliseconds.toDouble(), 0),
                    onChanged: (value) {
                      widget.onSeekStart?.call(Duration(
                          milliseconds:
                              value.toInt() - position.inMilliseconds));
                      if (mounted) {
                        setState(() {
                          tempPosition = Duration(milliseconds: value.toInt());
                        });
                      }
                    },
                    onChangeStart: (value) {
                      widget.isDragging.call(true);
                    },
                    onChangeEnd: (value) async {
                      widget.isDragging.call(false);
                      widget.onSeekEnd?.call(Duration(
                          milliseconds:
                              value.toInt() - position.inMilliseconds));
                      widget.player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
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
                  style: const TextStyle(
                    height: 1.0,
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ))),
        ],
      ),
    );
  }
}
