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
    // The screen's one main control: the accent disc, as Shiori draws it
    // over a picture; smaller in desktop's bar than in a phone's middle.
    return ShioriOverlayIconButton(
      tooltip: '${context.l10n.play} / ${context.l10n.pause}',
      focusNode: widget.focusNode,
      onPressed: widget.controller.player.playOrPause,
      emphasized: true,
      size: isDesktop ? 20 : 34,
      icon: AnimatedIcon(progress: animation, icon: AnimatedIcons.play_pause),
    );
  }
}
