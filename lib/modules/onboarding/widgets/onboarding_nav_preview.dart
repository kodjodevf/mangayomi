import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// A small drawing of the navigation bar the current choice would produce.
///
/// Not a screenshot: it is built from the same icons and labels the real bar
/// uses, so it stays honest if those change, and it shows the libraries the
/// user actually picked rather than a stock three.
class OnboardingNavPreview extends StatelessWidget {
  const OnboardingNavPreview({
    super.key,
    required this.libraries,
    required this.merged,
  });

  final List<ItemType> libraries;
  final bool merged;

  static const _icons = {
    ItemType.manga: Symbols.collections_bookmark_rounded,
    ItemType.anime: Symbols.video_library_rounded,
    ItemType.novel: Symbols.local_library_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final labels = {
      ItemType.manga: l10n.manga,
      ItemType.anime: l10n.anime,
      ItemType.novel: l10n.novel,
    };

    final bar = <(IconData, String)>[
      if (merged) ...[
        (Symbols.collections_bookmark_rounded, l10n.library),
        (Symbols.notifications_rounded, l10n.activity),
      ] else ...[
        for (final type in libraries) (_icons[type]!, labels[type]!),
        (Symbols.new_releases_rounded, l10n.updates),
        (Symbols.history_rounded, l10n.history),
      ],
      (Symbols.explore_rounded, l10n.browse),
      (Symbols.more_horiz_rounded, l10n.more),
    ];

    // Grouped, Library opens on a switcher between the libraries, as the
    // real screen does; Activity does the same for Updates and History. That
    // is the part of the choice the words cannot describe, so it is drawn.
    return Column(
      children: [
        _NavPreviewBar(items: bar),
        if (merged) ...[
          const SizedBox(height: ShioriSpace.s12),
          Text(
            l10n.onboarding_nav_grouped_inside,
            textAlign: TextAlign.center,
            style: context.shiori.caption,
          ),
          const SizedBox(height: ShioriSpace.s8),
          IgnorePointer(
            child: ShioriSegmentedControl<ItemType>(
              segments: [
                for (final type in libraries)
                  ShioriSegment(
                    value: type,
                    label: labels[type]!,
                    icon: _icons[type],
                  ),
              ],
              selected: libraries.first,
              onSelected: (_) {},
            ),
          ),
        ],
      ],
    );
  }
}

class _NavPreviewBar extends StatelessWidget {
  const _NavPreviewBar({required this.items});

  final List<(IconData, String)> items;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // Solid, not a half transparent wash. On a light scheme the wash left
        // the bar barely separated from the page behind it.
        color: context.shiori.color.ink3,
        borderRadius: BorderRadius.circular(ShioriShape.card),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: ShioriSpace.s12,
          horizontal: ShioriSpace.s8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final (index, item) in items.indexed)
              _NavPreviewItem(
                icon: item.$1,
                label: item.$2,
                // The entry the bar opens on. A back arrow never is one.
                selected: index == 0 && item.$1 != Symbols.arrow_back_rounded,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavPreviewItem extends StatelessWidget {
  const _NavPreviewItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // The current entry carries an indicator behind its icon, which is what a
    // NavigationBar actually draws and what makes it read as current.
    //
    // The icon sits on that indicator and takes its colour. The label sits on
    // the bar and takes the bar's. Colouring both from the indicator put a
    // near white label on a light grey bar under the rose schemes, which made
    // the current entry the one word in the row you could not read.
    final iconColor = selected
        ? scheme.onSecondaryContainer
        : context.shiori.color.fgMuted;
    final labelColor = selected
        ? context.shiori.color.fg
        : context.shiori.color.fgMuted;
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? scheme.secondaryContainer : null,
              borderRadius: BorderRadius.circular(ShioriShape.card),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ShioriSpace.s12,
                vertical: 2,
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
          ),
          const SizedBox(height: ShioriSpace.s4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.shiori.text.badge.copyWith(
              color: labelColor,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
