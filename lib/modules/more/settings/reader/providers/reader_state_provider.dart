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
        () => isar.settings.putSync(settings!..defaultReaderMode = value));
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
        () => isar.settings.putSync(settings!..animatePageTransitions = value));
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
    isar.writeTxnSync(() =>
        isar.settings.putSync(settings!..doubleTapAnimationSpeed = value));
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
        () => isar.settings.putSync(settings!..cropBorders = value));
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
        () => isar.settings.putSync(settings!..scaleType = value));
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
        () => isar.settings.putSync(settings!..pagePreloadAmount = value));
  }
}
