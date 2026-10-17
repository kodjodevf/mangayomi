import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/eval/model/m_bridge.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/pre_import_backup.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/restore.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/modules/more/widgets/dialog_actions.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/error_toast.dart';

class RollbackLastChangeTile extends ConsumerWidget {
  const RollbackLastChangeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots = ref.watch(lastLibrarySnapshotProvider).asData?.value;
    if (snapshots == null || snapshots.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;

    String when(LibrarySafetySnapshot snapshot) =>
        DateTime.fromMillisecondsSinceEpoch(snapshot.createdAt).toString();
    final single = snapshots.length == 1;
    return ShioriSettingRow(
      icon: Symbols.settings_backup_restore_rounded,
      title: l10n.roll_back_last_change,
      subtitle: single
          ? l10n.roll_back_last_change_subtitle(
              when(snapshots.first),
              snapshots.first.description,
            )
          : l10n.roll_back_available_count(snapshots.length),
      destructive: true,
      onTap: () async {
        final snapshot = single
            ? snapshots.first
            : await showShioriChoice<LibrarySafetySnapshot>(
                context,
                title: l10n.roll_back_last_change,
                options: [
                  for (final s in snapshots)
                    ShioriChoice(s, s.description, subtitle: when(s)),
                ],
              );
        if (snapshot == null || !context.mounted) return;
        await offerLibraryRollback(context, ref, snapshot.backupPath);
      },
    );
  }
}

Future<void> offerLibraryRollback(
  BuildContext context,
  WidgetRef ref,
  String safetyBackupPath,
) async {
  final l10n = context.l10n;
  final confirmed = await showShioriConfirm(
    context,
    title: l10n.roll_back,
    message: l10n.roll_back_confirm_message,
    confirmLabel: l10n.roll_back,
    destructive: true,
  );
  if (!confirmed || !context.mounted) return;

  bool? syncAfterRestore;
  final syncPreference = ref.read(synchingProvider(syncId: 1));
  final hasServer =
      (syncPreference.authToken?.isNotEmpty ?? false) &&
      (syncPreference.server?.isNotEmpty ?? false);
  if (hasServer) {
    syncAfterRestore = await confirmSyncAfterRestore(
      context,
      syncOn: syncPreference.syncOn,
    );
    if (!context.mounted) return;
  }

  showBusyDialog(context, l10n.restoring_backup);
  try {
    await ref.watch(
      doRestoreProvider(
        path: safetyBackupPath,
        context: context,
        merge: false,
        syncAfterRestore: syncAfterRestore,
      ).future,
    );
  } catch (e, s) {
    // Keep the snapshot: the roll back did not happen, so it is still the
    // way back.
    toastError(e, stack: s, source: 'rollback');
    return;
  } finally {
    if (context.mounted) hideBusyDialog(context);
  }
  await clearLastLibrarySnapshot();
  if (!context.mounted) return;
  ref.invalidate(lastLibrarySnapshotProvider);
  botToast(l10n.roll_back_done);
}
