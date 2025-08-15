import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'algorithm_weights_state_provider.g.dart';

@riverpod
class AlgorithmWeightsState extends _$AlgorithmWeightsState {
  @override
  AlgorithmWeights build() {
    return isar.settings.getSync(227)!.algorithmWeights ?? AlgorithmWeights();
  }

  void set(AlgorithmWeights value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..algorithmWeights = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
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
