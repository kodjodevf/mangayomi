// Where the server keeps what it must not lose: its identity, which every
// paired device pinned, and the database. Only the user running the server
// may read either.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'native/api/host.dart';

class DataDir {
  DataDir(this.path);

  /// MANGAYOMI_SYNC_DATA, or the platform's place for an app's data.
  factory DataDir.platformDefault() {
    final env = Platform.environment;
    final explicit = env['MANGAYOMI_SYNC_DATA'];
    if (explicit != null && explicit.isNotEmpty) return DataDir(explicit);
    const name = 'mangayomi-sync-server';
    if (Platform.isWindows) {
      return DataDir(p.join(env['APPDATA'] ?? env['USERPROFILE']!, name));
    }
    final home = env['HOME'] ?? '.';
    if (Platform.isMacOS) {
      return DataDir(p.join(home, 'Library', 'Application Support', name));
    }
    final xdg = env['XDG_DATA_HOME'];
    return DataDir(
      p.join(
        xdg != null && xdg.isNotEmpty ? xdg : p.join(home, '.local', 'share'),
        name,
      ),
    );
  }

  final String path;

  String get databasePath => p.join(path, 'sync.db');
  String get identityPath => p.join(path, 'identity.json');
  String get adminPath => p.join(path, 'admin.json');

  void create() {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      restrict(path, directory: true);
    }
  }

  /// The server's identity, made on first start. Losing or replacing it
  /// means every device pairs again.
  Future<ServerIdentity> identity() async {
    final file = File(identityPath);
    if (file.existsSync()) {
      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      return loadIdentity(
        privateKeyPem: json['privateKeyPem'] as String,
        certificatePem: json['certificatePem'] as String,
      );
    }
    final identity = await generateIdentity();
    writePrivate(
      identityPath,
      const JsonEncoder.withIndent('  ').convert({
        'privateKeyPem': identity.privateKeyPem,
        'certificatePem': identity.certificatePem,
      }),
    );
    return identity;
  }
}

/// Writes [contents] to [path] so that only this user can read it, even
/// for the moment between creating and restricting the file.
void writePrivate(String path, String contents) {
  final temp = File('$path.tmp');
  temp.writeAsStringSync('');
  restrict(temp.path);
  temp.writeAsStringSync(contents, flush: true);
  temp.renameSync(path);
}

/// Owner-only permissions. On Windows, a user's app data is already theirs.
void restrict(String path, {bool directory = false}) {
  if (Platform.isWindows) return;
  final result = Process.runSync('chmod', [directory ? '700' : '600', path]);
  if (result.exitCode != 0) {
    throw FileSystemException('Could not restrict ${result.stderr}', path);
  }
}
