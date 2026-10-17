import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

bool isTvPlayerSelectKey(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;

/// A focusable control that shows a solid theme-accent background when focused
/// (clearly visible over the dark backdrop) and fires [onPressed] on select.
class TvFocusable extends StatefulWidget {
  const TvFocusable({
    super.key,
    required this.accent,
    required this.child,
    required this.onPressed,
    this.focusNode,
    this.autofocus = false,
  });

  final Color accent;
  final Widget child;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<TvFocusable> createState() => _TvFocusableState();
}

class _TvFocusableState extends State<TvFocusable> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: enabled,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            isTvPlayerSelectKey(event.logicalKey) &&
            enabled) {
          widget.onPressed!();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused
                ? widget.accent
                : Colors.black.withValues(alpha: 0.35),
          ),
          child: Opacity(opacity: enabled ? 1.0 : 0.4, child: widget.child),
        ),
      ),
    );
  }
}

/// Focusable play/pause button — highlighted when focused, and the default
/// focus on reveal. OK on the seek bar also toggles it (Netflix convenience).
class TvPlayPauseButton extends StatelessWidget {
  const TvPlayPauseButton({
    super.key,
    required this.player,
    required this.accent,
    required this.focusNode,
  });

  final Player player;
  final Color accent;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: player.stream.playing,
      initialData: player.state.playing,
      builder: (context, snapshot) {
        final playing = snapshot.data ?? false;
        return TvFocusable(
          accent: accent,
          focusNode: focusNode,
          autofocus: true,
          onPressed: player.playOrPause,
          child: Icon(
            playing ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 34,
          ),
        );
      },
    );
  }
}
