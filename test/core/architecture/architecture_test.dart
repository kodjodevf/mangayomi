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
  final importPattern = RegExp(
    r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
    multiLine: true,
  );

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

    test('Layer 1B (lib/utils & lib/core) never imports lib/modules/, lib/router/router.dart, or lib/main.dart', () {
      final utilsViolations = _findImportViolations('lib/utils', const [
        'package:mangayomi/modules/',
        'package:mangayomi/router/router.dart',
        'package:mangayomi/main.dart',
      ]);
      final coreViolations = _findImportViolations('lib/core', const [
        'package:mangayomi/modules/',
        'package:mangayomi/router/router.dart',
        'package:mangayomi/main.dart',
      ]);
      expect(
        [...utilsViolations, ...coreViolations],
        isEmpty,
        reason:
            'lib/utils/ and lib/core/ must never import feature UI modules (lib/modules/), router.dart, or lib/main.dart:\n'
            '${[...utilsViolations, ...coreViolations].join('\n')}',
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
      final serviceImportViolations = _findImportViolations(
        'lib/services',
        const ['package:mangayomi/modules/', 'package:mangayomi/main.dart'],
      );
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

    test(
      'Layer 3 (lib/providers) never imports lib/modules/ or lib/main.dart',
      () {
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
      },
    );

    test('Layer 4 (lib/modules & lib/router) never imports lib/main.dart or direct Isar singleton (lib/repositories/db.dart)', () {
      final moduleViolations = _findImportViolations('lib/modules', const [
        'package:mangayomi/main.dart',
        'package:mangayomi/repositories/db.dart',
      ]);
      final routerViolations = _findImportViolations('lib/router', const [
        'package:mangayomi/main.dart',
        'package:mangayomi/repositories/db.dart',
      ]);
      expect(
        [...moduleViolations, ...routerViolations],
        isEmpty,
        reason:
            'Feature modules and router must never import main.dart or access Isar directly via db.dart (use repositories instead):\n'
            '${[...moduleViolations, ...routerViolations].join('\n')}',
      );
    });

    test('Direct Isar singleton (lib/repositories/db.dart) is strictly confined to lib/repositories/ and bootstrap', () {
      final violations = [
        ..._findImportViolations('lib/models', const [
          'package:mangayomi/repositories/db.dart',
        ]),
        ..._findImportViolations('lib/utils', const [
          'package:mangayomi/repositories/db.dart',
        ]),
        ..._findImportViolations('lib/core', const [
          'package:mangayomi/repositories/db.dart',
        ]),
        ..._findImportViolations('lib/providers', const [
          'package:mangayomi/repositories/db.dart',
        ]),
        ..._findImportViolations('lib/eval', const [
          'package:mangayomi/repositories/db.dart',
        ]),
        ..._findImportViolations('lib/services', const [
          'package:mangayomi/repositories/db.dart',
        ]).where((v) => !v.startsWith('lib/services/isolate_service.dart ->')),
      ];
      expect(
        violations,
        isEmpty,
        reason:
            'Only lib/repositories/ (plus main.dart and isolate_service.dart bootstrap) may import lib/repositories/db.dart:\n'
            '${violations.join('\n')}',
      );
    });

    test(
      'Shared UI kit (lib/modules/widgets) never imports feature modules',
      () {
        final featureDirs = Directory('lib/modules')
            .listSync()
            .whereType<Directory>()
            .map((d) => p.basename(d.path))
            .where((name) => name != 'widgets')
            .map((name) => 'package:mangayomi/modules/$name/')
            .toList();
        final violations = _findImportViolations(
          'lib/modules/widgets',
          featureDirs,
        );
        expect(
          violations,
          isEmpty,
          reason:
              'lib/modules/widgets/ is the shared, feature-agnostic UI kit. Move feature-specific widgets into their owning module:\n'
              '${violations.join('\n')}',
        );
      },
    );

    test('Shared reader infrastructure (lib/modules/reader_common) never imports a concrete reader', () {
      final violations = _findImportViolations(
        'lib/modules/reader_common',
        const [
          'package:mangayomi/modules/manga/',
          'package:mangayomi/modules/novel/',
          'package:mangayomi/modules/anime/',
        ],
      );
      expect(
        violations,
        isEmpty,
        reason:
            'lib/modules/reader_common/ is shared by the manga, novel and anime readers and must not depend on any of them:\n'
            '${violations.join('\n')}',
      );
    });

    test('Sibling media modules (manga, anime, novel) are 100% isolated and never import each other', () {
      final violations = [
        ..._findImportViolations('lib/modules/manga', const [
          'package:mangayomi/modules/anime/',
          'package:mangayomi/modules/novel/',
        ]),
        ..._findImportViolations('lib/modules/anime', const [
          'package:mangayomi/modules/manga/',
          'package:mangayomi/modules/novel/',
          'package:mangayomi/modules/library/',
        ]),
        ..._findImportViolations('lib/modules/novel', const [
          'package:mangayomi/modules/manga/',
          'package:mangayomi/modules/anime/',
        ]),
      ];
      expect(
        violations,
        isEmpty,
        reason:
            'Media features (manga, anime, novel) must remain strictly decoupled. Shared code belongs in lib/modules/reader_common/, lib/modules/widgets/, or lib/services/:\n'
            '${violations.join('\n')}',
      );
    });

    test('Phase 3: Reader and Player entry views remain decomposed (< 1400 lines) and no module file exceeds 1400 lines', () {
      const maxLines = 1400;
      final oversizedFiles = <String>[];
      for (final file in _dartFilesIn('lib/modules')) {
        final lineCount = file.readAsLinesSync().length;
        if (lineCount > maxLines) {
          oversizedFiles.add(
            '${p.normalize(file.path)} ($lineCount lines > $maxLines)',
          );
        }
      }
      expect(
        oversizedFiles,
        isEmpty,
        reason:
            'No UI module file in lib/modules/ should exceed $maxLines lines. Extract sub-widgets or mixins:\n'
            '${oversizedFiles.join('\n')}',
      );
    });
  });
}
