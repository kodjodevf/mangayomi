import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/device_sync/pairing_scanner_screen.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/sync_providers.dart';
import 'package:mangayomi/services/sync_host/peer_pairing.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/error_toast.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shiori/shiori.dart';

/// Whether this device has a camera to scan an invite with.
bool get canScanInvites =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

/// What this device syncs with now, for the user: the server, or a host.
String syncTargetLabel(BuildContext context, SyncPreference prefs) {
  final server = prefs.server ?? '';
  if (server == SyncPreference.thisDeviceHost) {
    return context.l10n.device_sync_with_this_device;
  }
  if (prefs.hostFingerprint != null) {
    return context.l10n.device_sync_with_host(
      Uri.tryParse(server)?.authority ?? server,
    );
  }
  return server;
}

/// Asks before this device stops syncing with what it syncs with now.
/// True when it syncs with nothing, or the user agreed.
Future<bool> confirmSyncTargetChange(
  BuildContext context,
  SyncPreference prefs,
) async {
  if (!prefs.isConnected) return true;
  final l10n = context.l10n;
  return showShioriConfirm(
    context,
    title: l10n.device_sync_switch_title,
    message: l10n.device_sync_switch_message(syncTargetLabel(context, prefs)),
    confirmLabel: l10n.dialog_confirm,
  );
}

Future<void> scanInvite(BuildContext context, WidgetRef ref) async {
  final invite = await Navigator.of(context).push<PairingInvite>(
    MaterialPageRoute(builder: (_) => const PairingScannerScreen()),
  );
  if (invite != null && context.mounted) await joinHost(context, ref, invite);
}

Future<void> pasteInvite(BuildContext context, WidgetRef ref) async {
  final invite = await showDialog<PairingInvite>(
    context: context,
    builder: (_) => const _PasteInviteDialog(),
  );
  if (invite != null && context.mounted) await joinHost(context, ref, invite);
}

/// Owns its text controller, so the controller outlives the dialog's
/// closing animation, which still reads it.
class _PasteInviteDialog extends StatefulWidget {
  const _PasteInviteDialog();

  @override
  State<_PasteInviteDialog> createState() => _PasteInviteDialogState();
}

class _PasteInviteDialogState extends State<_PasteInviteDialog> {
  final _link = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  void _submit() {
    final invite = PairingInvite.parse(_link.text);
    if (invite == null) {
      setState(() => _error = context.l10n.device_sync_link_invalid);
    } else {
      Navigator.pop(context, invite);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ShioriDialog(
      title: l10n.device_sync_paste,
      content: TextField(
        controller: _link,
        autofocus: true,
        keyboardType: TextInputType.url,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: l10n.device_sync_link,
          errorText: _error,
          errorMaxLines: 2,
        ),
      ),
      actions: [
        ShioriButton.quiet(
          label: l10n.cancel,
          onPressed: () => Navigator.pop(context),
        ),
        ShioriButton(label: l10n.device_sync_pair, onPressed: _submit),
      ],
    );
  }
}

/// Pairs with the host [invite] names, then syncs with it from the start.
Future<void> joinHost(
  BuildContext context,
  WidgetRef ref,
  PairingInvite invite,
) async {
  final l10n = context.l10n;
  final prefs = ref.read(synchingProvider(syncId: 1));
  if (!await confirmSyncTargetChange(context, prefs) || !context.mounted) {
    return;
  }

  showBusyDialog(context, l10n.device_sync_pairing);
  final ({PeerPairingOutcome outcome, String? server}) result;
  try {
    result = await pairWithHost(invite);
  } catch (error, stack) {
    // This device's identity could not be read or made (no secure storage,
    // say): close the busy dialog rather than leave it up for good.
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    toastError(error, stack: stack, source: 'sync_pairing');
    return;
  }
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pop();

  switch (result.outcome) {
    case PeerPairingOutcome.paired:
      final synching = ref.read(synchingProvider(syncId: 1).notifier);
      await synching.useHost(
        result.server!,
        invite.fingerprint,
        addresses: invite.addresses,
      );
      synching.setSyncOn(true);
      botToast(l10n.device_sync_paired, second: 3);
      await ref
          .read(syncServerProvider(syncId: 1).notifier)
          .startSync(l10n, false);
    case PeerPairingOutcome.wrongCode:
      botToast(l10n.device_sync_wrong_code, second: 5);
    case PeerPairingOutcome.refused:
      botToast(l10n.device_sync_refused, second: 5);
    case PeerPairingOutcome.unreachable:
      botToast(l10n.device_sync_unreachable, second: 5);
  }
}
