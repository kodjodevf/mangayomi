import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'material_you_state_provider.g.dart';

@riverpod
class MaterialYouState extends _$MaterialYouState {
  @override
  bool build() {
    return settingsRepository.currentOrNull?.useMaterialYou ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.useMaterialYou = value);
  }
}
