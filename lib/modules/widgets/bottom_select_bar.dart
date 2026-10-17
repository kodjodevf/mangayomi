import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

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
    final tokens = context.shiori;
    final c = tokens.color;
    final height = tokens.density.rowHeight + ShioriSpace.s16;
    return AnimatedContainer(
      curve: ShioriMotion.standardCurve,
      duration: ShioriMotion.of(context, ShioriMotion.standard),
      height: isVisible ? height : 0,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.ink3,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ShioriShape.sheet),
        ),
        border: Border(top: BorderSide(color: c.hairline)),
      ),
      child: OverflowBox(
        alignment: Alignment.topCenter,
        minHeight: height,
        maxHeight: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions,
        ),
      ),
    );
  }
}

/// Button for the BottomSelectBar
class BottomSelectButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;

  /// Names the action for screen readers and on hover.
  final String? tooltip;

  const BottomSelectButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.shiori.color;
    return Expanded(
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        color: c.fg,
        icon: icon,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShioriShape.card),
          ),
          minimumSize: Size.fromHeight(context.shiori.density.rowHeight),
        ),
      ),
    );
  }
}
