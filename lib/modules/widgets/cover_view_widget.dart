import 'package:flutter/material.dart';
import 'package:mangayomi/utils/colors.dart';

class CoverViewWidget extends StatelessWidget {
  final List<Widget> children;
  final bool? isLongPressed;
  final ImageProvider? image;
  final bool isComfortableGrid;
  final Widget? bottomTextWidget;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  const CoverViewWidget(
      {super.key,
      required this.children,
      this.isComfortableGrid = false,
      this.bottomTextWidget,
      required this.onTap,
      this.image,
      this.onLongPress,
      this.isLongPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: InkWell(
                    onTap: onTap,
                    onLongPress: onLongPress,
                    child: Container(
                      color: isLongPressed != null && isLongPressed!
                          ? primaryColor(context).withOpacity(0.4)
                          : Colors.transparent,
                      child: image == null
                          ? isComfortableGrid
                              ? Column(
                                  children: [...children, bottomTextWidget!],
                                )
                              : Stack(
                                  children: children,
                                )
                          : Ink.image(
                              height: 200,
                              fit: BoxFit.cover,
                              image: image!,
                              child: Stack(
                                children: children,
                              ),
                            ),
                    )),
              ),
            ),
            if (isComfortableGrid) bottomTextWidget!
          ],
        ));
  }
}
