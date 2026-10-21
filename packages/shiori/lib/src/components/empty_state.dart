import 'package:flutter/material.dart';

import '../tokens.dart';
import 'button.dart';

/// What a screen shows when it has nothing to show: an illustration, one
/// line saying why, and the next step.
///
/// "Empty library" alone tells a reader nothing they can act on; "Your
/// library is empty · Browse sources" does.
class ShioriEmptyState extends StatelessWidget {
  const ShioriEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// A `Symbols.*_rounded` glyph, drawn at illustration size.
  final IconData icon;
  final String title;

  /// One or two sentences on why it is empty, or what fills it.
  final String? message;

  /// The next step, shown as the screen's primary button with [onAction].
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Tighter, for use inside a list or a sheet rather than a whole page.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final c = tokens.color;
    final circle = tokens.scaled(compact ? 64 : 88);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ShioriSpace.s24,
          vertical: compact ? ShioriSpace.s16 : ShioriSpace.s32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Container(
                  width: circle,
                  height: circle,
                  decoration: BoxDecoration(
                    color: c.ink2,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: circle * 0.5, color: c.fgMuted),
                ),
              ),
              SizedBox(height: compact ? ShioriSpace.s12 : ShioriSpace.s16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: tokens.text.section.copyWith(color: c.fg),
              ),
              if (message != null) ...[
                const SizedBox(height: ShioriSpace.s8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: tokens.text.body.copyWith(color: c.fgMuted),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                SizedBox(height: compact ? ShioriSpace.s16 : ShioriSpace.s24),
                ShioriButton(label: actionLabel!, onPressed: onAction),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
