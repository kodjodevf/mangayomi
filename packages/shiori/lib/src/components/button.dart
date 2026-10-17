import 'package:flutter/material.dart';

import '../alphas.dart';
import '../tokens.dart';

/// The three levels of action. A screen has at most one [primary].
enum ShioriButtonVariant {
  /// The action the screen exists for: "Resume", "Add to library".
  primary,

  /// An alternative to the primary: "Track", "Filter".
  secondary,

  /// A low-key action: "Cancel", "Show all".
  quiet,
}

/// A button at one of Shiori's three levels.
///
/// Built on Material's buttons, so focus, hover, keyboard activation and
/// semantics come for free; Shiori only decides how each level looks.
class ShioriButton extends StatelessWidget {
  const ShioriButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ShioriButtonVariant.primary,
    this.icon,
    this.destructive = false,
    this.expand = false,
    this.autofocus = false,
  });

  const ShioriButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
    this.expand = false,
    this.autofocus = false,
  }) : variant = ShioriButtonVariant.secondary;

  const ShioriButton.quiet({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.destructive = false,
    this.expand = false,
    this.autofocus = false,
  }) : variant = ShioriButtonVariant.quiet;

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final ShioriButtonVariant variant;

  /// An optional leading `Symbols.*_rounded` glyph.
  final IconData? icon;

  /// For actions that delete or discard: drawn in the error colours.
  final bool destructive;

  /// Fills the available width.
  final bool expand;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final scheme = Theme.of(context).colorScheme;
    final c = tokens.color;

    final (Color bg, Color fg) = switch (variant) {
      ShioriButtonVariant.primary =>
        destructive ? (scheme.error, scheme.onError) : (c.accent, c.onAccent),
      ShioriButtonVariant.secondary => (
        c.ink2,
        destructive ? c.error.foreground : c.fg,
      ),
      ShioriButtonVariant.quiet => (
        Colors.transparent,
        destructive ? c.error.foreground : c.accentInk,
      ),
    };

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? (variant == ShioriButtonVariant.quiet
                  ? Colors.transparent
                  : c.fg.withValues(alpha: Alphas.tint))
            : bg,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? c.fg.withValues(alpha: Alphas.disabled)
            : fg,
      ),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: Alphas.focus)),
      minimumSize: WidgetStatePropertyAll(
        Size(tokens.density.minTarget, tokens.density.minTarget),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: ShioriSpace.s16),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      textStyle: WidgetStatePropertyAll(
        tokens.text.row.copyWith(fontWeight: FontWeight.w700),
      ),
      elevation: const WidgetStatePropertyAll(0),
      animationDuration: ShioriMotion.fast,
    );

    final child = icon == null
        ? Text(label, maxLines: 1, overflow: TextOverflow.ellipsis)
        : Row(
            mainAxisSize: MainAxisSize.min,
            spacing: ShioriSpace.s8,
            children: [
              Icon(icon, size: tokens.scaled(20)),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = variant == ShioriButtonVariant.quiet
        ? TextButton(
            onPressed: onPressed,
            autofocus: autofocus,
            style: style,
            child: child,
          )
        : FilledButton(
            onPressed: onPressed,
            autofocus: autofocus,
            style: style,
            child: child,
          );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
