import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  final ScrollController? controller;
  final int? itemCount;
  final bool reverse;
  final double mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;
  const GridViewWidget(
      {super.key,
      this.controller,
      required this.itemCount,
      required this.itemBuilder,
      this.reverse = false,
      this.mainAxisExtent = 280});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GridView.builder(
          controller: controller,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: mainAxisExtent,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder),
    );
  }
}
