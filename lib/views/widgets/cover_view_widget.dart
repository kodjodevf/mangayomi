import 'package:flutter/material.dart';

class CoverViewWidget extends StatelessWidget {
  final List<Widget> children;
  final bool isComfortableGrid;
  final Widget? bottomTextWidget;
  const CoverViewWidget(
      {super.key,
      required this.children,
      this.isComfortableGrid = false,
      this.bottomTextWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isComfortableGrid
          ? Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: children,
                  ),
                ),
                bottomTextWidget!
              ],
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: children,
              ),
            ),
    );
  }
}
