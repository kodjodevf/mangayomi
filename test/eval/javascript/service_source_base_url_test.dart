import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/eval/javascript/service.dart';

void main() {
  test('uses the JavaScript extension runtime BaseUrl', () {
    expect(
      resolveJavaScriptSourceBaseUrl(
        'https://manifest.example',
        () => 'https://runtime.example',
      ),
      'https://runtime.example',
    );
  });

  test('falls back when getBaseUrl is not implemented', () {
    expect(
      resolveJavaScriptSourceBaseUrl(
        'https://manifest.example',
        () => throw StateError('getBaseUrl is not implemented'),
      ),
      'https://manifest.example',
    );
  });

  test('falls back when the runtime BaseUrl is blank', () {
    expect(
      resolveJavaScriptSourceBaseUrl('https://manifest.example', () => '   '),
      'https://manifest.example',
    );
  });

  test('falls back when runtime BaseUrl resolution throws', () {
    expect(
      resolveJavaScriptSourceBaseUrl(
        'https://manifest.example',
        () => throw Exception('failed'),
      ),
      'https://manifest.example',
    );
  });
}
