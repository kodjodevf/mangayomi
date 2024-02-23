import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class DraggableScrollbarWidget extends StatelessWidget {
  final ScrollController controller;
  final BoxScrollView child;
  const DraggableScrollbarWidget(
      {super.key, required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return context.isDesktop
        ? child
        : DraggableScrollbar(
            padding: const EdgeInsets.only(right: 7),
            heightScrollThumb: 48.0,
            backgroundColor: context.primaryColor,
            scrollThumbBuilder:
                (backgroundColor, thumbAnimation, labelAnimation, height,
                    {labelConstraints, labelText}) {
              return FadeTransition(
                opacity: thumbAnimation,
                child: Container(
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: height,
                  width: 8.0,
                ),
              );
            },
            scrollbarTimeToFade: const Duration(seconds: 2),
            controller: controller,
            child: child);
  }
}
