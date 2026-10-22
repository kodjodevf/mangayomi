import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/manga.dart';
import 'package:mangayomi/modules/more/about/providers/check_for_update.dart';
import 'package:mangayomi/modules/more/about/providers/download_file_screen.dart';
import 'package:mangayomi/modules/more/data_and_storage/providers/auto_backup.dart';
import 'package:mangayomi/modules/more/settings/sync/providers/sync_providers.dart';
import 'package:mangayomi/services/discord_rpc.dart';
import 'package:mangayomi/services/fetch_item_sources.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/utils/platform_utils.dart';

mixin MainScreenLifecycleMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  Timer? _backupTimer;
  Timer? _syncTimer;

  void initLifecycleServices() {
    _initializeTimers();
    _initializeProviders();
    discordRpc?.connect(ref);
  }

  void disposeLifecycleServices() {
    _backupTimer?.cancel();
    _syncTimer?.cancel();
    discordRpc?.disconnect();
  }

  void _rescheduleSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;

    if (ref.read(restoreSyncGuardProvider)) return;

    final syncPrefs = ref.read(synchingProvider(syncId: 1));
    final freq = syncPrefs.autoSyncFrequency;
    if (syncPrefs.syncOn &&
        freq > 0 &&
        (syncPrefs.authToken?.isNotEmpty ?? false)) {
      _syncTimer = Timer.periodic(Duration(seconds: freq), _onSyncTimerTick);
    }
  }

  void _initializeTimers() {
    _backupTimer = Timer.periodic(
      const Duration(minutes: 5),
      _onBackupTimerTick,
    );

    _rescheduleSyncTimer();

    // Pauses the auto-sync timer for the duration of a restore (and its
    // post-restore upload), instead of just rescheduling it — a restore can
    // outlast one sync interval, so a reschedule alone could still let the
    // timer fire mid-restore. syncServerProvider.startSync also checks this
    // guard directly, covering a manual sync trigger too.
    ref.listenManual<bool>(restoreSyncGuardProvider, (_, restoring) {
      if (restoring) {
        _syncTimer?.cancel();
        _syncTimer = null;
        return;
      }
      _rescheduleSyncTimer();
    });

    // Listen to changes in sync preferences (frequency, syncOn, login/logout)
    // and immediately reschedule the timer and check if due.
    ref.listenManual(synchingProvider(syncId: 1), (prev, next) {
      _rescheduleSyncTimer();
      if (mounted) {
        unawaited(autoSyncIfDue(ref));
      }
    });
  }

  void _initializeProviders() {
    // The extension-repo fetches (one per item type) and the GitHub update
    // check hit the network; delay them so they don't compete with the first
    // paint and the initial library queries.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        for (var type in ItemType.values) {
          ref.read(
            fetchItemSourcesListProvider(
              id: null,
              reFresh: false,
              itemType: type,
            ),
          );
        }
      }
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted || isTv) return;
      ref.listenManual<AsyncValue<UpdateInfo?>>(checkForUpdateProvider, (
        _,
        next,
      ) {
        next.whenData((updateInfo) {
          if (updateInfo != null && mounted) {
            showDialog(
              context: context,
              builder: (_) => DownloadFileScreen(updateAvailable: updateInfo),
            );
          }
        });
      });
    });
  }

  void _onBackupTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    ref.read(checkAndBackupProvider);
  }

  void _onSyncTimerTick(Timer timer) {
    if (!mounted) {
      timer.cancel();
      return;
    }
    unawaited(autoSyncIfDue(ref));
  }
}
