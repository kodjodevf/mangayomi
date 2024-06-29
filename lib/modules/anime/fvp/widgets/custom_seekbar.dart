import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:video_player/video_player.dart';

class CustomSeekBar extends StatefulWidget {
  final VideoPlayerController controller;
  final Duration? delta;
  final Function(Duration)? onSeekStart;
  final Function(Duration)? onSeekEnd;

  const CustomSeekBar(
      {super.key,
      this.onSeekStart,
      this.onSeekEnd,
      required this.controller,
      this.delta});

  @override
  CustomSeekBarState createState() => CustomSeekBarState();
}

class CustomSeekBarState extends State<CustomSeekBar> {
  Duration? tempPosition;
  late VideoPlayerController controller = widget.controller;
  Duration position = Duration.zero;
  late Duration duration = controller.value.duration;
  Duration buffer = Duration.zero;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void deactivate() {
    controller.removeListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.deactivate();
  }

  final isDesktop = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  @override
  Widget build(BuildContext context) {
    duration = controller.value.duration;
    position = controller.value.position;

    for (final DurationRange range in controller.value.buffered) {
      final end = range.end;
      if (end > buffer) {
        buffer = end;
      }
    }
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
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: isDesktop ? null : 3,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
              ),
              child: Slider(
                max: max(duration.inMilliseconds.toDouble(), 0),
                value: max(
                    (widget.delta ?? tempPosition ?? position)
                        .inMilliseconds
                        .toDouble(),
                    0),
                secondaryTrackValue: max(buffer.inMilliseconds.toDouble(), 0),
                onChanged: (value) {
                  widget.onSeekStart?.call(Duration(
                      milliseconds: value.toInt() - position.inMilliseconds));
                  if (mounted) {
                    setState(() {
                      tempPosition = Duration(milliseconds: value.toInt());
                    });
                  }
                },
                onChangeEnd: (value) async {
                  widget.onSeekEnd?.call(Duration(
                      milliseconds: value.toInt() - position.inMilliseconds));
                  widget.controller
                      .seekTo(Duration(milliseconds: value.toInt()));
                },
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
