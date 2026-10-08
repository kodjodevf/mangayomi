import 'package:flutter/material.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';

/// A row of choices that works under a thumb and under a d-pad.
///
/// The TV build uses the same pills as the TV home and the Browse switcher,
/// because a SegmentedButton's segments are not reliably reachable with a
/// d-pad.
class OnboardingChoiceRow<T> extends StatelessWidget {
  const OnboardingChoiceRow({
    super.key,
    required this.values,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final List<T> values;
  final String Function(T) label;
  final bool Function(T) isSelected;
  final void Function(T)? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (isTv) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final value in values)
            TvPill(
              label: label(value),
              selected: isSelected(value),
              onTap: () => onTap?.call(value),
            ),
        ],
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          FilterChip(
            label: Text(label(value)),
            selected: isSelected(value),
            // The tick would appear and disappear with the selection, so every
            // chip in the row changed width and the row jumped around as the
            // user tapped through it. The fill already says which is on.
            showCheckmark: false,
            // The default selected fill comes from the scheme's secondary
            // container while the label stays on the surface colour, and on
            // some of the light schemes that lands dark text on a dark fill.
            // Pairing primary with onPrimary keeps them legible together
            // whatever palette the user has chosen.
            selectedColor: scheme.primary,
            labelStyle: TextStyle(
              color: isSelected(value) ? scheme.onPrimary : scheme.onSurface,
            ),
            onSelected: onTap == null ? null : (_) => onTap!(value),
          ),
      ],
    );
  }
}

/// Where the user is in the flow, and how much of it is left.
///
/// The count is not fixed, because the arrange step drops out for a single
/// library or a wide window. Three dots followed by only two questions would
/// be a small lie about how long this takes.
class OnboardingStepDots extends StatelessWidget {
  const OnboardingStepDots({
    super.key,
    required this.steps,
    required this.current,
    required this.duration,
  });

  final int steps;
  final int current;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < steps; i++)
          AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6,
            // The one you are on is a bar, the rest are dots, so it reads at a
            // glance without colour having to carry it alone.
            width: i == current ? 20 : 6,
            decoration: BoxDecoration(
              color: i == current
                  ? scheme.primary
                  : scheme.onSurfaceVariant.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

class OnboardingAddedRepo extends StatelessWidget {
  const OnboardingAddedRepo({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle_outline, size: 18, color: theme.hintColor),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ),
      ],
    );
  }
}
