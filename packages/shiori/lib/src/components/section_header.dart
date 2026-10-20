import 'package:flutter/material.dart';

import '../tokens.dart';

/// The heading of a group inside a screen: "Chapters · 127",
/// "CONTINUE READING".
class ShioriSectionHeader extends StatelessWidget {
  const ShioriSectionHeader({
    super.key,
    required this.title,
    this.count,
    this.overline = false,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(
      ShioriSpace.s16,
      ShioriSpace.s16,
      ShioriSpace.s8,
      ShioriSpace.s8,
    ),
  });

  final String title;

  /// Shown after the title, in muted tabular figures.
  final int? count;

  /// A [ShioriGroupLabel] instead of a heading, for quieter groups: the same
  /// label as a group of settings.
  final bool overline;

  /// An action at the end of the row ("Show all"), shown with [onAction].
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final style = overline
        ? tokens.groupLabel
        : tokens.text.section.copyWith(color: tokens.color.fg);
    final text = overline ? title.toUpperCase() : title;
    final hasAction = actionLabel != null && onAction != null;
    // The action keeps a full tap target, taller than the label; the room it
    // takes over the label comes out of the padding, so a header with an
    // action sits where one without it does instead of pushing the list down.
    var resolved = padding.resolve(Directionality.of(context));
    if (hasAction) {
      final line = (style.fontSize ?? 14) * (style.height ?? 1.2);
      final excess = ((tokens.density.minTarget - line) / 2).clamp(
        0.0,
        double.infinity,
      );
      resolved = resolved.copyWith(
        top: (resolved.top - excess).clamp(0.0, double.infinity),
        bottom: (resolved.bottom - excess).clamp(0.0, double.infinity),
      );
    }
    return Padding(
      padding: resolved,
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text.rich(
                TextSpan(
                  text: text,
                  children: [
                    if (count != null)
                      TextSpan(
                        text: ' · $count',
                        style: TextStyle(
                          color: tokens.color.fgMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                  ],
                ),
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (hasAction)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: tokens.color.accentInk,
                textStyle: tokens.text.meta.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

/// The title of a group, in [ShioriTokens.groupLabel]: what a group of
/// settings, [ShioriSectionHeader] with `overline` and a list's own group
/// separators all show, so a group reads the same on every screen.
///
/// Set in capitals and announced as a heading. It brings no padding; the
/// screen places it.
class ShioriGroupLabel extends StatelessWidget {
  const ShioriGroupLabel(this.title, {super.key, this.maxLines = 1});

  final String title;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title.toUpperCase(),
        style: context.shiori.groupLabel,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
