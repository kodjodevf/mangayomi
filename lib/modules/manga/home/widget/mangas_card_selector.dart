import 'package:flutter/material.dart';
import 'package:mangayomi/utils/colors.dart';

class MangasCardSelector extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  const MangasCardSelector(
      {super.key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            side: BorderSide(width: 0.6, color: primaryColor(context)),
            backgroundColor: selected ? primaryColor(context) : null,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
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
                const SizedBox(
                  width: 5,
                ),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).textTheme.bodyLarge!.color),
                ),
              ],
            ),
          )),
    );
  }
}
