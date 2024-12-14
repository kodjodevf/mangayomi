import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/services/aniskip.dart';
import 'package:media_kit/media_kit.dart';

class AniSkipCountDownButton extends ConsumerStatefulWidget {
  final bool active;
  final bool autoSkip;
  final int timeoutLength;
  final String skipTypeText;
  final Results? aniSkipResult;
  final Player player;
  const AniSkipCountDownButton(
      {super.key,
      required this.skipTypeText,
      required this.aniSkipResult,
      required this.player,
      required this.active,
      required this.autoSkip,
      required this.timeoutLength});

  @override
  ConsumerState<AniSkipCountDownButton> createState() => _AniSkipCountDownButtonState();
}

class _AniSkipCountDownButtonState extends ConsumerState<AniSkipCountDownButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: widget.timeoutLength))..forward();
    super.initState();
    if (widget.active) {
      if (widget.autoSkip) {
        _seekTo();
      } else {
        _controller.addListener(() {
          if (_controller.isCompleted) {
            setState(() {
              _isCompleted = true;
            });
            _controller.reset();
          }
        });
      }
    }
  }

  void _seekTo() {
    setState(() {
      _isCompleted = true;
    });
    _controller.reset();
    widget.player.seek(Duration(seconds: widget.aniSkipResult!.interval!.endTime!.ceil()));
  }

  bool _isCompleted = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.active && !widget.autoSkip
        ? _isCompleted
            ? const SizedBox.shrink()
            : AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: MaterialButton(
                      padding: const EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        _seekTo();
                      },
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        width: 200,
                        child: Stack(
                          children: [
                            RotatedBox(
                              quarterTurns: 0,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SizedBox.fromSize(
                                    size: const Size(200, 40),
                                    child: LinearProgressIndicator(
                                        color: Colors.red,
                                        value: 1 - _controller.value,
                                        backgroundColor: Colors.transparent)),
                              ),
                            ),
                            Positioned.fill(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    widget.skipTypeText.toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text((widget.timeoutLength - (_controller.duration! * _controller.value).inSeconds)
                                      .toString()),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
                })
        : const SizedBox.shrink();
  }
}
