import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Lets a horizontal drag carry you between top-level tabs, showing both the
/// page you are leaving and the one you are arriving at while your finger is
/// down.
///
/// The shell renders exactly one tab, so the neighbour does not exist until it
/// is asked for. [pageBuilder] builds it for the duration of the drag only;
/// once the drag commits, [onSwitch] navigates and the shell supplies the real
/// one. Building a whole screen for a peek is cheap next to rebuilding the
/// navigation stack around a PageView, and it leaves deep links, route
/// arguments and the desktop rail untouched.
class SwipeableTabs extends StatefulWidget {
  const SwipeableTabs({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.count,
    required this.pageBuilder,
    required this.onSwitch,
    this.enabled = true,
  });

  /// The live page, as built by the shell.
  final Widget child;
  final int currentIndex;
  final int count;

  /// Builds a neighbouring tab for the peek.
  final Widget Function(int index) pageBuilder;

  /// Called once a drag has carried far enough to commit.
  final ValueChanged<int> onSwitch;

  /// Off on tablets and TV, where the rail is the navigation and a horizontal
  /// drag belongs to the content.
  final bool enabled;

  /// How far across the width the drag has to travel to commit.
  static const _commitFraction = 0.28;

  /// Or how fast it has to be going, so a flick works without the distance.
  static const _commitVelocity = 450.0;

  static const _settleDuration = Duration(milliseconds: 220);

  @override
  State<SwipeableTabs> createState() => _SwipeableTabsState();
}

class _SwipeableTabsState extends State<SwipeableTabs>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: SwipeableTabs._settleDuration,
  )..addListener(() => setState(() {}));

  /// Drag offset in pixels. Negative means dragging towards the next tab.
  double _offset = 0;

  /// Where the settle animation started and where it is heading, so the
  /// controller's 0..1 value can be read as a position.
  double _settleFrom = 0;
  double _settleTo = 0;

  bool _dragging = false;

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  double get _position => _settle.isAnimating || _settle.value > 0 && !_dragging
      ? _settleFrom + (_settleTo - _settleFrom) * _settle.value
      : _offset;

  /// The neighbour a given drag direction leads to, or null at either end.
  int? _neighbourFor(double offset) {
    if (offset == 0) return null;
    final index = offset < 0
        ? widget.currentIndex + 1
        : widget.currentIndex - 1;
    if (index < 0 || index >= widget.count) return null;
    return index;
  }

  void _onDragStart(DragStartDetails _) {
    _settle.stop();
    setState(() {
      _dragging = true;
      _offset = 0;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final width = context.size?.width ?? 1;
    var next = _offset + details.delta.dx;
    // Nothing to reveal past the first or last tab, so resist rather than
    // dragging a blank gap into view.
    if (_neighbourFor(next) == null) next = _offset + details.delta.dx * 0.25;
    setState(() => _offset = next.clamp(-width, width));
  }

  void _onDragEnd(DragEndDetails details) {
    final width = context.size?.width ?? 1;
    final velocity = details.velocity.pixelsPerSecond.dx;
    final target = _neighbourFor(_offset);

    final farEnough = _offset.abs() > width * SwipeableTabs._commitFraction;
    final fastEnough =
        velocity.abs() > SwipeableTabs._commitVelocity &&
        velocity.sign == _offset.sign;

    _dragging = false;
    if (target != null && (farEnough || fastEnough)) {
      _settleFrom = _offset;
      _settleTo = _offset < 0 ? -width : width;
      _settle.forward(from: 0).whenComplete(() {
        HapticFeedback.selectionClick();
        widget.onSwitch(target);
        // The shell swaps the child in on the next frame; drop the peek then,
        // not before, or the outgoing page flashes back into view.
        if (mounted) {
          setState(() {
            _offset = 0;
            _settle.value = 0;
          });
        }
      });
    } else {
      _settleFrom = _offset;
      _settleTo = 0;
      _settle.forward(from: 0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final position = _position;
    final neighbour = _neighbourFor(position);

    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: position == 0
          ? widget.child
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    Transform.translate(
                      offset: Offset(position, 0),
                      child: widget.child,
                    ),
                    if (neighbour != null)
                      Transform.translate(
                        offset: Offset(
                          position + (position < 0 ? width : -width),
                          0,
                        ),
                        child: SizedBox(
                          width: width,
                          child: widget.pageBuilder(neighbour),
                        ),
                      ),
                  ],
                );
              },
            ),
    );
  }
}
