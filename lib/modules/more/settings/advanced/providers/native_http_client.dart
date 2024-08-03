import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'native_http_client.g.dart';

@riverpod
class UseNativeHttpClientState extends _$UseNativeHttpClientState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.useNativeHttpClient ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
        () => isar.settings.putSync(settings!..useNativeHttpClient = value));
  }
}
