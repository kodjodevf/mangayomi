import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'incognito_mode_state_provider.g.dart';

@riverpod
class IncognitoModeState extends _$IncognitoModeState {
  @override
  bool build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('incognitoMode', defaultValue: false)!;
  }

  void setIncognitoMode(bool value) {
    state = value;
    ref.watch(hiveBoxSettingsProvider).put('incognitoMode', state);
  }
}
