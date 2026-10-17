import 'package:flutter/material.dart';

import '../tokens.dart';

/// Something is on its way and its shape is unknown: a source answering, a
/// file being written. When the shape is known (a list of rows, a grid of
/// covers), prefer the skeletons, which hold its place.
///
/// [label] says what is being waited for, under the indicator; [inline]
/// draws a small one for the end of a row or a button.
class ShioriLoading extends StatelessWidget {
  const ShioriLoading({super.key, this.label, this.value}) : inline = false;

  const ShioriLoading.inline({super.key, this.value})
    : label = null,
      inline = true;

  final String? label;

  /// Progress from 0 to 1, when known.
  final double? value;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final size = tokens.scaled(inline ? 20 : 32);
    final indicator = SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: inline ? 2.5 : 3.5,
        strokeCap: StrokeCap.round,
        color: tokens.color.accent,
        backgroundColor: value == null ? null : tokens.color.ink2,
      ),
    );
    if (inline) return indicator;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: ShioriSpace.s16,
          children: [
            indicator,
            if (label != null)
              Text(
                label!,
                textAlign: TextAlign.center,
                style: tokens.text.meta.copyWith(color: tokens.color.fgMuted),
              ),
          ],
        ),
      ),
    );
  }
}

/// How far something has come, as a bar: a download, a migration, the share
/// of a library read. A [value] from 0 to 1, or null while the end is not
/// known, when the bar runs on its own.
///
/// The accent on an ink3 track with round ends, so every bar in the app is
/// the same bar. [height] is 6 for a bar that is the point of its row, less
/// for a bar along an edge (the web view's load). [color] replaces the
/// accent for a bar that has to say something else, such as a failure.
class ShioriProgressBar extends StatelessWidget {
  const ShioriProgressBar({super.key, this.value, this.height = 6, this.color});

  final double? value;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return ClipRRect(
      borderRadius: BorderRadius.circular(ShioriShape.pill),
      child: LinearProgressIndicator(
        value: value?.clamp(0.0, 1.0),
        minHeight: height,
        color: color ?? tokens.color.accent,
        backgroundColor: tokens.color.ink3,
      ),
    );
  }
}
