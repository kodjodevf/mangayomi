import 'package:flutter/material.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final detailText = detail?.trim();

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: compact ? 16 : 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: compact ? 32 : 44,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: compact ? 10 : 14),
            Text(
              message ?? l10n.something_went_wrong,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (detailText != null && detailText.isNotEmpty) ...[
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  detailText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: context.textColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: compact ? 14 : 20),
              FilledButton.tonalIcon(
                // On a TV there is no pointer, so the only actionable control
                // on the screen takes focus straight away.
                autofocus: autofocusRetry ?? isTv,
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
