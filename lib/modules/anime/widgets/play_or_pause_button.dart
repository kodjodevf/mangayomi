import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:media_kit_video/media_kit_video.dart';

// BUTTON: PLAY/PAUSE

/// A material design play/pause button.
class CustomPlayOrPauseButton extends StatefulWidget {
  final VideoController controller;
  final FocusNode? focusNode;

  const CustomPlayOrPauseButton({
    super.key,
    required this.controller,
    this.focusNode,
  });

  @override
  CustomPlayOrPauseButtonState createState() => CustomPlayOrPauseButtonState();
}

class CustomPlayOrPauseButtonState extends State<CustomPlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: widget.controller.player.state.playing ? 1 : 0,
    duration: ShioriMotion.standard,
  );

  StreamSubscription<bool>? subscription;

  double get iconSize => isDesktop ? 25 : 65;

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
      // One button for both: the icon shows which, the label names the pair.
      tooltip: '${context.l10n.play} / ${context.l10n.pause}',
      focusNode: widget.focusNode,
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
