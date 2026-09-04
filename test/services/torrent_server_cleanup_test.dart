import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/services/torrent_server.dart';

void main() {
  group('MTorrentServer.normalizeInfoHash', () {
    test('normalizes 40-character hex hash to lowercase', () {
      const hexUpper = '4C811CA573A16A00F742512F58900609B2DE4190';
      const hexLower = '4c811ca573a16a00f742512f58900609b2de4190';
      expect(MTorrentServer.normalizeInfoHash(hexUpper), hexLower);
      expect(MTorrentServer.normalizeInfoHash(hexLower), hexLower);
      expect(MTorrentServer.normalizeInfoHash('  $hexUpper  '), hexLower);
    });

    test('converts 32-character base32 hash to 40-character hex', () {
      const base32 = 'JSCBJJTTSFWQB52CKEXVRQAGBGZNYQMQ';
      final hex = MTorrentServer.normalizeInfoHash(base32);
      expect(hex.length, 40);
      expect(RegExp(r'^[0-9a-f]{40}$').hasMatch(hex), isTrue);
    });

    test('leaves non-standard strings untouched', () {
      expect(MTorrentServer.normalizeInfoHash(''), '');
      expect(MTorrentServer.normalizeInfoHash('short'), 'short');
    });
  });

  group('Torrent stream infohash extraction logic', () {
    test('extracts infohash query parameter from stream URL', () {
      final uri = Uri.parse(
        'http://127.0.0.1:5000/torrent/stream?infohash=4c811ca573a16a00f742512f58900609b2de4190&file=0',
      );
      final infoHash = uri.queryParameters['infohash'];
      expect(infoHash, '4c811ca573a16a00f742512f58900609b2de4190');
    });

    test('extracts infohash from magnet URI with urn:btih', () {
      const magnetUrl =
          'magnet:?xt=urn:btih:4c811ca573a16a00f742512f58900609b2de4190&dn=Test';
      final match =
          RegExp(r'urn:btih:([a-zA-Z0-9]+)', caseSensitive: false).firstMatch(magnetUrl);
      expect(match, isNotNull);
      final hash = MTorrentServer.normalizeInfoHash(match!.group(1)!);
      expect(hash, '4c811ca573a16a00f742512f58900609b2de4190');
    });
  });
}
