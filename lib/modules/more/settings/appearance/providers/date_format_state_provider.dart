import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'date_format_state_provider.g.dart';

/// Live view of the single Settings row (id 227), shared by every provider
/// that only needs one field off it. Settings is a large row (several list
/// fields, some unbounded), so this exists to make sure it only gets
/// deserialized when it actually changes — once — instead of every reader
/// doing its own isar.settings.getSync() on every single read.
@Riverpod(keepAlive: true)
Stream<Settings> settingsStream(Ref ref) {
  return isar.settings
      .watchObject(227, fireImmediately: true)
      .where((s) => s != null)
      .map((s) => s!);
}

@Riverpod(keepAlive: true)
class DateFormatState extends _$DateFormatState {
  @override
  String build() {
    return ref.watch(settingsStreamProvider).value?.dateFormat ??
        isar.settings.getSync(227)!.dateFormat!;
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

@Riverpod(keepAlive: true)
class RelativeTimesTampsState extends _$RelativeTimesTampsState {
  @override
  int build() {
    return ref.watch(settingsStreamProvider).value?.relativeTimesTamps ??
        isar.settings.getSync(227)!.relativeTimesTamps!;
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
