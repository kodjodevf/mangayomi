import 'dart:io';
import 'dart:math';

import 'package:draggable_menu/draggable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/router/router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

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

  tabBarController.addListener(() {
    if (tabBarController.indexIsChanging) return;
    index = tabBarController.index;
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
              body: Container(
                width: context.width(1) - width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                              dividerColor: context.isLight
                                  ? Colors.black
                                  : Colors.grey,
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
                                          color: context.isLight
                                              ? Colors.black
                                              : Colors.grey,
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
                          children: children
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
            );
          },
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
  tabBarController.dispose();
}
