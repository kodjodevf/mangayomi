import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'pure_black_dark_mode_state_provider.g.dart';

@riverpod
class PureBlackDarkModeState extends _$PureBlackDarkModeState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.pureBlackDarkMode!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..pureBlackDarkMode = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
