import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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
    Widget card = Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 130),
              curve: Curves.easeOut,
              // Focus "pop" — the focused cover lifts slightly, TV-style.
              transform: Matrix4.identity()..scaleByDouble(pop, pop, pop, 1),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                // Outer radius = inner clip radius (5) + border width (3) so the
                // ring's corners stay concentric with the card and don't clip.
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _focused ? context.primaryColor : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  autofocus: widget.autofocus,
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onSecondaryTap: widget.onSecondaryTap,
                  onFocusChange: _onFocusChange,
                  child: widget.image == null
                      ? Container(
                          color: showOverlay
                              ? context.primaryColor.withValues(alpha: 0.4)
                              : Colors.transparent,
                          child: widget.isComfortableGrid
                              ? Column(children: widget.children)
                              : Stack(children: widget.children),
                        )
                      : Ink.image(
                          fit: BoxFit.cover,
                          image: widget.image!,
                          child: Stack(
                            children: [
                              if (showOverlay)
                                Positioned.fill(
                                  child: Container(
                                    color: context.primaryColor.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
                                ),
                              ...widget.children,
                              if (widget.progress > 0)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: LinearProgressIndicator(
                                    value: widget.progress.clamp(0.0, 1.0),
                                    minHeight: 3,
                                    backgroundColor: Colors.black.withValues(
                                      alpha: 0.35,
                                    ),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      context.primaryColor,
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
          // A small gap so the focused card's 3px ring (and its slight scale)
          // clears the title below instead of bleeding onto it.
          if (showBottomText) const SizedBox(height: 4),
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
