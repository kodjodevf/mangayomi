import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_badges.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Builds and caches navigation destinations for the desktop rail and mobile bottom bar.
class NavDestinationBuilders {
  final Map<String, String> _hyphenatedLabelsCache = {};
  final Map<String, List<NavigationRailDestination>> _desktopDestinationsCache =
      {};
  final Map<String, List<Widget>> _mobileDestinationsCache = {};

  void clearCache() {
    _hyphenatedLabelsCache.clear();
    _desktopDestinationsCache.clear();
    _mobileDestinationsCache.clear();
  }

  String getHyphenatedUpdatesLabel(String languageCode, String defaultLabel) {
    final cacheKey = '$languageCode:$defaultLabel';
    return _hyphenatedLabelsCache.putIfAbsent(cacheKey, () {
      switch (languageCode) {
        case 'de':
          return "Aktuali-\nsierungen";
        case 'es':
        case 'es_419':
          return "Actuali-\nzaciones";
        case 'it':
          return "Aggiorna-\nmenti";
        case 'tr':
          return "Güncel-\nlemeler";
        default:
          return defaultLabel;
      }
    });
  }

  /// Wraps [icon] in a [Tooltip] with [message] unless the user turned the
  /// nav double-tap hint off in Settings, in which case it's the bare icon.
  Widget navTooltipIcon(bool showTooltip, String message, Widget icon) {
    return showTooltip ? Tooltip(message: message, child: icon) : icon;
  }

  List<NavigationRailDestination> buildNavigationWidgetsDesktop(
    WidgetRef ref,
    List<String> dest,
    BuildContext context,
  ) {
    final cacheKey = dest.join(',');
    if (_desktopDestinationsCache.containsKey(cacheKey)) {
      return _desktopDestinationsCache[cacheKey]!;
    }

    final l10n = context.l10n;
    final showTooltip = ref.read(showNavDoubleTapTooltipStateProvider);
    final destinations = List<NavigationRailDestination?>.filled(
      dest.length,
      null,
    );

    if (dest.contains(NavGroup.library)) {
      destinations[dest.indexOf(NavGroup.library)] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: const Icon(Symbols.collections_bookmark_rounded, fill: 1),
        icon: const Icon(Symbols.collections_bookmark_rounded),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.library),
        ),
      );
    }
    if (dest.contains(NavGroup.activity)) {
      destinations[dest.indexOf(NavGroup.activity)] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.notifications_rounded, fill: 1),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.notifications_rounded),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.activity),
        ),
      );
    }
    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Symbols.book_rounded, fill: 1),
        ),
        icon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Symbols.book_rounded),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.manga),
        ),
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Symbols.video_library_rounded),
        ),
        icon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Symbols.video_library_rounded),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.anime),
        ),
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Symbols.auto_stories_rounded, fill: 1),
        ),
        icon: navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Symbols.auto_stories_rounded),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.novel),
        ),
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.new_releases_rounded, fill: 1),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.new_releases_rounded),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(
            getHyphenatedUpdatesLabel(
              ref.watch(l10nLocaleStateProvider.select((l) => l.languageCode)),
              l10n.updates,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (dest.contains("/history")) {
      destinations[dest.indexOf("/history")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: const Icon(Symbols.history_rounded, fill: 1),
        icon: const Icon(Symbols.history_rounded),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.history),
        ),
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Symbols.explore_rounded, fill: 1),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Symbols.explore_rounded),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.browse),
        ),
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: const Icon(Symbols.more_horiz_rounded, fill: 1),
        icon: const Icon(Symbols.more_horiz_rounded),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.more),
        ),
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationRailDestination(
        padding: isTv
            ? const EdgeInsets.symmetric(vertical: ShioriSpace.s8)
            : null,
        selectedIcon: const Icon(Symbols.account_tree_rounded, fill: 1),
        icon: const Icon(Symbols.account_tree_rounded),
        label: Padding(
          padding: const EdgeInsets.only(top: ShioriSpace.s4),
          child: Text(l10n.tracking),
        ),
      );
    }

    final result = destinations.nonNulls.toList();
    _desktopDestinationsCache[cacheKey] = result;
    return result;
  }

  List<Widget> buildNavigationWidgetsMobile(
    WidgetRef ref,
    List<String> dest,
    BuildContext context,
  ) {
    final cacheKey = dest.join(',');
    if (_mobileDestinationsCache.containsKey(cacheKey)) {
      return _mobileDestinationsCache[cacheKey]!;
    }

    final l10n = context.l10n;
    final showTooltip = ref.read(showNavDoubleTapTooltipStateProvider);
    final destinations = List<Widget>.filled(
      dest.length,
      const SizedBox.shrink(),
    );

    if (dest.contains("_disableLibSwitch")) {
      destinations[dest.indexOf("_disableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.arrow_back_rounded, fill: 1),
        icon: const Icon(Symbols.arrow_back_rounded, fill: 1),
        label: l10n.go_back,
      );
    }
    if (dest.contains(NavGroup.library)) {
      destinations[dest.indexOf(NavGroup.library)] = NavigationDestination(
        selectedIcon: const Icon(Symbols.collections_bookmark_rounded, fill: 1),
        icon: const Icon(Symbols.collections_bookmark_rounded),
        label: l10n.library,
      );
    }
    if (dest.contains(NavGroup.activity)) {
      destinations[dest.indexOf(NavGroup.activity)] = NavigationDestination(
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.notifications_rounded, fill: 1),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.notifications_rounded),
          ref: ref,
        ),
        label: l10n.activity,
      );
    }
    if (dest.contains("_enableLibSwitch")) {
      destinations[dest.indexOf("_enableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.collections_bookmark_rounded, fill: 1),
        icon: const Icon(Symbols.collections_bookmark_rounded),
        label: l10n.library,
      );
    }
    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.book_rounded, fill: 1),
        icon: const Icon(Symbols.book_rounded),
        label: l10n.manga,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.manga) : '',
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.video_library_rounded),
        icon: const Icon(Symbols.video_library_rounded),
        label: l10n.anime,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.anime) : '',
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.auto_stories_rounded, fill: 1),
        icon: const Icon(Symbols.auto_stories_rounded),
        label: l10n.novel,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.novel) : '',
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationDestination(
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.new_releases_rounded, fill: 1),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Symbols.new_releases_rounded),
          ref: ref,
        ),
        label: l10n.updates,
      );
    }
    if (dest.contains("/history")) {
      destinations[dest.indexOf("/history")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.history_rounded, fill: 1),
        icon: const Icon(Symbols.history_rounded),
        label: l10n.history,
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationDestination(
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Symbols.explore_rounded, fill: 1),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Symbols.explore_rounded),
          ref: ref,
        ),
        label: l10n.browse,
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.more_horiz_rounded, fill: 1),
        icon: const Icon(Symbols.more_horiz_rounded),
        label: l10n.more,
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Symbols.account_tree_rounded, fill: 1),
        icon: const Icon(Symbols.account_tree_rounded),
        label: l10n.tracking,
      );
    }

    _mobileDestinationsCache[cacheKey] = destinations;
    return destinations;
  }
}
