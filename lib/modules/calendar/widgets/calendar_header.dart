import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
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
                icon: const Icon(Icons.keyboard_arrow_left),
                onPressed: onPreviousClick,
              ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: onNextClick,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
