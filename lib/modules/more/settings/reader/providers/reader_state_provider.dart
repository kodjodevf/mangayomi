import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_state_provider.g.dart';

@riverpod
class DefaultReadingModeState extends _$DefaultReadingModeState {
  @override
  ReaderMode build() {
    return isar.settings.getSync(227)!.defaultReaderMode;
  }

  void set(ReaderMode value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..defaultReaderMode = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class AnimatePageTransitionsState extends _$AnimatePageTransitionsState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.animatePageTransitions!;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..animatePageTransitions = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class DoubleTapAnimationSpeedState extends _$DoubleTapAnimationSpeedState {
  @override
  int build() {
    return isar.settings.getSync(227)!.doubleTapAnimationSpeed!;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..doubleTapAnimationSpeed = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class CropBordersState extends _$CropBordersState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.cropBorders ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..cropBorders = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class ScaleTypeState extends _$ScaleTypeState {
  @override
  ScaleType build() {
    return isar.settings.getSync(227)!.scaleType;
  }

  void set(ScaleType value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..scaleType = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class PagePreloadAmountState extends _$PagePreloadAmountState {
  @override
  int build() {
    return isar.settings.getSync(227)!.pagePreloadAmount ?? 6;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..pagePreloadAmount = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class BackgroundColorState extends _$BackgroundColorState {
  @override
  BackgroundColor build() {
    return isar.settings.getSync(227)!.backgroundColor;
  }

  void set(BackgroundColor value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..backgroundColor = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class UsePageTapZonesState extends _$UsePageTapZonesState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.usePageTapZones ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..usePageTapZones = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class FullScreenReaderState extends _$FullScreenReaderState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.fullScreenReader ?? true;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..fullScreenReader = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class NavigationOrderState extends _$NavigationOrderState {
  final items = [
    '/MangaLibrary',
    '/AnimeLibrary',
    '/NovelLibrary',
    '/updates',
    '/history',
    '/browse',
    '/more',
    '/trackerLibrary',
  ];

  @override
  List<String> build() {
    return _checkMissingItems(
      isar.settings.getSync(227)!.navigationOrder?.toList() ?? [],
    );
  }

  List<String> _checkMissingItems(List<String> navigationOrder) {
    navigationOrder.addAll(
      items.where((e) => !navigationOrder.contains(e)).toList(),
    );
    return navigationOrder;
  }

  void set(List<String> values) {
    final settings = isar.settings.getSync(227);
    state = values;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..navigationOrder = values
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class HideItemsState extends _$HideItemsState {
  @override
  List<String> build() {
    return isar.settings.getSync(227)!.hideItems ?? ['/trackerLibrary'];
  }

  void set(List<String> values) {
    final settings = isar.settings.getSync(227);
    state = values;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..hideItems = values
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class MergeLibraryNavMobileState extends _$MergeLibraryNavMobileState {
  @override
  bool build() {
    return isar.settings.getSync(227)!.mergeLibraryNavMobile ?? false;
  }

  void set(bool value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..mergeLibraryNavMobile = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class NovelFontSizeState extends _$NovelFontSizeState {
  @override
  int build() {
    return isar.settings.getSync(227)!.novelFontSize ?? 14;
  }

  void set(int value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..novelFontSize = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

@riverpod
class NovelTextAlignState extends _$NovelTextAlignState {
  @override
  NovelTextAlign build() {
    return isar.settings.getSync(227)!.novelTextAlign;
  }

  void set(NovelTextAlign value) {
    final settings = isar.settings.getSync(227);
    state = value;
    isar.writeTxnSync(
      () => isar.settings.putSync(
        settings!
          ..novelTextAlign = value
          ..updatedAt = DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
