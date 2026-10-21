import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// One way to sort, in a list of them. The one in use ([showLeading]) has
/// its label in the accent and an arrow for its direction; tapping it again
/// reverses it. The others keep the arrow's room so labels line up.
class ListTileChapterSort extends StatelessWidget {
  final String label;
  final bool reverse;
  final VoidCallback onTap;
  final bool showLeading;
  const ListTileChapterSort({
    super.key,
    required this.label,
    required this.reverse,
    required this.onTap,
    required this.showLeading,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    return Semantics(
      selected: showLeading,
      value: showLeading
          ? (reverse
                ? context.l10n.sort_ascending
                : context.l10n.sort_descending)
          : null,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          dense: true,
          minTileHeight: tokens.density.minTarget,
          selected: showLeading,
          leading: SizedBox.square(
            dimension: tokens.scaled(24),
            child: showLeading
                ? AnimatedRotation(
                    // The arrow turns, rather than swapping, when the
                    // direction flips.
                    turns: reverse ? 0.5 : 0,
                    duration: ShioriMotion.of(context, ShioriMotion.fast),
                    child: Icon(
                      Symbols.arrow_downward_rounded,
                      color: c.accentInk,
                      size: tokens.scaled(24),
                    ),
                  )
                : null,
          ),
          title: Text(
            label,
            style: tokens.text.row.copyWith(
              color: showLeading ? c.accentInk : c.fg,
              fontWeight: showLeading ? FontWeight.w700 : null,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
