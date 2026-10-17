import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// Marks a feature still in beta, in the accent, as a badge.
class BetaBadge extends StatelessWidget {
  const BetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final accent = tokens.color.accentInk;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.accent.withValues(alpha: Alphas.accentTint),
        borderRadius: BorderRadius.circular(ShioriShape.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s8,
          vertical: 2,
        ),
        child: Text(
          l10n.beta.toUpperCase(),
          style: tokens.text.badge.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
