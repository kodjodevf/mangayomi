import 'package:mangayomi_sync_server/src/service_file.dart';
import 'package:test/test.dart';

void main() {
  String file(ServiceKind kind) => serviceFile(
    kind,
    executable: '/opt/mangayomi sync/bin/mangayomi-sync-server',
    dataDir: '/home/me/.local/share/mangayomi-sync-server',
    serveArgs: [
      '--advertise',
      'https://sync.example.com:53319',
      '--allow-public',
    ],
    user: 'me',
  );

  test('systemd quotes what has spaces and lets the server write its data', () {
    final unit = file(ServiceKind.systemd);
    expect(
      unit,
      contains(
        'ExecStart="/opt/mangayomi sync/bin/mangayomi-sync-server" '
        '--data-dir /home/me/.local/share/mangayomi-sync-server serve '
        '--advertise https://sync.example.com:53319 --allow-public',
      ),
    );
    expect(unit, contains('User=me'));
    expect(
      unit,
      contains('ReadWritePaths=/home/me/.local/share/mangayomi-sync-server'),
    );
  });

  test('launchd gets each argument as its own string', () {
    final plist = file(ServiceKind.launchd);
    expect(
      plist,
      contains(
        '<string>/opt/mangayomi sync/bin/mangayomi-sync-server</string>',
      ),
    );
    expect(plist, contains('<string>--allow-public</string>'));
    expect(plist, contains('<string>$launchdLabel</string>'));
  });

  test('XML special characters are escaped', () {
    final plist = serviceFile(
      ServiceKind.launchd,
      executable: '/a&b/<x>',
      dataDir: '/d',
      serveArgs: const [],
      user: 'me',
    );
    expect(plist, contains('<string>/a&amp;b/&lt;x&gt;</string>'));
  });

  test('Windows quotes the path inside the task command', () {
    final task = serviceFile(
      ServiceKind.windows,
      executable: r'C:\Program Files\mangayomi-sync-server.exe',
      dataDir: r'C:\Users\me\AppData\Roaming\mangayomi-sync-server',
      serveArgs: const [],
      user: 'me',
    );
    expect(
      task,
      contains(
        r'/TR "\"C:\Program Files\mangayomi-sync-server.exe\" --data-dir',
      ),
    );
  });
}
