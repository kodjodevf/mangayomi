import 'package:flutter/material.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class GridViewWidget extends StatelessWidget {
  final ScrollController? controller;
  final int? itemCount;
  final bool reverse;
  final double? childAspectRatio;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int? gridSize;
  const GridViewWidget({
    super.key,
    this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.reverse = false,
    this.childAspectRatio = 0.69,
    this.gridSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GridView.builder(
        // Grid spacing defaults to zero, so covers sat flush against each other
        // and the grid ran to the screen edges. On TV the focused cover scales
        // up, and with no gap it had nowhere to grow: give it room, and keep
        // the edge columns off the panel edge.
        padding: isTv
            ? const EdgeInsets.fromLTRB(12, 13, 12, 12)
            : const EdgeInsets.only(top: 13),
        controller: controller,
        gridDelegate: (gridSize == null || gridSize == 0)
            ? SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: childAspectRatio!,
                // Denser default on TV: from across a room 220px covers show
                // only ~4 huge tiles; 150 gives more, smaller covers.
                maxCrossAxisExtent: isTv ? 150 : 220,
                crossAxisSpacing: isTv ? 10 : 0,
                mainAxisSpacing: isTv ? 10 : 0,
              )
            : SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize!,
                childAspectRatio: childAspectRatio!,
                crossAxisSpacing: isTv ? 10 : 0,
                mainAxisSpacing: isTv ? 10 : 0,
              ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
