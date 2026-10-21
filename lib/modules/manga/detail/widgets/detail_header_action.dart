import 'package:flutter/material.dart';
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
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final color = active ? tokens.color.accentInk : tokens.color.fgMuted;
    return InkWell(
      onTap: onPressed,
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
