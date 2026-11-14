// `mangayomi-sync-server`: serve, and the commands to look after a server,
// running or not.
import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:mangayomi_sync/mangayomi_sync.dart';

import 'admin.dart';
import 'admin_client.dart';
import 'data_dir.dart';
import 'database.dart';
import 'log.dart';
import 'native_library.dart';
import 'qr_render.dart';
import 'service_file.dart';
import 'sync_server.dart';

/// Runs the command in [args]; the process's exit code.
Future<int> runCli(List<String> args) async {
  final runner =
      CommandRunner<int>(
          'mangayomi-sync-server',
          'Keeps Mangayomi libraries in sync across devices.\n\n'
              'Start it with `serve`, then add each device with `pair`.',
        )
        ..argParser.addOption(
          'data-dir',
          help:
              'Where the server keeps its identity and database. '
              'Default: \$MANGAYOMI_SYNC_DATA or the platform data directory.',
        )
        ..argParser.addFlag(
          'version',
          negatable: false,
          help: 'Print the version.',
        )
        ..addCommand(_Serve())
        ..addCommand(_Pair())
        ..addCommand(_Devices())
        ..addCommand(_Forget())
        ..addCommand(_Status())
        ..addCommand(_Admin())
        ..addCommand(_Backup())
        ..addCommand(_Fingerprint())
        ..addCommand(_Service());
  try {
    final top = runner.argParser.parse(args);
    if (top.flag('version')) {
      stdout.writeln(serverVersion);
      return 0;
    }
    return await runner.run(args) ?? 0;
  } on UsageException catch (error) {
    stderr.writeln(error);
    return 64;
  } on CliError catch (error) {
    stderr.writeln('Error: ${error.message}');
    return 1;
  }
}

class CliError implements Exception {
  const CliError(this.message);
  final String message;
}

abstract class _Command extends Command<int> {
  DataDir get dataDir {
    final explicit = globalResults?.option('data-dir');
    return explicit != null ? DataDir(explicit) : DataDir.platformDefault();
  }

  /// The running server's admin API, or null when none is running.
  Future<AdminClient?> runningServer() async {
    final access = AdminAccess.read(dataDir);
    if (access == null) return null;
    final client = AdminClient(access);
    if (await client.reachable()) return client;
    client.close();
    return null;
  }

  Future<AdminClient> requireRunningServer() async =>
      await runningServer() ??
      (throw CliError(
        'No server is running with data in ${dataDir.path}. Start one with '
        '`mangayomi-sync-server serve`.',
      ));

  ServerDatabase openDatabase() {
    if (!File(dataDir.databasePath).existsSync()) {
      throw CliError(
        'No server data in ${dataDir.path}. Start the server once with '
        '`serve`, or pass --data-dir.',
      );
    }
    return ServerDatabase.open(dataDir.databasePath);
  }
}

class _Serve extends _Command {
  _Serve() {
    argParser
      ..addOption(
        'address',
        defaultsTo: '0.0.0.0',
        help: 'The address to listen on; 0.0.0.0 for every network.',
      )
      ..addOption(
        'port',
        defaultsTo: '${SyncServer.defaultPort}',
        help: 'The port devices connect to.',
      )
      ..addMultiOption(
        'advertise',
        valueHelp: 'https://host:port',
        help:
            'An address devices reach this server at from elsewhere (a '
            'domain, a public IP, a VPN), put first in pairing codes. '
            'Repeat for several.',
      )
      ..addFlag(
        'allow-public',
        help:
            'Let devices connect from public networks, not only local ones '
            'and VPNs. Needed when the server is reached over the internet.',
      )
      ..addOption(
        'admin-port',
        defaultsTo: '${AdminServer.defaultPort}',
        help: 'The admin page and API port, on 127.0.0.1 only.',
      )
      ..addFlag(
        'admin',
        defaultsTo: true,
        help: 'Serve the admin page and API.',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Log every sync.',
      );
  }

  @override
  String get name => 'serve';

  @override
  String get description => 'Run the server.';

  @override
  Future<int> run() async {
    final args = argResults!;
    final port = _port(args.option('port')!, 'port');
    final adminPort = _port(args.option('admin-port')!, 'admin-port');
    final advertise = [
      for (final address in args.multiOption('advertise')) _advertised(address),
    ];
    final log = Log(
      level: args.flag('verbose') ? LogLevel.fine : LogLevel.info,
    );

    final dir = dataDir..create();
    // One server per data directory: two would each think they own it.
    final lock = File('${dir.path}/server.lock').openSync(mode: FileMode.write);
    try {
      lock.lockSync(FileLock.exclusive);
    } on FileSystemException {
      throw CliError('Another server is already running with ${dir.path}.');
    }

    await loadNativeLibrary();
    final database = ServerDatabase.open(dir.databasePath);
    final SyncServer server;
    try {
      server = await SyncServer.start(
        database: database,
        identity: await dir.identity(),
        address: args.option('address')!,
        port: port,
        advertise: advertise,
        allowPublicNetworks: args.flag('allow-public'),
        log: log,
      );
    } catch (error) {
      database.close();
      throw CliError('Could not start: $error');
    }

    AdminServer? admin;
    if (args.flag('admin')) {
      try {
        admin = await AdminServer.start(
          server: server,
          database: database,
          port: adminPort,
          log: log,
        );
        admin.access.write(dir);
      } on SocketException catch (error) {
        log.error('No admin API: port $adminPort is taken ($error)');
      }
    }

    server.events.listen((event) {
      if (event is PairingRequested) {
        log.info(
          'Accept it with `pair` or on the admin page'
          '${admin == null ? '' : ' (${admin.access.base})'}.',
        );
      }
    });

    final done = Completer<void>();
    final signals =
        [
              ProcessSignal.sigint.watch(),
              if (!Platform.isWindows) ProcessSignal.sigterm.watch(),
            ]
            .map(
              (stream) => stream.listen((_) {
                if (!done.isCompleted) done.complete();
              }),
            )
            .toList();
    await done.future;

    log.info('Stopping');
    for (final signal in signals) {
      await signal.cancel();
    }
    await admin?.close();
    final adminFile = File(dir.adminPath);
    if (adminFile.existsSync()) adminFile.deleteSync();
    await server.stop();
    database.close();
    lock.closeSync();
    return 0;
  }

  static int _port(String value, String option) {
    final port = int.tryParse(value);
    if (port == null || port < 0 || port > 65535) {
      throw UsageException('--$option must be a port number.', '');
    }
    return port;
  }

  static String _advertised(String address) {
    final uri = Uri.tryParse(address);
    if (uri == null ||
        uri.scheme != 'https' ||
        uri.host.isEmpty ||
        !uri.hasPort ||
        (uri.path.isNotEmpty && uri.path != '/')) {
      throw UsageException(
        '--advertise takes https://host:port, such as '
            'https://sync.example.com:53319; got "$address".',
        '',
      );
    }
    return 'https://${uri.host}:${uri.port}';
  }
}

class _Pair extends _Command {
  _Pair() {
    argParser
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Let in the first device that sends the code, without asking.',
      )
      ..addOption('minutes', defaultsTo: '5', help: 'How long the code works.');
  }

  @override
  String get name => 'pair';

  @override
  String get description =>
      'Show a pairing code for a new device, and let it in.';

  @override
  Future<int> run() async {
    final client = await requireRunningServer();
    final minutes = int.tryParse(argResults!.option('minutes')!) ?? 5;
    final opened =
        await client.post('/pairing?minutes=$minutes') as Map<String, dynamic>;
    final link = opened['link'] as String;

    final interrupted = ProcessSignal.sigint.watch().listen((_) async {
      await client.delete('/pairing');
      stdout.writeln('\nPairing stopped.');
      exit(130);
    });
    try {
      if (stdout.hasTerminal) stdout.write(qrForTerminal(link));
      stdout
        ..writeln()
        ..writeln(
          'In Mangayomi: Settings → Sync → Sync between your devices, then '
          "Scan the host's QR code, or Paste a pairing link with this link:",
        )
        ..writeln(link)
        ..writeln()
        ..writeln('Code: ${opened['code']}')
        ..writeln('Addresses: ${(opened['addresses'] as List).join(', ')}')
        ..writeln()
        ..writeln('Waiting for a device… (Ctrl+C to stop)');
      return await _wait(client);
    } finally {
      await interrupted.cancel();
      client.close();
    }
  }

  Future<int> _wait(AdminClient client) async {
    final devicesBefore = {
      for (final device in await client.get('/devices') as List)
        device['fingerprint'],
    };
    final asked = <String>{};
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final status = await client.get('/status') as Map<String, dynamic>;
      for (final device in status['devices'] as List) {
        if (!devicesBefore.contains(device['fingerprint'])) {
          stdout.writeln('Paired "${device['name']}". It can sync now.');
          return 0;
        }
      }
      for (final request in status['pending'] as List) {
        final id = request['id'] as String;
        if (!asked.add(id)) continue;
        final accept = argResults!.flag('yes') || _ask(request as Map);
        await client.post('/pairing/$id/${accept ? 'accept' : 'refuse'}');
        if (!accept) stdout.writeln('Denied. Still waiting for a device…');
      }
      if (status['pairing'] == null && (status['pending'] as List).isEmpty) {
        stderr.writeln(
          'The pairing code expired or was used. Run `pair` again.',
        );
        return 1;
      }
    }
  }

  static bool _ask(Map request) {
    if (!stdin.hasTerminal) {
      throw const CliError(
        'A device asked to pair, and there is no terminal to ask you: run '
        '`pair --yes`, or accept it on the admin page.',
      );
    }
    stdout
      ..writeln()
      ..writeln(
        '"${request['deviceName']}" at ${request['address']} wants to sync.',
      )
      ..writeln('Its fingerprint: ${request['fingerprint']}')
      ..write('Allow it? [y/N] ');
    final answer = stdin.readLineSync()?.trim().toLowerCase();
    return answer == 'y' || answer == 'yes';
  }
}

class _Devices extends _Command {
  @override
  String get name => 'devices';

  @override
  String get description => 'List the paired devices.';

  @override
  Future<int> run() async {
    final database = openDatabase();
    try {
      final devices = database.devices();
      if (devices.isEmpty) {
        stdout.writeln('No device is paired. Add one with `pair`.');
        return 0;
      }
      for (final device in devices) {
        stdout
          ..writeln(device.name)
          ..writeln('  fingerprint ${device.fingerprint}')
          ..writeln('  paired      ${_time(device.pairedAt)}')
          ..writeln('  last sync   ${_time(device.lastSyncAt)}');
      }
      return 0;
    } finally {
      database.close();
    }
  }
}

class _Forget extends _Command {
  @override
  String get name => 'forget';

  @override
  String get description =>
      'Stop a device from syncing. It has to pair again to come back.';

  @override
  String get invocation =>
      '${runner!.executableName} forget <name or fingerprint>';

  @override
  Future<int> run() async {
    final rest = argResults!.rest;
    if (rest.length != 1) usageException('Name one device.');
    final database = openDatabase();
    final PairedDevice device;
    try {
      device = _match(database.devices(), rest.single);
    } finally {
      database.close();
    }

    final client = await runningServer();
    if (client != null) {
      // Through the running server, which also cuts it off mid-connection.
      try {
        await client.delete('/devices/${device.fingerprint}');
      } finally {
        client.close();
      }
    } else {
      final database = openDatabase();
      try {
        database.removeDevice(device.fingerprint);
      } finally {
        database.close();
      }
    }
    stdout.writeln('Forgot "${device.name}".');
    return 0;
  }

  static PairedDevice _match(List<PairedDevice> devices, String query) {
    final upper = query.toUpperCase();
    final matches = [
      for (final device in devices)
        if (device.name == query ||
            (upper.length >= 6 && device.fingerprint.startsWith(upper)))
          device,
    ];
    return switch (matches) {
      [final one] => one,
      [] => throw CliError('No paired device is "$query". See `devices`.'),
      _ => throw CliError(
        'Several devices match "$query": give more of the fingerprint.',
      ),
    };
  }
}

class _Status extends _Command {
  @override
  String get name => 'status';

  @override
  String get description => 'Whether the server runs, and what it keeps.';

  @override
  Future<int> run() async {
    final client = await runningServer();
    if (client == null) {
      stdout.writeln('Not running (data in ${dataDir.path}).');
      return 3;
    }
    try {
      final status = await client.get('/status') as Map<String, dynamic>;
      stdout
        ..writeln(
          'Running, version ${status['version']}, port ${status['port']}',
        )
        ..writeln('Fingerprint ${status['fingerprint']}')
        ..writeln(
          '${(status['devices'] as List).length} devices, '
          '${status['rows']} items, ${status['tombstones']} deletions kept',
        )
        ..writeln('Data in ${dataDir.path}')
        ..writeln('Admin page: ${client.access.base}');
      if (status['pairing'] != null) stdout.writeln('Pairing is open.');
      return 0;
    } finally {
      client.close();
    }
  }
}

class _Admin extends _Command {
  @override
  String get name => 'admin';

  @override
  String get description =>
      'Print the admin page link, with its token: keep it to yourself.';

  @override
  Future<int> run() async {
    final client = await requireRunningServer();
    client.close();
    stdout.writeln(client.access.pageUrl);
    return 0;
  }
}

class _Backup extends _Command {
  @override
  String get name => 'backup';

  @override
  String get description =>
      'Copy the database to a file, even while the server runs. The '
      'identity (identity.json) is not in it: back that up too, or every '
      'device pairs again after a restore.';

  @override
  String get invocation => '${runner!.executableName} backup <file>';

  @override
  Future<int> run() async {
    final rest = argResults!.rest;
    if (rest.length != 1) usageException('Give the file to write.');
    final target = File(rest.single);
    if (target.existsSync()) throw CliError('${target.path} already exists.');
    final database = openDatabase();
    try {
      database.backupTo(target.absolute.path);
    } finally {
      database.close();
    }
    stdout.writeln('Saved ${target.path}.');
    return 0;
  }
}

class _Fingerprint extends _Command {
  @override
  String get name => 'fingerprint';

  @override
  String get description =>
      "The server certificate's fingerprint, which devices check.";

  @override
  Future<int> run() async {
    final dir = dataDir;
    if (!File(dir.identityPath).existsSync()) {
      throw CliError('No identity in ${dir.path} yet: start the server once.');
    }
    await loadNativeLibrary();
    stdout.writeln((await dir.identity()).fingerprint);
    return 0;
  }
}

class _Service extends _Command {
  _Service() {
    argParser.addOption(
      'kind',
      allowed: [for (final kind in ServiceKind.values) kind.name],
      defaultsTo: platformServiceKind.name,
      help: 'What starts the server with the machine.',
    );
  }

  @override
  String get name => 'service';

  @override
  String get description =>
      'Print what starts this server with the machine (a systemd unit, a '
      'launchd agent or a scheduled task), with how to install it. Options '
      'after -- go to serve.';

  @override
  String get invocation =>
      '${runner!.executableName} service [-- serve options]';

  @override
  Future<int> run() async {
    final kind = ServiceKind.values.byName(argResults!.option('kind')!);
    final executable = Platform.resolvedExecutable;
    if (p.basenameWithoutExtension(executable) == 'dart' ||
        p.basenameWithoutExtension(executable) == 'dartvm') {
      throw const CliError(
        'Run `service` from the packaged server, not with `dart run`: the '
        'service has to start that executable.',
      );
    }
    final data = DataDir(p.absolute(dataDir.path))
      // launchd writes its log there before the server could make it.
      ..create();
    final user =
        Platform.environment['USER'] ??
        Platform.environment['USERNAME'] ??
        'root';
    stdout.write(
      serviceFile(
        kind,
        executable: executable,
        dataDir: data.path,
        serveArgs: argResults!.rest,
        user: user,
      ),
    );
    // The same command again, to write the file where it goes.
    final again = [
      _shellQuote(executable),
      '--data-dir',
      _shellQuote(data.path),
      'service',
      if (argResults!.rest.isNotEmpty) ...[
        '--',
        ...argResults!.rest.map(_shellQuote),
      ],
    ].join(' ');
    stderr.writeln(switch (kind) {
      ServiceKind.systemd =>
        '\nTo install it:\n'
            '  $again > mangayomi-sync-server.service\n'
            '  sudo mv mangayomi-sync-server.service /etc/systemd/system/\n'
            '  sudo systemctl daemon-reload\n'
            '  sudo systemctl enable --now mangayomi-sync-server',
      ServiceKind.launchd =>
        '\nTo install it:\n'
            '  $again > ~/Library/LaunchAgents/$launchdLabel.plist\n'
            '  launchctl load -w ~/Library/LaunchAgents/$launchdLabel.plist',
      ServiceKind.windows =>
        '\nRun the command above in a terminal to start the server at '
            'each sign-in.',
    });
    return 0;
  }
}

String _shellQuote(String arg) => RegExp(r'^[\w./:@=+-]+$').hasMatch(arg)
    ? arg
    : "'${arg.replaceAll("'", "'\\''")}'";

String _time(int? ms) => ms == null
    ? 'never'
    : DateTime.fromMillisecondsSinceEpoch(ms)
          .toLocal()
          .toString()
          .substring(0, 19);
