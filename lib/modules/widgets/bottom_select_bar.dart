import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Bar, that appears at the bottom of the screen when long-pressing (selecting)
/// a Manga/Anime/Novel or Chapter/Episode
class BottomSelectBar extends StatelessWidget {
  final bool isVisible;
  final List<BottomSelectButton> actions;

  const BottomSelectBar({
    super.key,
    required this.isVisible,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      duration: const Duration(milliseconds: 100),
      height: isVisible ? 70 : 0,
      width: context.width(1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions,
      ),
    );
  }
}

/// Button for the BottomSelectBar
class BottomSelectButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  const BottomSelectButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: onPressed,
          child: icon,
        ),
      ),
    );
  }
}
