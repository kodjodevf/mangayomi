import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'algorithm_weights_state_provider.g.dart';

@riverpod
class AlgorithmWeightsState extends _$AlgorithmWeightsState {
  @override
  AlgorithmWeights build() {
    return settingsRepository.current.algorithmWeights ?? AlgorithmWeights();
  }

  void set(AlgorithmWeights value) {
    state = value;
    settingsRepository.update((s) => s.algorithmWeights = value);
  }

  void setWeights({int? genre, int? setting, int? synopsis, int? theme}) {
    set(
      AlgorithmWeights(
        genre: genre ?? state.genre,
        setting: setting ?? state.setting,
        synopsis: synopsis ?? state.synopsis,
        theme: theme ?? state.theme,
      ),
    );
  }
}
