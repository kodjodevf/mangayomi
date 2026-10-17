import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:shiori/shiori.dart';

/// A page on its way: the accent ring filling as the bytes arrive, the share
/// on the reader's label once it is known.
///
/// It was Material's ring spinning slowly round, the share left unsaid.
/// Drawn over the page's ground, whatever colour the reader set it to: the
/// ring is the accent and the label carries its own scrim.
class ReaderPageLoading extends StatelessWidget {
  const ReaderPageLoading({super.key, required this.progress});

  /// From 0 to 1; 0 while the size is not known.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final known = progress > 0 && progress.isFinite;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: ShioriSpace.s12,
        children: [
          SizedBox.square(
            dimension: tokens.scaled(36),
            child: TweenAnimationBuilder<double>(
              duration: ShioriMotion.of(context, ShioriMotion.standard),
              curve: ShioriMotion.standardCurve,
              tween: Tween(end: known ? progress.clamp(0.0, 1.0) : 0),
              builder: (context, value, _) => CircularProgressIndicator(
                value: known ? value : null,
                strokeWidth: 3.5,
                strokeCap: StrokeCap.round,
                color: tokens.color.accent,
                backgroundColor: known ? ShioriScrim.underText : null,
              ),
            ),
          ),
          if (known) ShioriOverlayLabel('${(progress * 100).round()} %'),
        ],
      ),
    );
  }
}

/// A page that would not load: what happened and the way to try again, on a
/// card of its own so it reads on a white page as on a black one.
///
/// The message used to be white text at 70 %, lost on a white or grey
/// reader background.
class ReaderPageError extends StatelessWidget {
  const ReaderPageError({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ShioriSpace.s16),
        child: Material(
          color: tokens.color.ink1.withValues(alpha: Alphas.chrome),
          borderRadius: BorderRadius.circular(ShioriShape.card),
          child: Padding(
            padding: const EdgeInsets.all(ShioriSpace.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: ShioriSpace.s12,
              children: [
                Icon(
                  Symbols.broken_image_rounded,
                  size: tokens.scaled(32),
                  color: tokens.color.fgMuted,
                ),
                Text(
                  l10n.image_loading_error,
                  textAlign: TextAlign.center,
                  style: tokens.text.body.copyWith(color: tokens.color.fg),
                ),
                // The page's taps turn pages; the button keeps its own.
                ReaderInteractiveRegion(
                  child: ShioriButton(
                    icon: Symbols.refresh_rounded,
                    label: l10n.retry,
                    onPressed: onRetry,
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
