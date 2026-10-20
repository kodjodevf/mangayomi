import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../tokens.dart';

/// What a toast is telling the reader. Sets its icon and its tint.
enum ShioriToastTone { info, success, warning, error }

/// An action under a toast's message: "Undo", "View", "Solve".
@immutable
class ShioriToastAction {
  const ShioriToastAction(this.label, this.onPressed, {this.semanticLabel});

  final String label;
  final VoidCallback onPressed;

  /// What a screen reader says, when [label] alone is too terse out of
  /// context ("Solve" is "Solve the Cloudflare challenge").
  final String? semanticLabel;
}

/// The card a brief message is drawn on.
///
/// Presentation only. Showing, queueing and dismissing it is the host's
/// job, so the same card works with any overlay mechanism.
class ShioriToastCard extends StatelessWidget {
  const ShioriToastCard({
    super.key,
    required this.message,
    this.tone = ShioriToastTone.info,
    this.leading,
    this.actions = const [],
    this.maxLines = 6,
    this.fontSize,
    this.showIcon = true,
  });

  final String message;
  final ShioriToastTone tone;

  /// Replaces the tone's icon, for instance with the app's own mark.
  final Widget? leading;

  /// Laid out under the message, so a long label never squeezes the text.
  final List<ShioriToastAction> actions;
  final int maxLines;

  /// Overrides the body size, for callers that already pass one.
  final double? fontSize;

  /// Off for a plain line of text with no icon at all.
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final (IconData icon, Color tint) = switch (tone) {
      ShioriToastTone.info => (Symbols.info_rounded, c.accentInk),
      ShioriToastTone.success => (
        Symbols.check_circle_rounded,
        c.completed.foreground,
      ),
      ShioriToastTone.warning => (
        Symbols.warning_rounded,
        c.offline.foreground,
      ),
      ShioriToastTone.error => (Symbols.error_rounded, c.error.foreground),
    };

    final body = tokens.text.row.copyWith(
      color: c.fg,
      fontSize: fontSize,
      height: 1.35,
    );

    return Semantics(
      liveRegion: true,
      container: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Material(
          color: c.ink3,
          elevation: 6,
          shadowColor: ShioriScrim.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ShioriShape.card),
            side: BorderSide(color: c.hairline),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              ShioriSpace.s16,
              ShioriSpace.s12,
              ShioriSpace.s16,
              ShioriSpace.s12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: ShioriSpace.s12,
              children: [
                if (showIcon)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child:
                        leading ??
                        Icon(icon, size: tokens.scaled(20), color: tint),
                  ),
                Expanded(
                  // As tall as the message and its actions: the overlay
                  // gives the card the whole screen's height to fill.
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: ShioriSpace.s4,
                    children: [
                      Text(
                        message,
                        style: body,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (actions.isNotEmpty)
                        Wrap(
                          spacing: ShioriSpace.s8,
                          children: [
                            for (final action in actions)
                              // A label of its own replaces the visible one
                              // for screen readers, on a node that can still
                              // be activated.
                              Semantics(
                                container: true,
                                button: true,
                                label: action.semanticLabel,
                                onTap: action.onPressed,
                                excludeSemantics: action.semanticLabel != null,
                                child: TextButton(
                                  onPressed: action.onPressed,
                                  style: TextButton.styleFrom(
                                    foregroundColor: tint,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: ShioriSpace.s8,
                                    ),
                                    // A full target: the toast is often tapped
                                    // in passing, and may be gone in seconds.
                                    minimumSize: Size(
                                      0,
                                      tokens.density.minTarget,
                                    ),
                                    textStyle: tokens.text.meta.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  child: Text(action.label),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
