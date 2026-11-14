// What makes the server start with the machine: a systemd unit, a launchd
// agent, or a scheduled task, filled in with where this server and its data
// are. Printed, not installed: installing one is the user's call.
import 'dart:io';

enum ServiceKind { systemd, launchd, windows }

ServiceKind get platformServiceKind => Platform.isMacOS
    ? ServiceKind.launchd
    : Platform.isWindows
    ? ServiceKind.windows
    : ServiceKind.systemd;

const launchdLabel = 'com.mangayomi.sync-server';

/// The file for [kind], running [executable] with its data in [dataDir] and
/// [serveArgs] passed to `serve`. [user] runs it under systemd.
String serviceFile(
  ServiceKind kind, {
  required String executable,
  required String dataDir,
  required List<String> serveArgs,
  required String user,
}) {
  final command = [executable, '--data-dir', dataDir, 'serve', ...serveArgs];
  return switch (kind) {
    ServiceKind.systemd =>
      '''
[Unit]
Description=Mangayomi sync server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$user
ExecStart=${command.map(_systemdQuote).join(' ')}
Restart=on-failure
RestartSec=5
NoNewPrivileges=yes
PrivateTmp=yes
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=${_systemdQuote(dataDir)}

[Install]
WantedBy=multi-user.target
''',
    ServiceKind.launchd =>
      '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$launchdLabel</string>
  <key>ProgramArguments</key>
  <array>
${command.map((arg) => '    <string>${_xml(arg)}</string>').join('\n')}
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <dict>
    <key>SuccessfulExit</key>
    <false/>
  </dict>
  <key>StandardErrorPath</key>
  <string>${_xml('$dataDir/server.log')}</string>
</dict>
</plist>
''',
    ServiceKind.windows =>
      'schtasks /Create /F /SC ONLOGON /RL LIMITED '
          '/TN "Mangayomi sync server" '
          '/TR "${command.map(_windowsQuote).join(' ').replaceAll('"', r'\"')}"\n',
  };
}

String _systemdQuote(String arg) => RegExp(r'^[\w./:@=+-]+$').hasMatch(arg)
    ? arg
    : '"${arg.replaceAll(r'\', r'\\').replaceAll('"', r'\"')}"';

String _windowsQuote(String arg) =>
    arg.contains(' ') || arg.isEmpty ? '"$arg"' : arg;

String _xml(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');
