import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/gridview_widget.dart';
import 'package:shiori/shiori.dart';

/// Placeholder grid shown while a page of covers is loading.
///
/// A centred spinner says nothing about what is coming and reads as a stall.
/// This lays out the shape the content will land in, and it goes through the
/// real [GridViewWidget] so the delegate, spacing, padding and TV insets match
/// exactly. Nothing shifts when the covers arrive.
///
/// Each cell is a [ShioriSkeleton], so it breathes with the rest of the
/// app's loading states and holds still under reduced motion.
class CoverGridSkeleton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GridViewWidget(
      itemCount: itemCount,
      gridSize: gridSize,
      childAspectRatio: childAspectRatio,
      itemBuilder: (context, index) => const _CoverPlaceholder(),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(ShioriSpace.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: ShioriSkeleton.box(radius: ShioriShape.cover)),
          SizedBox(height: ShioriSpace.s8),
          // Stands in for the title line under the cover.
          FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: 0.72,
            child: ShioriSkeleton.line(),
          ),
        ],
      ),
    );
  }
}
