import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MangasCardSelector extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  const MangasCardSelector({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // On TV this is the same kind of switcher as the home categories and the
    // Browse tabs, so use the shared pill. It brings the accent focus state,
    // remote OK handling and scroll-into-view that the plain button lacks, and
    // keeps the source page consistent with the rest of the TV UI.
    if (isTv) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ShioriSpace.s4,
          vertical: ShioriSpace.s8,
        ),
        child: TvPill(
          label: text,
          icon: icon,
          selected: selected,
          onTap: onPressed,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: ShioriSpace.s8,
        top: ShioriSpace.s4,
        bottom: ShioriSpace.s4,
      ),
      child: ChoiceChip(
        selected: selected,
        showCheckmark: false,
        avatar: Icon(icon, fill: selected ? 1 : 0),
        label: Text(text),
        onSelected: (_) => onPressed(),
      ),
    );
  }
}
