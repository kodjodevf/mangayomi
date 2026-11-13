import 'package:mangayomi_sync_server/src/qr_render.dart';
import 'package:test/test.dart';

void main() {
  const link =
      'mangayomi-sync://pair?u=https%3A%2F%2F10.0.0.2%3A53319&f=AB&c=X';

  test('the terminal code has a quiet zone and resets its colours', () {
    final lines = qrForTerminal(link).trimRight().split('\n');
    expect(lines, everyElement(endsWith('\x1b[0m')));
    // The first row is all quiet zone: light on light.
    expect(lines.first.replaceAll('\x1b[37;47m▀', ''), '\x1b[0m');
  });

  test('the SVG is square and dark on light', () {
    final svg = qrForSvg(link);
    final size = RegExp(r'viewBox="0 0 (\d+) (\d+)"').firstMatch(svg)!;
    expect(size[1], size[2]);
    expect(svg, contains('fill="#fff"'));
    expect(svg, contains('fill="#000"'));
  });
}
