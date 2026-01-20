import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/services/http/doh/doh_providers.dart';

class DoHProviderState {
  final bool enabled;
  final int? providerId;

  DoHProviderState({required this.enabled, this.providerId});

  DoHProviderState copyWith({bool? enabled, int? providerId}) {
    return DoHProviderState(
      enabled: enabled ?? this.enabled,
      providerId: providerId ?? this.providerId,
    );
  }
}

final doHProviderStateProvider =
    NotifierProvider<DoHProviderNotifier, DoHProviderState>(() {
      return DoHProviderNotifier();
    });

class DoHProviderNotifier extends Notifier<DoHProviderState> {
  @override
  DoHProviderState build() {
    final settings = isar.settings.getSync(227)!;
    return DoHProviderState(
      enabled: settings.doHEnabled ?? false,
      providerId: settings.doHProviderId,
    );
  }

  void setDoHEnabled(bool enabled) {
    final settings = isar.settings.getSync(227)!;
    settings.doHEnabled = enabled;
    if (enabled && settings.doHProviderId == null) {
      settings.doHProviderId = 0;
    }
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
    state = state.copyWith(enabled: enabled);
  }

  void setDoHProvider(int providerId) {
    final provider = DoHProviders.byId[providerId];
    if (provider == null) {
      return;
    }

    final settings = isar.settings.getSync(227)!;
    settings.doHProviderId = providerId;
    settings.doHEnabled = true;
    isar.writeTxnSync(() {
      isar.settings.putSync(settings);
    });
    state = state.copyWith(enabled: true, providerId: providerId);
  }
}

final availableDoHProvidersProvider = Provider<List<DoHProvider>>((ref) {
  return DoHProviders.all;
});
