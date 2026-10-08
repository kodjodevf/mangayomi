import 'package:flutter/material.dart';
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
    ItemType.manga: Icons.collections_bookmark_outlined,
    ItemType.anime: Icons.video_collection_outlined,
    ItemType.novel: Icons.local_library_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = l10nLocalizations(context)!;
    final labels = {
      ItemType.manga: l10n.manga,
      ItemType.anime: l10n.anime,
      ItemType.novel: l10n.novel,
    };

    final bar = <(IconData, String)>[
      if (merged)
        (Icons.collections_bookmark_outlined, l10n.library)
      else
        for (final type in libraries) (_icons[type]!, labels[type]!),
      (Icons.explore_outlined, l10n.browse),
      (Icons.more_horiz_outlined, l10n.more),
    ];

    // Merged hides a second bar behind the first: tapping Library swaps the
    // whole row for the libraries plus a way back. That is the part of the
    // choice the words cannot describe, so it is drawn too.
    final insideLibrary = <(IconData, String)>[
      (Icons.arrow_back, l10n.go_back),
      for (final type in libraries) (_icons[type]!, labels[type]!),
    ];

    return Column(
      children: [
        _NavPreviewBar(items: bar),
        if (merged) ...[
          const SizedBox(height: 6),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.onboarding_nav_inside,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _NavPreviewBar(items: insideLibrary),
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
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        // Solid, not a half transparent wash. On a light scheme the wash left
        // the bar barely separated from the page behind it.
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final (index, item) in items.indexed)
              _NavPreviewItem(
                icon: item.$1,
                label: item.$2,
                // The entry the bar opens on. A back arrow never is one.
                selected: index == 0 && item.$1 != Icons.arrow_back,
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
        : scheme.onSurfaceVariant;
    final labelColor = selected ? scheme.onSurface : scheme.onSurfaceVariant;
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? scheme.secondaryContainer : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Icon(icon, size: 20, color: iconColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: selected ? FontWeight.w600 : null,
            ),
          ),
        ],
      ),
    );
  }
}
