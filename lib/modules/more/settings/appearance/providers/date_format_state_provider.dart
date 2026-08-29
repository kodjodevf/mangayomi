import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'date_format_state_provider.g.dart';

/// Live view of the single Settings row (id 227), shared by every provider
/// that only needs one field off it. Settings is a large row (several list
/// fields, some unbounded), so this exists to make sure it only gets
/// deserialized when it actually changes — once — instead of every reader
/// doing its own isar.settings.getSync() on every single read.
@Riverpod(keepAlive: true)
Stream<Settings> settingsStream(Ref ref) {
  return settingsRepository.watch();
}

@Riverpod(keepAlive: true)
class DateFormatState extends _$DateFormatState {
  @override
  String build() {
    return ref.watch(settingsStreamProvider).value?.dateFormat ??
        settingsRepository.current.dateFormat!;
  }

  void set(String dateFormat) {
    state = dateFormat;
    settingsRepository.update((s) => s.dateFormat = dateFormat);
  }
}

@Riverpod(keepAlive: true)
class RelativeTimesTampsState extends _$RelativeTimesTampsState {
  @override
  int build() {
    return ref.watch(settingsStreamProvider).value?.relativeTimesTamps ??
        settingsRepository.current.relativeTimesTamps!;
  }

  void set(int type) {
    state = type;
    settingsRepository.update((s) => s.relativeTimesTamps = type);
  }
}
