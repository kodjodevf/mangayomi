import 'package:flutter/material.dart';
import 'package:mangayomi/utils/colors.dart';

class CustomFloatingActionBtn extends StatelessWidget {
  final bool isExtended;
  final VoidCallback onPressed;
  final String label;
  final double width;
  final double textWidth;

  const CustomFloatingActionBtn(
      {super.key,
      required this.isExtended,
      required this.onPressed,
      required this.label,
      required this.width,
      required this.textWidth});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 55,
      width: !isExtended ? 63 : width,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: FloatingActionButton(
        backgroundColor: primaryColor(context),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
                AnimatedContainer(
                  curve: Curves.easeIn,
                  width: !isExtended ? 0 : 5,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              width: !isExtended ? 0 : textWidth,
              duration: const Duration(milliseconds: 200),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
