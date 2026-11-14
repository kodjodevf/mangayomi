// The Rust side of the server, which takes the TLS connections. Looked for,
// in order: where MANGAYOMI_SYNC_NATIVE says, next to the executable (a
// packaged server), then in this package's cargo build (development).
import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated_io.dart';
import 'package:path/path.dart' as p;

import 'native/frb_generated.dart';

const _stem = 'mangayomi_sync_server_native';

String get nativeLibraryName => Platform.isWindows
    ? '$_stem.dll'
    : Platform.isMacOS
    ? 'lib$_stem.dylib'
    : 'lib$_stem.so';

/// Where the native library could be, best first.
List<String> nativeLibraryCandidates({String? packageRoot}) {
  final explicit = Platform.environment['MANGAYOMI_SYNC_NATIVE'];
  final root = packageRoot ?? _packageRoot();
  return [
    ?explicit,
    p.join(p.dirname(Platform.resolvedExecutable), nativeLibraryName),
    p.join(
      p.dirname(Platform.resolvedExecutable),
      '..',
      'lib',
      nativeLibraryName,
    ),
    if (root != null) ...[
      p.join(root, 'native', 'target', 'release', nativeLibraryName),
      p.join(root, 'native', 'target', 'debug', nativeLibraryName),
    ],
  ];
}

/// The server package's root when running from source: the directory with
/// this package's pubspec, above the script. Never for a compiled server,
/// which uses only the libraries it was packaged with.
String? _packageRoot() {
  if (!Platform.script.path.endsWith('.dart')) return null;
  var dir = p.dirname(p.fromUri(Platform.script));
  for (var i = 0; i < 4; i++) {
    final pubspec = File(p.join(dir, 'pubspec.yaml'));
    if (pubspec.existsSync() &&
        pubspec.readAsStringSync().contains('name: mangayomi_sync_server')) {
      return dir;
    }
    dir = p.dirname(dir);
  }
  return null;
}

var _loaded = false;

Future<void> loadNativeLibrary({String? packageRoot}) async {
  if (_loaded) return;
  final candidates = nativeLibraryCandidates(packageRoot: packageRoot);
  final path = candidates.firstWhere(
    (candidate) => File(candidate).existsSync(),
    orElse: () => throw StateError(
      'The native library ($nativeLibraryName) was not found. Looked in:\n'
      '${candidates.map((c) => '  $c').join('\n')}\n'
      'Build it with `cargo build --release` in server/native, or point '
      'MANGAYOMI_SYNC_NATIVE at it.',
    ),
  );
  await RustLib.init(externalLibrary: ExternalLibrary.open(path));
  _loaded = true;
}
