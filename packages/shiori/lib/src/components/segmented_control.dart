import 'package:flutter/material.dart';

import '../tokens.dart';
import 'badge.dart';

/// One choice in a [ShioriSegmentedControl].
class ShioriSegment<T> {
  const ShioriSegment({
    required this.value,
    required this.label,
    this.icon,
    this.badge = 0,
  });

  final T value;
  final String label;
  final IconData? icon;

  /// What waits behind the segment, such as new updates; shown as a count
  /// after the label, and nothing at zero.
  final int badge;
}

/// A row of mutually exclusive choices that switch what the screen shows:
/// the media of a library, Updates or History, a setting for this series or
/// for all of them.
///
/// Every segment is a full target and says so to a screen reader, as a
/// button that is selected or not. The row takes the width it is given and
/// shares it equally, so it reads the same with two segments or four.
class ShioriSegmentedControl<T> extends StatelessWidget {
  const ShioriSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
  });

  final List<ShioriSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final motion = ShioriMotion.of(context, ShioriMotion.fast);
    return Container(
      padding: const EdgeInsets.all(ShioriSpace.s4 - 1),
      decoration: BoxDecoration(
        color: c.ink2,
        borderRadius: BorderRadius.circular(ShioriShape.pill),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _Segment(
                segment: segment,
                selected: segment.value == selected,
                motion: motion,
                onTap: () {
                  if (segment.value != selected) onSelected(segment.value);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.selected,
    required this.motion,
    required this.onTap,
  });

  final ShioriSegment<T> segment;
  final bool selected;
  final Duration motion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final fg = selected ? c.fg : c.fgMuted;
    // The track's own padding takes the rest of the target height.
    final height = tokens.density.minTarget - (ShioriSpace.s4 - 1) * 2;
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ShioriShape.pill),
          child: AnimatedContainer(
            duration: motion,
            curve: ShioriMotion.standardCurve,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? c.ink3 : Colors.transparent,
              borderRadius: BorderRadius.circular(ShioriShape.pill),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: ShioriSpace.s4,
              children: [
                if (segment.icon != null)
                  Icon(
                    segment.icon,
                    size: tokens.scaled(16),
                    fill: selected ? 1 : 0,
                    color: fg,
                  ),
                Flexible(
                  child: Text(
                    segment.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: tokens.text.row.copyWith(
                      color: fg,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (segment.badge > 0)
                  ShioriBadge(segment.badge, kind: ShioriStatusKind.newChapter),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
