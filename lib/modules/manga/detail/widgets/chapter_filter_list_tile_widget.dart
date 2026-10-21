import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// A filter that cycles off → only these → all but these, or a plain tick
/// for the lists that have no third state.
///
/// [type] is 0 (off), 1 (included) or 2 (excluded). Excluded was drawn as
/// Material's indeterminate box, a dash, which reads as "partly" rather than
/// "not these": it is a cross in the error tone now, with the label struck
/// through, and said to screen readers.
class ListTileChapterFilter extends StatelessWidget {
  final String label;
  final int type;
  final VoidCallback onTap;
  const ListTileChapterFilter({
    super.key,
    required this.label,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final excluded = type == 2;
    final (IconData icon, Color color) = switch (type) {
      1 => (Symbols.check_box_rounded, c.accentInk),
      2 => (Symbols.disabled_by_default_rounded, c.error.foreground),
      _ => (Symbols.check_box_outline_blank_rounded, c.fgMuted),
    };
    return MergeSemantics(
      child: Semantics(
        checked: type == 1,
        mixed: excluded,
        value: excluded ? context.l10n.excluded : null,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            dense: true,
            minTileHeight: tokens.density.minTarget,
            leading: AnimatedSwitcher(
              duration: ShioriMotion.of(context, ShioriMotion.fast),
              child: Icon(
                icon,
                key: ValueKey(type),
                fill: type == 0 ? 0 : 1,
                color: color,
                size: tokens.scaled(24),
              ),
            ),
            title: Text(
              label,
              style: tokens.text.row.copyWith(
                color: excluded ? c.fgMuted : c.fg,
                decoration: excluded ? TextDecoration.lineThrough : null,
                decorationColor: c.fgMuted,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
