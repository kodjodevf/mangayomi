// The device side of pairing: sends the invite's code to the host it
// names, over a connection that only goes through when the host shows the
// certificate the invite names.
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/services/sync_host/sync_secrets.dart';
import 'package:mangayomi/src/rust/api/sync_host.dart';
import 'package:mangayomi/utils/error_toast.dart';

enum PeerPairingOutcome {
  paired,

  /// The host took the code as wrong: mistyped, or from an older invite.
  wrongCode,

  /// The invite ran out, was used, or the host's user said no.
  refused,

  /// No address in the invite answered as the host it names.
  unreachable,
}

/// How long the host's user has to accept the device, plus the way there.
const _pairingTimeout = Duration(minutes: 2, seconds: 15);

/// Pairs with the host [invite] names. On [PeerPairingOutcome.paired], the
/// address that answered is in `server`.
Future<({PeerPairingOutcome outcome, String? server})> pairWithHost(
  PairingInvite invite, {
  SyncSecrets? secrets,
  String? deviceName,
}) async {
  final identity = await (secrets ?? SyncSecrets()).identity();
  deviceName ??= await thisDeviceName();
  for (final address in invite.addresses) {
    final SyncPeerResponse response;
    try {
      response = await SyncPeerClient(
        identity: identity,
        baseUrl: address,
        hostFingerprint: invite.fingerprint,
        timeoutSeconds: _pairingTimeout.inSeconds,
      ).pair(code: invite.code, deviceName: deviceName);
    } catch (error, stack) {
      // Unreachable from here, or not the host the invite names: the next
      // address may be the one.
      recordError(error, stack: stack, source: 'sync_pairing');
      continue;
    }
    final outcome = switch (response.status) {
      200 => PeerPairingOutcome.paired,
      401 => PeerPairingOutcome.wrongCode,
      _ => PeerPairingOutcome.refused,
    };
    return (
      outcome: outcome,
      server: outcome == PeerPairingOutcome.paired ? address : null,
    );
  }
  return (outcome: PeerPairingOutcome.unreachable, server: null);
}

/// What the host's user sees when this device asks to pair.
Future<String> thisDeviceName() async {
  try {
    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      return '${android.manufacturer} ${android.model}';
    }
    if (Platform.isIOS) return (await info.iosInfo).name;
    if (Platform.isMacOS) return (await info.macOsInfo).computerName;
    if (Platform.isWindows) return (await info.windowsInfo).computerName;
    if (Platform.isLinux) return (await info.linuxInfo).prettyName;
  } catch (error, stack) {
    recordError(error, stack: stack, source: 'sync_pairing');
  }
  return Platform.localHostname;
}
