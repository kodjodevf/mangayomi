import 'package:flutter/material.dart';
import 'package:mangayomi/modules/calendar/widgets/calendar_indicator.dart';

const _maxEvents = 3;

class CalendarDay extends StatelessWidget {
  final DateTime date;
  final int events;
  final VoidCallback onDayClick;
  final bool isToday;
  final bool isPast;

  const CalendarDay({
    required this.date,
    required this.events,
    required this.onDayClick,
    required this.isToday,
    required this.isPast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onBgColor = theme.colorScheme.onSurface;

    return InkWell(
      onTap: onDayClick,
      customBorder: const CircleBorder(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: isToday
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: onBgColor, width: 1),
                )
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${date.day}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isPast ? onBgColor.withValues(alpha: 0.38) : onBgColor,
                ),
              ),
              if (events > 0) ...[
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    events.clamp(0, _maxEvents),
                    (index) => CalendarIndicator(
                      index: index,
                      size: 56,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
