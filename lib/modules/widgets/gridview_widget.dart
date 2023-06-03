import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  final ScrollController? controller;
  final int? itemCount;
  final bool reverse;
  final double? childAspectRatio;
  final Widget? Function(BuildContext, int) itemBuilder;
  const GridViewWidget(
      {super.key,
      this.controller,
      required this.itemCount,
      required this.itemBuilder,
      this.reverse = false,
      this.childAspectRatio = 0.69});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GridView.builder(
          padding: const EdgeInsets.only(top: 13),
          controller: controller,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: childAspectRatio!,
            maxCrossAxisExtent: 220,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder),
    );
  }
}
