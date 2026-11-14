import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/modules/more/settings/sync/device_sync/join_host.dart';
import 'package:mangayomi/modules/more/settings/sync/device_sync/pairing_invite_dialog.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/providers/sync_providers.dart';
import 'package:mangayomi/services/sync_host/sync_host_controller.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/utils/date.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:shiori/shiori.dart';

/// Sync without a server: host it on this device, or join the device that
/// does.
class DeviceSyncScreen extends ConsumerStatefulWidget {
  const DeviceSyncScreen({super.key});

  @override
  ConsumerState<DeviceSyncScreen> createState() => _DeviceSyncScreenState();
}

class _DeviceSyncScreenState extends ConsumerState<DeviceSyncScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(syncHostControllerProvider.notifier).loadDevices(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final prefs = ref.watch(synchingProvider(syncId: 1));
    final host = ref.watch(syncHostControllerProvider);
    final joined = prefs.hostFingerprint != null;

    final String? hostStatus;
    if (host.running) {
      hostStatus = l10n.device_sync_host_running('${host.port}');
    } else if (host.error != null) {
      hostStatus = l10n.device_sync_host_failed('${host.error}');
    } else {
      hostStatus = null;
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.device_sync)),
      body: SingleChildScrollView(
        padding: tvPageInsets,
        child: Column(
          children: [
            ShioriSettingsGroup(
              title: l10n.device_sync_host_section,
              footer: l10n.device_sync_host_info,
              children: [
                ShioriSwitchRow(
                  icon: Symbols.dns_rounded,
                  title: l10n.device_sync_host,
                  subtitle: hostStatus,
                  value: prefs.hostEnabled,
                  onChanged: host.busy ? null : (on) => _setHosting(on, prefs),
                ),
                if (host.running)
                  ShioriSettingRow(
                    icon: Symbols.qr_code_2_rounded,
                    title: l10n.device_sync_add_device,
                    onTap: () => showPairingInvite(context, ref),
                  ),
              ],
            ),
            if (prefs.hostEnabled || host.devices.isNotEmpty)
              ShioriSettingsGroup(
                title: l10n.device_sync_paired_devices,
                children: [
                  if (host.devices.isEmpty)
                    ShioriSettingRow(
                      icon: Symbols.devices_rounded,
                      title: l10n.device_sync_no_paired,
                      enabled: false,
                    ),
                  for (final device in host.devices) _deviceRow(device),
                ],
              ),
            if (!prefs.hostEnabled)
              ShioriSettingsGroup(
                title: l10n.device_sync_join_section,
                footer: l10n.device_sync_join_info,
                children: [
                  if (joined) ...[
                    ShioriSettingRow(
                      icon: Symbols.check_circle_rounded,
                      title: syncTargetLabel(context, prefs),
                    ),
                    ShioriSettingRow(
                      icon: Symbols.link_off_rounded,
                      title: l10n.device_sync_leave,
                      destructive: true,
                      onTap: () => _leave(),
                    ),
                  ],
                  if (canScanInvites)
                    ShioriSettingRow(
                      icon: Symbols.qr_code_scanner_rounded,
                      title: l10n.device_sync_scan,
                      onTap: () => scanInvite(context, ref),
                    ),
                  ShioriSettingRow(
                    icon: Symbols.content_paste_rounded,
                    title: l10n.device_sync_paste,
                    onTap: () => pasteInvite(context, ref),
                  ),
                ],
              ),
            const SizedBox(height: ShioriSpace.s24),
          ],
        ),
      ),
    );
  }

  Widget _deviceRow(PairedDevice device) {
    final l10n = context.l10n;
    final date = dateFormat(
      '${device.pairedAt}',
      ref: ref,
      context: context,
      useRelativeTimesTamps: false,
    );
    return ShioriSettingRow(
      icon: Symbols.smartphone_rounded,
      title: device.name,
      subtitle: l10n.device_sync_paired_on(date),
      trailing: IconButton(
        tooltip: l10n.remove,
        icon: const Icon(Symbols.delete_rounded),
        onPressed: () async {
          final confirmed = await showShioriConfirm(
            context,
            title: l10n.device_sync_forget_title(device.name),
            message: l10n.device_sync_forget_message,
            confirmLabel: l10n.remove,
            destructive: true,
          );
          if (!confirmed) return;
          await ref
              .read(syncHostControllerProvider.notifier)
              .forget(device.fingerprint);
        },
      ),
    );
  }

  Future<void> _setHosting(bool on, SyncPreference prefs) async {
    final l10n = context.l10n;
    final controller = ref.read(syncHostControllerProvider.notifier);
    final synching = ref.read(synchingProvider(syncId: 1).notifier);
    if (on) {
      if (prefs.server != SyncPreference.thisDeviceHost &&
          !await confirmSyncTargetChange(context, prefs)) {
        return;
      }
      await controller.start();
      if (!ref.read(syncHostControllerProvider).running) return;
      await synching.setHostEnabled(true);
      if (prefs.server != SyncPreference.thisDeviceHost) {
        await synching.useThisDeviceAsHost();
      }
      synching.setSyncOn(true);
      return;
    }
    final confirmed = await showShioriConfirm(
      context,
      title: l10n.device_sync_stop_host_title,
      message: l10n.device_sync_stop_host_message,
      confirmLabel: l10n.dialog_confirm,
      destructive: true,
    );
    if (!confirmed) return;
    await controller.stop();
    await synching.setHostEnabled(false);
    if (ref.read(synchingProvider(syncId: 1)).server ==
        SyncPreference.thisDeviceHost) {
      await synching.leaveHost();
    }
  }

  Future<void> _leave() async {
    final l10n = context.l10n;
    final confirmed = await showShioriConfirm(
      context,
      title: l10n.device_sync_leave,
      confirmLabel: l10n.dialog_confirm,
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(synchingProvider(syncId: 1).notifier).leaveHost();
  }
}
