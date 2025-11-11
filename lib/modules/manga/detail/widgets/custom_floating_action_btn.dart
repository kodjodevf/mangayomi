import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CustomFloatingActionBtn extends StatelessWidget {
  final bool isExtended;
  final VoidCallback onPressed;
  final String label;

  const CustomFloatingActionBtn({
    super.key,
    required this.isExtended,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    const curve = Curves.easeInOut;

    return AnimatedSize(
      duration: duration,
      curve: curve,
      alignment: Alignment.centerRight,
      child: FloatingActionButton.extended(
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        onPressed: onPressed,
        extendedIconLabelSpacing: 0,
        extendedPadding: EdgeInsets.symmetric(horizontal: 16),
        icon: const Icon(Icons.play_arrow_rounded, size: 24),
        label: AnimatedSwitcher(
          duration: duration,
          switchInCurve: curve,
          switchOutCurve: curve,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              axisAlignment: -1,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: isExtended
              ? Padding(
                  key: const ValueKey('extended'),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('collapsed')),
        ),
      ),
    );
  }
}
