// An invite as a QR code: in the terminal for `pair`, as SVG for the admin
// page. Dark on light whatever the terminal's colours, or many phones would
// not read it.
import 'package:qr/qr.dart';

QrImage _image(String data) => QrImage(
  QrCode(
    payload: QrPayload.fromString(data),
    errorCorrectLevel: QrErrorCorrectLevel.medium,
  ),
);

/// Two modules per character cell, each cell's halves coloured with ANSI.
String qrForTerminal(String data, {int quietZone = 2}) {
  final image = _image(data);
  final size = image.moduleCount;
  bool dark(int row, int col) =>
      row >= 0 &&
      col >= 0 &&
      row < size &&
      col < size &&
      image.isDark(row, col);

  const black = 30, white = 37;
  final out = StringBuffer();
  for (var row = -quietZone; row < size + quietZone; row += 2) {
    for (var col = -quietZone; col < size + quietZone; col++) {
      final top = dark(row, col) ? black : white;
      final bottom = dark(row + 1, col) ? black : white;
      // ▀ draws the top half in the foreground, the bottom in the background.
      out.write('\x1b[$top;${bottom + 10}m▀');
    }
    out.writeln('\x1b[0m');
  }
  return out.toString();
}

/// One path of unit squares, scaled by the viewBox.
String qrForSvg(String data, {int quietZone = 4}) {
  final image = _image(data);
  final size = image.moduleCount;
  final path = StringBuffer();
  for (var row = 0; row < size; row++) {
    for (var col = 0; col < size; col++) {
      if (image.isDark(row, col)) {
        path.write('M${col + quietZone} ${row + quietZone}h1v1h-1z');
      }
    }
  }
  final total = size + quietZone * 2;
  return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $total $total" '
      'shape-rendering="crispEdges"><rect width="$total" height="$total" '
      'fill="#fff"/><path d="$path" fill="#000"/></svg>';
}
