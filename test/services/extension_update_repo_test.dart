import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/services/fetch_sources_list.dart';

Source _installed(String version) => Source()
  ..id = 1
  ..isAdded = true
  ..sourceCode = 'class DefaultExtension {}'
  ..version = version;

Source _offered(String version) => Source()
  ..id = 1
  ..version = version
  ..sourceCodeUrl = 'https://example.com/source.js';

void main() {
  final upstream = Repo(jsonUrl: 'https://upstream.example/index.json');
  final fork = Repo(jsonUrl: 'https://fork.example/index.json');
  final other = Repo(jsonUrl: 'https://other.example/index.json');

  group('reposInUpdateOrder', () {
    test('asks the repository the source came from first, then the rest', () {
      final order = reposInUpdateOrder([upstream, fork, other], fork);
      expect(order.map((r) => r.jsonUrl), [
        fork.jsonUrl,
        upstream.jsonUrl,
        other.jsonUrl,
      ]);
    });

    test('keeps every repository when the source has no known origin', () {
      expect(reposInUpdateOrder([upstream, fork], null), [upstream, fork]);
    });

    test('still asks every repository when the origin was removed', () {
      final gone = Repo(jsonUrl: 'https://gone.example/index.json');
      expect(reposInUpdateOrder([upstream, fork], gone), [upstream, fork]);
    });
  });

  group('isInstallCandidate', () {
    test('an installed source only takes a newer version', () {
      final installed = _installed('0.2.14');
      expect(isInstallCandidate(installed, _offered('0.2.15')), isTrue);
      // The repository it came from offering the same build must not end the
      // search: a newer build elsewhere would never be installed.
      expect(isInstallCandidate(installed, _offered('0.2.14')), isFalse);
      expect(isInstallCandidate(installed, _offered('0.2.13')), isFalse);
    });

    test('a source that is not installed takes any version', () {
      expect(isInstallCandidate(null, _offered('0.0.1')), isTrue);
      final listedOnly = Source()
        ..id = 1
        ..isAdded = false
        ..version = '0.2.14';
      expect(isInstallCandidate(listedOnly, _offered('0.2.14')), isTrue);
    });

    test('an installed row without code is reinstalled at any version', () {
      final noCode = _installed('0.2.14')..sourceCode = '';
      expect(isInstallCandidate(noCode, _offered('0.2.14')), isTrue);
    });
  });
}
