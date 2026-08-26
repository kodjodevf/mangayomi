import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'state_provider.g.dart';

@riverpod
class MangaHomeDisplayTypeState extends _$MangaHomeDisplayTypeState {
  @override
  DisplayType build() {
    return settingsRepository.current.mangaHomeDisplayType;
  }

  void setMangaHomeDisplayType(DisplayType displayType) {
    state = displayType;
    settingsRepository.update((s) => s.mangaHomeDisplayType = displayType);
  }
}
