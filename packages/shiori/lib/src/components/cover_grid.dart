import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../tokens.dart';
import 'skeleton.dart';

/// The widest a cover may get in a grid, per density. The grid fits as many
/// columns as this allows, so a phone shows three and a desktop window as
/// many as its width holds.
double shioriCoverMaxWidth(ShioriDensity density) => switch (density) {
  ShioriDensity.phone => 130,
  ShioriDensity.desktop => 160,
  ShioriDensity.tv => 190,
};

/// The grid delegate every cover grid uses: columns from the density, room
/// under each cover for a two-line title and a meta line.
SliverGridDelegate shioriCoverGridDelegate(
  BuildContext context, {
  bool withTitles = true,
}) {
  final tokens = context.shiori;
  final text = tokens.text;
  // Title (two lines) plus a meta line, plus the gap above them.
  final titleRoom = withTitles
      ? ShioriSpace.s4 +
            text.card.fontSize! * 1.3 * 2 +
            text.meta.fontSize! * 1.4
      : 0.0;
  final maxWidth = shioriCoverMaxWidth(tokens.density);
  return _CoverGridDelegate(maxWidth: maxWidth, titleRoom: titleRoom);
}

class _CoverGridDelegate extends SliverGridDelegate {
  const _CoverGridDelegate({required this.maxWidth, required this.titleRoom});

  final double maxWidth;
  final double titleRoom;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    const gap = ShioriSpace.s12;
    final width = constraints.crossAxisExtent;
    final columns = ((width + gap) / (maxWidth + gap)).ceil().clamp(1, 1000);
    final tileWidth = (width - gap * (columns - 1)) / columns;
    final tileHeight = tileWidth * 3 / 2 + titleRoom;
    return SliverGridRegularTileLayout(
      crossAxisCount: columns,
      mainAxisStride: tileHeight + ShioriSpace.s16,
      crossAxisStride: tileWidth + gap,
      childMainAxisExtent: tileHeight,
      childCrossAxisExtent: tileWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_CoverGridDelegate oldDelegate) =>
      oldDelegate.maxWidth != maxWidth || oldDelegate.titleRoom != titleRoom;
}

/// A grid of covers, or, with [ShioriCoverGrid.skeleton], the same grid
/// while it loads.
class ShioriCoverGrid extends StatelessWidget {
  const ShioriCoverGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.withTitles = true,
    this.controller,
    this.padding = const EdgeInsets.all(ShioriSpace.s16),
    this.physics,
  }) : _skeleton = false;

  /// [itemCount] placeholder tiles in the grid's own layout, so nothing
  /// shifts when the real covers arrive.
  const ShioriCoverGrid.skeleton({
    super.key,
    this.itemCount = 12,
    this.withTitles = true,
    this.padding = const EdgeInsets.all(ShioriSpace.s16),
  }) : itemBuilder = _noBuilder,
       controller = null,
       physics = const NeverScrollableScrollPhysics(),
       _skeleton = true;

  final int itemCount;

  /// Builds one tile, usually a [ShioriCoverTile].
  final IndexedWidgetBuilder itemBuilder;
  final bool withTitles;
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final bool _skeleton;

  static Widget _noBuilder(BuildContext context, int index) =>
      const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      physics: physics,
      gridDelegate: shioriCoverGridDelegate(context, withTitles: withTitles),
      itemCount: itemCount,
      itemBuilder: _skeleton ? _skeletonTile : itemBuilder,
    );
  }

  Widget _skeletonTile(BuildContext context, int index) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const ShioriSkeleton.cover(),
      if (withTitles) ...[
        const SizedBox(height: ShioriSpace.s8),
        const ShioriSkeleton.line(),
        const SizedBox(height: ShioriSpace.s4),
        const FractionallySizedBox(
          widthFactor: 0.6,
          child: ShioriSkeleton.line(),
        ),
      ],
    ],
  );
}
