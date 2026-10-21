import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:shiori/shiori.dart';

/// The glyph of a reading mode: a page, and the way it turns.
///
/// Drawn after Mihon's reader icons (custom Material Symbols Rounded,
/// Copyright (C) Google LLC, Apache-2.0), changed for Shiori: the frame is a
/// page rather than a phone, so its side button is gone; the two horizontal
/// strips Mihon has no mode for are its long strip turned on its side; and,
/// as a Material Symbol does with `fill`, a picked mode fills its page with
/// a tint of its colour.
class ReaderModeGlyph extends StatelessWidget {
  const ReaderModeGlyph(
    this.mode, {
    super.key,
    this.size,
    this.color,
    this.filled = false,
  });

  final ReaderMode mode;

  /// Defaults to the icon theme's, as an [Icon] does.
  final double? size;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final size = this.size ?? theme.size ?? 24;
    final color = this.color ?? theme.color ?? Colors.black;
    return Semantics(
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _GlyphPainter(_paths[mode]!, color, filled),
        ),
      ),
    );
  }
}

/// The 960-unit Material Symbols grid, its y running from -960 to 0.
const _grid = 960.0;

/// The page inside the frame, tinted when the mode is picked.
const _page = Rect.fromLTRB(280, -840, 680, -120);

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.data, this.color, this.filled);

  final String data;
  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / _grid;
    canvas
      ..save()
      ..scale(scale)
      ..translate(0, _grid);
    if (filled) {
      canvas.drawRect(
        _page,
        Paint()..color = color.withValues(alpha: Alphas.accentTint),
      );
    }
    canvas.drawPath(
      _parse(data)..fillType = PathFillType.evenOdd,
      Paint()..color = color,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.data != data || old.color != color || old.filled != filled;
}

final _cache = <String, Path>{};

/// The absolute M, L, C, Q and Z commands these paths are written in.
Path _parse(String data) => Path.from(
  _cache.putIfAbsent(data, () {
    final path = Path();
    final tokens = RegExp(r'[MLCQZ]|-?\d+(?:\.\d+)?')
        .allMatches(data)
        .map((m) => m.group(0)!)
        .toList();
    var command = 'M';
    var i = 0;
    double next() => double.parse(tokens[i++]);
    while (i < tokens.length) {
      final token = tokens[i];
      if (RegExp(r'^[MLCQZ]$').hasMatch(token)) {
        command = token;
        i++;
        if (command == 'Z') path.close();
        continue;
      }
      switch (command) {
        case 'M':
          path.moveTo(next(), next());
          command = 'L';
        case 'L':
          path.lineTo(next(), next());
        case 'C':
          path.cubicTo(next(), next(), next(), next(), next(), next());
        case 'Q':
          path.quadraticBezierTo(next(), next(), next(), next());
        default:
          i++;
      }
    }
    return path;
  }),
);

const _paths = <ReaderMode, String>{
  ReaderMode.ltr: 'M600 -660C577.9 -660 560 -642.1 560 -620L560 -340C560 -317.9 577.9 -300 600 -300C622.1 -300 640 -317.9 640 -340L640 -620C640 -642.1 622.1 -660 600 -660ZM680 -840L680 -120L280 -120L280 -440L383 -440L348 -404Q337 -393 337 -376.5Q337 -360 349 -348Q360 -337 377 -337Q394 -337 405 -348L509 -452Q515 -458 517.5 -465Q520 -472 520 -480Q520 -488 517.5 -495Q515 -502 509 -508L405 -612Q394 -623 377.5 -623.5Q376.8 -623.5 376.2 -623.5Q360.5 -623.5 349 -612Q338 -601 337.5 -584.5Q337 -568 348 -556L383 -520L280 -520L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.rtl: 'M360 -660C337.9 -660 320 -642.1 320 -620L320 -340C320 -317.9 337.9 -300 360 -300C382.1 -300 400 -317.9 400 -340L400 -620C400 -642.1 382.1 -660 360 -660ZM680 -840L680 -520L577 -520L612 -556Q623 -568 622.5 -584.5Q622 -601 611 -612Q599.5 -623.5 583.8 -623.5Q583.2 -623.5 582.5 -623.5Q566 -623 555 -612L451 -508Q445 -502 442.5 -495Q440 -488 440 -480Q440 -472 442.5 -465Q445 -458 451 -452L555 -348Q566 -337 583 -337Q600 -337 611 -348Q623 -360 623 -376.5Q623 -393 612 -404L577 -440L680 -440L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.vertical: 'M480 -700Q463 -700 451.5 -688.5Q440 -677 440 -660L440 -534L404 -569Q393 -580 376.5 -580Q360 -580 348 -568Q337 -557 337 -540Q337 -523 348 -512L452 -408Q458 -402 465 -399.5Q472 -397 480 -397Q488 -397 495 -399.5Q502 -402 508 -408L612 -512Q623 -523 623.5 -539.5Q624 -556 612 -568Q601 -579 584.5 -579.5Q583.8 -579.5 583.1 -579.5Q567.5 -579.5 556 -569L520 -534L520 -660Q520 -677 508.5 -688.5Q497 -700 480 -700ZM360 -240C337.9 -240 320 -222.1 320 -200C320 -177.9 337.9 -160 360 -160L600 -160C622.1 -160 640 -177.9 640 -200C640 -222.1 622.1 -240 600 -240ZM680 -840L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.webtoon: 'M480 -800C457.9 -800 440 -782.1 440 -760L440 -316.6L440 -316.6L440 -316.6L440 -316.6L408.3 -348.3C400.5 -356.1 390.2 -360 380 -360C369.8 -360 359.5 -356.1 351.7 -348.3C336.1 -332.7 336.1 -307.3 351.7 -291.7L451.7 -191.7C451.7 -191.7 451.8 -191.7 451.8 -191.6L451.8 -191.6C455.6 -187.8 460 -185 464.7 -183L464.7 -183C469.4 -181.1 474.6 -180 480 -180C485.4 -180 490.6 -181.1 495.3 -183L495.3 -183C500 -185 504.4 -187.8 508.2 -191.6L508.2 -191.6C508.2 -191.7 508.3 -191.7 508.3 -191.7L608.3 -291.7C623.9 -307.3 623.9 -332.7 608.3 -348.3C600.5 -356.1 590.2 -360 580 -360C569.8 -360 559.5 -356.1 551.7 -348.3L520 -316.6L520 -760C520 -782.1 502.1 -800 480 -800ZM680 -840L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.verticalContinuous: 'M480 -800C457.9 -800 440 -782.1 440 -760L440 -600C440 -577.9 457.9 -560 480 -560C502.1 -560 520 -577.9 520 -600L520 -760C520 -782.1 502.1 -800 480 -800ZM480 -510C457.9 -510 440 -492.1 440 -470L440 -316.6L408.3 -348.3C400.5 -356.1 390.2 -360 380 -360C369.8 -360 359.5 -356.1 351.7 -348.3C336.1 -332.7 336.1 -307.3 351.7 -291.7L451.7 -191.7C451.7 -191.7 451.8 -191.7 451.8 -191.6L451.8 -191.6C455.6 -187.8 460 -185 464.7 -183L464.7 -183C469.4 -181.1 474.6 -180 480 -180C485.4 -180 490.6 -181.1 495.3 -183L495.3 -183C500 -185 504.4 -187.8 508.2 -191.6L508.2 -191.6C508.2 -191.7 508.3 -191.7 508.3 -191.7L608.3 -291.7C623.9 -307.3 623.9 -332.7 608.3 -348.3C600.5 -356.1 590.2 -360 580 -360C569.8 -360 559.5 -356.1 551.7 -348.3L520 -316.6L520 -470C520 -492.1 502.1 -510 480 -510ZM680 -840L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.horizontalContinuous: 'M320 -480C320 -457.9 337.9 -440 360 -440L503.4 -440L503.4 -440L503.4 -440L503.4 -440L471.7 -408.3C463.9 -400.5 460 -390.2 460 -380C460 -369.8 463.9 -359.5 471.7 -351.7C487.3 -336.1 512.7 -336.1 528.3 -351.7L628.3 -451.7C628.3 -451.7 628.3 -451.8 628.4 -451.8L628.4 -451.8C632.2 -455.6 635 -460 637 -464.7L637 -464.7C638.9 -469.4 640 -474.6 640 -480C640 -485.4 638.9 -490.6 637 -495.3L637 -495.3C635 -500 632.2 -504.4 628.4 -508.2L628.4 -508.2C628.3 -508.2 628.3 -508.3 628.3 -508.3L528.3 -608.3C512.7 -623.9 487.3 -623.9 471.7 -608.3C463.9 -600.5 460 -590.2 460 -580C460 -569.8 463.9 -559.5 471.7 -551.7L503.4 -520L360 -520C337.9 -520 320 -502.1 320 -480ZM680 -840L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
  ReaderMode.horizontalContinuousRTL: 'M640 -480C640 -457.9 622.1 -440 600 -440L456.6 -440L456.6 -440L456.6 -440L456.6 -440L488.3 -408.3C496.1 -400.5 500 -390.2 500 -380C500 -369.8 496.1 -359.5 488.3 -351.7C472.7 -336.1 447.3 -336.1 431.7 -351.7L331.7 -451.7C331.7 -451.7 331.7 -451.8 331.6 -451.8L331.6 -451.8C327.8 -455.6 325 -460 323 -464.7L323 -464.7C321.1 -469.4 320 -474.6 320 -480C320 -485.4 321.1 -490.6 323 -495.3L323 -495.3C325 -500 327.8 -504.4 331.6 -508.2L331.6 -508.2C331.7 -508.2 331.7 -508.3 331.7 -508.3L431.7 -608.3C447.3 -623.9 472.7 -623.9 488.3 -608.3C496.1 -600.5 500 -590.2 500 -580C500 -569.8 496.1 -559.5 488.3 -551.7L456.6 -520L600 -520C622.1 -520 640 -502.1 640 -480ZM680 -840L680 -120L280 -120L280 -840ZM280 -920Q247 -920 223.5 -896.5Q200 -873 200 -840L200 -120Q200 -87 223.5 -63.5Q247 -40 280 -40L680 -40Q713 -40 736.5 -63.5Q760 -87 760 -120L760 -840Q760 -873 736.5 -896.5Q713 -920 680 -920Z',
};
