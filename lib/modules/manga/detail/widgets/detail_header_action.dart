import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mangayomi/utils/haptics.dart';
import 'package:shiori/shiori.dart';

/// One of the quick actions under a series' cover: an icon over a short
/// label. [active] marks a state that is on (in the library, tracked): the
/// accent, with the icon filled.
class DetailHeaderAction extends StatelessWidget {
  const DetailHeaderAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  /// A second action under a long press, like editing the categories of a
  /// series already in the library.
  final VoidCallback? onLongPress;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final color = active ? tokens.color.accentInk : tokens.color.fgMuted;
    return InkWell(
      onTap: onPressed,
      onLongPress: onLongPress == null
          ? null
          : () {
              // InkWell buzzes for a long press on Android only.
              if (defaultTargetPlatform == TargetPlatform.iOS) {
                selectionHaptic();
              }
              onLongPress!();
            },
      borderRadius: BorderRadius.circular(ShioriShape.card),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: tokens.density.minTarget),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ShioriSpace.s4,
            vertical: ShioriSpace.s8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s4,
            children: [
              Icon(
                icon,
                fill: active ? 1 : 0,
                size: tokens.scaled(22),
                color: color,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tokens.text.meta.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
