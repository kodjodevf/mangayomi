import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mangayomi/utils/colors.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/library/providers/library_state_provider.dart';
import 'package:mangayomi/views/more/providers/incognito_mode_state_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final route = GoRouter.of(context);
    int currentIndex = route.location == '/library'
        ? 0
        : route.location == '/updates'
            ? 1
            : route.location == '/history'
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
                        'Incognito mode',
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
                              : route.location != '/library' &&
                                      route.location != '/updates' &&
                                      route.location != '/history' &&
                                      route.location != '/browse' &&
                                      route.location != '/more'
                                  ? 0
                                  : 80,
                          child: NavigationRailTheme(
                            data: NavigationRailThemeData(
                              indicatorShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: NavigationRail(
                              labelType: NavigationRailLabelType.all,
                              useIndicator: true,
                              destinations: const [
                                NavigationRailDestination(
                                    selectedIcon: Icon(
                                      Icons.collections_bookmark,
                                    ),
                                    icon: Icon(
                                      Icons.collections_bookmark_outlined,
                                    ),
                                    label: Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text('Library'))),
                                NavigationRailDestination(
                                    selectedIcon: Icon(
                                      Icons.new_releases,
                                    ),
                                    icon: Icon(
                                      Icons.new_releases_outlined,
                                    ),
                                    label: Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Text('Updates'))),
                                NavigationRailDestination(
                                    selectedIcon: Icon(
                                      Icons.history,
                                    ),
                                    icon: Icon(
                                      Icons.history_outlined,
                                    ),
                                    label: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("History"),
                                    )),
                                NavigationRailDestination(
                                    selectedIcon: Icon(
                                      Icons.explore,
                                    ),
                                    icon: Icon(
                                      Icons.explore_outlined,
                                    ),
                                    label: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("Browse"),
                                    )),
                                NavigationRailDestination(
                                    selectedIcon: Icon(
                                      Icons.more_horiz,
                                    ),
                                    icon: Icon(
                                      Icons.more_horiz_outlined,
                                    ),
                                    label: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text("More"),
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
                                  route.go('/library');
                                } else if (newIndex == 1) {
                                  route.go('/updates');
                                } else if (newIndex == 2) {
                                  route.go('/history');
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
                          : route.location != '/library' &&
                                  route.location != '/updates' &&
                                  route.location != '/history' &&
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
                          destinations: const [
                            NavigationDestination(
                                selectedIcon: Icon(
                                  Icons.collections_bookmark,
                                ),
                                icon: Icon(
                                  Icons.collections_bookmark_outlined,
                                ),
                                label: 'Library'),
                            NavigationDestination(
                                selectedIcon: Icon(
                                  Icons.new_releases,
                                ),
                                icon: Icon(
                                  Icons.new_releases_outlined,
                                ),
                                label: 'Updates'),
                            NavigationDestination(
                                selectedIcon: Icon(
                                  Icons.history,
                                ),
                                icon: Icon(
                                  Icons.history_outlined,
                                ),
                                label: "History"),
                            NavigationDestination(
                                selectedIcon: Icon(
                                  Icons.explore,
                                ),
                                icon: Icon(
                                  Icons.explore_outlined,
                                ),
                                label: "Browse"),
                            NavigationDestination(
                                selectedIcon: Icon(
                                  Icons.more_horiz,
                                ),
                                icon: Icon(
                                  Icons.more_horiz_outlined,
                                ),
                                label: "More"),
                          ],
                          onDestinationSelected: (newIndex) {
                            if (mounted) {
                              setState(() {
                                currentIndex = newIndex;
                              });
                            }
                            if (newIndex == 0) {
                              route.go('/library');
                            } else if (newIndex == 1) {
                              route.go('/updates');
                            } else if (newIndex == 2) {
                              route.go('/history');
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
