import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Makes a Material [Slider] usable with a TV remote.
///
/// A Material Slider grabs *all four* arrow keys to change its value, so on a
/// d-pad you can focus it but never move away - it's a trap. This wrapper owns
/// the focus instead: Left/Right adjust the value (via [onDecrease]/[onIncrease])
/// and Up/Down/Select fall through so focus can leave. The inner slider is
/// excluded from focus so it can't swallow the keys. Off-TV ([enabled] false)
/// it's a transparent pass-through, keeping normal touch/mouse behaviour.
class TvEscapableSlider extends StatefulWidget {
  const TvEscapableSlider({
    super.key,
    required this.child,
    required this.onDecrease,
    required this.onIncrease,
    required this.enabled,
  });

  final Widget child;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final bool enabled;

  @override
  State<TvEscapableSlider> createState() => _TvEscapableSliderState();
}

class _TvEscapableSliderState extends State<TvEscapableSlider> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    // The inner Slider gives no focus cue of its own (it's ExcludeFocus'd), so
    // draw a rounded accent tint + ring around it while this owns focus, so it's
    // obvious which slider the d-pad is currently on.
    final accent = Theme.of(context).colorScheme.primary;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          final k = event.logicalKey;
          if (k == LogicalKeyboardKey.arrowLeft) {
            widget.onDecrease();
            return KeyEventResult.handled;
          }
          if (k == LogicalKeyboardKey.arrowRight) {
            widget.onIncrease();
            return KeyEventResult.handled;
          }
        }
        // Up / Down / Select fall through so focus can leave the slider.
        return KeyEventResult.ignored;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        // Border is always present (transparent when idle) so focusing never
        // shifts the slider's layout.
        decoration: BoxDecoration(
          color: _focused ? accent.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _focused ? accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: ExcludeFocus(child: widget.child),
      ),
    );
  }
}
