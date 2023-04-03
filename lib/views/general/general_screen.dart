import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hidable/hidable.dart';
import 'package:mangayomi/views/general/scroll_controller_provider.dart';
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
    final scrollController = ref.watch(scrollControllerProvider);
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
            : null,
        child: Hidable(
          controller: scrollController,
          wOpacity: true,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w500)),
              indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              height: 20,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            ),
            child: ClipRRect(
              child: NavigationBar(
                animationDuration: const Duration(seconds: 1),
                selectedIndex: currentIndex,
                destinations: const [
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.collections_bookmark,
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.collections_bookmark_outlined,
                      ),
                      label: 'Library'),
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.new_releases,
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.new_releases_outlined,
                      ),
                      label: 'Updates'),
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.history_outlined,
                      ),
                      label: "History"),
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.explore,
                        color: Colors.white,
                      ),
                      icon: Icon(
                        Icons.explore_outlined,
                      ),
                      label: "Browse"),
                  NavigationDestination(
                      selectedIcon: Icon(
                        Icons.more_horiz,
                        color: Colors.white,
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
        ),
      ),
    );
  }
}
