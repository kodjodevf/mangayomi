import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';

final libLocationRegex = RegExp(r"^/(Manga|Anime|Novel)Library$");

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
    _defaultLocation = _navigationOrder.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(_defaultLocation);
        _initializeTimers();
        _initializeProviders();
      }
    });
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
        ref.read(checkForUpdateProvider(context: context));
        for (var type in ItemType.values) {
          ref.read(
            FetchItemSourcesListProvider(
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
    super.dispose();
  }

  int currentIndex = 0;
  bool isLibSwitch = false;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final route = GoRouter.of(context);
    final navigationOrder = ref.watch(navigationOrderStateProvider);
    final hideItems = ref.watch(hideItemsStateProvider);
    final location = ref.watch(routerCurrentLocationStateProvider);

    return ref
        .watch(migrationProvider)
        .when(
          data: (_) => Consumer(
            builder: (context, ref, child) {
              final isReadingScreen = _isReadingScreen(location);
              bool uniqueSwitch = false;
              final dest = !context.isTablet && isLibSwitch
                  ? [
                      "_disableLibSwitch",
                      ...navigationOrder.where(
                        (nav) => libLocationRegex.hasMatch(nav),
                      ),
                    ].where((nav) => !hideItems.contains(nav)).toList()
                  : navigationOrder
                        .where((nav) => !hideItems.contains(nav))
                        .map((nav) {
                          if (!context.isTablet &&
                              !isLibSwitch &&
                              [
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

              if (isLibSwitch &&
                  (currentIndex >= dest.length ||
                      !libLocationRegex.hasMatch(location ?? ""))) {
                currentIndex = 0;
              } else {
                String? libLocation;
                if (!context.isTablet && !isLibSwitch) {
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
              final isLongPressed = ref.watch(isLongPressedMangaStateProvider);

              return Column(
                children: [
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

class _IncognitoModeBar extends StatelessWidget {
  const _IncognitoModeBar({required this.incognitoMode, required this.l10n});

  final bool incognitoMode;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnimatedContainer(
        height: incognitoMode
            ? Platform.isAndroid || Platform.isIOS
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

class _TabletLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final destinations = buildNavigationWidgetsDesktop(ref, dest, context);
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 0),
          width: _getNavigationRailWidth(isLongPressed, location),
          child: Stack(
            children: [
              NavigationRailTheme(
                data: NavigationRailThemeData(
                  indicatorShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  useIndicator: true,
                  destinations: destinations,
                  selectedIndex:
                      (currentIndex >= 0 && currentIndex < destinations.length)
                      ? currentIndex
                      : 0,
                  onDestinationSelected: (newIndex) {
                    route.go(dest[newIndex]);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
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
