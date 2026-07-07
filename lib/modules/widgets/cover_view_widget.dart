import 'package:flutter/material.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

class CoverViewWidget extends StatefulWidget {
  final List<Widget> children;
  final bool? isLongPressed;
  final ImageProvider? image;
  final bool isComfortableGrid;
  final Widget? bottomTextWidget;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
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
  });

  @override
  State<CoverViewWidget> createState() => _CoverViewWidgetState();
}

class _CoverViewWidgetState extends State<CoverViewWidget> {
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
    if (mode != FocusHighlightMode.traditional && _focused) {
      setState(() => _focused = false);
    }
  }

  void _onFocusChange(bool hasFocus) {
    final show =
        hasFocus &&
        FocusManager.instance.highlightMode == FocusHighlightMode.traditional;
    if (mounted && show != _focused) {
      setState(() => _focused = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Comfortable grid renders the label below the card, so it must not also be
    // placed inside the card. Render it once, and only when provided.
    final showBottomText =
        widget.isComfortableGrid && widget.bottomTextWidget != null;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
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
                  onTap: widget.onTap,
                  onLongPress: widget.onLongPress,
                  onSecondaryTap: widget.onSecondaryTap,
                  onFocusChange: _onFocusChange,
                  child: Container(
                    color: widget.isLongPressed != null && widget.isLongPressed!
                        ? context.primaryColor.withValues(alpha: 0.4)
                        : Colors.transparent,
                    child: widget.image == null
                        ? widget.isComfortableGrid
                              // bottomTextWidget is rendered once below the card,
                              // so it's not duplicated inside here anymore.
                              ? Column(children: widget.children)
                              : Stack(children: widget.children)
                        : Ink.image(
                            fit: BoxFit.cover,
                            image: widget.image!,
                            child: Stack(children: widget.children),
                          ),
                  ),
                ),
              ),
            ),
          ),
          if (showBottomText) widget.bottomTextWidget!,
        ],
      ),
    );
  }
}
