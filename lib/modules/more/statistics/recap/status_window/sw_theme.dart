// shiori-file: the Status Window is a fixed dark "system UI" palette and type scale from the recap design, independent of the app theme.
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:shiori/shiori.dart';

abstract final class SwColors {
  static const bgTop = Color(0xFF0B1A3A);
  static const bg = Color(0xFF05070D);
  static const text = Color(0xFFD7F3FF);
  static const muted = Color(0xFF7FA7C9);
  static const cyan = Color(0xFF5EE7FF);
  static const blue = Color(0xFF2F6FFF);
  static const titleGlow = Color(0xFF9EF0FF);
  static const gold = Color(0xFFFFD166);
  static const rose = Color(0xFFFF5F7A);
  static const violet = Color(0xFF7828FF);
  static const badgeText = Color(0xFFBCD3E6);
  static const bright = Colors.white;
  static const coverPlaceholder = Color(0xFF10223F);
  static const windowTop = Color(0xB80E2856);
  static const windowBottom = Color(0xD1061024);
  static const toastFill = Color(0x8C0A2850);
  static const track = Color(0x1F5EE7FF);
  static const hairline = Color(0x405EE7FF);
  static const border = Color(0x995EE7FF);
  static const glow = Color(0x592F6FFF);
}

abstract final class SwMotion {
  static const entrance = Duration(milliseconds: 520);
  static const stagger = Duration(milliseconds: 90);
  static const countUp = Duration(milliseconds: 1400);
}

abstract final class SwShape {
  static final window = BorderRadius.circular(4);
  static final toast = BorderRadius.circular(6);
  static const bracket = 14.0;
}

/// The Status Window's type scale, on Rajdhani when it's available.
class SwText {
  SwText(this.fonts);

  final RecapFonts fonts;

  TextStyle _base(double size, {bool bold = false, Color? color}) => TextStyle(
    fontFamily: bold ? fonts.displayBold : fonts.display,
    fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
    fontSize: size,
    color: color ?? SwColors.text,
    height: 1.25,
  );

  TextStyle get windowTitle =>
      _base(13, bold: true, color: SwColors.titleGlow).copyWith(
        letterSpacing: 4,
        shadows: const [Shadow(color: SwColors.cyan, blurRadius: 8)],
      );
  TextStyle get body => _base(14);
  TextStyle get bodyStrong => _base(14, bold: true, color: SwColors.bright);
  TextStyle get small => _base(11, color: SwColors.muted);
  TextStyle get label =>
      _base(11, color: SwColors.muted).copyWith(letterSpacing: 2);
  TextStyle get accent => _base(11, color: SwColors.cyan);
  TextStyle get stat => _base(
    24,
    bold: true,
    color: SwColors.bright,
  ).copyWith(height: 1.05, fontFeatures: const [FontFeature.tabularFigures()]);
  TextStyle get level =>
      _base(30, bold: true, color: SwColors.bright).copyWith(height: 1);
  TextStyle get bondTitle =>
      _base(20, bold: true, color: SwColors.bright).copyWith(height: 1.05);
  TextStyle get rank => _base(14, bold: true, color: SwColors.bright);
  TextStyle get gateTitle => _base(20, bold: true, color: SwColors.bright);
  TextStyle get badgeName => _base(14, bold: true, color: SwColors.gold);
  TextStyle get badgeDetail => _base(12, color: SwColors.badgeText);
}

/// A glowing system window with corner brackets and a spaced-out title.
class SwWindow extends StatelessWidget {
  const SwWindow({
    super.key,
    required this.title,
    required this.text,
    required this.child,
  });

  final String title;
  final SwText text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: const _BracketPainter(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: SwShape.window,
          border: Border.all(color: SwColors.border),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [SwColors.windowTop, SwColors.windowBottom],
          ),
          boxShadow: const [BoxShadow(color: SwColors.glow, blurRadius: 22)],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            ShioriSpace.s16,
            ShioriSpace.s12,
            ShioriSpace.s16,
            ShioriSpace.s16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, textAlign: TextAlign.center, style: text.windowTitle),
              const SizedBox(height: ShioriSpace.s12),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const b = SwShape.bracket;
    final paint = Paint()
      ..color = SwColors.cyan
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(-2, b - 2)
        ..lineTo(-2, -2)
        ..lineTo(b - 2, -2),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width + 2, size.height - b + 2)
        ..lineTo(size.width + 2, size.height + 2)
        ..lineTo(size.width - b + 2, size.height + 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_BracketPainter oldDelegate) => false;
}

/// A thin progress track with the cyan-blue fill.
class SwBar extends StatelessWidget {
  const SwBar({
    super.key,
    required this.value,
    this.height = 5,
    this.border = false,
  });

  final double value;
  final double height;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final fill = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: SwColors.track,
        border: border ? Border.all(color: SwColors.border) : null,
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: fill,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [SwColors.blue, SwColors.cyan]),
            boxShadow: [BoxShadow(color: SwColors.cyan, blurRadius: 8)],
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}

/// Counts up from zero to [value] once, then shows it formatted.
class SwCountUp extends StatelessWidget {
  const SwCountUp({
    super.key,
    required this.value,
    required this.format,
    required this.style,
  });

  final int value;
  final String Function(int) format;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: SwMotion.countUp,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => Text(format(v.round()), style: style),
    );
  }
}

/// [label] with an icon sized to its text. Icons instead of ★/▶ glyphs,
/// which the display fonts lack and iOS may draw as emoji.
Widget recapIconText(
  String label,
  IconData icon,
  TextStyle style, {
  bool trailing = false,
}) {
  final glyph = WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: Icon(icon, size: style.fontSize, color: style.color, fill: 1),
  );
  const gap = TextSpan(text: ' ');
  return Text.rich(
    TextSpan(
      children: trailing
          ? [TextSpan(text: label), gap, glyph]
          : [glyph, gap, TextSpan(text: label)],
    ),
    style: style,
  );
}
