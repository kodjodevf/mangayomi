import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/calendar/widgets/calendar_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

const _maxEventDots = 3;

class UpcomingCalendar extends StatefulWidget {
  final DateTime selectedYearMonth;
  final Map<DateTime, int> events;
  final ValueChanged<DateTime> setSelectedYearMonth;
  final ValueChanged<DateTime> onClickDay;

  const UpcomingCalendar({
    required this.selectedYearMonth,
    required this.events,
    required this.setSelectedYearMonth,
    required this.onClickDay,
    super.key,
  });

  @override
  State<UpcomingCalendar> createState() => _UpcomingCalendarState();
}

class _UpcomingCalendarState extends State<UpcomingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedYearMonth;
  }

  @override
  void didUpdateWidget(covariant UpcomingCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedYearMonth != widget.selectedYearMonth) {
      _focusedDay = widget.selectedYearMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 1000)),
      focusedDay: _focusedDay,
      locale: locale.toLanguageTag(),
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        titleTextStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
        ),
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left,
          color: theme.colorScheme.onSurface,
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right,
          color: theme.colorScheme.onSurface,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: theme.colorScheme.onSurface,
        ),
        weekendStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: theme.colorScheme.primary,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.primary,
        ),
        outsideTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
        ),
        // Disable default marker so we use our custom builder
        markersMaxCount: 0,
      ),
      eventLoader: (day) {
        final key = DateTime(day.year, day.month, day.day);
        final count = widget.events[key] ?? 0;
        return List.generate(count, (_) => day);
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final key = DateTime(date.year, date.month, date.day);
          final count = widget.events[key] ?? 0;
          if (count == 0) return null;
          return Positioned(
            bottom: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                min(count, _maxEventDots),
                (index) => CalendarIndicator(
                  index: index,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          );
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _focusedDay = focusedDay);
        widget.onClickDay(
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
        );
      },
      onFormatChanged: (format) {
        setState(() => _calendarFormat = format);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        widget.setSelectedYearMonth(
          DateTime(focusedDay.year, focusedDay.month),
        );
      },
    );
  }
}
