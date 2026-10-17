import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// A small label on a cover or a list row: the Local, download-count and
/// language badges, a relation, a genre, a rating. [tone] colours it; the
/// default is a neutral raised surface. [strong] sets the label in bold, for
/// the one tag a row is there for.
class EntryBadgeChip extends StatelessWidget {
  const EntryBadgeChip({
    super.key,
    required this.label,
    this.tone,
    this.strong = false,
  });

  final String label;
  final ShioriStatus? tone;
  final bool strong;

  /// The accent, filled: the tag that matters most on a row.
  static ShioriStatus accent(BuildContext context) {
    final ink = context.shiori.color.accentInk;
    return ShioriStatus(ink, ShioriColors.onFill(ink));
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final tone = this.tone ?? ShioriStatus(tokens.color.ink3, tokens.color.fg);
    return Container(
      constraints: BoxConstraints(minWidth: tokens.scaled(18)),
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s4 + 1,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(ShioriShape.badge),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: tokens.text.badge.copyWith(
          color: tone.foreground,
          fontWeight: strong ? FontWeight.w700 : null,
        ),
      ),
    );
  }
}
