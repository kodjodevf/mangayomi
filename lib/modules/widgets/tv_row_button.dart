import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mangayomi/modules/widgets/tv_pill.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';

/// Tracks which [TvListRow] currently holds focus, so every other row can fade
/// back while one is active. Provide it above a list of rows. Rows with no
/// scope above them simply never fade, so this stays optional.
class TvRowFocusScope extends InheritedNotifier<ValueNotifier<Object?>> {
  const TvRowFocusScope({
    super.key,
    required ValueNotifier<Object?> super.notifier,
    required super.child,
  });

  /// Subscribes: the caller rebuilds whenever the active row changes.
  static Object? activeRow(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<TvRowFocusScope>()
      ?.notifier
      ?.value;

  /// Reads without subscribing, for focus callbacks and dispose.
  static ValueNotifier<Object?>? notifierOf(BuildContext context) =>
      (context.getElementForInheritedWidgetOfExactType<TvRowFocusScope>()?.widget
              as TvRowFocusScope?)
          ?.notifier;
}

/// The shell shared by the TV list rows (Browse sources and extensions).
///
/// It watches its own buttons for focus without ever taking focus itself, then
/// lights the whole row as a band while focus is anywhere inside it and fades
/// the row back while a *different* row is the active one. The result is that
/// the row a remote is on stays obvious even once focus moves off the leading
/// button onto Latest / Pin or an action button.
class TvListRow extends StatefulWidget {
  const TvListRow({super.key, required this.children});
  final List<Widget> children;

  @override
  State<TvListRow> createState() => _TvListRowState();
}

class _TvListRowState extends State<TvListRow> {
  /// Identity for this row in the shared scope. Rows are rebuilt as the list
  /// re-sorts, so identity has to travel with the State, not the widget.
  final Object _id = Object();
  ValueNotifier<Object?>? _scope;
  bool _focused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scope = TvRowFocusScope.notifierOf(context);
  }

  @override
  void dispose() {
    // Never leave the scope pointing at a row that no longer exists: every
    // other row would stay faded with nothing lit. Deferred because clearing it
    // here would notify listeners mid-teardown.
    final scope = _scope;
    if (scope != null && scope.value == _id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scope.value == _id) scope.value = null;
      });
    }
    super.dispose();
  }

  void _onFocusChange(bool hasFocus) {
    if (hasFocus != _focused) setState(() => _focused = hasFocus);
    final scope = _scope;
    if (scope == null) return;
    if (hasFocus) {
      scope.value = _id;
    } else if (scope.value == _id) {
      // Focus left the list entirely (e.g. up to the pills), so nothing is
      // active and every row goes back to full strength.
      scope.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
    final active = TvRowFocusScope.activeRow(context);
    final fadedBack = active != null && active != _id;

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: _onFocusChange,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        opacity: fadedBack ? 0.7 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Lightened toward white so the band reads as lit rather than as a
            // flat wash of accent behind the text.
            color: _focused
                ? Color.lerp(
                    accent,
                    Colors.white,
                    0.35,
                  )!.withValues(alpha: 0.16)
                : Colors.transparent,
          ),
          child: Row(children: widget.children),
        ),
      ),
    );
  }
}

/// A focusable button inside a [TvListRow]: transparent when idle, accent-filled
/// when focused, and firing [onTap] on a remote OK press. Scrolls itself into
/// view on focus.
class TvRowButton extends StatefulWidget {
  const TvRowButton({
    super.key,
    required this.onTap,
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onLongPress,
  });
  final VoidCallback onTap;
  final Widget child;
  final FocusNode? focusNode;

  /// Optional held-OK action. A remote reports a held OK as key repeats, never
  /// as a pointer long-press, so when this is set the button resolves both tap
  /// and hold on key release, exactly like [TvPill].
  final VoidCallback? onLongPress;

  /// Claim focus on first build. Set on the first row of a pushed list (mass
  /// migration, etc.) that has no nav rail to hand focus over, so the remote
  /// has a starting point instead of being stranded.
  final bool autofocus;

  @override
  State<TvRowButton> createState() => _TvRowButtonState();
}

class _TvRowButtonState extends State<TvRowButton> {
  bool _focused = false;
  bool _held = false;

  @override
  Widget build(BuildContext context) {
    final accent = context.primaryColor;
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
        if (!tvIsSelectKey(event.logicalKey)) return KeyEventResult.ignored;
        final longPress = widget.onLongPress;
        // Without a hold action, fire on key-down as before. With one, both
        // tap and hold resolve on release so a hold never also taps.
        if (longPress == null) {
          if (event is KeyDownEvent) {
            widget.onTap();
          }
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent) {
          _held = false;
          return KeyEventResult.handled;
        }
        if (event is KeyRepeatEvent) {
          _held = true;
          return KeyEventResult.handled;
        }
        if (event is KeyUpEvent) {
          if (_held) {
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // Sits on top of the row's band, so it has to stay clearly the
            // brightest thing in the row.
            color: _focused
                ? accent.withValues(alpha: 0.32)
                : Colors.transparent,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
