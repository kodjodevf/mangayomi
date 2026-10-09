import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/modules/history/providers/isar_providers.dart';
import 'package:mangayomi/repositories/history_repository.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/appearance/providers/floating_navigation_bar_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/modules/main_view/nav_shrink.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/settings/browse/providers/browse_state_provider.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';
import 'package:mangayomi/modules/main_view/widgets/mode_bars.dart';
import 'package:mangayomi/modules/main_view/widgets/tablet_layout.dart';
import 'package:mangayomi/modules/main_view/widgets/mobile_bottom_navigation.dart';
import 'package:mangayomi/modules/main_view/widgets/nav_badges.dart';

final libLocationRegex = RegExp(r"^/(Manga|Anime|Novel)Library$");

/// Nav destinations kept off the anime-only TV layout (the manga & novel
/// libraries). True means "keep this destination".
bool _isNotHiddenLibOnTv(String nav) =>
    nav != "/MangaLibrary" && nav != "/NovelLibrary";

/// The ItemType a nav destination maps to, or null for destinations with no
/// single content type to scope a global search to (Updates, History,
/// Browse, More, ...). Shared by the desktop rail and mobile bottom bar's
/// double-tap-for-global-search handling.
ItemType? itemTypeForNavDest(String dest) => switch (dest) {
  "/MangaLibrary" => ItemType.manga,
  "/AnimeLibrary" => ItemType.anime,
  "/NovelLibrary" => ItemType.novel,
  _ => null,
};

/// How close together two taps on the same nav destination need to land to
/// count as a double-tap/double-click, rather than two separate single taps.
const _navDoubleTapWindow = Duration(milliseconds: 450);

/// Resumes the most recently read/watched entry from history (optionally filtered by [itemType]),
/// or shows a snackbar if none found.
Future<void> resumeLatestHistory(
  BuildContext context, [
  ItemType? itemType,
]) async {
  // When an itemType is specified (e.g. from the active tab), strictly query that itemType.
  final history = itemType != null
      ? historyRepository.getLatestHistory(itemType)
      : historyRepository.getLatestHistory();
  if (history != null && history.chapterId != null) {
    final chapter = chapterRepository.findByIdSync(history.chapterId!);
    if (chapter != null && chapter.manga.value != null) {
      await pushMangaReaderView(context: context, chapter: chapter);
      return;
    }
  }
  if (context.mounted) {
    botToast(context.l10n.no_next_chapter, second: 2);
  }
}

/// Whether tapping [current] counts as a double-tap on [last], given when
/// [last] landed. Shared by the desktop rail and mobile bottom bar, which
/// each track their own last-tap state (an index vs. a route string) but
/// apply the same timing check to it.
bool isNavDoubleTap<T>(
  T current,
  T? last,
  DateTime? lastTapTime,
  DateTime now,
) {
  return current == last &&
      lastTapTime != null &&
      now.difference(lastTapTime) < _navDoubleTapWindow;
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Timer? _backupTimer;
  Timer? _syncTimer;

  late final String _defaultLocation;
  late final List<String> _navigationOrder;

  static final Map<String, String> _hyphenatedLabelsCache = {};

  final Map<String, List<NavigationRailDestination>> _desktopDestinationsCache =
      {};

  // Double-tapping a Manga/Anime/Novel destination on the mobile bottom bar
  // opens Global Search scoped to that type, mirroring the desktop rail's
  // double-click. Keyed by destination string since the bottom bar callback
  // only hands back the route, not an index.
  String? _lastMobileNavDest;
  DateTime? _lastMobileNavTapTime;
  final Map<String, List<Widget>> _mobileDestinationsCache = {};
  void _clearCache() {
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

  @override
  void initState() {
    super.initState();

    _navigationOrder = ref.read(navigationOrderStateProvider);
    final hiddenItems = ref.read(hideItemsStateProvider);

    // On the anime-only TV layout, never land on a hidden manga/novel library.
    final order = ref.read(animeOnlyTvModeProvider)
        ? _navigationOrder.where(_isNotHiddenLibOnTv).toList()
        : _navigationOrder;
    final visible = order.where((e) => !hiddenItems.contains(e)).toList();
    _defaultLocation = visible.isNotEmpty ? visible.first : "/AnimeLibrary";

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(_defaultLocation);
        _initializeTimers();
        _initializeProviders();
      }
    });

    discordRpc?.connect(ref);
  }

  void _rescheduleSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (ref.read(restoreSyncGuardProvider)) return;

    final syncPrefs = ref.read(synchingProvider(syncId: 1));
    final freq = syncPrefs.autoSyncFrequency;
    if (syncPrefs.syncOn &&
        freq > 0 &&
        (syncPrefs.authToken?.isNotEmpty ?? false)) {
      _syncTimer = Timer.periodic(Duration(seconds: freq), _onSyncTimerTick);
    }
  }

  /// The first library the user actually has visible, in their own nav order.
  String? _firstVisibleLibrary() {
    final hidden = ref.read(hideItemsStateProvider);
    final order = ref.read(animeOnlyTvModeProvider)
        ? _navigationOrder.where(_isNotHiddenLibOnTv)
        : _navigationOrder;
    for (final nav in order) {
      if (libLocationRegex.hasMatch(nav) && !hidden.contains(nav)) return nav;
    }
    return null;
  }

  void _initializeTimers() {
    _backupTimer = Timer.periodic(
      const Duration(minutes: 5),
      _onBackupTimerTick,
    );

    _rescheduleSyncTimer();

    // Pauses the auto-sync timer for the duration of a restore (and its
    // post-restore upload), instead of just rescheduling it — a restore can
    // outlast one sync interval, so a reschedule alone could still let the
    // timer fire mid-restore. syncServerProvider.startSync also checks this
    // guard directly, covering a manual sync trigger too.
    ref.listenManual<bool>(restoreSyncGuardProvider, (_, restoring) {
      if (restoring) {
        _syncTimer?.cancel();
        _syncTimer = null;
        return;
      }
      _rescheduleSyncTimer();
    });

    // Listen to changes in sync preferences (frequency, syncOn, login/logout)
    // and immediately reschedule the timer and check if due.
    ref.listenManual(synchingProvider(syncId: 1), (prev, next) {
      _rescheduleSyncTimer();
      if (mounted) {
        unawaited(autoSyncIfDue(ref));
      }
    });
  }

  void _initializeProviders() {
    // The extension-repo fetches (one per item type) and the GitHub update
    // check hit the network; delay them so they don't compete with the first
    // paint and the initial library queries.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        for (var type in ItemType.values) {
          ref.read(
            fetchItemSourcesListProvider(
              id: null,
              reFresh: false,
              itemType: type,
            ),
          );
        }
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || isTv) return;
      ref.listenManual<AsyncValue<UpdateInfo?>>(checkForUpdateProvider, (
        _,
        next,
      ) {
        next.whenData((updateInfo) {
          if (updateInfo != null && mounted) {
            showDialog(
              context: context,
              builder: (_) => DownloadFileScreen(updateAvailable: updateInfo),
            );
          }
        });
      });
    });
  }

  void _onBackupTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    ref.read(checkAndBackupProvider);
  }

  void _onSyncTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    unawaited(autoSyncIfDue(ref));
  }

  @override
  void dispose() {
    _backupTimer?.cancel();
    _syncTimer?.cancel();
    discordRpc?.disconnect();
    super.dispose();
  }

  int currentIndex = 0;
  bool isLibSwitch = false;

  final NavShrink _navShrink = NavShrink();

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

  @override
  Widget build(BuildContext context) {
    ref.listen<Locale>(l10nLocaleStateProvider, (previous, next) {
      _clearCache();
      setState(() {});
    });
    // Destinations are cached by route list alone, so a toggle that only
    // changes what's baked into those same widgets (the tooltip) needs its
    // own cache-busting listener, same as the locale above.
    ref.listen<bool>(showNavDoubleTapTooltipStateProvider, (previous, next) {
      _clearCache();
      setState(() {});
    });
    ref.listen<bool>(floatingNavigationBarStateProvider, (previous, next) {
      if (!next) _wakeNav();
    });

    final l10n = context.l10n;
    final route = GoRouter.of(context);
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);
    final mergeLibraryNavMobile = ref.watch(mergeLibraryNavMobileStateProvider);
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
                dest = dest.where(_isNotHiddenLibOnTv).toList();
              }

              if (mergeLibraryNavMobile && !prefersNavRail && !isLibSwitch) {
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
                if (mergeLibraryNavMobile && !prefersNavRail && !isLibSwitch) {
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
                                  buildNavigationWidgetsDesktop:
                                      _buildNavigationWidgetsDesktop,
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
                                    _buildNavigationWidgetsMobile,
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
                                    if (isDoubleTap &&
                                        destination == '/history') {
                                      _lastMobileNavDest = null;
                                      _lastMobileNavTapTime = null;
                                      final activeType = ref.read(
                                        activeHistoryItemTypeStateProvider,
                                      );
                                      unawaited(
                                        resumeLatestHistory(
                                          context,
                                          activeType,
                                        ),
                                      );
                                      return;
                                    }
                                    final itemType = itemTypeForNavDest(
                                      destination,
                                    );
                                    if (isDoubleTap && itemType != null) {
                                      _lastMobileNavDest = null;
                                      _lastMobileNavTapTime = null;
                                      context.push(
                                        '/globalSearch',
                                        extra: (null, itemType),
                                      );
                                      return;
                                    }
                                    _lastMobileNavDest = destination;
                                    _lastMobileNavTapTime = now;
                                    route.go(destination);
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
          // A failed migration used to render the loading screen, so the app
          // sat on a blank splash forever with nothing to act on. Show what
          // happened and let the user run it again.
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

  static bool _isReadingScreen(String? location) {
    return location == '/mangaReaderView' ||
        location == '/animePlayerView' ||
        location == '/novelReaderView';
  }

  /// Wraps [icon] in a [Tooltip] with [message] unless the user turned the
  /// nav double-tap hint off in Settings, in which case it's the bare icon.
  Widget _navTooltipIcon(bool showTooltip, String message, Widget icon) {
    return showTooltip ? Tooltip(message: message, child: icon) : icon;
  }

  List<NavigationRailDestination> _buildNavigationWidgetsDesktop(
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

    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Icons.book_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.manga),
          const Icon(Icons.book_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.manga),
        ),
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Icons.video_collection_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.anime),
          const Icon(Icons.video_collection_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.anime),
        ),
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Icons.auto_stories_rounded),
        ),
        icon: _navTooltipIcon(
          showTooltip,
          l10n.double_tap_search_hint(l10n.novel),
          const Icon(Icons.auto_stories_outlined),
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.novel),
        ),
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_rounded),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_outlined),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            getHyphenatedUpdatesLabel(
              ref.watch(l10nLocaleStateProvider).languageCode,
              l10n.updates,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (dest.contains("/history")) {
      destinations[dest.indexOf("/history")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.history_rounded),
        icon: const Icon(Icons.history_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.history),
        ),
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_rounded),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_outlined),
          ref: ref,
        ),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.browse),
        ),
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.more_horiz_rounded),
        icon: const Icon(Icons.more_horiz_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.more),
        ),
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.account_tree_rounded),
        icon: const Icon(Icons.account_tree_outlined),
        label: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(l10n.tracking),
        ),
      );
    }

    final result = destinations.nonNulls.toList();
    _desktopDestinationsCache[cacheKey] = result;
    return result;
  }

  List<Widget> _buildNavigationWidgetsMobile(
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
        selectedIcon: const Icon(Icons.arrow_back_rounded),
        icon: const Icon(Icons.arrow_back_rounded),
        label: l10n.go_back,
      );
    }
    if (dest.contains("_enableLibSwitch")) {
      destinations[dest.indexOf("_enableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Icons.collections_bookmark_rounded),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: l10n.library,
      );
    }
    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.book_rounded),
        icon: const Icon(Icons.book_outlined),
        label: l10n.manga,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.manga) : '',
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.video_collection_rounded),
        icon: const Icon(Icons.video_collection_outlined),
        label: l10n.anime,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.anime) : '',
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.auto_stories_rounded),
        icon: const Icon(Icons.auto_stories_outlined),
        label: l10n.novel,
        tooltip: showTooltip ? l10n.double_tap_search_hint(l10n.novel) : '',
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationDestination(
        selectedIcon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_rounded),
          ref: ref,
        ),
        icon: UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_outlined),
          ref: ref,
        ),
        label: l10n.updates,
      );
    }
    if (dest.contains("/history")) {
      destinations[dest.indexOf("/history")] = NavigationDestination(
        selectedIcon: const Icon(Icons.history_rounded),
        icon: const Icon(Icons.history_outlined),
        label: l10n.history,
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationDestination(
        selectedIcon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_rounded),
          ref: ref,
        ),
        icon: ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_outlined),
          ref: ref,
        ),
        label: l10n.browse,
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationDestination(
        selectedIcon: const Icon(Icons.more_horiz_rounded),
        icon: const Icon(Icons.more_horiz_outlined),
        label: l10n.more,
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.account_tree_rounded),
        icon: const Icon(Icons.account_tree_outlined),
        label: l10n.tracking,
      );
    }

    _mobileDestinationsCache[cacheKey] = destinations;
    return destinations;
  }
}

// Resolved once — GoogleFonts lookups in build run font resolution on every
// rebuild of these always-mounted bars.
final String? barFontFamily = GoogleFonts.aBeeZee().fontFamily;
