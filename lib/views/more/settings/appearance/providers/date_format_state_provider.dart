import 'package:mangayomi/providers/hive_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'date_format_state_provider.g.dart';

@riverpod
class DateFormatState extends _$DateFormatState {
  @override
  String build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('dateFormat', defaultValue: "M/d/y")!;
  }

  void set(String dateFormat) {
    state = dateFormat;
    ref.watch(hiveBoxSettingsProvider).put('dateFormat', state);
  }
}

@riverpod
class RelativeTimesTampsState extends _$RelativeTimesTampsState {
  @override
  int build() {
    return ref
        .watch(hiveBoxSettingsProvider)
        .get('relativeTimesTamps', defaultValue: 2)!;
  }

  void set(int type) {
    state = type;
    ref.watch(hiveBoxSettingsProvider).put('relativeTimesTamps', state);
  }
}
