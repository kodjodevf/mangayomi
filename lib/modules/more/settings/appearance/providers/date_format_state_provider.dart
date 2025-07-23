import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'date_format_state_provider.g.dart';

@riverpod
class DateFormatState extends _$DateFormatState {
  @override
  String build() {
    return isar.settings.getSync(227)!.dateFormat!;
  }

  void set(String dateFormat) {
    final settings = isar.settings.getSync(227);
    state = dateFormat;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..dateFormat = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class RelativeTimesTampsState extends _$RelativeTimesTampsState {
  @override
  int build() {
    return isar.settings.getSync(227)!.relativeTimesTamps!;
  }

  void set(int type) {
    final settings = isar.settings.getSync(227);
    state = type;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..relativeTimesTamps = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
