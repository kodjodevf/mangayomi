// Builds the server for this machine and packs it into dist/: the
// executable, its native libraries, and the README, ready to unpack and run
// with nothing else installed.
//
//   dart run tool/package.dart
//
// Needs cargo for the native library. Builds for the machine it runs on
// only: the release workflow runs it once per platform.
import 'dart:convert';
import 'dart:ffi' show Abi;
import 'dart:io';

import 'package:mangayomi_sync_server/src/admin.dart' show serverVersion;
import 'package:path/path.dart' as p;

Future<void> main() async {
  final root = p.dirname(p.dirname(p.fromUri(Platform.script)));
  Directory.current = root;

  final os = Platform.operatingSystem;
  final arch = _arch();
  final name = 'mangayomi-sync-server-$serverVersion-$os-$arch';

  await _run('cargo', ['build', '--release'], workingDirectory: 'native');
  final out = p.join('build', 'package');
  if (Directory(out).existsSync()) Directory(out).deleteSync(recursive: true);
  await _run('dart', ['build', 'cli', '-o', out]);

  final bundle = p.join(out, 'bundle');
  final staged = Directory(p.join('dist', name));
  if (staged.existsSync()) staged.deleteSync(recursive: true);
  staged.parent.createSync(recursive: true);
  Directory(bundle).renameSync(staged.path);

  // The executable under the name the README and service files use.
  final exe = Platform.isWindows ? '.exe' : '';
  File(p.join(staged.path, 'bin', 'mangayomi_sync_server$exe'))
      .renameSync(p.join(staged.path, 'bin', 'mangayomi-sync-server$exe'));

  final native = switch (os) {
    'windows' => 'mangayomi_sync_server_native.dll',
    'macos' => 'libmangayomi_sync_server_native.dylib',
    _ => 'libmangayomi_sync_server_native.so',
  };
  File(p.join('native', 'target', 'release', native))
      .copySync(p.join(staged.path, 'lib', native));
  File('README.md').copySync(p.join(staged.path, 'README.md'));
  final license = File(p.join('..', 'LICENSE'));
  if (license.existsSync()) license.copySync(p.join(staged.path, 'LICENSE'));

  // Proof it runs from where it lands: serving loads both native
  // libraries, which --version would not.
  final data = Directory.systemTemp.createTempSync('mangayomi-sync-package-');
  final server = await Process.start(
    p.join(staged.path, 'bin', 'mangayomi-sync-server$exe'),
    ['--data-dir', data.path, 'serve', '--port', '0', '--no-admin'],
  );
  server.stdout.drain<void>();
  final listening = server.stderr
      .transform(const SystemEncoding().decoder)
      .transform(const LineSplitter())
      .any((line) => line.contains('Listening on'))
      .timeout(const Duration(seconds: 30), onTimeout: () => false);
  final ok = await listening;
  server.kill();
  await server.exitCode;
  data.deleteSync(recursive: true);
  if (!ok) {
    stderr.writeln('The packaged server did not start.');
    exit(1);
  }

  final archive = Platform.isWindows ? '$name.zip' : '$name.tar.gz';
  final archivePath = p.join('dist', archive);
  if (File(archivePath).existsSync()) File(archivePath).deleteSync();
  if (Platform.isWindows) {
    await _run('powershell', [
      '-NoProfile',
      '-Command',
      'Compress-Archive -Path "${staged.path}" -DestinationPath "$archivePath"',
    ]);
  } else {
    await _run('tar', ['-czf', archive, name], workingDirectory: 'dist');
  }
  stdout.writeln('Packed $archivePath');
}

/// x64, arm64...: the part after the OS in `macos_arm64`.
String _arch() => Abi.current().toString().split('_').last;

Future<void> _run(
  String executable,
  List<String> args, {
  String? workingDirectory,
}) async {
  stdout.writeln('> $executable ${args.join(' ')}');
  final process = await Process.start(
    executable,
    args,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
    runInShell: Platform.isWindows,
  );
  final code = await process.exitCode;
  if (code != 0) {
    stderr.writeln('$executable failed ($code)');
    exit(code);
  }
}
