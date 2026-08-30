import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/utils/extensions/string_extensions.dart';

void main() {
  group('StringExtensions.getUrlWithoutDomain (Issue #961)', () {
    test('extracts path and query from normal HTTP URL', () {
      expect(
        'https://example.com/manga/chapter-1?page=2#top'.getUrlWithoutDomain,
        '/manga/chapter-1?page=2#top',
      );
    });

    test('extracts path from relative URL', () {
      expect('/chapter-1'.getUrlWithoutDomain, '/chapter-1');
    });

    test('does not throw on invalid URI / JSON string payload', () {
      const jsonPayload =
          '{"showId":"srGrP23qJnjsHrRYD","translationType":["sub"],"episodeString":"20"}';
      expect(jsonPayload.getUrlWithoutDomain, jsonPayload);
    });

    test('does not throw on invalid characters or schemes', () {
      const invalid = ':::not-a-valid-uri:::';
      expect(invalid.getUrlWithoutDomain, invalid);
    });
  });

  group('CustomExtendedNetworkImageProvider.tryDecodeDataUri (Issue #953)', () {
    test('decodes valid base64 gif data URI', () {
      const uri =
          'data:image/gif;base64,R0lGODdhAQABAPAAAMPDwwAAACwAAAAAAQABAAACAkQBADs=';
      final bytes = CustomExtendedNetworkImageProvider.tryDecodeDataUri(uri);
      expect(bytes, isNotNull);
      expect(bytes!.isNotEmpty, isTrue);
      // Verify first bytes of GIF header "GIF87a" or "GIF89a"
      expect(utf8.decode(bytes.sublist(0, 3)), 'GIF');
    });

    test('decodes plain text data URI', () {
      const uri = 'data:text/plain;charset=utf-8,Hello%20World';
      final bytes = CustomExtendedNetworkImageProvider.tryDecodeDataUri(uri);
      expect(bytes, isNotNull);
      expect(utf8.decode(bytes!), 'Hello World');
    });

    test('returns null for non-data URIs', () {
      expect(
        CustomExtendedNetworkImageProvider.tryDecodeDataUri(
          'https://example.com/image.png',
        ),
        isNull,
      );
    });

    test('returns null for malformed data URI', () {
      expect(
        CustomExtendedNetworkImageProvider.tryDecodeDataUri(
          'data:invalid-format',
        ),
        isNull,
      );
    });
  });
}
