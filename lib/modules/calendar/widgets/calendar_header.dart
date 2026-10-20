import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime yearMonth;
  final VoidCallback onPreviousClick;
  final VoidCallback onNextClick;

  const CalendarHeader({
    required this.yearMonth,
    required this.onPreviousClick,
    required this.onNextClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);
    final formatter = DateFormat('MMMM yyyy', locale.toLanguageTag());
    final title = formatter.format(yearMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ShioriSpace.s8,
        horizontal: ShioriSpace.s16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedSwitcher(
            duration: ShioriMotion.standard,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              title,
              key: ValueKey(title),
              style: theme.textTheme.titleLarge,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
                icon: const Icon(Symbols.keyboard_arrow_left_rounded, fill: 1),
                onPressed: onPreviousClick,
              ),
              IconButton(
                tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
                icon: const Icon(Symbols.keyboard_arrow_right_rounded, fill: 1),
                onPressed: onNextClick,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
