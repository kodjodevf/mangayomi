import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';

/// Placeholder grid shown while a page of covers is loading.
///
/// A centred spinner says nothing about what is coming and reads as a stall.
/// This lays out the shape the content will land in, and it goes through the
/// real [GridViewWidget] so the delegate, spacing, padding and TV insets match
/// exactly. Nothing shifts when the covers arrive.
///
/// The tint is the theme foreground at low alpha rather than a fixed grey,
/// because the palette is chosen at runtime and a grey that reads correctly on
/// one scheme is wrong on another.
class CoverGridSkeleton extends StatefulWidget {
  const CoverGridSkeleton({
    super.key,
    this.gridSize,
    this.childAspectRatio = 0.69,
    this.itemCount = 12,
  });

  /// Fixed column count, or null to follow the max-extent delegate. Pass the
  /// same value the real grid uses so the columns line up.
  final int? gridSize;

  /// Must match the real grid, otherwise the cells resize on load.
  final double childAspectRatio;

  final int itemCount;

  @override
  State<CoverGridSkeleton> createState() => _CoverGridSkeletonState();
}

class _CoverGridSkeletonState extends State<CoverGridSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  bool _animate = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the platform's reduce-motion setting: hold a flat tint instead
    // of breathing. Decided here rather than in build so the controller is not
    // started as a build side effect.
    _animate = !MediaQuery.disableAnimationsOf(context);
    if (_animate) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fg = Theme.of(context).colorScheme.onSurface;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        // Rebuilding a dozen plain boxes is cheaper than wrapping the grid in
        // an Opacity, which would force a save layer on every frame.
        final tint = fg.withValues(
          alpha: _animate ? 0.06 + (_pulse.value * 0.06) : 0.08,
        );
        return GridViewWidget(
          itemCount: widget.itemCount,
          gridSize: widget.gridSize,
          childAspectRatio: widget.childAspectRatio,
          itemBuilder: (context, index) => _CoverPlaceholder(tint: tint),
        );
      },
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.tint});

  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 6),
          // Stands in for the title line under the cover.
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.72,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(3),
              ),
              child: const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
