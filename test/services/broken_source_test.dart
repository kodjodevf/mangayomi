import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/get_filter_list.dart';
import 'package:mangayomi/services/get_source_preference.dart';
import 'package:mangayomi/services/supports_latest.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A source whose code will not run: empty, as when half installed.
  Source broken() => Source(
    id: 4242,
    name: 'Broken',
    lang: 'en',
    baseUrl: 'https://broken.test',
    sourceCode: '',
  );

  test('a source whose code will not run has no filters or settings', () {
    expect(getFilterList(source: broken()), isEmpty);
    expect(getSourcePreference(source: broken()), isEmpty);
  });

  test('nor Latest, rather than an error where its tabs go', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(supportsLatestProvider(source: broken())), isFalse);
  });
}
