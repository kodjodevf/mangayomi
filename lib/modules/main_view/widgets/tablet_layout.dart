import 'dart:async';

import 'package:mangayomi/utils/constant.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/main_view/main_screen.dart';

class MainTabletLayout extends StatefulWidget {
  const MainTabletLayout({
    super.key,
    required this.isLongPressed,
    required this.location,
    required this.dest,
    required this.currentIndex,
    required this.route,
    required this.child,
    required this.ref,
    required this.buildNavigationWidgetsDesktop,
  });

  final bool isLongPressed;
  final String? location;
  final List<String> dest;
  final int currentIndex;
  final GoRouter route;
  final Widget child;
  final WidgetRef ref;
  final List<NavigationRailDestination> Function(
    WidgetRef,
    List<String>,
    BuildContext,
  )
  buildNavigationWidgetsDesktop;

  @override
  State<MainTabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<MainTabletLayout> {
  // Explicit focus scopes for the rail and the routed content, used on Android
  // TV only. Directional (d-pad) focus traversal doesn't cross into the rail —
  // the routed page lives in its own FocusScope and arrows only move focus
  // within it — so we move focus between the two scopes ourselves. A scope
  // wraps the whole rail because NavigationRail doesn't expose its
  // destinations' focus nodes.
  final FocusScopeNode _railScope = FocusScopeNode(debugLabel: 'navRailScope');
  final FocusScopeNode _contentScope = FocusScopeNode(
    debugLabel: 'navContentScope',
  );
  bool _didAutofocusRail = false;

  // Double-clicking a Manga/Anime/Novel rail destination opens Global Search
  // scoped to that type, instead of just re-selecting the already-active tab.
  // Tracked here rather than via a nested GestureDetector because
  // NavigationRail handles taps itself; onDestinationSelected still fires on
  // a repeat tap, so a same-index-within-a-window check is all this needs.
  int? _lastNavTapIndex;
  DateTime? _lastNavTapTime;

  void _onDestinationTapped(BuildContext context, int newIndex) {
    final now = DateTime.now();
    final isDoubleTap = isNavDoubleTap(
      newIndex,
      _lastNavTapIndex,
      _lastNavTapTime,
      now,
    );

    final dest = widget.dest[newIndex];
    if (isDoubleTap && dest == '/history') {
      _lastNavTapIndex = null;
      _lastNavTapTime = null;
      final activeType = widget.ref.read(activeHistoryItemTypeStateProvider);
      unawaited(resumeLatestHistory(context, activeType));
      return;
    }

    final itemType = itemTypeForNavDest(dest);
    if (isDoubleTap && itemType != null) {
      _lastNavTapIndex = null;
      _lastNavTapTime = null;
      context.push('/globalSearch', extra: (null, itemType));
      return;
    }

    _lastNavTapIndex = newIndex;
    _lastNavTapTime = now;
    widget.route.go(widget.dest[newIndex]);
  }

  @override
  void dispose() {
    _railScope.dispose();
    _contentScope.dispose();
    super.dispose();
  }

  // TV d-pad crossing: LEFT that can't move any further inside the content
  // pulls focus onto the rail; RIGHT from the rail dives into the content.
  // Other keys (up/down/select) fall through to the default handler. Only
  // active while the rail is visible (library tabs), never in the reader.
  KeyEventResult _handleTvKey(KeyEvent event, bool railVisible) {
    if (!railVisible) return KeyEventResult.ignored;
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowLeft) {
      if (_railScope.hasFocus) return KeyEventResult.ignored;
      final current = FocusManager.instance.primaryFocus;
      final moved = current?.focusInDirection(TraversalDirection.left) ?? false;
      if (!moved) _railScope.requestFocus();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight && _railScope.hasFocus) {
      // Focus the content scope — it restores its focusedChild, which for the
      // library grid is the first cover (autofocused on TV). That fixes both
      // "focus never lands on the grid" and the anime-tab "hold Left to reach
      // the rail" (Left from a cover reaches the rail in one press).
      _contentScope.requestFocus();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final destinations = widget.buildNavigationWidgetsDesktop(
      widget.ref,
      widget.dest,
      context,
    );
    final railWidth = _getNavigationRailWidth(
      widget.isLongPressed,
      widget.location,
    );
    final railVisible = railWidth > 0;

    // On a TV, open with the tab rail focused so the user lands on the tabs and
    // dives into content with RIGHT. One-shot per mount.
    if (isTv && railVisible && !_didAutofocusRail) {
      _didAutofocusRail = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _railScope.requestFocus();
      });
    }

    final scheme = Theme.of(context).colorScheme;
    Widget navRail = NavigationRail(
      labelType: NavigationRailLabelType.all,
      useIndicator: true,
      // Centre the tabs rather than bunching them under the logo with dead
      // space below. Off-TV keeps the default top alignment.
      groupAlignment: isTv ? 0.0 : null,
      // Brand the rail on TV: the app glyph, then the beta flag under it.
      leading: isTv ? const _TvRailHeader() : null,
      // A TV is read from across a room, so the desktop defaults (24px icons,
      // regular labels) are undersized. Colours are restated rather than left
      // null, because supplying an IconThemeData/TextStyle replaces the rail's
      // own defaults wholesale and would otherwise drop the selected and
      // unselected colouring. All null off TV, so desktop keeps its defaults.
      selectedIconTheme: isTv
          ? IconThemeData(size: 28, color: scheme.onSecondaryContainer)
          : null,
      unselectedIconTheme: isTv
          ? IconThemeData(size: 28, color: scheme.onSurfaceVariant)
          : null,
      selectedLabelTextStyle: isTv
          ? TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            )
          : null,
      unselectedLabelTextStyle: isTv
          ? TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)
          : null,
      destinations: destinations,
      selectedIndex:
          (widget.currentIndex >= 0 &&
              widget.currentIndex < destinations.length)
          ? widget.currentIndex
          : 0,
      onDestinationSelected: (newIndex) =>
          _onDestinationTapped(context, newIndex),
    );
    if (isTv) {
      navRail = FocusScope(node: _railScope, child: navRail);
    }

    Widget content = widget.child;
    if (isTv) {
      content = FocusScope(node: _contentScope, child: content);
    }

    Widget row = Row(
      children: [
        AnimatedContainer(
          // The rail collapses to zero width when a reader or player opens, so
          // on TV give that a real transition instead of snapping. Off-TV keeps
          // the original instant behaviour.
          duration: Duration(milliseconds: isTv ? 220 : 0),
          curve: Curves.easeOutCubic,
          width: railWidth,
          child: Stack(
            children: [
              NavigationRailTheme(
                data: NavigationRailThemeData(
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                // On Android TV the rail destination's default d-pad focus
                // overlay is too faint to see from across a room. The
                // destination InkResponse draws its focus highlight from the
                // ambient Theme.focusColor, so a bold primary-tinted focusColor
                // makes the focused tab clearly visible. No-op off TV.
                child: Theme(
                  data: Theme.of(context).copyWith(
                    focusColor: isTv
                        ? context.primaryColor.withValues(alpha: 0.45)
                        : Theme.of(context).focusColor,
                  ),
                  child: navRail,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: content),
      ],
    );

    // Wrap in a non-focusable key handler on TV so we can move focus across the
    // rail/content scope boundary that directional traversal won't cross.
    if (isTv) {
      row = Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (node, event) => _handleTvKey(event, railVisible),
        child: row,
      );
    }
    return row;
  }

  static double _getNavigationRailWidth(bool isLongPressed, String? location) {
    if (isLongPressed) return 0;

    const validLocations = {
      '/MangaLibrary',
      '/AnimeLibrary',
      '/NovelLibrary',
      '/history',
      '/updates',
      '/browse',
      '/more',
      '/trackerLibrary',
    };

    return (location == null || validLocations.contains(location)) ? 100 : 0;
  }
}

/// The top of the TV nav rail: the app glyph over a beta flag.
///
/// Uses the bare glyph asset rather than the app icon, tinted with the theme
/// accent, so it carries no white tile of its own into a dark rail and follows
/// whatever accent the user picked.
class _TvRailHeader extends StatelessWidget {
  const _TvRailHeader();

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Padding(
      // Tight under the glyph: the first destination already carries its
      // own vertical padding, so this only needs to clear the beta pill.
      padding: const EdgeInsets.only(top: 14, bottom: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            appIconAssets[2],
            width: 30,
            height: 30,
            color: accent,
            filterQuality: FilterQuality.medium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              'BETA',
              style: TextStyle(
                color: accent,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
