import 'package:flutter/foundation.dart';

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shiori/shiori.dart';

/// A sheet of tabs over the screen: the library's filter, sort and display,
/// a series' chapter options, the readers' settings.
///
/// The sheet is as tall as the tab on show, up to most of the screen: a
/// short tab doesn't leave a band of empty sheet, a long one scrolls. The
/// tabs are pages that follow the finger, and the sheet's height moves with
/// them from one tab's height to the next's.
///
/// Every tab is measured off screen, in the sheet itself, rather than in an
/// invisible dialog opened first as the draggable menu did; the tab bar, a
/// swipe and the height all move together.
///
/// [tabs] and [children] pair up; each child is laid out at its natural
/// height and must not scroll on its own (a Column, not a ListView): the
/// sheet scrolls. [fullWidth] lets the sheet take the whole width on a wide
/// screen, for a reader; elsewhere it keeps a comfortable reading width.
/// [vsync] is kept for the callers that pass it.
Future<void> customDraggableTabBar({
  required List<Widget> tabs,
  required List<Widget> children,
  required BuildContext context,
  required TickerProvider vsync,
  bool fullWidth = false,
  Widget? moreWidget,
  bool dimBehind = true,
  int? seeThroughTab,
  ValueListenable<bool>? seeThrough,
}) {
  assert(tabs.length == children.length, 'One child per tab.');
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Over the whole app, the navigation bar included: inside the shell the
    // bar was drawn over the sheet's foot.
    useRootNavigator: true,
    // The sheet paints its own ground, so it can let the page show through.
    backgroundColor: Colors.transparent,
    barrierColor: dimBehind ? null : Colors.transparent,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(ShioriShape.sheet),
      ),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      maxWidth: fullWidth ? double.infinity : 720,
    ),
    builder: (sheetContext) => _TabbedSheet(
      tabs: tabs,
      moreWidget: moreWidget,
      seeThroughTab: seeThroughTab,
      seeThrough: seeThrough,
      children: children,
    ),
  );
}

class _TabbedSheet extends StatefulWidget {
  const _TabbedSheet({
    required this.tabs,
    required this.children,
    required this.moreWidget,
    this.seeThroughTab,
    this.seeThrough,
  });

  final List<Widget> tabs;
  final List<Widget> children;
  final Widget? moreWidget;

  /// The tab on which the sheet turns see-through while [seeThrough] holds,
  /// so what it changes (a colour filter over the page) can be judged
  /// behind it.
  final int? seeThroughTab;
  final ValueListenable<bool>? seeThrough;

  @override
  State<_TabbedSheet> createState() => _TabbedSheetState();
}

class _TabbedSheetState extends State<_TabbedSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _controller = TabController(
    length: widget.tabs.length,
    vsync: this,
  );

  /// Each tab's natural height, measured off screen, so the sheet can be as
  /// tall as the tab on show and follow the swipe from one to the next.
  final Map<int, double> _heights = {};

  /// False until the first heights are known: the sheet takes them at once
  /// rather than growing from nothing while it slides in.
  bool _settled = false;

  void _measured(int index, double height) {
    if (_heights[index] == height) return;
    setState(() => _heights[index] = height);
    if (!_settled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _settled = true);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    // The sheet runs under the system's gesture bar, which its ground
    // fills; the content keeps that much room at the end, so the last row
    // is not drawn under the bar.
    final overlap = MediaQuery.paddingOf(context).bottom;
    final sheet = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: ShioriSpace.s8),
            child: Container(
              width: 36,
              height: ShioriSpace.s4,
              decoration: BoxDecoration(
                color: tokens.color.fg.withValues(alpha: Alphas.hairline * 2),
                borderRadius: BorderRadius.circular(ShioriShape.pill),
              ),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              // Labels and indicator come from the Shiori tab theme.
              // Scrollable, so a long label (a translated "Custom filter") is read
              // whole rather than cut; centred while they all fit.
              child: TabBar(
                controller: _controller,
                tabs: widget.tabs,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                dividerColor: Colors.transparent,
              ),
            ),
            ?widget.moreWidget,
          ],
        ),
        const Divider(height: 1),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                // Every tab laid out at its natural height and never shown:
                // the measure the visible pages are sized from. No focus,
                // taps, semantics or animation reach it.
                Offstage(
                  child: ExcludeFocus(
                    child: ExcludeSemantics(
                      child: IgnorePointer(
                        child: TickerMode(
                          enabled: false,
                          child: Stack(
                            children: [
                              for (final (i, child) in widget.children.indexed)
                                OverflowBox(
                                  alignment: Alignment.topCenter,
                                  minHeight: 0,
                                  maxHeight: double.infinity,
                                  child: _MeasureHeight(
                                    onHeight: (h) => _measured(i, h),
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: overlap),
                                      child: child,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _pages(constraints.maxHeight, overlap),
              ],
            ),
          ),
        ),
      ],
    );
    final seeThrough = widget.seeThrough;
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, ?seeThrough]),
      builder: (context, child) {
        final clear =
            seeThrough != null &&
            seeThrough.value &&
            _controller.index == widget.seeThroughTab;
        return AnimatedContainer(
          duration: ShioriMotion.of(context, ShioriMotion.standard),
          decoration: BoxDecoration(
            color: tokens.color.ink1.withValues(alpha: clear ? 0.55 : 1),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(ShioriShape.sheet),
            ),
          ),
          child: child,
        );
      },
      child: sheet,
    );
  }

  /// The tabs as pages that follow the finger, in a box whose height moves
  /// with them: between two tabs' heights while swiping or animating, eased
  /// when a tab's own content grows or shrinks.
  Widget _pages(double maxHeight, double overlap) {
    final animation = _controller.animation!;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = animation.value.clamp(0.0, widget.tabs.length - 1.0);
        final from = value.floor();
        final to = value.ceil();
        final fromHeight = _heights[from] ?? _heights[to] ?? 0;
        final toHeight = _heights[to] ?? fromHeight;
        final height = lerpDouble(fromHeight, toHeight, value - from)!;
        // Between two tabs the height tracks the movement exactly; resting
        // on one, a change in its content is eased.
        final moving = (value - value.round()).abs() > 0.001;
        return AnimatedContainer(
          duration: !_settled || moving
              ? Duration.zero
              : ShioriMotion.of(context, ShioriMotion.standard),
          curve: ShioriMotion.enterCurve,
          height: height.clamp(0.0, maxHeight),
          child: child,
        );
      },
      child: TabBarView(
        controller: _controller,
        children: [
          for (final child in widget.children)
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: overlap),
              child: child,
            ),
        ],
      ),
    );
  }
}

/// Reports its child's height after each layout that changes it.
class _MeasureHeight extends SingleChildRenderObjectWidget {
  const _MeasureHeight({required this.onHeight, required super.child});

  final ValueChanged<double> onHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureHeight(onHeight);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureHeight renderObject,
  ) => renderObject.onHeight = onHeight;
}

class _RenderMeasureHeight extends RenderProxyBox {
  _RenderMeasureHeight(this.onHeight);

  ValueChanged<double> onHeight;
  double? _last;

  @override
  void performLayout() {
    super.performLayout();
    final height = size.height;
    if (height == _last) return;
    _last = height;
    // Not during layout: the sheet rebuilds with the new height next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => onHeight(height));
  }
}
