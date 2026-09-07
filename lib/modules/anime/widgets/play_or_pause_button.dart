import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/anime/widgets/player_theme.dart';
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
    duration: const Duration(milliseconds: 200),
  );

  StreamSubscription<bool>? subscription;

  // The tappable disc behind the glyph — this is what gives the button
  // contrast on bright scenes, where a bare white icon used to disappear.
  double get discSize => isDesktop ? 46.0 : 76.0;
  double get glyphSize => isDesktop ? 22.0 : 34.0;

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
      focusNode: widget.focusNode,
      onPressed: widget.controller.player.playOrPause,
      iconSize: discSize,
      padding: EdgeInsets.zero,
      color: Colors.white,
      icon: IgnorePointer(
        child: Container(
          width: discSize,
          height: discSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PlayerTheme.chipBackdrop,
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Center(
            child: AnimatedIcon(
              progress: animation,
              icon: AnimatedIcons.play_pause,
              size: glyphSize,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
