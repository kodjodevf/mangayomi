import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'app_ui_scale_state_provider.g.dart';

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [AppUiScale]); higher renders the UI larger, lower smaller.
@riverpod
class AppUiScaleState extends _$AppUiScaleState {
  @override
  double build() {
    return isar.settings.getSync(227)!.appUiScale ?? 1.0;
  }

  void set(double value, {bool end = false}) {
    state = value;
    if (end) {
      final settings = isar.settings.getSync(227);
      isar.writeTxnSync(
        () => isar.settings.putSync(
          settings!
            ..appUiScale = state
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
