import 'package:flutter/material.dart';

class BottomTextWidget extends StatelessWidget {
  final String text;
  const BottomTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3), //New
                offset: const Offset(0.5, 0.9),
                blurRadius: 3.0)
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(offset: Offset(0.5, 0.9), blurRadius: 3.0)
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
