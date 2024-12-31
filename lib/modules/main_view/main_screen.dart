import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/update.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/widgets/loading_icon.dart';
import 'package:mangayomi/services/fetch_anime_sources.dart';
import 'package:mangayomi/services/fetch_manga_sources.dart';
import 'package:mangayomi/modules/main_view/providers/migration.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/services/fetch_novel_sources.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  String getHyphenatedUpdatesLabel(String languageCode, String defaultLabel) {
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
  }

  late bool hideManga = ref.watch(hideMangaStateProvider);
  late bool hideAnime = ref.watch(hideAnimeStateProvider);
  late bool hideNovel = ref.watch(hideNovelStateProvider);
  late String? location =
      ref.watch(routerCurrentLocationStateProvider(context));
  late String defaultLocation = hideManga
      ? hideAnime
          ? hideNovel
              ? '/more'
              : '/NovelLibrary'
          : '/AnimeLibrary'
      : '/MangaLibrary';
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(defaultLocation);

      Timer.periodic(Duration(minutes: 5), (timer) {
        ref.read(checkAndBackupProvider);
      });
      ref.watch(checkForUpdateProvider(context: context));
      ref.watch(fetchMangaSourcesListProvider(id: null, reFresh: false));
      ref.watch(fetchAnimeSourcesListProvider(id: null, reFresh: false));
      ref.watch(fetchNovelSourcesListProvider(id: null, reFresh: false));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final route = GoRouter.of(context);
    location = ref.watch(routerCurrentLocationStateProvider(context));
    return ref.watch(migrationProvider).when(data: (_) {
      return Consumer(builder: (context, ref, chuld) {
        hideManga = ref.watch(hideMangaStateProvider);
        hideAnime = ref.watch(hideAnimeStateProvider);
        hideNovel = ref.watch(hideNovelStateProvider);
        bool isReadingScreen = location == '/mangaReaderView' ||
            location == '/animePlayerView' ||
            location == '/novelReaderView';
        final dest = [
          '/MangaLibrary',
          '/AnimeLibrary',
          '/NovelLibrary',
          '/updates',
          '/history',
          '/browse',
          '/more'
        ];
        if (hideManga) {
          dest.removeWhere((d) => d == "/MangaLibrary");
        }
        if (hideAnime) {
          dest.removeWhere((d) => d == "/AnimeLibrary");
        }
        if (hideNovel) {
          dest.removeWhere((d) => d == "/NovelLibrary");
        }
        int currentIndex = dest.indexOf(location ?? defaultLocation);
        if (currentIndex == -1) {
          currentIndex = dest.length - 1;
        }

        final incognitoMode = ref.watch(incognitoModeStateProvider);
        final isLongPressed = ref.watch(isLongPressedMangaStateProvider);
        return Column(
          children: [
            if (!isReadingScreen)
              Material(
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
                      )
                    ],
                  ),
                ),
              ),
            Flexible(
              child: Scaffold(
                body: context.isTablet
                    ? Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 0),
                            width: switch (isLongPressed) {
                              true => 0,
                              _ => switch (location) {
                                  null => 100,
                                  != '/MangaLibrary' &&
                                        != '/AnimeLibrary' &&
                                        != '/NovelLibrary' &&
                                        != '/history' &&
                                        != '/updates' &&
                                        != '/browse' &&
                                        != '/more' =>
                                    0,
                                  _ => 100,
                                },
                            },
                            child: Stack(
                              children: [
                                NavigationRailTheme(
                                  data: NavigationRailThemeData(
                                    indicatorShape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                  ),
                                  child: Builder(builder: (context) {
                                    return NavigationRail(
                                      labelType: NavigationRailLabelType.all,
                                      useIndicator: true,
                                      destinations: [
                                        if (!hideManga)
                                          NavigationRailDestination(
                                              selectedIcon: const Icon(
                                                  Icons.collections_bookmark),
                                              icon: const Icon(Icons
                                                  .collections_bookmark_outlined),
                                              label: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(l10n.manga))),
                                        if (!hideAnime)
                                          NavigationRailDestination(
                                              selectedIcon: const Icon(
                                                  Icons.video_collection),
                                              icon: const Icon(Icons
                                                  .video_collection_outlined),
                                              label: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(l10n.anime))),
                                        if (!hideNovel)
                                          NavigationRailDestination(
                                              selectedIcon: const Icon(
                                                  Icons.local_library),
                                              icon: const Icon(
                                                  Icons.local_library_outlined),
                                              label: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(l10n.novel))),
                                        NavigationRailDestination(
                                            selectedIcon: _updatesTotalNumbers(
                                                ref, Icon(Icons.new_releases)),
                                            icon: _updatesTotalNumbers(
                                                ref,
                                                Icon(Icons
                                                    .new_releases_outlined)),
                                            label: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                getHyphenatedUpdatesLabel(
                                                  ref
                                                      .watch(
                                                          l10nLocaleStateProvider)
                                                      .languageCode,
                                                  l10n.updates,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        NavigationRailDestination(
                                            selectedIcon:
                                                const Icon(Icons.history),
                                            icon: const Icon(
                                                Icons.history_outlined),
                                            label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(l10n.history))),
                                        NavigationRailDestination(
                                            selectedIcon:
                                                _extensionUpdateTotalNumbers(
                                                    ref, Icon(Icons.explore)),
                                            icon: _extensionUpdateTotalNumbers(
                                                ref,
                                                Icon(Icons.explore_outlined)),
                                            label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(l10n.browse))),
                                        NavigationRailDestination(
                                            selectedIcon:
                                                const Icon(Icons.more_horiz),
                                            icon: const Icon(
                                                Icons.more_horiz_outlined),
                                            label: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Text(l10n.more))),
                                      ],
                                      selectedIndex: currentIndex,
                                      onDestinationSelected: (newIndex) {
                                        route.go(dest[newIndex]);
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: widget.child)
                        ],
                      )
                    : widget.child,
                bottomNavigationBar: context.isTablet
                    ? null
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        width: context.width(1),
                        height: switch (isLongPressed) {
                          true => 0,
                          _ => switch (location) {
                              null => null,
                              != '/MangaLibrary' &&
                                    != '/AnimeLibrary' &&
                                    != '/NovelLibrary' &&
                                    != '/history' &&
                                    != '/updates' &&
                                    != '/browse' &&
                                    != '/more' =>
                                0,
                              _ => null,
                            },
                        },
                        child: NavigationBarTheme(
                          data: NavigationBarThemeData(
                            indicatorShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: NavigationBar(
                            animationDuration:
                                const Duration(milliseconds: 500),
                            selectedIndex: currentIndex,
                            destinations: [
                              if (!hideManga)
                                NavigationDestination(
                                    selectedIcon:
                                        const Icon(Icons.collections_bookmark),
                                    icon: const Icon(
                                        Icons.collections_bookmark_outlined),
                                    label: l10n.manga),
                              if (!hideAnime)
                                NavigationDestination(
                                    selectedIcon:
                                        const Icon(Icons.video_collection),
                                    icon: const Icon(
                                        Icons.video_collection_outlined),
                                    label: l10n.anime),
                              if (!hideNovel)
                                NavigationDestination(
                                    selectedIcon:
                                        const Icon(Icons.local_library),
                                    icon: const Icon(
                                        Icons.local_library_outlined),
                                    label: l10n.novel),
                              NavigationDestination(
                                  selectedIcon: _updatesTotalNumbers(
                                      ref, Icon(Icons.new_releases)),
                                  icon: _updatesTotalNumbers(
                                      ref, Icon(Icons.new_releases_outlined)),
                                  label: l10n.updates),
                              NavigationDestination(
                                  selectedIcon: const Icon(Icons.history),
                                  icon: const Icon(Icons.history_outlined),
                                  label: l10n.history),
                              NavigationDestination(
                                  selectedIcon: _extensionUpdateTotalNumbers(
                                      ref, Icon(Icons.explore)),
                                  icon: _extensionUpdateTotalNumbers(
                                      ref, Icon(Icons.explore_outlined)),
                                  label: l10n.browse),
                              NavigationDestination(
                                  selectedIcon: const Icon(Icons.more_horiz),
                                  icon: const Icon(Icons.more_horiz_outlined),
                                  label: l10n.more),
                            ],
                            onDestinationSelected: (newIndex) {
                              route.go(dest[newIndex]);
                            },
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      });
    }, error: (error, _) {
      return const LoadingIcon();
    }, loading: () {
      return const LoadingIcon();
    });
  }
}

Widget _extensionUpdateTotalNumbers(WidgetRef re, Widget widget) {
  return StreamBuilder(
      stream: isar.sources
          .filter()
          .idIsNotNull()
          .and()
          .isActiveEqualTo(true)
          .watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final entries = snapshot.data!
              .where((element) =>
                  compareVersions(element.version!, element.versionLast!) < 0)
              .toList();
          if (entries.isEmpty) {
            return widget;
          }
          return Badge(label: Text("${entries.length}"), child: widget);
        }
        return widget;
      });
}

Widget _updatesTotalNumbers(WidgetRef ref, Widget widget) {
  return StreamBuilder(
      stream: isar.updates.filter().idIsNotNull().watch(fireImmediately: true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final entries = snapshot.data!.where((element) {
            if (!element.chapter.isLoaded) {
              element.chapter.loadSync();
            }
            return !(element.chapter.value?.isRead ?? false);
          }).toList();
          if (entries.isEmpty) {
            return widget;
          }
          return Badge(label: Text("${entries.length}"), child: widget);
        }
        return widget;
      });
}
