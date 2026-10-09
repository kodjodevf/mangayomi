import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/widgets/floating_nav_bar.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class MainMobileBottomNavigation extends StatelessWidget {
  const MainMobileBottomNavigation({
    super.key,
    required this.isLongPressed,
    required this.location,
    required this.currentIndex,
    required this.dest,
    required this.route,
    required this.ref,
    required this.buildNavigationWidgetsMobile,
    required this.onDestinationSelected,
    required this.useFloatingNav,
    this.shrink = 0,
    this.onWake,
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
  final bool useFloatingNav;
  final double shrink;
  final VoidCallback? onWake;

  @override
  Widget build(BuildContext context) {
    if (useFloatingNav) {
      return SizedBox(
        width: context.width(1),
        height: _getBottomNavigationHeight(isLongPressed, location),
        child: FloatingNavBar(
          destinations: buildNavigationWidgetsMobile(
            ref,
            dest,
            context,
          ).cast<NavigationDestination>(),
          currentIndex: currentIndex,
          onSelected: (newIndex) => onDestinationSelected(dest[newIndex]),
          showLabels: context.isLandscape,
          shrink: shrink,
          onWake: onWake,
        ),
      );
    }

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
          labelBehavior: context.width(1) / dest.length < 72
              ? NavigationDestinationLabelBehavior.onlyShowSelected
              : NavigationDestinationLabelBehavior.alwaysShow,
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
