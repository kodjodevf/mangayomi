import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mangayomi/services/http/m_client.dart';

void main() {
  group('default extension user agent', () {
    test('is added even when the site has no saved cookie', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/popular'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: 'Mangayomi browser',
        useDefaultUserAgent: true,
      );

      expect(request.headers[HttpHeaders.userAgentHeader], 'Mangayomi browser');
    });

    test('repairs a user agent previously saved with JSON quotes', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/popular'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: '"Mozilla/5.0 (X11; Linux x86_64)"',
        useDefaultUserAgent: true,
      );

      expect(
        request.headers[HttpHeaders.userAgentHeader],
        'Mozilla/5.0 (X11; Linux x86_64)',
      );
    });

    test('preserves a source-specific user agent', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/video'),
      )..headers['User-Agent'] = 'Source-specific browser';

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: 'Mangayomi browser',
        useDefaultUserAgent: true,
      );

      expect(request.headers['User-Agent'], 'Source-specific browser');
      expect(request.headers, hasLength(1));
    });

    test('does not add an empty configured value', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/popular'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: '  ',
        useDefaultUserAgent: true,
      );

      expect(request.headers, isEmpty);
    });

    test('does not affect non-source traffic without a matching cookie', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://api.example/account'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: 'Mangayomi browser',
        useDefaultUserAgent: false,
      );

      expect(request.headers, isEmpty);
    });

    test('keeps cookie and matching user agent together', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/popular'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {HttpHeaders.cookieHeader: 'clearance=token'},
        userAgent: 'Matching browser',
        useDefaultUserAgent: false,
      );

      expect(request.headers[HttpHeaders.cookieHeader], 'clearance=token');
      expect(request.headers[HttpHeaders.userAgentHeader], 'Matching browser');
    });

    test('treats a quoted whitespace value as empty', () {
      final request = http.Request(
        'GET',
        Uri.parse('https://source.example/popular'),
      );

      applyStoredRequestHeaders(
        request,
        cookieHeaders: const {},
        userAgent: '"   "',
        useDefaultUserAgent: true,
      );

      expect(request.headers, isEmpty);
    });
  });
}
