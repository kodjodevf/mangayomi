import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Makes a Material [Slider] usable with a TV remote.
///
/// A Material Slider grabs *all four* arrow keys to change its value, so on a
/// d-pad you can focus it but never move away — it's a trap. This wrapper owns
/// the focus instead: Left/Right adjust the value (via [onDecrease]/[onIncrease])
/// and Up/Down/Select fall through so focus can leave. The inner slider is
/// excluded from focus so it can't swallow the keys. Off-TV ([enabled] false)
/// it's a transparent pass-through, keeping normal touch/mouse behaviour.
class TvEscapableSlider extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Focus(
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          final k = event.logicalKey;
          if (k == LogicalKeyboardKey.arrowLeft) {
            onDecrease();
            return KeyEventResult.handled;
          }
          if (k == LogicalKeyboardKey.arrowRight) {
            onIncrease();
            return KeyEventResult.handled;
          }
        }
        // Up / Down / Select fall through so focus can leave the slider.
        return KeyEventResult.ignored;
      },
      child: ExcludeFocus(child: child),
    );
  }
}
