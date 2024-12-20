import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class ListViewWidget extends StatelessWidget {
  final ScrollController? controller;
  final int? itemCount;
  final bool reverse;
  final Widget? Function(BuildContext, int) itemBuilder;
  const ListViewWidget(
      {super.key,
      this.controller,
      required this.itemCount,
      required this.itemBuilder,
      this.reverse = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SuperListView.builder(
          padding: const EdgeInsets.only(top: 13),
          controller: controller,
          itemCount: itemCount,
          itemBuilder: itemBuilder),
    );
  }
}
