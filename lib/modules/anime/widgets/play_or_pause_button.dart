import 'dart:async';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';

// BUTTON: PLAY/PAUSE

/// A material design play/pause button.
class CustomPlayOrPauseButton extends StatefulWidget {
  final VideoController controller;
  final bool isDesktop;

  const CustomPlayOrPauseButton({
    super.key,
    required this.controller,
    required this.isDesktop,
  });

  @override
  CustomPlayOrPauseButtonState createState() => CustomPlayOrPauseButtonState();
}

class CustomPlayOrPauseButtonState extends State<CustomPlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: widget.controller.player.state.playing ? 1 : 0,
    duration: const Duration(milliseconds: 200),
  );

  StreamSubscription<bool>? subscription;

  double get iconSize => widget.isDesktop ? 25 : 65;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??= widget.controller.player.stream.playing.listen((event) {
      if (event) {
        animation.forward();
      } else {
        animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.controller.player.playOrPause,
      iconSize: iconSize,
      color: Colors.white,
      icon: IgnorePointer(
        child: AnimatedIcon(
          progress: animation,
          icon: AnimatedIcons.play_pause,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
