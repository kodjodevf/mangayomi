import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'logs_state.g.dart';

@riverpod
class LogsState extends _$LogsState {
  @override
  bool build() {
    return settingsRepository.current.enableLogs ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.enableLogs = value);
  }
}
