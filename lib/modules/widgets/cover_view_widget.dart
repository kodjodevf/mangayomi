import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CoverViewWidget extends StatelessWidget {
  final List<Widget> children;
  final bool? isLongPressed;
  final ImageProvider? image;
  final bool isComfortableGrid;
  final Widget? bottomTextWidget;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  const CoverViewWidget({
    super.key,
    required this.children,
    this.isComfortableGrid = false,
    this.bottomTextWidget,
    required this.onTap,
    this.image,
    this.onLongPress,
    this.isLongPressed,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    final showOverlay = isLongPressed != null && isLongPressed!;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                onSecondaryTap: onSecondaryTap,
                child: image == null
                    ? Container(
                        color: showOverlay
                            ? context.primaryColor.withValues(alpha: 0.4)
                            : Colors.transparent,
                        child: isComfortableGrid
                            ? Column(children: [...children, bottomTextWidget!])
                            : Stack(children: children),
                      )
                    : Ink.image(
                        fit: BoxFit.cover,
                        image: image!,
                        child: Stack(
                          children: [
                            if (showOverlay)
                              Positioned.fill(
                                child: Container(
                                  color: context.primaryColor.withValues(alpha: 0.4),
                                ),
                              ),
                            ...children,
                          ],
                        ),
                      ),
              ),
            ),
          ),
          if (isComfortableGrid) bottomTextWidget!,
        ],
      ),
    );
  }
}
