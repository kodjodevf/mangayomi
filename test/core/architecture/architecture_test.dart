import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

List<File> _dartFilesIn(String relativeDir) {
  final dir = Directory(relativeDir);
  if (!dir.existsSync()) return const [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}

List<String> _findImportViolations(
  String directory,
  List<String> forbiddenPrefixes,
) {
  final violations = <String>[];
  final importPattern = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''', multiLine: true);

  for (final file in _dartFilesIn(directory)) {
    final content = file.readAsStringSync();
    for (final match in importPattern.allMatches(content)) {
      final uri = match.group(1)!;
      for (final prefix in forbiddenPrefixes) {
        if (uri.startsWith(prefix)) {
          violations.add('${p.normalize(file.path)} -> $uri');
        }
      }
    }
  }
  return violations;
}

List<String> _findSymbolViolations(String directory, RegExp symbolPattern) {
  final violations = <String>[];
  for (final file in _dartFilesIn(directory)) {
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.startsWith('//')) continue;
      if (symbolPattern.hasMatch(line)) {
        violations.add('${p.normalize(file.path)}:${i + 1}: $line');
      }
    }
  }
  return violations;
}

void main() {
  group('Mangayomi Architecture Guard-Rails (docs/architecture/ARCHITECTURE.md)', () {
    test('Architecture reference document exists', () {
      final doc = File('docs/architecture/ARCHITECTURE.md');
      expect(
        doc.existsSync(),
        isTrue,
        reason: 'docs/architecture/ARCHITECTURE.md must exist as the single source of truth.',
      );
      expect(doc.readAsStringSync().trim(), isNotEmpty);
    });

    test('Layer 1 (lib/models) never imports higher layers or main.dart', () {
      final violations = _findImportViolations('lib/models', const [
        'package:mangayomi/modules/',
        'package:mangayomi/services/',
        'package:mangayomi/providers/',
        'package:mangayomi/main.dart',
      ]);
      expect(
        violations,
        isEmpty,
        reason:
            'lib/models/ must remain pure data structures without importing modules, services, providers, or main.dart:\n'
            '${violations.join('\n')}',
      );
    });

    test('Layer 2A (lib/repositories) is 100% decoupled from UI, Riverpod, Services, and main.dart', () {
      final importViolations = _findImportViolations('lib/repositories', const [
        'package:mangayomi/modules/',
        'package:mangayomi/services/',
        'package:mangayomi/providers/',
        'package:mangayomi/main.dart',
        'package:flutter_riverpod/',
      ]);
      expect(
        importViolations,
        isEmpty,
        reason:
            'lib/repositories/ must never import modules, services, providers, main.dart, or flutter_riverpod:\n'
            '${importViolations.join('\n')}',
      );

      final symbolViolations = _findSymbolViolations(
        'lib/repositories',
        RegExp(r'\b(WidgetRef|BuildContext)\b'),
      );
      expect(
        symbolViolations,
        isEmpty,
        reason:
            'lib/repositories/ must never accept WidgetRef or BuildContext:\n'
            '${symbolViolations.join('\n')}',
      );
    });

    test('Layer 2B (lib/services & lib/eval) never imports lib/modules/ or lib/main.dart and never uses WidgetRef', () {
      final serviceImportViolations = _findImportViolations('lib/services', const [
        'package:mangayomi/modules/',
        'package:mangayomi/main.dart',
      ]);
      final evalImportViolations = _findImportViolations('lib/eval', const [
        'package:mangayomi/modules/',
        'package:mangayomi/main.dart',
      ]);
      expect(
        [...serviceImportViolations, ...evalImportViolations],
        isEmpty,
        reason:
            'lib/services/ and lib/eval/ must never import feature UI modules (lib/modules/) or lib/main.dart:\n'
            '${[...serviceImportViolations, ...evalImportViolations].join('\n')}',
      );

      final widgetRefViolations = [
        ..._findSymbolViolations('lib/services', RegExp(r'\bWidgetRef\b')),
        ..._findSymbolViolations('lib/eval', RegExp(r'\bWidgetRef\b')),
      ];
      expect(
        widgetRefViolations,
        isEmpty,
        reason:
            'lib/services/ and lib/eval/ must never depend on WidgetRef:\n'
            '${widgetRefViolations.join('\n')}',
      );
    });

    test('Layer 3 (lib/providers) never imports lib/modules/ or lib/main.dart', () {
      final violations = _findImportViolations('lib/providers', const [
        'package:mangayomi/modules/',
        'package:mangayomi/main.dart',
      ]);
      expect(
        violations,
        isEmpty,
        reason:
            'Shared application providers (lib/providers/) must never import feature UI modules (lib/modules/) or lib/main.dart:\n'
            '${violations.join('\n')}',
      );
    });
  });
}
