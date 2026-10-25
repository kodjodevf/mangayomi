// shiori-file: The Strip is a fixed print-comic palette and type scale from the recap design (ink, paper, halftone), independent of the app theme.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/statistics/recap/recap_fonts.dart';
import 'package:shiori/shiori.dart';

abstract final class StripColors {
  static const bg = Color(0xFF0D0D0F);
  static const nav = Color(0xFFBBBBBB);
  static const ink = Colors.black;
  static const paper = Colors.white;
  static const caption = Color(0xFFFFFBE6);
  static const yellow = Color(0xFFFFE14D);
  static const red = Color(0xFFFF3B5C);
  static const blue = Color(0xFF3B6BFF);
  static const sky = Color(0xFFBFE6FF);
  static const pink = Color(0xFFFFD0DC);
  static const mint = Color(0xFFC8F5D2);
  static const dawnTop = Color(0xFFFFB36B);
  static const dawnMid = Color(0xFFFF6F91);
  static const dawnBottom = Color(0xFF4B3B8F);
  static const sun = Color(0xFFFFF3C4);
  static const dot = Color(0x2E000000);
  static const shade = Color(0xE6000000);
  static const veil = Color(0x1A000000);
  static const clear = Color(0x00000000);
  static const coverPlaceholder = Color(0xFF26262B);
}

abstract final class StripShape {
  static const panelBorder = 3.0;
  static const captionBorder = 2.0;
  static const shadow = Offset(3, 3);
  static const tileRadius = BorderRadius.all(Radius.circular(2));
}

/// The Strip's type scale: Bangers for sound effects, Anton for numerals.
class StripText {
  StripText(this.fonts);

  final RecapFonts fonts;

  TextStyle sfx(double size, {Color color = StripColors.paper}) => TextStyle(
    fontFamily: fonts.comic,
    fontWeight: FontWeight.w700,
    fontSize: size,
    height: 0.95,
    letterSpacing: size * 0.02,
    color: color,
  );

  TextStyle numeral(double size, {Color color = StripColors.paper}) =>
      TextStyle(
        fontFamily: fonts.numerals,
        fontWeight: FontWeight.w900,
        fontSize: size,
        height: 1,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  TextStyle get label => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 3,
    color: StripColors.ink,
  );
  TextStyle get caption => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: StripColors.ink,
  );
  TextStyle get body => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: StripColors.ink,
  );
  TextStyle get heavy => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w900,
    color: StripColors.ink,
  );
  TextStyle get button => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 1,
    color: StripColors.paper,
  );
  TextStyle get nav => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: StripColors.paper,
  );
  TextStyle get tileTitle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: StripColors.paper,
  );
  TextStyle get tileBody =>
      const TextStyle(fontSize: 13, height: 1.35, color: StripColors.nav);
}

/// One comic panel: ink border, gutter below, contents clipped.
class StripPanel extends StatelessWidget {
  const StripPanel({
    super.key,
    required this.height,
    required this.child,
    this.color = StripColors.paper,
    this.gradient,
    this.halftone = false,
  });

  final double? height;
  final Widget child;
  final Color color;
  final Gradient? gradient;
  final bool halftone;

  @override
  Widget build(BuildContext context) {
    Widget body = child;
    if (halftone) {
      body = CustomPaint(painter: const HalftonePainter(), child: body);
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        border: Border.all(width: StripShape.panelBorder),
      ),
      clipBehavior: Clip.hardEdge,
      child: body,
    );
  }
}

/// A yellowed caption box with a hard drop shadow.
class StripCaption extends StatelessWidget {
  const StripCaption(this.text, {super.key, required this.style});

  final String text;
  final StripText style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ShioriSpace.s8,
        vertical: ShioriSpace.s4,
      ),
      decoration: BoxDecoration(
        color: StripColors.caption,
        border: Border.all(width: StripShape.captionBorder),
        boxShadow: const [
          BoxShadow(color: StripColors.ink, offset: StripShape.shadow),
        ],
      ),
      child: Text(text, style: style.caption),
    );
  }
}

/// Outlined comic lettering: an ink stroke under the fill.
class StripSfx extends StatelessWidget {
  const StripSfx(
    this.text, {
    super.key,
    required this.style,
    this.stroke = 2,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle style;
  final double stroke;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final fill = Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
    if (stroke <= 0) return fill;
    // Resolve the outline's style the way [Text] resolves the fill's, or
    // inherited letter spacing and leading pull the two apart.
    final inherited = DefaultTextStyle.of(context);
    return CustomPaint(
      painter: SfxStrokePainter(
        text: text,
        style: inherited.style.merge(style),
        stroke: stroke,
        textAlign: textAlign ?? TextAlign.start,
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        maxLines: maxLines,
        textHeightBehavior: inherited.textHeightBehavior,
      ),
      child: fill,
    );
  }
}

/// Paints [text] as an ink outline in the exact box its fill [Text] got.
class SfxStrokePainter extends CustomPainter {
  const SfxStrokePainter({
    required this.text,
    required this.style,
    required this.stroke,
    required this.textAlign,
    required this.textDirection,
    required this.textScaler,
    required this.maxLines,
    required this.textHeightBehavior,
  });

  final String text;
  final TextStyle style;
  final double stroke;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextScaler textScaler;
  final int? maxLines;
  final TextHeightBehavior? textHeightBehavior;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke * 2
            ..strokeJoin = StrokeJoin.round
            ..color = StripColors.ink,
        ),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: maxLines,
      textHeightBehavior: textHeightBehavior,
      ellipsis: maxLines == null ? null : '…',
    )..layout(minWidth: size.width, maxWidth: size.width);
    painter.paint(canvas, Offset.zero);
    painter.dispose();
  }

  @override
  bool shouldRepaint(SfxStrokePainter old) =>
      old.text != text ||
      old.style != style ||
      old.stroke != stroke ||
      old.textAlign != textAlign ||
      old.textHeightBehavior != textHeightBehavior ||
      old.textScaler != textScaler;
}

/// Print halftone: a grid of small ink dots.
class HalftonePainter extends CustomPainter {
  const HalftonePainter();

  static const _step = 7.0;
  static const _radius = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = StripColors.dot;
    for (var y = _step / 2; y < size.height; y += _step) {
      for (var x = _step / 2; x < size.width; x += _step) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(HalftonePainter oldDelegate) => false;
}

/// Manga speed lines radiating from the centre.
class SpeedLinesPainter extends CustomPainter {
  const SpeedLinesPainter();

  static const _rays = 72;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final reach = size.longestSide;
    final paint = Paint()..color = StripColors.ink;
    const sweep = 2 * pi / _rays;
    for (var i = 0; i < _rays; i++) {
      final a = i * sweep;
      final b = a + sweep * 0.22;
      canvas.drawPath(
        Path()
          ..moveTo(centre.dx, centre.dy)
          ..lineTo(centre.dx + cos(a) * reach, centre.dy + sin(a) * reach)
          ..lineTo(centre.dx + cos(b) * reach, centre.dy + sin(b) * reach)
          ..close(),
        paint,
      );
    }
    // A clear centre so the number reads.
    canvas.drawCircle(
      centre,
      size.shortestSide * 0.36,
      Paint()
        ..shader =
            RadialGradient(
              colors: const [StripColors.paper, Color(0x00FFFFFF)],
              stops: const [0.7, 1],
            ).createShader(
              Rect.fromCircle(center: centre, radius: size.shortestSide * 0.36),
            ),
    );
  }

  @override
  bool shouldRepaint(SpeedLinesPainter oldDelegate) => false;
}
