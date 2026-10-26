import 'package:flutter/material.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_mode_glyph.dart';

/// Material Symbols Rounded `crop`, struck through: cropping off.
///
/// The font has no `crop_off`, so it is drawn here, after custom Material
/// Symbols Rounded (Copyright (C) Google LLC, Apache-2.0): the slash is at
/// the font's stroke weight, joins the lower-left arms and is cut clear on
/// its upper-right side, as the font's own `*_off` glyphs are.
class CropOffGlyph extends StatelessWidget {
  const CropOffGlyph({super.key, this.size, this.color});

  /// Default to the icon theme's, as an [Icon] does, so a disabled button
  /// greys it too.
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final size = this.size ?? theme.size ?? 24;
    final color = this.color ?? theme.color ?? Colors.black;
    return Semantics(
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(painter: _CropOffPainter(color)),
      ),
    );
  }
}

class _CropOffPainter extends CustomPainter {
  _CropOffPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / 960)
      ..translate(0, 960)
      // The slash overlaps the arms it joins: filled as the SVG is, nonzero.
      ..drawPath(parseSymbolPath(_cropOff), Paint()..color = color)
      ..restore();
  }

  @override
  bool shouldRepaint(_CropOffPainter old) => old.color != color;
}

const _cropOff =
    'M240 -920Q223 -920 211.5 -908.5Q200 -897 200 -880L200 -873.1L280 -793.1'
    'L280 -880Q280 -897 268.5 -908.5Q257 -920 240 -920Z'
    'M360 -760L360 -713.1L393.1 -680L680 -680L680 -393.1L713.1 -360L760 -360'
    'L760 -680Q760 -713 736.5 -736.5Q713 -760 680 -760Z'
    'M280 -623.4L623.4 -280L280 -280L280 -623.4Z'
    'M793.1 -280L873.1 -200L880 -200Q897 -200 908.5 -211.5Q920 -223 920 -240'
    'Q920 -257 908.5 -268.5Q897 -280 880 -280Z'
    'M120 -880C109.8 -880 99.5 -876.1 91.7 -868.3C76.1 -852.7 76.1 -827.3 91.7 -811.7'
    'L143.4 -760L80 -760Q63 -760 51.5 -748.5Q40 -737 40 -720Q40 -703 51.5 -691.5'
    'Q63 -680 80 -680L200 -680L200 -280Q200 -247 223.5 -223.5Q247 -200 280 -200'
    'L680 -200L680 -80Q680 -63 691.5 -51.5Q703 -40 720 -40Q737 -40 748.5 -51.5'
    'Q760 -63 760 -80L760 -143.4L811.7 -91.7C819.5 -83.9 829.8 -80 840 -80'
    'C850.2 -80 860.5 -83.9 868.3 -91.7C883.9 -107.3 883.9 -132.7 868.3 -148.3'
    'L148.3 -868.3C140.5 -876.1 130.2 -880 120 -880Z';
