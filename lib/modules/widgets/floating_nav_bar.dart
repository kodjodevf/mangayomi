import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// The floating capsule bar used on Apple platforms in place of the material
/// NavigationBar. Icons only, with a single highlight pill that slides between
/// slots, and a shrunk state for when the user is scrolling down.
///
/// The pill can also be dragged: it follows the pointer freely and the tab only
/// changes once it is let go, so a drag can be taken back by returning to the
/// slot it started from.
class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    this.showLabels = false,
    this.swipeTarget,
    this.swipeProgress = 0,
  });

  final List<NavigationDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// The tab a page swipe is heading towards, and how far along it is, 0 to 1.
  ///
  /// The pill reaches for it rather than waiting: the leading edge sets off
  /// ahead of the trailing one, so it stretches between the two tabs while the
  /// finger is still moving and closes up on whichever one the swipe settles
  /// on.
  final int? swipeTarget;
  final double swipeProgress;

  /// Puts the label beside each icon and lets the bar hug its contents rather
  /// than span the screen. Used in landscape, where there is width to spare and
  /// height to save, and where a rail would otherwise take over.
  final bool showLabels;

  static const _duration = Duration(milliseconds: 260);
  static const _curve = Curves.easeOutCubic;

  /// How the glass edge varies along the bar. Irregular on purpose, and never
  /// far from full: glass catches light in patches, but a stretch that dips
  /// too low reads as the washed-out centre that a fade produced.
  /// Destinations the bar can hold at full size. Past this every extra one
  /// takes a little height, since the slots are getting narrower and a bar
  /// that keeps its full height starts to look crowded.
  static const _comfortableCount = 5;
  static const _fullHeight = 56.0;
  static const _shrinkPerExtra = 3.0;
  static const _minHeight = 44.0;

  /// Icon size as a fraction of bar height, so icons shrink with the bar
  /// rather than needing their own ladder of numbers.
  static const _iconRatio = 27 / _fullHeight;

  /// Gap between an icon and its label, and the room either side of a labelled
  /// item, in the labelled layout.
  static const _labelGap = 6.0;
  static const _labelPad = 9.0;

  /// Viewport height below which the bar trims further. A phone in landscape
  /// has very little of it, and a bar sized for portrait eats the content.
  static const _shortViewport = 480.0;
  static const _shortViewportTrim = 6.0;

  @visibleForTesting
  static double heightFor(int destinationCount, {double viewportHeight = 0}) {
    final crowding =
        math.max(0, destinationCount - _comfortableCount) * _shrinkPerExtra;
    final landscape = viewportHeight > 0 && viewportHeight < _shortViewport
        ? _shortViewportTrim
        : 0.0;
    return math.max(_minHeight, _fullHeight - crowding - landscape);
  }

  /// Hairline. Anything heavier stops reading as glass and starts reading as
  /// a border.
  @visibleForTesting
  static const glassStrokeWidth = 1.0;

  @visibleForTesting
  static const glassPatchStops = [0.0, 0.13, 0.27, 0.44, 0.58, 0.71, 0.86, 1.0];
  @visibleForTesting
  static const glassPatchAlphas = [
    1.0,
    0.42,
    0.92,
    0.34,
    0.86,
    0.38,
    0.98,
    0.5,
  ];

  /// Space between the pill and the bar itself: top, bottom, and the two end
  /// caps. One value for every bar edge is what keeps that gap even.
  static const _pillInset = 5.0;

  /// Space between the pill and its slot's boundary with a neighbour. Smaller
  /// than the bar inset, which is what lets the pill be wider without eating
  /// into the even gap around the bar's own edges.
  static const _pillSlotInset = 1.5;

  /// Pixels of extra width per pixel of pointer movement in a frame, which is
  /// what makes the pill look like it is being pulled along.
  static const _speedStretch = 0.9;
  static const _maxSpeedStretch = 24.0;

  /// The bar's own side margin.
  static const _margin = 20.0;

  /// How much the whole bar scales up while a drag is in flight. This is a
  /// zoom, not a stretch: the icons scale with it, so the bar keeps its
  /// proportions instead of deforming.
  static const _dragZoom = 1.035;

  /// How much of the bar's width a full edge push adds, applied as a
  /// horizontal scale anchored at the far side so the bar gives in the
  /// direction being pushed.
  static const _barGive = 0.05;

  /// How far the pill may reach towards the tab a swipe is heading for, as a
  /// fraction of the distance between them.
  ///
  /// Small on purpose. The pill straining at its slot reads as wanting to go;
  /// the pill actually travelling most of the way reads as having gone, and
  /// then arriving is an anticlimax. It leans, it does not walk. The move
  /// itself happens on release, when the selection changes.
  static const _reachLead = 0.15;
  static const _reachTrail = 0.04;

  /// How much thinner the pill gets at full reach, per side. Something being
  /// pulled longer gets narrower, and without this the pill just looked bigger
  /// rather than strained.
  static const _reachSquash = 4.5;

  /// How much the pill grows when picked up. A scale rather than a smaller
  /// gap: shrinking only the vertical gap makes the pill rounder instead of
  /// bigger, since its width does not change with it.
  static const _pillZoom = 1.04;

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<FloatingNavBar> {
  /// Pointer position in bar-local coordinates, or null when nothing is being
  /// dragged.
  double? _dragX;

  /// Smoothed drag speed, carried as the extra width it earns. Smoothing keeps
  /// per-event jitter from making the pill flutter.
  double _stretch = 0;

  /// Set briefly on a tap so a plain press gets the same lift a drag does,
  /// rather than the bar only ever reacting to one of the two.
  bool _tapped = false;
  Timer? _tapTimer;

  /// True for the first moments of a drag, while the pill is still travelling
  /// to the finger. Tracking only becomes one-to-one once it has arrived, so
  /// grabbing a different tab pulls the pill over rather than teleporting it.
  bool _catchingUp = false;
  Timer? _catchUpTimer;

  /// Last laid-out slot width and bar width, so [_startDrag] can work out
  /// where the pill currently is. Written during layout, read on the next
  /// gesture, which is always at least a frame later.
  double _slot = 0;
  double _barWidth = 0;

  /// Left edge of every slot, plus the bar's right edge. Icon-only items are
  /// all one width, but a labelled one is as wide as its label, so positions
  /// come from here rather than from multiplying a slot width by an index.
  List<double> _bounds = const [];

  double _slotStart(int i) => i < _bounds.length ? _bounds[i] : 0;
  double _slotEnd(int i) => i + 1 < _bounds.length ? _bounds[i + 1] : _barWidth;
  double _slotWidth(int i) => _slotEnd(i) - _slotStart(i);

  /// Width each labelled item needs: icon, gap, label, and room either side.
  static List<double> labelledWidths(
    List<NavigationDestination> destinations,
    double iconSize,
    TextStyle style,
    double textScale,
  ) => [
    for (final d in destinations)
      () {
        final painter = TextPainter(
          text: TextSpan(text: d.label, style: style),
          textDirection: TextDirection.ltr,
          textScaler: TextScaler.linear(textScale),
        )..layout();
        return iconSize +
            FloatingNavBar._labelGap +
            painter.width +
            FloatingNavBar._labelPad * 2;
      }(),
  ];

  /// Signed overshoot past an end of the bar, -1 to 1. Drives how far the bar
  /// itself gives, so the whole component deforms rather than just the pill.
  double _edgePush = 0;

  /// The slot the pill was dropped on, kept until the parent reports the same
  /// index. Routing is not synchronous, so without this the pill would spring
  /// back to the old tab for the frames in between.
  int? _droppedIndex;

  @override
  void didUpdateWidget(FloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_droppedIndex != null && widget.currentIndex == _droppedIndex) {
      _droppedIndex = null;
    }
  }

  int _slotAt(double x, double _) {
    for (var i = 0; i < widget.destinations.length; i++) {
      if (x < _slotEnd(i)) return i;
    }
    return widget.destinations.length - 1;
  }

  void _flashTap() {
    _tapTimer?.cancel();
    setState(() => _tapped = true);
    _tapTimer = Timer(FloatingNavBar._duration, () {
      if (mounted) setState(() => _tapped = false);
    });
  }

  void _startDrag(double x) {
    _catchUpTimer?.cancel();
    _tapTimer?.cancel();

    // Only travel when the grab landed somewhere else. Grabbing the pill
    // itself has nothing to travel to, and easing towards a target that moves
    // with the finger made it stutter instead of tracking.
    final centre = _restingCentre(
      _slot,
      _barWidth,
      _droppedIndex ?? widget.currentIndex,
    );
    final halfPill = (_slot - FloatingNavBar._pillSlotInset * 2) / 2;
    final travels = _slot > 0 && (x - centre).abs() > halfPill;

    setState(() {
      _dragX = x;
      _stretch = 0;
      _edgePush = 0;
      _tapped = false;
      _catchingUp = travels;
    });
    if (!travels) return;
    _catchUpTimer = Timer(FloatingNavBar._duration, () {
      if (mounted) setState(() => _catchingUp = false);
    });
  }

  @override
  void dispose() {
    _catchUpTimer?.cancel();
    _tapTimer?.cancel();
    super.dispose();
  }

  void _updateDrag(double x) => setState(() {
    final travelled = (x - _dragX!).abs() * FloatingNavBar._speedStretch;
    _stretch = (_stretch * 0.6 + travelled * 0.4).clamp(
      0.0,
      FloatingNavBar._maxSpeedStretch,
    );
    _dragX = x;
  });

  void _endDrag(double slot) {
    final target = _slotAt(_dragX!, slot);
    final changing = target != widget.currentIndex;
    _catchUpTimer?.cancel();
    setState(() {
      _dragX = null;
      _stretch = 0;
      _edgePush = 0;
      _catchingUp = false;
      // Only hold a dropped slot when the selection is actually moving.
      // Otherwise the pill would sit on a slot the app never navigated to.
      _droppedIndex = changing ? target : null;
    });
    if (changing) widget.onSelected(target);
  }

  void _cancelDrag() {
    _catchUpTimer?.cancel();
    setState(() {
      _dragX = null;
      _stretch = 0;
      _edgePush = 0;
      _catchingUp = false;
    });
  }

  /// Left and right edges of the pill, in bar-local coordinates.
  ///
  /// At rest it spans its slot, except at either end where it runs out to the
  /// bar's own edge. While dragging it is centred on the pointer, and pushing
  /// it past an end pins that edge and spends the rest on width.
  /// Where the pill sits at rest for [index].
  ///
  /// The end slots get pushed inwards so the pill keeps its inset from the
  /// bar's caps, which means their pill is no longer centred on its slot. The
  /// icons have to follow it or they sit off centre inside the pill.
  double _restingCentre(double slot, double width, int index) {
    const outer = FloatingNavBar._pillInset;
    final base = _slotWidth(index) - FloatingNavBar._pillSlotInset * 2;
    final lo = outer + base / 2;
    final hi = width - outer - base / 2;
    final centre = (_slotStart(index) + _slotEnd(index)) / 2;
    return centre.clamp(math.min(lo, hi), math.max(lo, hi));
  }

  /// The pill part way to [FloatingNavBar.swipeTarget], stretched between the
  /// two slots.
  ///
  /// The edge in front of the movement runs on an eased-out curve and the one
  /// behind it on an eased-in curve, so the gap between them opens in the
  /// middle of the swipe and closes again at either end. That is the reach.
  (double, double)? _reachingEdges(double slot, double width, int index) {
    final target = widget.swipeTarget;
    final t = widget.swipeProgress.clamp(0.0, 1.0);
    if (target == null || target == index || t <= 0) return null;
    if (target < 0 || target >= widget.destinations.length) return null;

    // Both ends taken from where the pill actually rests on each slot, so the
    // clamping at the bar's caps carries through the reach as well.
    const gap = FloatingNavBar._pillSlotInset;
    final fromHalf = (_slotWidth(index) - gap * 2) / 2;
    final toHalf = (_slotWidth(target) - gap * 2) / 2;
    final fromCentre = _restingCentre(slot, width, index);
    final toCentre = _restingCentre(slot, width, target);
    final fromLeft = fromCentre - fromHalf;
    final fromRight = fromCentre + fromHalf;
    final toLeft = toCentre - toHalf;
    final toRight = toCentre + toHalf;

    // Eased out and capped, so most of the reach happens in the first part of
    // the swipe and further dragging barely adds to it: it strains rather than
    // creeping steadily across.
    final eased = _reachAmount(index);
    final lead = eased * FloatingNavBar._reachLead;
    final trail = eased * FloatingNavBar._reachTrail;
    final forward = target > index;
    return forward
        ? (_lerp(fromLeft, toLeft, trail), _lerp(fromRight, toRight, lead))
        : (_lerp(fromLeft, toLeft, lead), _lerp(fromRight, toRight, trail));
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  /// How hard the pill is straining towards another tab, 0 to 1.
  double _reachAmount(int index) {
    final target = widget.swipeTarget;
    if (target == null || target == index) return 0;
    if (target < 0 || target >= widget.destinations.length) return 0;
    return Curves.easeOut.transform(widget.swipeProgress.clamp(0.0, 1.0));
  }

  (double, double) _pillEdges(double slot, double width, int index) {
    const outer = FloatingNavBar._pillInset;
    // Sized from the slot it is over, which is not a fixed width once labels
    // are in play.
    final over = _dragX == null ? index : _slotAt(_dragX!, slot);
    final base = _slotWidth(over) - FloatingNavBar._pillSlotInset * 2;

    // Keep the pill a fixed distance from the bar's own ends, so the gap there
    // matches the top and bottom. Clamping the centre rather than the edges
    // also stops a pointer far past the bar from inverting the pill.
    double centreFor(double wanted, double pillWidth) {
      final lo = outer + pillWidth / 2;
      final hi = width - outer - pillWidth / 2;
      return wanted.clamp(math.min(lo, hi), math.max(lo, hi));
    }

    if (_dragX == null) {
      final reaching = _reachingEdges(slot, width, index);
      if (reaching != null) return reaching;
      final centre = _restingCentre(slot, width, index);
      return (centre - base / 2, centre + base / 2);
    }

    final pillWidth = math.min(base + _stretch, width - outer * 2);
    final centre = centreFor(_dragX!, pillWidth);

    // Past an end the pill pins there, keeping its inset. It must not grow
    // backwards, away from the push: the bar takes the give instead.
    // Read during layout only; the drag callbacks rebuild anyway, so the bar
    // picks this up on the same frame it is computed for.
    _edgePush = ((_dragX! - centre) / 60).clamp(-1.0, 1.0);
    return (centre - pillWidth / 2, centre + pillWidth / 2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle =
        theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
    final height = FloatingNavBar.heightFor(
      widget.destinations.length,
      viewportHeight: MediaQuery.sizeOf(context).height,
    );

    // Sit closer to the bottom than a full safe-area inset would put us. The
    // bar is a floating capsule, not a docked bar, so it can overlap the home
    // indicator's margin without crowding it.
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final bottom = math.max(8.0, safeBottom - 12);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        FloatingNavBar._margin,
        0,
        FloatingNavBar._margin,
        bottom,
      ),
      // Sized to its contents when labelled, and centred. Left to fill the
      // width, the items spread right across the screen with great gaps
      // between them; the bar should be as wide as the tabs and no wider.
      //
      // Only ever horizontally: Scaffold lays a bottomNavigationBar out with
      // the screen height as its maximum, and anything that fills its
      // constraints vertically here reports that height to the body as bottom
      // padding, which pushes every page's content off screen.
      child: LayoutBuilder(
        builder: (context, outer) {
          final natural = widget.showLabels
              ? math.min(
                  labelledWidths(
                    widget.destinations,
                    height * FloatingNavBar._iconRatio,
                    labelStyle,
                    MediaQuery.textScalerOf(context).scale(1),
                  ).fold<double>(0, (a, b) => a + b),
                  outer.maxWidth,
                )
              : outer.maxWidth;
          return Align(
            alignment: Alignment.bottomCenter,
            heightFactor: 1,
            child: SizedBox(width: natural, child: _bar(context, height)),
          );
        },
      ),
    );
  }

  Widget _bar(BuildContext context, double height) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final light = theme.brightness == Brightness.light;
    final labelStyle =
        theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
    final dragging = _dragX != null;
    final lifted = dragging || _tapped;

    return _Zoom(
      zoom: lifted ? FloatingNavBar._dragZoom : 1.0,
      give: dragging ? _edgePush * FloatingNavBar._barGive : 0.0,
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          // Outside the clip: a clipped child cannot cast a shadow past
          // its own bounds, and in a light theme the shadow is most of
          // what separates the bar from the page.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: light ? 0.16 : 0.34),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                  // A light theme has nothing darker behind it for the
                  // blur to pull in, so translucency alone leaves the bar
                  // invisible against the page. Go nearly opaque there and
                  // keep the glass effect for dark.
                  color: light
                      ? scheme.surfaceContainerHighest.withValues(alpha: 0.94)
                      : scheme.surface.withValues(alpha: 0.62),
                  borderRadius: BorderRadius.circular(height / 2),
                ),

                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final count = widget.destinations.length;
                    final width = constraints.maxWidth;
                    final resting = _droppedIndex ?? widget.currentIndex;

                    // Icon-only items share the width evenly. Labelled ones
                    // are each as wide as their own label, so the boundaries
                    // have to be accumulated rather than derived from a slot
                    // width and an index.
                    final widths = widget.showLabels
                        ? labelledWidths(
                            widget.destinations,
                            height * FloatingNavBar._iconRatio,
                            labelStyle,
                            MediaQuery.textScalerOf(context).scale(1),
                          )
                        : List<double>.filled(count, width / count);
                    final total = widths.fold<double>(0, (a, b) => a + b);
                    // Only ever shrink. Scaling labelled items up to fill the
                    // bar spread them across the whole screen; they keep
                    // their own width and the bar is sized to them instead.
                    final scale = total > width && total > 0
                        ? width / total
                        : 1.0;
                    final bounds = <double>[0];
                    for (final w in widths) {
                      bounds.add(bounds.last + w * scale);
                    }
                    _bounds = bounds;
                    final slot = width / count;
                    _slot = slot;
                    _barWidth = width;

                    // Fill and weight belong to the selected tab, never to
                    // whichever slot the pill happens to be over. The pill
                    // alone shows where a drag currently is.
                    final (left, right) = _pillEdges(slot, width, resting);

                    // Thinner the harder it is straining, so the stretch reads
                    // as a stretch rather than as the pill simply growing.
                    final squash =
                        _reachAmount(resting) * FloatingNavBar._reachSquash;

                    return GestureDetector(
                      // Picking the pill up anywhere along the bar is more
                      // forgiving than having to grab it exactly.
                      onHorizontalDragStart: (d) =>
                          _startDrag(d.localPosition.dx),
                      onHorizontalDragUpdate: (d) =>
                          _updateDrag(d.localPosition.dx),
                      onHorizontalDragEnd: (_) => _endDrag(slot),
                      onHorizontalDragCancel: _cancelDrag,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // One pill that travels, rather than a highlight
                          // fading in and out under each icon in turn.
                          AnimatedPositioned(
                            // A dragged pill has to track the finger exactly;
                            // easing here would make it lag behind.
                            // Eases while it travels to the finger, then
                            // tracks it exactly. Easing throughout would
                            // make it lag behind; never easing would make
                            // it teleport to whichever tab was grabbed.
                            duration: dragging && !_catchingUp
                                ? Duration.zero
                                : FloatingNavBar._duration,
                            curve: FloatingNavBar._curve,
                            left: left,
                            width: right - left,
                            top: FloatingNavBar._pillInset + squash,
                            bottom: FloatingNavBar._pillInset + squash,
                            // Grows from the middle on every side, so it
                            // keeps its shape. Scaling only the height
                            // would just make it rounder.
                            child: AnimatedScale(
                              duration: FloatingNavBar._duration,
                              curve: FloatingNavBar._curve,
                              scale: lifted ? FloatingNavBar._pillZoom : 1.0,
                              child: AnimatedContainer(
                                duration: FloatingNavBar._duration,
                                curve: FloatingNavBar._curve,
                                decoration: ShapeDecoration(
                                  // The one element that carries the
                                  // theme. Pairing it with
                                  // onSecondaryContainer for the icon is
                                  // what guarantees the icon stays legible
                                  // across every scheme the user can pick,
                                  // which tinting the icon against the bar
                                  // could not.
                                  color: scheme.secondaryContainer.withValues(
                                    // Slightly more solid in hand, so
                                    // it still reads as picked up.
                                    alpha: dragging ? 1.0 : 0.9,
                                  ),
                                  // A stadium is a full capsule at any
                                  // size, so the pill stays as round as the
                                  // bar's own caps however it scales.
                                  shape: const StadiumBorder(),
                                ),
                              ),
                            ),
                          ),
                          // A lit top and bottom edge instead of an
                          // outline. Drawn over everything, since it is the
                          // surface catching light, not a frame behind it.
                          Positioned.fill(
                            child: IgnorePointer(
                              child: _GlassEdge(
                                color: scheme.onSurface,
                                light: light,
                                radius: height / 2,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              for (var i = 0; i < count; i++)
                                SizedBox(
                                  // Explicit rather than Expanded: labelled
                                  // items are each as wide as their label,
                                  // and the pill is positioned from the same
                                  // widths.
                                  width: bounds[i + 1] - bounds[i],
                                  child: _FloatingNavItem(
                                    destination: widget.destinations[i],
                                    selected: i == resting,
                                    iconSize:
                                        height * FloatingNavBar._iconRatio,
                                    label: widget.showLabels
                                        ? widget.destinations[i].label
                                        : null,
                                    labelStyle: labelStyle,
                                    // Follow the pill inwards at the ends,
                                    // so the icon stays centred in it.
                                    nudge:
                                        _restingCentre(slot, width, i) -
                                        slot * (i + 0.5),
                                    onTap: () {
                                      _flashTap();
                                      widget.onSelected(i);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The lit top and bottom edges of the bar.
///
/// The bar's glass edge.
///
/// A hairline stroke following the whole outline, caps included. A horizontal
/// band cannot reach the far left and right points of a stadium at all, since
/// those sit at mid height, which left the ends unlit. Stroking the path fixes
/// that and is thinner besides.
///
/// It is dimmest around the equator and brightest along the top, so the caps
/// keep some light without the stroke reading as a drawn border, and it varies
/// along its length the way glass catches light in patches.
class _GlassEdge extends StatelessWidget {
  const _GlassEdge({
    required this.color,
    required this.light,
    required this.radius,
  });

  final Color color;
  final bool light;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          for (final a in FloatingNavBar.glassPatchAlphas)
            Colors.white.withValues(alpha: a),
        ],
        stops: FloatingNavBar.glassPatchStops,
      ).createShader(rect),
      child: CustomPaint(
        painter: _GlassEdgePainter(color: color, light: light, radius: radius),
      ),
    );
  }
}

class _GlassEdgePainter extends CustomPainter {
  const _GlassEdgePainter({
    required this.color,
    required this.light,
    required this.radius,
  });

  final Color color;
  final bool light;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = FloatingNavBar.glassStrokeWidth
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: light ? 0.22 : 0.36),
          // Never zero: this is where the caps are, and they should keep a
          // trace of light rather than breaking the outline.
          color.withValues(alpha: light ? 0.04 : 0.07),
          color.withValues(alpha: light ? 0.11 : 0.18),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        // Inset by half the stroke so it lands inside the clip rather than
        // being shaved in half by it.
        rect.deflate(FloatingNavBar.glassStrokeWidth / 2),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_GlassEdgePainter old) =>
      old.color != color || old.light != light || old.radius != radius;
}

/// Scales the bar up while a drag is in flight, and lets it give sideways when
/// the pill is pushed into an end cap.
class _Zoom extends StatelessWidget {
  const _Zoom({required this.zoom, required this.give, required this.child});

  final double zoom;

  /// Signed, negative pushes left. Scales horizontally from the opposite edge
  /// so the bar grows towards the side being pushed.
  final double give;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: FloatingNavBar._duration,
      curve: FloatingNavBar._curve,
      scale: zoom,
      alignment: Alignment.bottomCenter,
      child: Transform.scale(
        scaleX: 1 + give.abs(),
        scaleY: 1,
        alignment: give < 0 ? Alignment.centerRight : Alignment.centerLeft,
        child: child,
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.destination,
    required this.selected,
    required this.iconSize,
    required this.nudge,
    required this.onTap,
    this.label,
    this.labelStyle,
  });

  final NavigationDestination destination;
  final bool selected;
  final double iconSize;

  /// Horizontal shift so the icon lands on the pill's centre rather than its
  /// slot's. Zero everywhere except the two end slots.
  final double nudge;

  /// Shown beside the icon in the labelled layout; null keeps it icon-only.
  final String? label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = selected
        ? (destination.selectedIcon ?? destination.icon)
        : destination.icon;
    // A selected icon sits on the pill, so it takes the pill's paired colour
    // rather than the bar's. Unselected ones stay neutral, so only the active
    // tab carries the theme.
    // Both states at full strength: the pill, the fill and the stroke weight
    // already say which tab is active, so dimming the rest only made them
    // harder to read.
    final color = selected ? scheme.onSecondaryContainer : scheme.onSurface;
    return Semantics(
      // The label is gone visually, so it has to survive for screen readers.
      label: destination.label,
      selected: selected,
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Transform.translate(
            offset: Offset(nudge, 0),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: iconSize),
              duration: FloatingNavBar._duration,
              curve: FloatingNavBar._curve,
              builder: (context, size, child) => IconTheme(
                data: IconThemeData(
                  size: size,
                  color: color,
                  // Several destinations (history, more) have an "outlined"
                  // variant that is the same drawing, so filling cannot show
                  // selection. Thickening the stroke does, and it is harmless on
                  // the icons that do fill.
                  shadows: selected
                      ? [Shadow(color: color, blurRadius: 0.9)]
                      : null,
                ),
                child: child!,
              ),
              child: label == null
                  ? icon
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon,
                        const SizedBox(width: FloatingNavBar._labelGap),
                        // Flexible so a long label in a narrow window ellipsises
                        // rather than overflowing the bar.
                        Flexible(
                          child: Text(
                            label!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: labelStyle?.copyWith(color: color),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
