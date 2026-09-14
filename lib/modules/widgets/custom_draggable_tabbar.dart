import 'dart:io';
import 'dart:math';

import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

class MeasureWidgetSize extends StatefulWidget {
  final Function(Size? size) onCalculateSize;
  final Widget child;

  const MeasureWidgetSize({
    super.key,
    required this.onCalculateSize,
    required this.child,
  });

  @override
  State<MeasureWidgetSize> createState() => _MeasureWidgetSizeState();
}

class _MeasureWidgetSizeState extends State<MeasureWidgetSize> {
  final _key = GlobalKey();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onCalculateSize(_key.currentContext?.size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}

/// The children with room left at the foot for the floating bar.
///
/// This sheet is pushed inside the shell rather than over it, so the bar is
/// drawn on top of it and a tab long enough to reach the bottom has its last
/// controls behind the bar.
///
/// Read from the sheet's own context, not from whatever opened it. The shell
/// reserves the bar's height as bottom padding on its body, but a screen with
/// its own Scaffold and its own bottom bar has that stripped again before
/// anything inside it can read it, and the library is exactly such a screen.
/// The sheet is pushed on the branch navigator, which sits in the shell's body
/// where the reservation is still intact.
///
/// Only the displayed children get this room, never the ones measured for the
/// sheet's height: a tab whose content already stops short of the bar would
/// gain a band of empty space, and a tab long enough to run underneath it is
/// scrolling anyway, so what it needs is somewhere further to scroll.
List<Widget> _padded(BuildContext context, List<Widget> children) {
  final overlap = usesFloatingNav ? MediaQuery.paddingOf(context).bottom : 0.0;
  if (overlap == 0) return children;
  return [
    for (final child in children)
      Padding(
        padding: EdgeInsets.only(bottom: overlap),
        child: child,
      ),
  ];
}

Future<void> customDraggableTabBar({
  required List<Widget> tabs,
  required List<Widget> children,
  required BuildContext context,
  required TickerProvider vsync,
  bool fullWidth = false,
  Widget? moreWidget,
}) async {
  final controller = DraggableMenuController();
  late TabController tabBarController;
  tabBarController = TabController(length: tabs.length, vsync: vsync);
  final maxHeight = context.height(0.8);

  int index = 0;
  List<Map<String, dynamic>> widgetsHeight = [];

  void refresh() {
    controller.animateTo(
      widgetsHeight.indexWhere((element) => element["index"] == index),
    );
  }

  tabBarController.animation!.addListener(() {
    final currentIndex = tabBarController.animation!.value.round();
    index = tabBarController.index;
    if (index != currentIndex) {
      index = currentIndex;
    }
    refresh();
  });

  await showDialog(
    context: context,
    builder: (context) {
      return Material(
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              MeasureWidgetSize(
                onCalculateSize: (size) {
                  final additionnalHeight = Random().nextDouble() * 0.01;
                  double newHeight = size!.height + 52.0 + additionnalHeight;
                  if (!(newHeight <= maxHeight)) {
                    newHeight = maxHeight + additionnalHeight;
                  }
                  widgetsHeight.add({"index": i, "height": newHeight});
                  if (widgetsHeight.length == children.length) {
                    Navigator.pop(context);
                  }
                },
                child: children[i],
              ),
            ],
          ],
        ),
      );
    },
  );
  widgetsHeight.sort(
    (a, b) => (a["height"] as double).compareTo(b["height"] as double),
  );
  if (context.mounted) {
    await DraggableMenu.open(
      context,
      DraggableMenu(
        curve: Curves.linearToEaseOut,
        controller: controller,
        levels: widgetsHeight
            .map((e) => DraggableMenuLevel(height: e["height"]))
            .toList(),
        customUi: Consumer(
          builder: (context, ref, child) {
            final location = ref.watch(routerCurrentLocationStateProvider);
            final width = context.isTablet && !fullWidth
                ? switch (location) {
                    null => 100,
                    != '/MangaLibrary' &&
                        != '/AnimeLibrary' &&
                        != '/history' &&
                        != '/browse' &&
                        != '/more' =>
                      0,
                    _ => 100,
                  }
                : 0;
            return Scaffold(
              backgroundColor: Platform.isLinux ? null : Colors.transparent,
              body: SizedBox(
                width: context.width(1) - width,
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: DefaultTabController(
                    length: tabs.length,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              flex: 9,
                              child: TabBar(
                                unselectedLabelStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                dividerColor: Theme.of(context).dividerColor,
                                dividerHeight: 0.4,
                                controller: tabBarController,
                                tabs: tabs,
                              ),
                            ),
                            if (moreWidget != null)
                              Flexible(
                                flex: 1,
                                child: Column(
                                  children: [
                                    moreWidget,
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            color: Theme.of(context)
                                                .dividerColor,
                                            height: 0.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: tabBarController,
                            children: _padded(context, children)
                                .map(
                                  (e) => SingleChildScrollView(
                                    child: MeasureWidgetSize(
                                      onCalculateSize: (_) => refresh(),
                                      child: e,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
  tabBarController.dispose();
}
