import 'dart:async';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar_community/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/providers/downloaded_only_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/main_view/providers/tv_mode_provider.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/detail/providers/state_providers.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';

final libLocationRegex = RegExp(r"^/(Manga|Anime|Novel)Library$");

/// Nav destinations kept off the anime-only TV layout (the manga & novel
/// libraries). True means "keep this destination".
bool _isNotHiddenLibOnTv(String nav) =>
    nav != "/MangaLibrary" && nav != "/NovelLibrary";

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
  late final int _autoSyncFrequency;

  static final Map<String, String> _hyphenatedLabelsCache = {};

  final Map<String, List<NavigationRailDestination>> _desktopDestinationsCache =
      {};
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
    _autoSyncFrequency = ref
        .read(synchingProvider(syncId: 1))
        .autoSyncFrequency;
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

  void _initializeTimers() {
    _backupTimer = Timer.periodic(
      const Duration(minutes: 5),
      _onBackupTimerTick,
    );

    if (_autoSyncFrequency != 0) {
      _syncTimer = Timer.periodic(
        Duration(seconds: _autoSyncFrequency),
        _onSyncTimerTick,
      );
    }
  }

  void _initializeProviders() {
    Future.microtask(() {
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
    try {
      final l10n = l10nLocalizations(context)!;
      ref.read(syncServerProvider(syncId: 1).notifier).startSync(l10n, true);
    } catch (e) {
      botToast(
        "Failed to sync! Maybe the sync server is down. "
        "Restart the app to resume auto sync.",
      );
      timer.cancel();
    }
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
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<UpdateInfo?>>(checkForUpdateProvider, (_, next) {
      // On TV the in-app updater (download + install an APK) is not reachable
      // with a d-pad and is not how TV builds update (sideload / the release
      // APK). Left on, this modal would appear unannounced over whatever the
      // user is doing and trap focus with no way to dismiss it. TV updates out
      // of band, so never raise it there.
      if (isTv) return;
      next.whenData((updateInfo) {
        if (updateInfo != null && context.mounted) {
          showDialog(
            context: context,
            builder: (_) => DownloadFileScreen(updateAvailable: updateInfo),
          );
        }
      });
    });

    ref.listen<Locale>(l10nLocaleStateProvider, (previous, next) {
      _clearCache();
      setState(() {});
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
              final isReadingScreen = _isReadingScreen(location);
              bool uniqueSwitch = false;
              List<String> dest = !context.isTablet && isLibSwitch
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

              if (mergeLibraryNavMobile && !context.isTablet && !isLibSwitch) {
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
                if (mergeLibraryNavMobile &&
                    !context.isTablet &&
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

              return Column(
                children: [
                  if (!isReadingScreen)
                    _DownloadedOnlyBar(
                      downloadedOnly: downloadedOnly,
                      l10n: l10n,
                    ),
                  if (!isReadingScreen)
                    _IncognitoModeBar(incognitoMode: incognitoMode, l10n: l10n),
                  Flexible(
                    child: Scaffold(
                      body: context.isTablet
                          ? _TabletLayout(
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
                      bottomNavigationBar: context.isTablet
                          ? null
                          : _MobileBottomNavigation(
                              isLongPressed: isLongPressed,
                              location: location,
                              currentIndex: currentIndex,
                              dest: dest,
                              route: route,
                              ref: ref,
                              buildNavigationWidgetsMobile:
                                  _buildNavigationWidgetsMobile,
                              onDestinationSelected: (destination) {
                                if (destination == "_enableLibSwitch") {
                                  setState(() {
                                    isLibSwitch = true;
                                  });
                                } else if (destination == "_disableLibSwitch") {
                                  setState(() {
                                    isLibSwitch = false;
                                  });
                                } else {
                                  route.go(destination);
                                }
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
          error: (error, _) => const LoadingIcon(),
          loading: () => const LoadingIcon(),
        );
  }

  static bool _isReadingScreen(String? location) {
    return location == '/mangaReaderView' ||
        location == '/animePlayerView' ||
        location == '/novelReaderView';
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
    final destinations = List<NavigationRailDestination?>.filled(
      dest.length,
      null,
    );

    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationRailDestination(
        // Even breathing room between tabs on TV; null off-TV.
        padding: isTv ? const EdgeInsets.symmetric(vertical: 6) : null,
        selectedIcon: const Icon(Icons.collections_bookmark),
        icon: const Icon(Icons.collections_bookmark_outlined),
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
        selectedIcon: const Icon(Icons.video_collection),
        icon: const Icon(Icons.video_collection_outlined),
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
        selectedIcon: const Icon(Icons.local_library),
        icon: const Icon(Icons.local_library_outlined),
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
        selectedIcon: _UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases),
          ref: ref,
        ),
        icon: _UpdatesBadgeWidget(
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
        selectedIcon: const Icon(Icons.history),
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
        selectedIcon: _ExtensionBadgeWidget(
          icon: const Icon(Icons.explore),
          ref: ref,
        ),
        icon: _ExtensionBadgeWidget(
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
        selectedIcon: const Icon(Icons.more_horiz),
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
        selectedIcon: const Icon(Icons.account_tree),
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
    final destinations = List<Widget>.filled(
      dest.length,
      const SizedBox.shrink(),
    );

    if (dest.contains("_disableLibSwitch")) {
      destinations[dest.indexOf("_disableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Icons.arrow_back),
        icon: const Icon(Icons.arrow_back),
        label: l10n.go_back,
      );
    }
    if (dest.contains("_enableLibSwitch")) {
      destinations[dest.indexOf("_enableLibSwitch")] = NavigationDestination(
        selectedIcon: const Icon(Icons.collections_bookmark),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: l10n.library,
      );
    }
    if (dest.contains("/MangaLibrary")) {
      destinations[dest.indexOf("/MangaLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.collections_bookmark),
        icon: const Icon(Icons.collections_bookmark_outlined),
        label: l10n.manga,
      );
    }
    if (dest.contains("/AnimeLibrary")) {
      destinations[dest.indexOf("/AnimeLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.video_collection),
        icon: const Icon(Icons.video_collection_outlined),
        label: l10n.anime,
      );
    }
    if (dest.contains("/NovelLibrary")) {
      destinations[dest.indexOf("/NovelLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.local_library),
        icon: const Icon(Icons.local_library_outlined),
        label: l10n.novel,
      );
    }
    if (dest.contains("/updates")) {
      destinations[dest.indexOf("/updates")] = NavigationDestination(
        selectedIcon: _UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases),
          ref: ref,
        ),
        icon: _UpdatesBadgeWidget(
          icon: const Icon(Icons.new_releases_outlined),
          ref: ref,
        ),
        label: l10n.updates,
      );
    }
    if (dest.contains("/history")) {
      destinations[dest.indexOf("/history")] = NavigationDestination(
        selectedIcon: const Icon(Icons.history),
        icon: const Icon(Icons.history_outlined),
        label: l10n.history,
      );
    }
    if (dest.contains("/browse")) {
      destinations[dest.indexOf("/browse")] = NavigationDestination(
        selectedIcon: _ExtensionBadgeWidget(
          icon: const Icon(Icons.explore),
          ref: ref,
        ),
        icon: _ExtensionBadgeWidget(
          icon: const Icon(Icons.explore_outlined),
          ref: ref,
        ),
        label: l10n.browse,
      );
    }
    if (dest.contains("/more")) {
      destinations[dest.indexOf("/more")] = NavigationDestination(
        selectedIcon: const Icon(Icons.more_horiz),
        icon: const Icon(Icons.more_horiz_outlined),
        label: l10n.more,
      );
    }
    if (dest.contains("/trackerLibrary")) {
      destinations[dest.indexOf("/trackerLibrary")] = NavigationDestination(
        selectedIcon: const Icon(Icons.account_tree),
        icon: const Icon(Icons.account_tree_outlined),
        label: l10n.tracking,
      );
    }

    _mobileDestinationsCache[cacheKey] = destinations;
    return destinations;
  }
}

class _DownloadedOnlyBar extends StatelessWidget {
  const _DownloadedOnlyBar({required this.downloadedOnly, required this.l10n});

  final bool downloadedOnly;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: downloadedOnly
            ? isMobile
                  ? MediaQuery.of(context).padding.top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.secondaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.downloaded_only,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.aBeeZee().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncognitoModeBar extends StatelessWidget {
  const _IncognitoModeBar({required this.incognitoMode, required this.l10n});

  final bool incognitoMode;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: incognitoMode
            ? isMobile
                  ? MediaQuery.of(context).padding.top * 2
                  : 50
            : 0,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 150),
        color: context.primaryColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                l10n.incognito_mode,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: GoogleFonts.aBeeZee().fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletLayout extends StatefulWidget {
  const _TabletLayout({
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
  State<_TabletLayout> createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<_TabletLayout> {
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
      onDestinationSelected: (newIndex) {
        widget.route.go(widget.dest[newIndex]);
      },
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

class _MobileBottomNavigation extends StatelessWidget {
  const _MobileBottomNavigation({
    required this.isLongPressed,
    required this.location,
    required this.currentIndex,
    required this.dest,
    required this.route,
    required this.ref,
    required this.buildNavigationWidgetsMobile,
    required this.onDestinationSelected,
  });

  final bool isLongPressed;
  final String? location;
  final int currentIndex;
  final List<String> dest;
  final GoRouter route;
  final WidgetRef ref;
  final List<Widget> Function(WidgetRef, List<String>, BuildContext)
  buildNavigationWidgetsMobile;
  final Function(String) onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 0),
      width: context.width(1),
      height: _getBottomNavigationHeight(isLongPressed, location),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(overflow: TextOverflow.ellipsis),
          ),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 500),
          selectedIndex: currentIndex,
          destinations: buildNavigationWidgetsMobile(ref, dest, context),
          onDestinationSelected: (newIndex) {
            onDestinationSelected(dest[newIndex]);
          },
        ),
      ),
    );
  }

  static double? _getBottomNavigationHeight(
    bool isLongPressed,
    String? location,
  ) {
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

    return (location == null || validLocations.contains(location)) ? null : 0;
  }
}

class _ExtensionBadgeWidget extends ConsumerWidget {
  const _ExtensionBadgeWidget({required this.icon, required this.ref});

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: isar.sources
          .filter()
          .idIsNotNull()
          .optional(
            hideItems.contains("/MangaLibrary"),
            (q) => q.not().itemTypeEqualTo(ItemType.manga),
          )
          .optional(
            hideItems.contains("/AnimeLibrary"),
            (q) => q.not().itemTypeEqualTo(ItemType.anime),
          )
          .optional(
            hideItems.contains("/NovelLibrary"),
            (q) => q.not().itemTypeEqualTo(ItemType.novel),
          )
          .and()
          .isActiveEqualTo(true)
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        final entries = snapshot.data!
            .where(
              (element) =>
                  compareVersions(element.version!, element.versionLast!) < 0,
            )
            .toList();

        if (entries.isEmpty) {
          return icon;
        }

        return Badge(label: Text("${entries.length}"), child: icon);
      },
    );
  }
}

class _UpdatesBadgeWidget extends ConsumerWidget {
  const _UpdatesBadgeWidget({required this.icon, required this.ref});

  final Widget icon;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hideItems = ref.watch(hideItemsStateProvider);

    return StreamBuilder(
      stream: isar.updates
          .filter()
          .idIsNotNull()
          .optional(
            hideItems.contains("/MangaLibrary"),
            (q) => q.chapter(
              (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.manga)),
            ),
          )
          .optional(
            hideItems.contains("/AnimeLibrary"),
            (q) => q.chapter(
              (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.anime)),
            ),
          )
          .optional(
            hideItems.contains("/NovelLibrary"),
            (q) => q.chapter(
              (c) => c.manga((m) => m.not().itemTypeEqualTo(ItemType.novel)),
            ),
          )
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return icon;
        }

        final entries = snapshot.data!.where((element) {
          if (!element.chapter.isLoaded) {
            element.chapter.loadSync();
          }
          return !(element.chapter.value?.isRead ?? false);
        }).toList();

        if (entries.isEmpty) {
          return icon;
        }

        return Badge(label: Text("${entries.length}"), child: icon);
      },
    );
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
            'assets/app_icons/icon.png',
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
