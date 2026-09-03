import 'package:flutter_test/flutter_test.dart';
import 'package:mangayomi/models/settings.dart';

void main() {
  group('Repo deduplication logic', () {
    test('detects duplicates with case insensitivity and trailing slashes', () {
      final existingRepos = [
        Repo(
          name: 'Keiyoushi',
          jsonUrl: 'https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json',
        ),
        Repo(
          name: 'TestRepo',
          jsonUrl: 'https://example.com/repo/',
        ),
      ];

      bool isDuplicate(String inputUrl) {
        final clean = inputUrl.trim().toLowerCase();
        return existingRepos.any((r) {
          final rUrl = r.jsonUrl?.trim().toLowerCase();
          if (rUrl == null) return false;
          return rUrl == clean ||
              rUrl == '$clean/' ||
              '$rUrl/' == clean ||
              (clean.endsWith('/') && rUrl == clean.substring(0, clean.length - 1)) ||
              (rUrl.endsWith('/') && rUrl.substring(0, rUrl.length - 1) == clean);
        });
      }

      expect(
        isDuplicate('https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json'),
        isTrue,
      );
      expect(
        isDuplicate('HTTPS://RAW.GITHUBUSERCONTENT.COM/KEIYOUSHI/EXTENSIONS/REPO/INDEX.MIN.JSON'),
        isTrue,
      );
      expect(
        isDuplicate('https://example.com/repo'),
        isTrue,
      );
      expect(
        isDuplicate('https://example.com/repo/'),
        isTrue,
      );
      expect(
        isDuplicate('https://example.com/other-repo'),
        isFalse,
      );
    });

    test('deduplicates a list of Repos preserving first occurrence', () {
      final repos = [
        Repo(name: 'First', jsonUrl: 'https://example.com/repo1.json'),
        Repo(name: 'Duplicate', jsonUrl: 'https://example.com/repo1.json'),
        Repo(name: 'Case Variant', jsonUrl: 'HTTPS://EXAMPLE.COM/REPO1.JSON'),
        Repo(name: 'Second', jsonUrl: 'https://example.com/repo2.json'),
      ];

      final seen = <String>{};
      final result = <Repo>[];
      for (final repo in repos) {
        final key = repo.jsonUrl?.trim().toLowerCase();
        if (key != null && key.isNotEmpty) {
          if (seen.add(key)) {
            result.add(repo);
          }
        } else {
          result.add(repo);
        }
      }

      expect(result.length, 2);
      expect(result.first.name, 'First');
      expect(result.last.name, 'Second');
    });

    test('infers sensible repo name from URL when name is index.json or empty', () {
      String resolveDisplayName(String? name, String? url) {
        if (name != null && name.isNotEmpty && !name.endsWith('.json')) {
          return name;
        }
        if (url != null) {
          final cleaned = url.replaceAll(RegExp(r'/[^/]+\.json$'), '');
          final lastSegment = cleaned.split('/').where((s) => s.isNotEmpty).lastOrNull;
          return lastSegment ?? url;
        }
        return 'Invalid source - remove it';
      }

      expect(
        resolveDisplayName('Mangayomi extensions (m2k3a)', 'https://m2k3a.github.io/mangayomi-extensions/index.json'),
        'Mangayomi extensions (m2k3a)',
      );
      expect(
        resolveDisplayName('index.json', 'https://m2k3a.github.io/mangayomi-extensions/index.json'),
        'mangayomi-extensions',
      );
      expect(
        resolveDisplayName(null, 'https://m2k3a.github.io/mangayomi-extensions/index.json'),
        'mangayomi-extensions',
      );
    });
  });
}
