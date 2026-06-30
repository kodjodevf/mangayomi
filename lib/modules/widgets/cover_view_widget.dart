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
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
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
                              ? Column(
                                  children: [
                                    ...widget.children,
                                    widget.bottomTextWidget!,
                                  ],
                                )
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
          if (widget.isComfortableGrid) widget.bottomTextWidget!,
        ],
      ),
    );
  }
}
