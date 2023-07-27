import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/library/providers/library_state_provider.dart';
import 'package:mangayomi/modules/more/providers/incognito_mode_state_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final route = GoRouter.of(context);
    int currentIndex = route.location == '/MangaLibrary'
        ? 0
        : route.location == '/AnimeLibrary'
            ? 1
            : route.location == '/updates'
                ? 2
                : route.location == '/browse'
                    ? 3
                    : 4;
    bool isReadingScreen = route.location == '/mangareaderview';
    return Column(
      children: [
        if (!isReadingScreen)
          Consumer(builder: (context, ref, child) {
            final incognitoMode = ref.watch(incognitoModeStateProvider);
            return Material(
              child: AnimatedContainer(
                height: incognitoMode
                    ? Platform.isAndroid || Platform.isIOS
                        ? MediaQuery.of(context).padding.top * 2
                        : 50
                    : 0,
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 150),
                color: primaryColor(context),
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
            );
          }),
        Flexible(
          child: Scaffold(
            body: isTablet(context)
                ? Row(
                    children: [
                      Consumer(builder: (context, ref, child) {
                        final isLongPressed =
                            ref.watch(isLongPressedMangaStateProvider);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 0),
                          width: isLongPressed
                              ? 0
                              : route.location != '/MangaLibrary' &&
                                      route.location != '/AnimeLibrary' &&
                                      route.location != '/updates' &&
                                      route.location != '/browse' &&
                                      route.location != '/more'
                                  ? 0
                                  : 100,
                          child: NavigationRailTheme(
                            data: NavigationRailThemeData(
                              indicatorShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: NavigationRail(
                              labelType: NavigationRailLabelType.all,
                              useIndicator: true,
                              destinations: [
                                NavigationRailDestination(
                                    selectedIcon: const Icon(
                                      Icons.collections_bookmark,
                                    ),
                                    icon: const Icon(
                                      Icons.collections_bookmark_outlined,
                                    ),
                                    label: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(l10n.manga))),
                                NavigationRailDestination(
                                    selectedIcon: const Icon(
                                      Icons.video_collection,
                                    ),
                                    icon: const Icon(
                                      Icons.video_collection_outlined,
                                    ),
                                    label: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(l10n.anime),
                                    )),
                                NavigationRailDestination(
                                    selectedIcon: const Icon(
                                      Icons.new_releases,
                                    ),
                                    icon: const Icon(
                                      Icons.new_releases_outlined,
                                    ),
                                    label: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(l10n.updates))),
                                NavigationRailDestination(
                                    selectedIcon: const Icon(
                                      Icons.explore,
                                    ),
                                    icon: const Icon(
                                      Icons.explore_outlined,
                                    ),
                                    label: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(l10n.browse),
                                    )),
                                NavigationRailDestination(
                                    selectedIcon: const Icon(
                                      Icons.more_horiz,
                                    ),
                                    icon: const Icon(
                                      Icons.more_horiz_outlined,
                                    ),
                                    label: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(l10n.more),
                                    )),
                              ],
                              selectedIndex: currentIndex,
                              onDestinationSelected: (newIndex) {
                                if (mounted) {
                                  setState(() {
                                    currentIndex = newIndex;
                                  });
                                }
                                if (newIndex == 0) {
                                  route.go('/MangaLibrary');
                                } else if (newIndex == 1) {
                                  route.go('/AnimeLibrary');
                                } else if (newIndex == 2) {
                                  route.go('/updates');
                                } else if (newIndex == 3) {
                                  route.go('/browse');
                                } else if (newIndex == 4) {
                                  route.go('/more');
                                }
                              },
                            ),
                          ),
                        );
                      }),
                      Expanded(child: widget.child)
                    ],
                  )
                : widget.child,
            bottomNavigationBar: isTablet(context)
                ? null
                : Consumer(builder: (context, ref, child) {
                    final isLongPressed =
                        ref.watch(isLongPressedMangaStateProvider);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 0),
                      width: mediaWidth(context, 1),
                      height: isLongPressed
                          ? 0
                          : route.location != '/MangaLibrary' &&
                                  route.location != '/AnimeLibrary' &&
                                  route.location != '/updates' &&
                                  route.location != '/browse' &&
                                  route.location != '/more'
                              ? 0
                              : 80,
                      child: NavigationBarTheme(
                        data: NavigationBarThemeData(
                          indicatorShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          height: 20,
                        ),
                        child: NavigationBar(
                          animationDuration: const Duration(milliseconds: 500),
                          selectedIndex: currentIndex,
                          destinations: [
                            NavigationDestination(
                                selectedIcon: const Icon(
                                  Icons.collections_bookmark,
                                ),
                                icon: const Icon(
                                  Icons.collections_bookmark_outlined,
                                ),
                                label: l10n.manga),
                            NavigationDestination(
                                selectedIcon: const Icon(
                                  Icons.video_collection,
                                ),
                                icon: const Icon(
                                  Icons.video_collection_outlined,
                                ),
                                label: l10n.anime),
                            NavigationDestination(
                                selectedIcon: const Icon(
                                  Icons.new_releases,
                                ),
                                icon: const Icon(
                                  Icons.new_releases_outlined,
                                ),
                                label: l10n.updates),
                            NavigationDestination(
                                selectedIcon: const Icon(
                                  Icons.explore,
                                ),
                                icon: const Icon(
                                  Icons.explore_outlined,
                                ),
                                label: l10n.browse),
                            NavigationDestination(
                                selectedIcon: const Icon(
                                  Icons.more_horiz,
                                ),
                                icon: const Icon(
                                  Icons.more_horiz_outlined,
                                ),
                                label: l10n.more),
                          ],
                          onDestinationSelected: (newIndex) {
                            if (mounted) {
                              setState(() {
                                currentIndex = newIndex;
                              });
                            }
                            if (newIndex == 0) {
                              route.go('/MangaLibrary');
                            } else if (newIndex == 1) {
                              route.go('/AnimeLibrary');
                            } else if (newIndex == 2) {
                              route.go('/updates');
                            } else if (newIndex == 3) {
                              route.go('/browse');
                            } else if (newIndex == 4) {
                              route.go('/more');
                            }
                          },
                        ),
                      ),
                    );
                  }),
          ),
        ),
      ],
    );
  }
}
