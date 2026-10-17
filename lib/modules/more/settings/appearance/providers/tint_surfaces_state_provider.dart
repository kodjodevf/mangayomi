import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'tint_surfaces_state_provider.g.dart';

/// Whether the palette colours the surfaces too, or only the accent.
@riverpod
class TintSurfacesState extends _$TintSurfacesState {
  @override
  bool build() {
    return settingsRepository.current.tintSurfacesWithPalette ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.tintSurfacesWithPalette = value);
  }
}
