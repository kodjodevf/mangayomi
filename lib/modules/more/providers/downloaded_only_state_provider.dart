import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'downloaded_only_state_provider.g.dart';

@riverpod
class DownloadedOnlyState extends _$DownloadedOnlyState {
  @override
  bool build() {
    return settingsRepository.current.downloadedOnlyMode ?? false;
  }

  void setDownloadedOnly(bool value) {
    state = value;
    settingsRepository.update((s) => s.downloadedOnlyMode = value);
  }
}
