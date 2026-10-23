import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Skips building the real cover — a network fetch + decode — while the
/// nearest Scrollable is flinging fast, showing an empty box of the same
/// size instead. Swaps in the real image once scrolling settles.
class DeferredCoverImage extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final double width;
  final double height;

  const DeferredCoverImage({
    super.key,
    required this.builder,
    required this.width,
    required this.height,
  });

  @override
  State<DeferredCoverImage> createState() => _DeferredCoverImageState();
}

class _DeferredCoverImageState extends State<DeferredCoverImage> {
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final position = Scrollable.maybeOf(context)?.position;
    if (!identical(position, _scrollPosition)) {
      _scrollPosition?.isScrollingNotifier.removeListener(_onScrollingChanged);
      _scrollPosition = position;
      _scrollPosition?.isScrollingNotifier.addListener(_onScrollingChanged);
    }
  }

  bool _rebuildScheduled = false;

  void _onScrollingChanged() {
    if (!mounted) return;
    // A list laid out again settles its scroll position during layout, and
    // that can end a scroll: no rebuild can be asked for then, so it waits
    // for the frame to finish.
    final binding = SchedulerBinding.instance;
    if (binding.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      if (_rebuildScheduled) return;
      _rebuildScheduled = true;
      binding.addPostFrameCallback((_) {
        _rebuildScheduled = false;
        if (mounted) setState(() {});
      });
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollPosition?.isScrollingNotifier.removeListener(_onScrollingChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Scrollable.recommendDeferredLoadingForContext(context)) {
      return SizedBox(width: widget.width, height: widget.height);
    }
    return widget.builder(context);
  }
}
