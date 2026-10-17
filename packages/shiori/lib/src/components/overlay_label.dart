import 'package:flutter/material.dart';

import '../tokens.dart';

/// A short label floating over a page or a video: the page count, the zoom
/// mode just picked. A dark pill with white text, so it reads on a white
/// page and a black frame alike, whatever the theme.
class ShioriOverlayLabel extends StatelessWidget {
  const ShioriOverlayLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ShioriScrim.underText,
        borderRadius: BorderRadius.circular(ShioriShape.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s12,
          vertical: ShioriSpace.s4,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: tokens.text.row.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
