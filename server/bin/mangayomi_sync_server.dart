import 'dart:io';

import 'package:mangayomi_sync_server/src/cli.dart';

Future<void> main(List<String> args) async {
  exitCode = await runCli(args);
  // The native library keeps threads of its own: leave without waiting.
  await stdout.flush();
  exit(exitCode);
}
