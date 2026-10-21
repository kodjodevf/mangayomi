import 'package:flutter/material.dart';

import '../tokens.dart';

/// The three icon sizes, plus the two illustration sizes for empty states.
enum ShioriIconSize {
  small(16),
  medium(20),
  large(24),
  illustration(48),
  hero(96);

  const ShioriIconSize(this.value);

  final double value;
}

/// An icon from Material Symbols Rounded, the one family Shiori uses.
///
/// Selection is shown by filling the glyph (the font's FILL axis) rather
/// than by swapping to another icon: several Material icons have an
/// "outlined" variant that is the same drawing, so a swap could not show it.
class ShioriIcon extends StatelessWidget {
  const ShioriIcon(
    this.icon, {
    super.key,
    this.size = ShioriIconSize.medium,
    this.selected = false,
    this.color,
    this.semanticLabel,
  });

  /// A `Symbols.*_rounded` glyph.
  final IconData icon;
  final ShioriIconSize size;
  final bool selected;

  /// Defaults to the ambient [IconTheme].
  final Color? color;

  /// What a screen reader says. Leave null for a purely decorative icon.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ShioriTokens>();
    final scale = tokens?.density.typeScale ?? 1;
    return Icon(
      icon,
      size: size.value * scale,
      fill: selected ? 1 : 0,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
