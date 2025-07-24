import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_provider.g.dart';

@riverpod
class MangaHomeDisplayTypeState extends _$MangaHomeDisplayTypeState {
  @override
  DisplayType build() {
    final settings = isar.settings.getSync(227)!;
    return settings.mangaHomeDisplayType;
  }

  void setMangaHomeDisplayType(DisplayType displayType) {
    final settings = isar.settings.getSync(227)!;

    state = displayType;

    isar.writeTxnSync(() {
      isar.settings.putSync(
        settings
          ..mangaHomeDisplayType = displayType
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      );
    });
  }
}
