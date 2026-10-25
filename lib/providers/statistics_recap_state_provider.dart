import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_recap_state_provider.g.dart';

/// Whether Statistics shows the recap instead of the classic screen.
@riverpod
class StatisticsRecapState extends _$StatisticsRecapState {
  @override
  bool build() {
    return settingsRepository.current.statisticsRecap ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.statisticsRecap = value);
  }
}

/// The name in the Status Window; null shows the default.
@riverpod
class StatisticsReaderNameState extends _$StatisticsReaderNameState {
  @override
  String? build() {
    return settingsRepository.current.statisticsReaderName;
  }

  void set(String? value) {
    final name = value?.trim();
    state = name == null || name.isEmpty ? null : name;
    settingsRepository.update((s) => s.statisticsReaderName = state);
  }
}
