import 'package:flutter/material.dart';

/// The lit top and bottom edges of the floating navigation bar.
///
/// A hairline stroke following the whole outline, caps included. A horizontal
/// band cannot reach the far left and right points of a stadium at all, since
/// those sit at mid height, which left the ends unlit. Stroking the path fixes
/// that and is thinner besides.
///
/// It is dimmest around the equator and brightest along the top, so the caps
/// keep some light without the stroke reading as a drawn border, and it varies
/// along its length the way glass catches light in patches.
class FloatingNavGlassEdge extends StatelessWidget {
  const FloatingNavGlassEdge({
    super.key,
    required this.color,
    required this.light,
    required this.radius,
  });

  final Color color;
  final bool light;
  final double radius;

  /// Hairline. Anything heavier stops reading as glass and starts reading as
  /// a border.
  static const glassStrokeWidth = 1.0;

  static const glassPatchStops = [0.0, 0.13, 0.27, 0.44, 0.58, 0.71, 0.86, 1.0];

  static const glassPatchAlphas = [
    1.0,
    0.42,
    0.92,
    0.34,
    0.86,
    0.38,
    0.98,
    0.50,
  ];

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          for (final a in glassPatchAlphas) Colors.white.withValues(alpha: a),
        ],
        stops: glassPatchStops,
      ).createShader(rect),
      child: CustomPaint(
        painter: FloatingNavGlassEdgePainter(
          color: color,
          light: light,
          radius: radius,
        ),
      ),
    );
  }
}

class FloatingNavGlassEdgePainter extends CustomPainter {
  const FloatingNavGlassEdgePainter({
    required this.color,
    required this.light,
    required this.radius,
  });

  final Color color;
  final bool light;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = FloatingNavGlassEdge.glassStrokeWidth
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: light ? 0.34 : 0.36),
          // Never zero: this is where the caps are, and they should keep a
          // trace of light rather than breaking the outline.
          color.withValues(alpha: light ? 0.08 : 0.07),
          color.withValues(alpha: light ? 0.20 : 0.18),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        // Inset by half the stroke so it lands inside the clip rather than
        // being shaved in half by it.
        rect.deflate(FloatingNavGlassEdge.glassStrokeWidth / 2),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(FloatingNavGlassEdgePainter old) =>
      old.color != color || old.light != light || old.radius != radius;
}
