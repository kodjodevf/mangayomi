import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'logs_state.g.dart';

@riverpod
class LogsState extends _$LogsState {
  @override
  bool build() {
    return isar.settings.getSync(227)?.enableLogs ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);

    state = value;

    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings!
          ..enableLogs = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
  }
}
