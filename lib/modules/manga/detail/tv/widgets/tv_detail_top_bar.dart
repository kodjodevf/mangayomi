import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiori/shiori.dart';

import 'tv_key_utils.dart';

/// Focusable top bar: Back (top-left) and Refresh. Everything else now lives as
/// a button in the hero's action list, so the bar stays minimal. Down hands
/// focus to the content below.
class TvDetailTopBar extends StatelessWidget {
  const TvDetailTopBar({
    super.key,
    required this.topBarFocus,
    required this.refreshing,
    required this.onBack,
    required this.onRefresh,
    required this.onDown,
  });

  final FocusNode topBarFocus;
  final bool refreshing;
  final VoidCallback onBack;
  final VoidCallback onRefresh;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          onDown();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 10, 28, 4),
        child: Row(
          children: [
            TvDetailTopBarButton(
              focusNode: topBarFocus,
              icon: Symbols.arrow_back_rounded,
              onPressed: onBack,
            ),
            const Spacer(),
            TvDetailTopBarButton(
              icon: refreshing
                  ? Symbols.hourglass_empty_rounded
                  : Symbols.refresh_rounded,
              onPressed: onRefresh,
            ),
          ],
        ),
      ),
    );
  }
}

class TvDetailTopBarButton extends StatefulWidget {
  const TvDetailTopBarButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.focusNode,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final FocusNode? focusNode;

  @override
  State<TvDetailTopBarButton> createState() => _TvDetailTopBarButtonState();
}

class _TvDetailTopBarButtonState extends State<TvDetailTopBarButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.shiori.color.accentInk;
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && isTvSelectKey(event.logicalKey)) {
          widget.onPressed();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: ShioriMotion.fast,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _focused ? accent : accent.withValues(alpha: Alphas.focus),
          ),
          child: Icon(
            widget.icon,
            size: 22,
            color: _focused ? ShioriColors.onFill(accent) : accent,
          ),
        ),
      ),
    );
  }
}
