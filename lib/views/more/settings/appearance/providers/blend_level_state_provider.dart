import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'blend_level_state_provider.g.dart';

@riverpod
class BlendLevelState extends _$BlendLevelState {
  @override
  double build() {
    return ref.watch(hiveBoxSettings).get('blendLevel', defaultValue: 10.0)!;
  }

  void setBlendLevel(double blendLevelValue) {
    state = blendLevelValue;
    ref.watch(hiveBoxSettings).put('blendLevel', state);
  }
}
