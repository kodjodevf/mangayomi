import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// True for the remote / keyboard "select / OK" keys used across the TV UI.
bool tvIsSelectKey(LogicalKeyboardKey k) =>
    k == LogicalKeyboardKey.select ||
    k == LogicalKeyboardKey.enter ||
    k == LogicalKeyboardKey.numpadEnter ||
    k == LogicalKeyboardKey.gameButtonA ||
    k == LogicalKeyboardKey.space;

/// A focusable TV pill (chip) with the accent focused / selected / idle states
/// shared by the TV home category filter and the Browse tab switcher.
///
/// Focused = accent fill + white text + a slight scale; selected (not focused) =
/// accent tint + accent text; idle = muted. Handles remote OK (tap) and held-OK
/// (long-press), an optional Menu action while focused, and scrolls itself into
/// view on focus.
class TvPill extends StatefulWidget {
  const TvPill({
    super.key,
    required this.label,
    required this.onTap,
    this.onLongPress,
    this.onMenu,
    this.icon,
    this.focusNode,
    this.selected = false,
    this.autofocus = false,
  });
  final String label;
  final IconData? icon;
  final FocusNode? focusNode;
  final bool selected;
  final bool autofocus;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// Handled only while this pill has focus, so the remote's Menu button stays
  /// free everywhere else.
  final VoidCallback? onMenu;

  @override
  State<TvPill> createState() => _TvPillState();
}

class _TvPillState extends State<TvPill> {
  bool _focused = false;
  bool _held = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final bg = _focused
        ? accent
        : widget.selected
        ? accent.withValues(alpha: 0.22)
        : Theme.of(context).hintColor.withValues(alpha: 0.14);
    final fg = _focused
        ? Colors.white
        : widget.selected
        ? accent
        : Theme.of(context).colorScheme.onSurface;
    return Focus(
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (f) {
        setState(() => _focused = f);
        if (f && context.mounted && Scrollable.maybeOf(context) != null) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
      onKeyEvent: (node, event) {
        final onMenu = widget.onMenu;
        if (onMenu != null &&
            event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.contextMenu) {
          onMenu();
          return KeyEventResult.handled;
        }
        if (!tvIsSelectKey(event.logicalKey)) return KeyEventResult.ignored;
        // A remote reports a held OK as key *repeats*, never as a pointer
        // long-press. Both tap and hold resolve on release, so whatever a hold
        // opens never inherits the rest of that press.
        if (event is KeyDownEvent) {
          _held = false;
          return KeyEventResult.handled;
        }
        if (event is KeyRepeatEvent) {
          _held = true;
          return KeyEventResult.handled;
        }
        if (event is KeyUpEvent) {
          final longPress = widget.onLongPress;
          if (_held && longPress != null) {
            longPress();
          } else {
            widget.onTap();
          }
          _held = false;
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scaleByDouble(
              _focused ? 1.08 : 1.0,
              _focused ? 1.08 : 1.0,
              _focused ? 1.08 : 1.0,
              1,
            ),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: bg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 14, color: fg),
                const SizedBox(width: 4),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
