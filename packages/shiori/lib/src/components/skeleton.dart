import 'package:flutter/material.dart';

import '../alphas.dart';
import '../tokens.dart';

/// A placeholder in the shape of what is loading.
///
/// It breathes slowly between two tints of the foreground, and holds still
/// when the platform asks for reduced motion. A spinner says "wait"; a
/// skeleton also says what is coming, and where.
class ShioriSkeleton extends StatefulWidget {
  /// A box of a given size.
  const ShioriSkeleton.box({
    super.key,
    this.width,
    this.height,
    this.radius = ShioriShape.badge,
  }) : aspectRatio = null;

  /// A line of text, [width] wide, as tall as [ShioriType.row].
  const ShioriSkeleton.line({super.key, this.width})
    : height = 12,
      radius = ShioriShape.badge,
      aspectRatio = null;

  /// A cover, at 2:3.
  const ShioriSkeleton.cover({super.key})
    : width = null,
      height = null,
      radius = ShioriShape.cover,
      aspectRatio = coverAspect;

  final double? width;
  final double? height;
  final double radius;
  final double? aspectRatio;

  @override
  State<ShioriSkeleton> createState() => _ShioriSkeletonState();
}

class _ShioriSkeletonState extends State<ShioriSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: ShioriMotion.ambient,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (still) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fg = context.shiori.color.fg;
    final box = AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) => DecoratedBox(
        decoration: BoxDecoration(
          // Between the tint and twice the tint: visible on every surface,
          // never loud enough to read as content.
          color: fg.withValues(alpha: Alphas.tint * (1 + _pulse.value)),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        child: SizedBox(width: widget.width, height: widget.height),
      ),
    );
    return ExcludeSemantics(
      child: widget.aspectRatio == null
          ? box
          : AspectRatio(aspectRatio: widget.aspectRatio!, child: box),
    );
  }
}

/// A list row while it loads: a leading square and two lines.
class ShioriSkeletonRow extends StatelessWidget {
  const ShioriSkeletonRow({super.key, this.leading = true});

  final bool leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s16,
        vertical: ShioriSpace.s12,
      ),
      child: Row(
        spacing: ShioriSpace.s12,
        children: [
          if (leading)
            const ShioriSkeleton.box(
              width: 40,
              height: 40,
              radius: ShioriShape.cover,
            ),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ShioriSpace.s8,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ShioriSkeleton.line(),
                ),
                FractionallySizedBox(
                  widthFactor: 0.4,
                  child: ShioriSkeleton.line(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
