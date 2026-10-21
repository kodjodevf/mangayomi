import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// Reading modes as tiles that show their direction, for one series, with
/// the way to make the choice everyone's default, or to go back to it.
///
/// The reading mode is remembered per series; a list of six names never said
/// so, nor what the default was.
class ReaderModePicker extends StatelessWidget {
  const ReaderModePicker({
    super.key,
    required this.mode,
    required this.defaultMode,
    required this.seriesName,
    required this.onChanged,
    required this.onSetDefault,
  });

  /// The mode this series reads in.
  final ReaderMode mode;
  final ReaderMode defaultMode;
  final String seriesName;
  final ValueChanged<ReaderMode> onChanged;

  /// Makes [mode] the default for every series without one of its own.
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final c = tokens.color;
    final differs = mode != defaultMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
      child: Column(
        // As tall as the tiles: in a sheet, a full column stretched it to
        // nine tenths of the screen.
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: ShioriSpace.s8,
        children: [
          // The sheet's title, as on every Shiori sheet.
          Text(
            l10n.reading_mode_for(seriesName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.text.section.copyWith(color: c.fg),
          ),
          // Equal columns across the whole width: as many as fit at a
          // tile's least width, at least three. Fixed-width tiles left a gap
          // at the end of each row and cut the longer names.
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = ShioriSpace.s8;
              final columns = math.max(
                3,
                ((constraints.maxWidth + gap) / (tokens.scaled(112) + gap))
                    .floor(),
              );
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final m in ReaderMode.values)
                    _ModeTile(
                      mode: m,
                      width: width,
                      selected: m == mode,
                      onTap: () => onChanged(m),
                    ),
                ],
              );
            },
          ),
          if (differs)
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.default_is(getReaderModeName(defaultMode, context)),
                    style: tokens.caption,
                  ),
                ),
                ShioriButton.quiet(
                  label: l10n.use_default,
                  icon: Symbols.restart_alt_rounded,
                  onPressed: () => onChanged(defaultMode),
                ),
              ],
            ),
          if (differs)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: ShioriButton.secondary(
                label: l10n.set_as_default,
                icon: Symbols.star_rounded,
                onPressed: onSetDefault,
              ),
            )
          else
            Text(
              l10n.is_the_default,
              style: tokens.caption.copyWith(color: c.fgMuted),
            ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.width,
    required this.selected,
    required this.onTap,
  });

  final ReaderMode mode;
  final double width;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final fg = selected ? c.accentInk : c.fgMuted;
    final label = tokens.text.meta.copyWith(
      color: fg,
      fontWeight: selected ? FontWeight.w700 : null,
    );
    final labelHeight =
        2 *
        (label.fontSize ?? 12) *
        (label.height ?? 1.3) *
        MediaQuery.textScalerOf(context).scale(1);
    final icon = ReaderModeGlyph(
      mode,
      size: tokens.scaled(28),
      color: fg,
      filled: selected,
    );
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected
            ? c.accent.withValues(alpha: Alphas.accentTint)
            : c.ink2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ShioriShape.card),
          side: BorderSide(
            color: selected ? c.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s4,
                vertical: ShioriSpace.s12,
              ),
              child: Column(
                spacing: ShioriSpace.s4,
                children: [
                  icon,
                  // Two lines kept for every name, so the tiles line up in
                  // even rows whatever their name's length.
                  SizedBox(
                    height: labelHeight,
                    child: Center(
                      child: Text(
                        getReaderModeName(mode, context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: label,
                      ),
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
