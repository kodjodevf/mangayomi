import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'downloaded_only_state_provider.g.dart';

@riverpod
class DownloadedOnlyState extends _$DownloadedOnlyState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.downloadedOnlyMode ?? false;
  }

  void setDownloadedOnly(bool value) {
    final settings = isar.settings.getSync(227)!;
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings
          ..downloadedOnlyMode = state
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
