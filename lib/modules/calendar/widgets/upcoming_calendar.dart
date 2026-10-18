import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';
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
    final tokens = context.shiori;
    final locale = Localizations.localeOf(context);

    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 1000)),
      focusedDay: _focusedDay,
      locale: locale.toLanguageTag(),
      calendarFormat: _calendarFormat,
      // The switch's labels in the app's language, not the package's English.
      availableCalendarFormats: {
        CalendarFormat.month: context.l10n.calendar_format_month,
        CalendarFormat.twoWeeks: context.l10n.calendar_format_two_weeks,
        CalendarFormat.week: context.l10n.calendar_format_week,
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
        formatButtonShowsNext: false,
        titleTextStyle: tokens.text.section.copyWith(color: tokens.color.fg),
        // The month / two weeks / week switch as one of the app's pills.
        formatButtonTextStyle: tokens.text.meta.copyWith(
          color: tokens.color.fg,
          fontWeight: FontWeight.w600,
        ),
        formatButtonDecoration: BoxDecoration(
          color: tokens.color.ink2,
          borderRadius: BorderRadius.circular(ShioriShape.pill),
        ),
        leftChevronIcon: Icon(
          Symbols.keyboard_arrow_left_rounded,
          fill: 1,
          color: tokens.color.fg,
        ),
        rightChevronIcon: Icon(
          Symbols.keyboard_arrow_right_rounded,
          fill: 1,
          color: tokens.color.fg,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: tokens.text.meta.copyWith(
          fontWeight: FontWeight.w600,
          color: tokens.color.fgMuted,
        ),
        weekendStyle: tokens.text.meta.copyWith(
          fontWeight: FontWeight.w600,
          color: tokens.color.accentInk,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: context.shiori.color.accentInk, width: 1.5),
        ),
        todayTextStyle: tokens.text.row.copyWith(
          fontWeight: FontWeight.w700,
          color: tokens.color.accentInk,
        ),
        defaultTextStyle: tokens.text.row.copyWith(
          fontWeight: FontWeight.w500,
          color: tokens.color.fg,
        ),
        weekendTextStyle: tokens.text.row.copyWith(
          fontWeight: FontWeight.w500,
          color: tokens.color.accentInk,
        ),
        outsideTextStyle: tokens.text.row.copyWith(
          color: tokens.color.fg.withValues(alpha: Alphas.disabled),
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
                  color: context.shiori.color.accentInk,
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
