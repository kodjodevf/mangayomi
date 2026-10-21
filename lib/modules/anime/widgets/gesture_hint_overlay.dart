import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:shiori/shiori.dart';

/// Whether the gesture guide still has to be shown on this device.
bool shouldShowGestureHint() =>
    !(settingsRepository.current.playerGestureHintSeen ?? false);

/// Records that the gesture guide was seen, so it never shows again.
void markGestureHintSeen() =>
    settingsRepository.update((s) => s.playerGestureHintSeen = true);

/// The phone player's gestures, shown once over the first video: brightness
/// on the left, volume on the right, a double tap on either side to skip,
/// a horizontal drag to seek, a long press to speed up. None of them is
/// visible anywhere else. A tap anywhere dismisses it.
class GestureHintOverlay extends StatelessWidget {
  const GestureHintOverlay({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    Widget hint(IconData icon, String text) => Column(
      mainAxisSize: MainAxisSize.min,
      spacing: ShioriSpace.s8,
      children: [
        Icon(icon, color: Colors.white, size: tokens.scaled(32)),
        Text(
          text,
          textAlign: TextAlign.center,
          style: tokens.text.row.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
    return Semantics(
      button: true,
      label: l10n.got_it,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
        child: ColoredBox(
          color: ShioriScrim.underText,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(ShioriSpace.s24),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: hint(
                            Symbols.brightness_6_rounded,
                            l10n.gesture_brightness,
                          ),
                        ),
                        Expanded(
                          child: hint(
                            Symbols.touch_app_rounded,
                            l10n.gesture_double_tap_skip,
                          ),
                        ),
                        Expanded(
                          child: hint(
                            Symbols.volume_up_rounded,
                            l10n.gesture_volume,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: hint(
                          Symbols.swap_horiz_rounded,
                          l10n.gesture_drag_seek,
                        ),
                      ),
                      Expanded(
                        child: hint(
                          Symbols.speed_rounded,
                          l10n.gesture_long_press_speed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ShioriSpace.s24),
                  Text(
                    l10n.tap_to_continue,
                    style: tokens.caption.copyWith(
                      color: Colors.white.withValues(alpha: Alphas.secondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
