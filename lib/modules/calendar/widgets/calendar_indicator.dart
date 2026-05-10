import 'package:flutter/material.dart';

const _indicatorScale = 12;
const _indicatorAlphaMultiplier = 0.3;

class CalendarIndicator extends StatelessWidget {
  final int index;
  final double size;
  final Color color;

  const CalendarIndicator({
    required this.index,
    required this.size,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: size / _indicatorScale,
      height: size / _indicatorScale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: (index + 1) * _indicatorAlphaMultiplier),
      ),
    );
  }
}
