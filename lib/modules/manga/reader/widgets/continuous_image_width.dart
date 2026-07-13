import 'package:flutter/material.dart';

class ContinuousImageWidth extends StatelessWidget {
  final bool fillAvailableWidth;
  final Widget child;

  const ContinuousImageWidth({
    super.key,
    required this.fillAvailableWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!fillAvailableWidth) return child;
    return SizedBox(width: double.infinity, child: child);
  }
}
