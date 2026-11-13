// The host as the app sees it: whether it runs, the invite on screen, the
// device waiting to be let in, and the devices paired with it.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/sync_preference.dart';
import 'package:mangayomi/providers/sync_progress_provider.dart';
import 'package:mangayomi/providers/sync_providers.dart';
import 'package:mangayomi_sync/mangayomi_sync.dart';
import 'package:mangayomi/services/sync_server.dart';
import 'package:mangayomi/services/sync_host/sync_host_providers.dart';
import 'package:mangayomi/services/sync_host/sync_host_service.dart';
import 'package:mangayomi/services/sync_host/sync_secrets.dart';
import 'package:mangayomi/utils/error_toast.dart';

/// A device that sent the right code, until the user answers.
class PendingPairing {
  PendingPairing(this.request);

  final PairingRequest request;
  final _answer = Completer<bool>();

  void answer(bool allow) {
    if (!_answer.isCompleted) _answer.complete(allow);
  }
}

class SyncHostState {
  const SyncHostState({
    this.running = false,
    this.busy = false,
    this.port,
    this.error,
    this.invite,
    this.pending,
    this.devices = const [],
  });

  final bool running;

  /// Starting or stopping.
  final bool busy;
  final int? port;

  /// Why the host could not start.
  final Object? error;

  /// The invite on screen, while a device may pair.
  final PairingInvite? invite;
  final PendingPairing? pending;
  final List<PairedDevice> devices;

  SyncHostState copyWith({
    bool? running,
    bool? busy,
    int? port,
    Object? error,
    PairingInvite? invite,
    PendingPairing? pending,
    List<PairedDevice>? devices,
    bool clearError = false,
    bool clearInvite = false,
    bool clearPending = false,
  }) => SyncHostState(
    running: running ?? this.running,
    busy: busy ?? this.busy,
    port: port ?? this.port,
    error: clearError ? null : error ?? this.error,
    invite: clearInvite ? null : invite ?? this.invite,
    pending: clearPending ? null : pending ?? this.pending,
    devices: devices ?? this.devices,
  );
}

class SyncHostController extends Notifier<SyncHostState> {
  SyncHostService? _service;
  final _secrets = SyncSecrets();

  Timer? _localSync;

  /// How long the host waits after a device synced before it syncs its own
  /// library, so a device sending pages back to back triggers it once.
  static const localSyncDelay = Duration(seconds: 5);

  @override
  SyncHostState build() {
    ref.onDispose(() {
      _localSync?.cancel();
      _service?.stop();
    });
    return const SyncHostState();
  }

  Future<void> start() async {
    if (_service != null || state.busy) return;
    state = state.copyWith(busy: true, clearError: true);
    try {
      final engine = await ref.read(syncHostEngineProvider.future);
      final service = await SyncHostService.start(
        engine: engine,
        secrets: _secrets,
        approve: _approve,
        onPaired: (_) => _refreshDevices(),
        onSynced: _scheduleLocalSync,
      );
      _service = service;
      state = state.copyWith(
        running: true,
        busy: false,
        port: service.port,
        devices: await _secrets.pairedDevices(),
      );
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'sync_host');
      state = state.copyWith(busy: false, error: error);
    }
  }

  Future<void> stop() async {
    final service = _service;
    if (service == null) return;
    _service = null;
    state.pending?.answer(false);
    state = state.copyWith(busy: true, clearInvite: true, clearPending: true);
    try {
      await service.stop();
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'sync_host');
    }
    state = SyncHostState(devices: state.devices);
  }

  /// Lets one device pair, with the invite to show it.
  Future<PairingInvite?> openPairing() async {
    final service = _service;
    if (service == null) return null;
    try {
      final invite = await service.openPairing();
      state = state.copyWith(invite: invite);
      return invite;
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'sync_host');
      return null;
    }
  }

  /// No more pairing, and no to a device still waiting.
  void closePairing() {
    try {
      _service?.closePairing();
    } catch (error, stack) {
      recordError(error, stack: stack, source: 'sync_host');
    }
    state.pending?.answer(false);
    state = state.copyWith(clearInvite: true, clearPending: true);
  }

  Future<void> forget(String fingerprint) async {
    final service = _service;
    if (service != null) {
      await service.forget(fingerprint);
    } else {
      await _secrets.removePairedDevice(fingerprint);
    }
    await _refreshDevices();
  }

  /// Brings what a device just sent into this device's library, when this
  /// device syncs with its own host.
  void _scheduleLocalSync() {
    _localSync?.cancel();
    _localSync = Timer(localSyncDelay, () {
      if (!ref.mounted) return;
      final prefs = ref.read(synchingProvider(syncId: 1));
      if (!prefs.syncOn || prefs.server != SyncPreference.thisDeviceHost) {
        return;
      }
      if (ref.read(syncProgressProvider(syncId: 1)).active) {
        _scheduleLocalSync();
        return;
      }
      ref.read(syncServerProvider(syncId: 1).notifier).startSync(null, true);
    });
  }

  Future<void> loadDevices() => _refreshDevices();

  Future<void> _refreshDevices() async {
    final devices = await _secrets.pairedDevices();
    if (ref.mounted) state = state.copyWith(devices: devices);
  }

  Future<bool> _approve(PairingRequest request) async {
    // Only while the invite is on screen: the user is there to answer.
    if (state.invite == null || state.pending != null) return false;
    final pending = PendingPairing(request);
    state = state.copyWith(pending: pending);
    final allowed = await pending._answer.future.timeout(
      SyncHostService.responseTimeout - const Duration(seconds: 5),
      onTimeout: () => false,
    );
    if (ref.mounted && state.pending == pending) {
      // The code works once: this invite is spent.
      state = state.copyWith(clearPending: true, clearInvite: true);
    }
    return allowed;
  }
}

final syncHostControllerProvider =
    NotifierProvider<SyncHostController, SyncHostState>(SyncHostController.new);
