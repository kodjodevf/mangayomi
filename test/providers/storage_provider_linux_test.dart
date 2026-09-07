import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/providers/storage_provider.dart';

void main() {
  test('Linux documents fallback preserves the home directory location', () {
    expect(
      linuxDocumentsFallbackPath({'HOME': '/home/reader'}),
      '/home/reader',
    );
    expect(linuxDocumentsFallbackPath({'HOME': '  '}), isNull);
    expect(linuxDocumentsFallbackPath(const {}), isNull);
  });
}
