import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// One row in a [showTvMenu].
class TvMenuOption {
  const TvMenuOption(this.label, {this.icon, this.selected = false});

  final String label;
  final IconData? icon;

  /// Marks the current value, for menus that pick between options.
  final bool selected;
}

/// Shows a centred, d-pad driven menu and completes with the chosen index, or
/// null if dismissed.
///
/// The TV stand-in for an anchored PopupMenuButton. A dropdown pinned under an
/// icon in the corner of the screen is a poor target for a remote: it opens off
/// to one edge, and its items are small and easy to lose. This pops in the
/// middle of the screen with explicit Up/Down movement, matching the player's
/// speed menu.
Future<int?> showTvMenu(
  BuildContext context, {
  required String title,
  required List<TvMenuOption> options,
}) {
  return showDialog<int>(
    context: context,
    builder: (ctx) => _TvMenu(title: title, options: options),
  );
}

class _TvMenu extends StatefulWidget {
  const _TvMenu({required this.title, required this.options});

  final String title;
  final List<TvMenuOption> options;

  @override
  State<_TvMenu> createState() => _TvMenuState();
}

class _TvMenuState extends State<_TvMenu> {
  late final List<FocusNode> _nodes;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(
      widget.options.length,
      (i) => FocusNode(debugLabel: 'tvMenu$i'),
    );
    // Open on the current value, so the menu starts where the user left off
    // rather than always at the top.
    final selected = widget.options.indexWhere((o) => o.selected);
    _index = selected < 0 ? 0 : selected;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _nodes[_index].requestFocus();
    });
  }

  @override
  void dispose() {
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _move(int delta) {
    _index = (_index + delta).clamp(0, _nodes.length - 1);
    _nodes[_index].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    return AlertDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: 320,
        child: FocusTraversalGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < widget.options.length; i++)
                _TvMenuRow(
                  option: widget.options[i],
                  accent: accent,
                  focusNode: _nodes[i],
                  onKey: (event) {
                    final k = event.logicalKey;
                    if (k == LogicalKeyboardKey.arrowDown) {
                      _move(1);
                      return true;
                    }
                    if (k == LogicalKeyboardKey.arrowUp) {
                      _move(-1);
                      return true;
                    }
                    // Swallow Left/Right so focus cannot slip out sideways to
                    // whatever is behind the dialog.
                    if (k == LogicalKeyboardKey.arrowLeft ||
                        k == LogicalKeyboardKey.arrowRight) {
                      return true;
                    }
                    return false;
                  },
                  onPick: () => Navigator.pop(context, i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TvMenuRow extends StatefulWidget {
  const _TvMenuRow({
    required this.option,
    required this.accent,
    required this.focusNode,
    required this.onKey,
    required this.onPick,
  });

  final TvMenuOption option;
  final Color accent;
  final FocusNode focusNode;
  final bool Function(KeyEvent) onKey;
  final VoidCallback onPick;

  @override
  State<_TvMenuRow> createState() => _TvMenuRowState();
}

class _TvMenuRowState extends State<_TvMenuRow> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.option;
    return Focus(
      focusNode: widget.focusNode,
      onFocusChange: (f) => setState(() => _focused = f),
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
          return KeyEventResult.ignored;
        }
        if (event is KeyDownEvent && tvIsSelectKey(event.logicalKey)) {
          widget.onPick();
          return KeyEventResult.handled;
        }
        return widget.onKey(event)
            ? KeyEventResult.handled
            : KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: widget.onPick,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _focused
                ? widget.accent.withValues(alpha: 0.30)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              if (o.icon != null) ...[
                Icon(o.icon, size: 18),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  o.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: o.selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
              if (o.selected) Icon(Icons.check, size: 18, color: widget.accent),
            ],
          ),
        ),
      ),
    );
  }
}
