import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

class CoverViewWidget extends StatefulWidget {
  final List<Widget> children;
  final bool? isLongPressed;
  final ImageProvider? image;
  final bool isComfortableGrid;
  final Widget? bottomTextWidget;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  // On TV, the first cover autofocuses so the grid becomes the content scope's
  // focus target (otherwise d-pad focus never reaches it).
  final bool autofocus;
  // Notifies the parent when this card gains/loses focus — used by the TV home
  // rows to scroll the focused card into view. Fires on any focus change,
  // independent of the internal ring (which is gated to d-pad/keyboard input).
  final ValueChanged<bool>? onFocusChange;
  // 0..1 watch/read progress; when > 0 draws a thin bar along the cover bottom.
  final double progress;
  // Flies the cover to its detail page; see coverHeroTag. Only one cover per
  // series on a screen may carry a tag.
  final Object? heroTag;
  const CoverViewWidget({
    super.key,
    required this.children,
    this.isComfortableGrid = false,
    this.bottomTextWidget,
    required this.onTap,
    this.image,
    this.onLongPress,
    this.isLongPressed,
    this.onSecondaryTap,
    this.autofocus = false,
    this.onFocusChange,
    this.progress = 0,
    this.heroTag,
  });

  @override
  State<CoverViewWidget> createState() => _CoverViewWidgetState();
}

class _CoverViewWidgetState extends State<CoverViewWidget> {
  // Held-OK tracking for the TV long-press (see the Focus wrapper in build).
  bool _held = false;
  // True only between a Select KeyDown and its KeyUp on THIS card. Guards
  // against a stray KeyUp landing here without its KeyDown: e.g. pressing OK on
  // a detail screen's Back button pops on KeyDown, and the trailing KeyUp then
  // arrives at whatever cover regained focus. Without this it read as a tap and
  // immediately re-opened the detail we just left.
  bool _pressed = false;

  // Whether the card should draw a focus ring. Only set when focus arrives via
  // keyboard / d-pad navigation (FocusHighlightMode.traditional), so touch
  // input on phones/tablets never shows a ring. Gives d-pad/remote users on
  // Android TV — and keyboard users anywhere — a clearly visible focus target.
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    // Track highlight-mode changes so the ring is dropped immediately if the
    // user switches to touch input while a card is focused (it must never show
    // for touch), not only when focus is lost.
    FocusManager.instance.addHighlightModeListener(_onHighlightModeChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeHighlightModeListener(_onHighlightModeChanged);
    super.dispose();
  }

  Widget _hero(Widget child) {
    final tag = widget.heroTag;
    return tag == null ? child : Hero(tag: tag, child: child);
  }

  void _onHighlightModeChanged(FocusHighlightMode mode) {
    // On TV the ring must persist regardless of highlight mode (input is d-pad
    // only); elsewhere drop it the moment input switches away from keyboard.
    if (!isTv && mode != FocusHighlightMode.traditional && _focused) {
      setState(() => _focused = false);
    }
  }

  void _onFocusChange(bool hasFocus) {
    widget.onFocusChange?.call(hasFocus);
    // On TV always show the ring when focused so something is always visibly
    // focused; elsewhere only for keyboard/d-pad (traditional) so touch input
    // never shows it.
    final show =
        hasFocus &&
        (isTv ||
            FocusManager.instance.highlightMode ==
                FocusHighlightMode.traditional);
    if (mounted && show != _focused) {
      setState(() => _focused = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showOverlay = widget.isLongPressed != null && widget.isLongPressed!;
    // Comfortable grid renders the label below the card, so it must not also be
    // placed inside the card. Render it once, and only when provided.
    final showBottomText =
        widget.isComfortableGrid && widget.bottomTextWidget != null;
    // Matrix4.scale is deprecated in favour of the explicit per-axis form.
    final pop = _focused ? 1.06 : 1.0;
    // An InkWell's keyboard activation only ever fires onTap, so a remote
    // could not reach the long-press actions at all (library multi-select,
    // most importantly). On TV, when a long-press exists, intercept the select
    // key above the InkWell and resolve tap vs hold on release, exactly like
    // TvPill: press-and-release opens, press-and-hold selects. The wrapper
    // takes no focus of its own; it only sees keys bubbling from the InkWell.
    final tokens = context.shiori;
    final c = tokens.color;
    final motion = ShioriMotion.of(context, ShioriMotion.fast);
    // Multi-selection: the accent veils the cover and a check confirms it,
    // the same treatment as ShioriCover.
    final selection = showOverlay
        ? Positioned.fill(
            child: ColoredBox(
              color: c.accent.withValues(alpha: Alphas.secondary),
              child: Center(
                child: Icon(
                  Symbols.check_circle_rounded,
                  fill: 1,
                  color: c.onAccent,
                  size: tokens.scaled(32),
                ),
              ),
            ),
          )
        : null;
    Widget card = Padding(
      padding: const EdgeInsets.all(ShioriSpace.s4),
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: motion,
              curve: ShioriMotion.standardCurve,
              // Focus "pop" — the focused cover lifts slightly, TV-style.
              transform: Matrix4.identity()..scaleByDouble(pop, pop, pop, 1),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                // The ring sits outside the clip, its radius grown by its
                // width so the corners stay concentric with the cover.
                borderRadius: BorderRadius.circular(ShioriShape.cover + 3),
                border: Border.all(
                  color: _focused ? c.accent : Colors.transparent,
                  width: 3,
                ),
              ),
              child: _hero(
                Material(
                  borderRadius: BorderRadius.circular(ShioriShape.cover),
                  color: widget.image == null ? Colors.transparent : c.ink2,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    autofocus: widget.autofocus,
                    onTap: widget.onTap,
                    onLongPress: widget.onLongPress,
                    onSecondaryTap: widget.onSecondaryTap,
                    onFocusChange: _onFocusChange,
                    child: widget.image == null
                        ? Stack(
                            children: [
                              widget.isComfortableGrid
                                  ? Column(children: widget.children)
                                  : Stack(children: widget.children),
                              ?selection,
                            ],
                          )
                        : Ink.image(
                            fit: BoxFit.cover,
                            image: widget.image!,
                            child: Stack(
                              children: [
                                ?selection,
                                ...widget.children,
                                if (widget.progress > 0)
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: _ProgressBar(
                                      value: widget.progress,
                                      color: c.accent,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          // A small gap so the focused card's 3px ring (and its slight scale)
          // clears the title below instead of bleeding onto it.
          if (showBottomText) const SizedBox(height: ShioriSpace.s4),
          if (showBottomText) widget.bottomTextWidget!,
        ],
      ),
    );
    final longPress = widget.onLongPress;
    if (isTv && longPress != null) {
      card = Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if (!tvIsSelectKey(event.logicalKey)) return KeyEventResult.ignored;
          if (event is KeyDownEvent) {
            _held = false;
            _pressed = true;
            return KeyEventResult.handled;
          }
          if (event is KeyRepeatEvent) {
            if (_pressed) _held = true;
            return KeyEventResult.handled;
          }
          if (event is KeyUpEvent) {
            // A KeyUp without the matching KeyDown here is a leaked press from
            // another screen (e.g. a Back button that popped on KeyDown). Drop
            // it so it can't fire onTap and re-open what we just closed.
            if (!_pressed) return KeyEventResult.ignored;
            if (_held) {
              longPress();
            } else {
              widget.onTap();
            }
            _held = false;
            _pressed = false;
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: card,
      );
    }
    return card;
  }
}

/// A thin reading-progress track along the bottom of a cover.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const ColoredBox(color: ShioriScrim.onImage),
          FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: value.clamp(0.0, 1.0),
            child: ColoredBox(color: color),
          ),
        ],
      ),
    );
  }
}
