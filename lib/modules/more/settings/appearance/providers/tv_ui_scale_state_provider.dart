import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tv_ui_scale_state_provider.g.dart';

/// User fine-tune for the TV interface scale. 1.0 is the normalized reference
/// (see [TvUiScale]); higher renders the UI larger, lower smaller.
@riverpod
class TvUiScaleState extends _$TvUiScaleState {
  @override
  double build() {
    return isar.settings.getSync(227)!.tvUiScale ?? 1.0;
  }

  void set(double value, {bool end = false}) {
    state = value;
    if (end) {
      final settings = isar.settings.getSync(227);
      isar.writeTxnSync(
        () => isar.settings.putSync(
          settings!
            ..tvUiScale = state
            ..updatedAt = DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }
}
