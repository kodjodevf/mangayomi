import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: TvPill(
          label: text,
          icon: icon,
          selected: selected,
          onTap: onPressed,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          side: BorderSide(width: 0.6, color: context.primaryColor),
          backgroundColor: selected ? context.primaryColor : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: selected
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
              const SizedBox(width: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
