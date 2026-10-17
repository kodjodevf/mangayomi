import 'package:flutter/material.dart';

import '../alphas.dart';
import '../tokens.dart';

/// A small cover at the head of a list row, at 2:3.
///
/// [child] is the image; the thumbnail sizes, clips and grounds it, so a
/// missing or loading image leaves a quiet tile rather than a hole.
/// [onTap] makes the cover a target of its own, such as opening the series
/// from a row that otherwise opens a chapter.
class ShioriThumbnail extends StatelessWidget {
  const ShioriThumbnail({
    super.key,
    required this.child,
    this.height,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;

  /// Defaults to the density's row height less the row's padding.
  final double? height;
  final VoidCallback? onTap;

  /// Names the cover's own action, when it has one.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final h = height ?? tokens.density.rowHeight - ShioriSpace.s8;
    Widget thumb = ClipRRect(
      borderRadius: BorderRadius.circular(ShioriShape.cover),
      child: SizedBox(
        width: h * coverAspect,
        height: h,
        child: ColoredBox(color: tokens.color.ink2, child: child),
      ),
    );
    if (onTap != null) {
      thumb = Semantics(
        button: true,
        label: semanticLabel,
        child: GestureDetector(onTap: onTap, child: thumb),
      );
    }
    return thumb;
  }
}

/// A row in a list of series or chapters: a leading thumbnail, a title, a
/// muted line under it, and a trailing control.
///
/// [dimmed] marks something already read or watched: the text steps back but
/// stays legible. [selected] tints the row for multi-selection.
class ShioriListRow extends StatelessWidget {
  const ShioriListRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.dimmed = false,
    this.selected = false,
    this.titleMaxLines = 1,
  });

  final Widget? leading;
  final String title;

  /// One muted line: a chapter, a time, a source.
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final bool dimmed;
  final bool selected;
  final int titleMaxLines;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final titleColor = dimmed ? c.fgMuted : c.fg;
    final subtitleColor = dimmed
        ? c.fgMuted.withValues(alpha: Alphas.secondary)
        : c.fgMuted;
    final content = ConstrainedBox(
      constraints: BoxConstraints(minHeight: tokens.density.rowHeight),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s16,
          vertical: ShioriSpace.s4,
        ),
        child: Row(
          spacing: ShioriSpace.s12,
          children: [
            ?leading,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    title,
                    maxLines: titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text.row.copyWith(color: titleColor),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.meta.copyWith(color: subtitleColor),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
    return Semantics(
      selected: selected,
      child: Material(
        color: selected
            ? c.accent.withValues(alpha: Alphas.accentTint)
            : Colors.transparent,
        child: onTap == null && onLongPress == null
            ? content
            : InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                onSecondaryTap: onSecondaryTap,
                child: content,
              ),
      ),
    );
  }
}
