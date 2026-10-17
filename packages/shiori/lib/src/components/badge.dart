import 'package:flutter/material.dart';

import '../tokens.dart';

/// The statuses the app speaks in. Each maps to a fixed colour pair in
/// [ShioriColors], independent of the user's accent.
enum ShioriStatusKind {
  unread,
  downloaded,
  read,
  offline,
  completed,
  newChapter,
  error,
}

extension on ShioriColors {
  ShioriStatus pairFor(ShioriStatusKind kind) => switch (kind) {
    ShioriStatusKind.unread => unread,
    ShioriStatusKind.downloaded => downloaded,
    ShioriStatusKind.read => read,
    ShioriStatusKind.offline => offline,
    ShioriStatusKind.completed => completed,
    ShioriStatusKind.newChapter => newChapter,
    ShioriStatusKind.error => error,
  };
}

/// A count in a filled pill: unread chapters, new episodes.
///
/// Renders nothing for a count of zero, so callers do not have to guard it.
class ShioriBadge extends StatelessWidget {
  const ShioriBadge(
    this.count, {
    super.key,
    this.kind = ShioriStatusKind.unread,
    this.max = 999,
  });

  final int count;
  final ShioriStatusKind kind;

  /// Counts above this show as `max+`.
  final int max;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();
    final tokens = context.shiori;
    final pair = tokens.color.pairFor(kind);
    final label = count > max ? '$max+' : '$count';
    return Semantics(
      container: true,
      label: label,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: pair.background,
          borderRadius: BorderRadius.circular(ShioriShape.badge),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ShioriSpace.s4,
            vertical: 1,
          ),
          child: Text(
            label,
            style: tokens.text.badge.copyWith(color: pair.foreground),
          ),
        ),
      ),
    );
  }
}

/// A labelled status: "Offline", "Completed", "New chapter".
class ShioriStatusChip extends StatelessWidget {
  const ShioriStatusChip({
    super.key,
    required this.kind,
    required this.label,
    this.icon,
  });

  final ShioriStatusKind kind;
  final String label;

  /// An optional leading `Symbols.*_rounded` glyph.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final pair = tokens.color.pairFor(kind);
    final style = tokens.text.meta.copyWith(
      color: pair.foreground,
      fontWeight: FontWeight.w700,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pair.background,
        borderRadius: BorderRadius.circular(ShioriShape.badge),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s8,
          vertical: ShioriSpace.s4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: ShioriSpace.s4,
          children: [
            if (icon != null)
              Icon(icon, size: style.fontSize, color: pair.foreground),
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}
