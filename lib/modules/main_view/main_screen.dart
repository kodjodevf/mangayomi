import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/controllers/main_screen_lifecycle_mixin.dart';
import 'package:mangayomi/modules/main_view/nav_actions.dart';
import 'package:mangayomi/modules/main_view/nav_groups.dart';
import 'package:mangayomi/modules/main_view/nav_shrink.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_bottom_navigation.dart';
import 'package:mangayomi/modules/main_view/widgets/mode_bars.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_destination_builders.dart';
import 'package:mangayomi/modules/main_view/widgets/tablet_layout.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/floating_navigation_bar_state_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with MainScreenLifecycleMixin {
  late final String _defaultLocation;
  late final List<String> _navigationOrder;

  final NavDestinationBuilders _navBuilders = NavDestinationBuilders();

  // Double-tapping a Manga/Anime/Novel destination on the mobile bottom bar
  // opens Global Search scoped to that type, mirroring the desktop rail's
  // double-click. Keyed by destination string since the bottom bar callback
  // only hands back the route, not an index.
  String? _lastMobileNavDest;
  DateTime? _lastMobileNavTapTime;

  int currentIndex = 0;
  bool isLibSwitch = false;

  final NavShrink _navShrink = NavShrink();

  @override
  void initState() {
    super.initState();

    _navigationOrder = ref.read(navigationOrderStateProvider);
    final hiddenItems = ref.read(hideItemsStateProvider);

    // On the anime-only TV layout, never land on a hidden manga/novel library.
    final order = ref.read(animeOnlyTvModeProvider)
        ? _navigationOrder.where(isNotHiddenLibOnTv).toList()
        : _navigationOrder;
    final visible = order.where((e) => !hiddenItems.contains(e)).toList();
    _defaultLocation = visible.isNotEmpty ? visible.first : "/AnimeLibrary";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(_defaultLocation);
        initLifecycleServices();
      }
    });
  }

  @override
  void dispose() {
    disposeLifecycleServices();
    super.dispose();
  }

  /// The first library the user actually has visible, in their own nav order.
  String? _firstVisibleLibrary() {
    final hidden = ref.read(hideItemsStateProvider);
    final order = ref.read(animeOnlyTvModeProvider)
        ? _navigationOrder.where(isNotHiddenLibOnTv)
        : _navigationOrder;
    for (final nav in order) {
      if (libLocationRegex.hasMatch(nav) && !hidden.contains(nav)) return nav;
    }
    return null;
  }

  bool _onPageScroll(
    ScrollNotification notification, {
    required bool useFloatingNav,
  }) {
    if (!useFloatingNav || notification.metrics.axis != Axis.vertical) {
      return false;
    }

    var changed = false;
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.maxScrollExtent <= 0 ||
          metrics.pixels <= metrics.minScrollExtent) {
        changed = _navShrink.reset();
      } else {
        changed = _navShrink.update(notification.scrollDelta ?? 0);
      }
    }
    if (changed) setState(() {});
    return false;
  }

  void _wakeNav() {
    if (_navShrink.reset()) setState(() {});
  }

  static bool _isReadingScreen(String? location) {
    return location == '/mangaReaderView' ||
        location == '/animePlayerView' ||
        location == '/novelReaderView';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Locale>(l10nLocaleStateProvider, (previous, next) {
      _navBuilders.clearCache();
      setState(() {});
    });
    // Destinations are cached by route list alone, so a toggle that only
    // changes what's baked into those same widgets (the tooltip) needs its
    // own cache-busting listener, same as the locale above.
    ref.listen<bool>(showNavDoubleTapTooltipStateProvider, (previous, next) {
      _navBuilders.clearCache();
      setState(() {});
    });
    ref.listen<bool>(floatingNavigationBarStateProvider, (previous, next) {
      if (!next) _wakeNav();
    });
    // Remember where the user was inside each group, so tapping the group
    // brings them back there.
    ref.listen<String?>(routerCurrentLocationStateProvider, (_, location) {
      if (location != null) {
        ref.read(lastNavMemberProvider.notifier).visit(location);
      }
    });

    final l10n = context.l10n;
    final route = GoRouter.of(context);
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);
    final mergeLibraryNavMobile = ref.watch(mergeLibraryNavMobileStateProvider);
    // A television has its own home and keeps one destination per route.
    final grouped = ref.watch(navGroupingProvider) && !isTv;
    final location = ref.watch(routerCurrentLocationStateProvider);

    return ref
        .watch(migrationProvider)
        .when(
          data: (_) => Consumer(
            builder: (context, ref, child) {
              final useFloatingNav = shouldUseFloatingNav(
                enabled: ref.watch(floatingNavigationBarStateProvider),
              );
              final prefersNavRail = context.prefersNavRail(
                useFloatingNav: useFloatingNav,
              );
              final isReadingScreen = _isReadingScreen(location);
              bool uniqueSwitch = false;
              List<String> dest = !prefersNavRail && isLibSwitch
                  ? [
                      "_disableLibSwitch",
                      ...navigationOrder.where(
                        (nav) => libLocationRegex.hasMatch(nav),
                      ),
                    ].where((nav) => !hideItems.contains(nav)).toList()
                  : navigationOrder
                        .where((nav) => !hideItems.contains(nav))
                        .toList();

              // Anime-only TV layout: drop the manga & novel library tabs.
              if (ref.watch(animeOnlyTvModeProvider)) {
                dest = dest.where(isNotHiddenLibOnTv).toList();
              }

              if (grouped) {
                dest = groupDestinations(dest);
              } else if (mergeLibraryNavMobile &&
                  !prefersNavRail &&
                  !isLibSwitch) {
                dest = dest
                    .map((nav) {
                      if ([
                        "/MangaLibrary",
                        "/AnimeLibrary",
                        "/NovelLibrary",
                      ].contains(nav)) {
                        if (uniqueSwitch) return null;
                        uniqueSwitch = true;
                        return "_enableLibSwitch";
                      }
                      return nav;
                    })
                    .nonNulls
                    .toList();
              }

              if (isLibSwitch &&
                  (currentIndex >= dest.length ||
                      !libLocationRegex.hasMatch(location ?? ""))) {
                currentIndex = 0;
              } else {
                String? libLocation;
                final group = NavGroup.of(location);
                if (grouped && group != null && dest.contains(group)) {
                  libLocation = group;
                } else if (!grouped &&
                    mergeLibraryNavMobile &&
                    !prefersNavRail &&
                    !isLibSwitch) {
                  libLocation = location?.replaceAll(
                    libLocationRegex,
                    "_enableLibSwitch",
                  );
                }
                int currentIdx = dest.indexOf(
                  libLocation ?? location ?? _defaultLocation,
                );
                if (currentIdx != -1) {
                  currentIndex = currentIdx;
                }
              }

              final incognitoMode = ref.watch(incognitoModeStateProvider);
              final downloadedOnly = ref.watch(downloadedOnlyStateProvider);
              final isLongPressed = ref.watch(isLongPressedStateProvider);

              return FloatingNavigationScope(
                enabled: useFloatingNav,
                child: Column(
                  children: [
                    if (!isReadingScreen)
                      DownloadedOnlyBar(
                        downloadedOnly: downloadedOnly,
                        l10n: l10n,
                      ),
                    if (!isReadingScreen)
                      IncognitoModeBar(
                        incognitoMode: incognitoMode,
                        l10n: l10n,
                      ),
                    Flexible(
                      child: Scaffold(
                        extendBody: useFloatingNav,
                        body: NotificationListener<ScrollNotification>(
                          onNotification: (notification) => _onPageScroll(
                            notification,
                            useFloatingNav: useFloatingNav,
                          ),
                          child: prefersNavRail
                              ? MainTabletLayout(
                                  isLongPressed: isLongPressed,
                                  location: location,
                                  dest: dest,
                                  currentIndex: currentIndex,
                                  route: route,
                                  ref: ref,
                                  buildNavigationWidgetsDesktop: _navBuilders
                                      .buildNavigationWidgetsDesktop,
                                  child: widget.child,
                                )
                              : widget.child,
                        ),
                        bottomNavigationBar: prefersNavRail
                            ? null
                            : MainMobileBottomNavigation(
                                isLongPressed: isLongPressed,
                                location: location,
                                currentIndex: currentIndex,
                                dest: dest,
                                route: route,
                                ref: ref,
                                useFloatingNav: useFloatingNav,
                                shrink: _navShrink.shrunk ? 1.0 : 0.0,
                                onWake: _wakeNav,
                                buildNavigationWidgetsMobile:
                                    _navBuilders.buildNavigationWidgetsMobile,
                                onDestinationSelected: (destination) {
                                  if (destination == "_enableLibSwitch") {
                                    setState(() {
                                      isLibSwitch = true;
                                    });
                                    if (!libLocationRegex.hasMatch(
                                      location ?? "",
                                    )) {
                                      final target = _firstVisibleLibrary();
                                      if (target != null) route.go(target);
                                    }
                                  } else if (destination ==
                                      "_disableLibSwitch") {
                                    setState(() {
                                      isLibSwitch = false;
                                    });
                                  } else {
                                    final now = DateTime.now();
                                    final isDoubleTap = isNavDoubleTap(
                                      destination,
                                      _lastMobileNavDest,
                                      _lastMobileNavTapTime,
                                      now,
                                    );
                                    if (isDoubleTap) {
                                      _lastMobileNavDest = null;
                                      _lastMobileNavTapTime = null;
                                    } else {
                                      _lastMobileNavDest = destination;
                                      _lastMobileNavTapTime = now;
                                    }
                                    openNavDestination(
                                      context,
                                      ref,
                                      destination,
                                      isDoubleTap: isDoubleTap,
                                    );
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          error: (error, _) => Scaffold(
            body: ErrorState(
              message: l10n.startup_failed,
              detail: error.toString(),
              onRetry: () => ref.invalidate(migrationProvider),
            ),
          ),
          loading: () => const LoadingIcon(),
        );
  }
}
