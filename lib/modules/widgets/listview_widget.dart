import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class SuperListViewWidget extends StatelessWidget {
  final ScrollController? controller;
  final int? itemCount;
  final bool reverse;
  final Widget? Function(BuildContext, int) itemBuilder;
  const SuperListViewWidget({
    super.key,
    this.controller,
    required this.itemCount,
    required this.itemBuilder,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.shiori.color.ink0,
      child: SuperListView.builder(
        padding: const EdgeInsets.only(top: ShioriSpace.s12)
            .add(pageBottomInsets(context)),
        controller: controller,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
