import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// The shared failure state.
///
/// Screens used to render a bare `Center(child: Text(error.toString()))`, which
/// shows the user a stack trace, gives them nothing to do about it and looks
/// different in every place it appears. Use this instead: a readable line, the
/// technical cause kept but demoted, and a retry when the caller can offer one.
///
/// Every colour here comes from the theme, because the palette is chosen at
/// runtime and any fixed colour would be wrong on somebody else's scheme.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    this.message,
    this.detail,
    this.onRetry,
    this.compact = false,
    this.autofocusRetry,
    this.secondaryLabel,
    this.secondaryIcon,
    this.onSecondary,
  });

  /// Human readable line. Falls back to a generic message when null.
  final String? message;

  /// Technical cause, kept for bug reports but visually demoted. Nothing is
  /// rendered for it when null or empty.
  final String? detail;

  /// Omitted when the caller has nothing useful to re-run.
  final VoidCallback? onRetry;

  /// Tightens the padding for use inside a list or a sheet rather than as a
  /// whole page.
  final bool compact;

  /// Whether the retry button claims focus on a TV. Defaults to taking it,
  /// since it is usually the only control on the screen. Pass false where the
  /// route already autofocuses something else, because two widgets competing
  /// for autofocus in one scope resolve arbitrarily.
  final bool? autofocusRetry;

  /// A second way out beside the retry, such as opening a source in the
  /// browser to get past Cloudflare. Shown with [onSecondary].
  final String? secondaryLabel;
  final IconData? secondaryIcon;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tokens = context.shiori;
    final c = tokens.color;
    final detailText = detail?.trim();
    final circle = tokens.scaled(compact ? 56 : 72);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ShioriSpace.s24,
          vertical: compact ? ShioriSpace.s16 : ShioriSpace.s32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ExcludeSemantics(
              child: Container(
                width: circle,
                height: circle,
                decoration: BoxDecoration(
                  color: c.error.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Symbols.error_rounded,
                  size: circle * 0.5,
                  color: c.error.foreground,
                ),
              ),
            ),
            SizedBox(height: compact ? ShioriSpace.s12 : ShioriSpace.s16),
            Text(
              message ?? l10n.something_went_wrong,
              textAlign: TextAlign.center,
              style: tokens.text.section.copyWith(color: c.fg),
            ),
            if (detailText != null && detailText.isNotEmpty) ...[
              const SizedBox(height: ShioriSpace.s8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  detailText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.meta.copyWith(color: c.fgMuted),
                ),
              ),
            ],
            if (onRetry != null || onSecondary != null) ...[
              SizedBox(height: compact ? ShioriSpace.s16 : ShioriSpace.s24),
              Wrap(
                spacing: ShioriSpace.s8,
                runSpacing: ShioriSpace.s8,
                alignment: WrapAlignment.center,
                children: [
                  if (onRetry != null)
                    ShioriButton.secondary(
                      // On a TV there is no pointer, so the only actionable
                      // control on the screen takes focus straight away.
                      autofocus: autofocusRetry ?? isTv,
                      onPressed: onRetry,
                      icon: Symbols.refresh_rounded,
                      label: l10n.retry,
                    ),
                  if (onSecondary != null && secondaryLabel != null)
                    ShioriButton.quiet(
                      onPressed: onSecondary,
                      icon: secondaryIcon,
                      label: secondaryLabel!,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
