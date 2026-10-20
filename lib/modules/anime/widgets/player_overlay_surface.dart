import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';

/// The ground of whatever floats over the video (a seek, the volume, the
/// speed held down, Skip intro): the reader's scrim with white on it, as
/// [ShioriOverlayLabel] and the scrub preview are drawn. A theme surface
/// turned white over the picture in the light theme.
class PlayerOverlaySurface extends StatelessWidget {
  const PlayerOverlaySurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(
      horizontal: ShioriSpace.s12,
      vertical: ShioriSpace.s4,
    ),
    this.radius = ShioriShape.pill,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ShioriScrim.underText,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: IconTheme.merge(
        data: const IconThemeData(color: Colors.white),
        child: DefaultTextStyle.merge(
          style: tokens.text.row.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// The video waiting on its stream: the readers' ring for a page on its way,
/// in the accent, rather than Material's own in white.
class PlayerBuffering extends StatelessWidget {
  const PlayerBuffering({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.shiori;
    return SizedBox.square(
      dimension: tokens.scaled(36),
      child: CircularProgressIndicator(
        strokeWidth: 3.5,
        strokeCap: StrokeCap.round,
        color: tokens.color.accent,
      ),
    );
  }
}
