import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/utils/media_query.dart';

class GeneralScreen extends ConsumerStatefulWidget {
  const GeneralScreen({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends ConsumerState<GeneralScreen> {
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

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SizedBox(
        width: mediaWidth(context, 1),
        height: route.location != '/library' &&
                route.location != '/updates' &&
                route.location != '/history' &&
                route.location != '/browse' &&
                route.location != '/more'
            ? 0
            : 80,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            height: 20,
          ),
          child: NavigationBar(
            animationDuration: const Duration(seconds: 1),
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
            onDestinationSelected: (int newIndex) {
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
      ),
    );
  }
}
