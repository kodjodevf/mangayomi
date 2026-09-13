import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/modules/main_view/swipeable_tabs.dart';

/// What the shell knows about the tab strip, handed down to the container that
/// lays the branches out.
///
/// go_router builds that container inside the main screen but out of reach of
/// its state, and the ordering is the user's own: their arrangement, with the
/// hidden entries dropped and the merged-library toggle folded in. Working
/// that out twice would be two things to keep in step, so it travels down the
/// tree instead.
class NavShellScope extends InheritedWidget {
  const NavShellScope({
    super.key,
    required this.order,
    required this.currentIndex,
    required this.onSwitch,
    required this.onProgress,
    required this.swipeEnabled,
    required super.child,
  });

  /// Which branch each entry of the visible strip belongs to, in the user's
  /// order. Null where an entry is a toggle rather than a destination.
  final List<int?> order;
  final int currentIndex;
  final ValueChanged<int> onSwitch;
  final void Function(int? target, double progress) onProgress;
  final bool swipeEnabled;

  static NavShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NavShellScope>();

  @override
  bool updateShouldNotify(NavShellScope old) =>
      currentIndex != old.currentIndex ||
      swipeEnabled != old.swipeEnabled ||
      !listEquals(order, old.order);
}

/// Lays out the shell's branch navigators.
///
/// Falls back to the plain offstage stack whenever the scope is missing, which
/// is every route that is not the tab shell, so nothing here can strand a
/// screen that never asked to be swipeable.
class NavShellContainer extends StatelessWidget {
  const NavShellContainer({
    super.key,
    required this.shell,
    required this.children,
  });

  final StatefulNavigationShell shell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scope = NavShellScope.maybeOf(context);
    if (scope == null) return _plain(shell.currentIndex, children);

    return SwipeableTabs(
      branches: children,
      order: scope.order,
      currentIndex: scope.currentIndex,
      enabled: scope.swipeEnabled,
      onSwitch: scope.onSwitch,
      onProgress: scope.onProgress,
    );
  }

  /// Every branch kept alive, only the current one on screen. What
  /// StatefulShellRoute.indexedStack does for itself, for the cases that never
  /// reach the tab strip.
  static Widget _plain(int currentIndex, List<Widget> children) {
    return Stack(
      children: [
        for (var i = 0; i < children.length; i++)
          Offstage(
            offstage: i != currentIndex,
            child: TickerMode(enabled: i == currentIndex, child: children[i]),
          ),
      ],
    );
  }
}
