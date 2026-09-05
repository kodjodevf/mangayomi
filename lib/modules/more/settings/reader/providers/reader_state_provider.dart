import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'reader_state_provider.g.dart';

@riverpod
class DefaultReadingModeState extends _$DefaultReadingModeState {
  @override
  ReaderMode build() {
    return settingsRepository.current.defaultReaderMode;
  }

  void set(ReaderMode value) {
    state = value;
    settingsRepository.update((s) => s.defaultReaderMode = value);
  }
}

@riverpod
class AnimatePageTransitionsState extends _$AnimatePageTransitionsState {
  @override
  bool build() {
    return settingsRepository.current.animatePageTransitions!;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.animatePageTransitions = value);
  }
}

@riverpod
class DoubleTapAnimationSpeedState extends _$DoubleTapAnimationSpeedState {
  @override
  int build() {
    return settingsRepository.current.doubleTapAnimationSpeed!;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.doubleTapAnimationSpeed = value);
  }
}

@riverpod
class CropBordersState extends _$CropBordersState {
  @override
  bool build() {
    return settingsRepository.current.cropBorders ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.cropBorders = value);
  }
}

@riverpod
class ScaleTypeState extends _$ScaleTypeState {
  @override
  ScaleType build() {
    return settingsRepository.current.scaleType;
  }

  void set(ScaleType value) {
    state = value;
    settingsRepository.update((s) => s.scaleType = value);
  }
}

@riverpod
class PagePreloadAmountState extends _$PagePreloadAmountState {
  @override
  int build() {
    return settingsRepository.current.pagePreloadAmount ?? 6;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.pagePreloadAmount = value);
  }
}

@riverpod
class BackgroundColorState extends _$BackgroundColorState {
  @override
  BackgroundColor build() {
    return settingsRepository.current.backgroundColor;
  }

  void set(BackgroundColor value) {
    state = value;
    settingsRepository.update((s) => s.backgroundColor = value);
  }
}

@riverpod
class UsePageTapZonesState extends _$UsePageTapZonesState {
  @override
  bool build() {
    return settingsRepository.current.usePageTapZones ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.usePageTapZones = value);
  }
}

@riverpod
class FullScreenReaderState extends _$FullScreenReaderState {
  @override
  bool build() {
    return settingsRepository.current.fullScreenReader ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.fullScreenReader = value);
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
      settingsRepository.current.navigationOrder?.toList() ?? [],
    );
  }

  List<String> _checkMissingItems(List<String> navigationOrder) {
    navigationOrder.addAll(
      items.where((e) => !navigationOrder.contains(e)).toList(),
    );
    return navigationOrder;
  }

  void set(List<String> values) {
    state = values;
    settingsRepository.update((s) => s.navigationOrder = values);
  }
}

@riverpod
class HideItemsState extends _$HideItemsState {
  @override
  List<String> build() {
    return settingsRepository.current.hideItems ?? ['/trackerLibrary'];
  }

  void set(List<String> values) {
    state = values;
    settingsRepository.update((s) => s.hideItems = values);
  }
}

@riverpod
class MergeLibraryNavMobileState extends _$MergeLibraryNavMobileState {
  @override
  bool build() {
    return settingsRepository.current.mergeLibraryNavMobile ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.mergeLibraryNavMobile = value);
  }
}

@riverpod
class NovelFontSizeState extends _$NovelFontSizeState {
  @override
  int build() {
    return settingsRepository.current.novelFontSize ?? 14;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.novelFontSize = value);
  }
}

@riverpod
class NovelTextAlignState extends _$NovelTextAlignState {
  @override
  NovelTextAlign build() {
    return settingsRepository.current.novelTextAlign;
  }

  void set(NovelTextAlign value) {
    state = value;
    settingsRepository.update((s) => s.novelTextAlign = value);
  }
}

@riverpod
class NovelReaderThemeState extends _$NovelReaderThemeState {
  @override
  String build() {
    return settingsRepository.current.novelReaderTheme ?? '#292832';
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderTheme = value);
  }
}

@riverpod
class NovelReaderTextColorState extends _$NovelReaderTextColorState {
  @override
  String build() {
    return settingsRepository.current.novelReaderTextColor ?? '#CCCCCC';
  }

  void set(String value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderTextColor = value);
  }
}

@riverpod
class NovelReaderPaddingState extends _$NovelReaderPaddingState {
  @override
  int build() {
    return settingsRepository.current.novelReaderPadding ?? 16;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderPadding = value);
  }
}

@riverpod
class NovelReaderLineHeightState extends _$NovelReaderLineHeightState {
  @override
  double build() {
    return settingsRepository.current.novelReaderLineHeight ?? 1.5;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.novelReaderLineHeight = value);
  }
}

@riverpod
class NovelFontFamilyState extends _$NovelFontFamilyState {
  @override
  String? build() {
    return settingsRepository.current.novelFontFamily;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.novelFontFamily = value);
  }
}

@riverpod
class NovelShowScrollPercentageState extends _$NovelShowScrollPercentageState {
  @override
  bool build() {
    return settingsRepository.current.novelShowScrollPercentage ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.novelShowScrollPercentage = value);
  }
}

@riverpod
class NovelRemoveExtraParagraphSpacingState
    extends _$NovelRemoveExtraParagraphSpacingState {
  @override
  bool build() {
    return settingsRepository.current.novelRemoveExtraParagraphSpacing ??
        false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.novelRemoveExtraParagraphSpacing = value);
  }
}

@riverpod
class NovelTapToScrollState extends _$NovelTapToScrollState {
  @override
  bool build() {
    return settingsRepository.current.novelTapToScroll ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.novelTapToScroll = value);
  }
}

@riverpod
class ShowPagesNumberState extends _$ShowPagesNumberState {
  @override
  build() {
    return settingsRepository.current.showPagesNumber ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showPagesNumber = value);
  }
}

@riverpod
class KeepScreenOnReaderState extends _$KeepScreenOnReaderState {
  @override
  bool build() {
    return settingsRepository.current.keepScreenOnReader ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.keepScreenOnReader = value);
  }
}

@riverpod
class WebtoonSidePaddingState extends _$WebtoonSidePaddingState {
  @override
  int build() {
    return settingsRepository.current.webtoonSidePadding ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.webtoonSidePadding = value);
  }
}

@riverpod
class ShowPageGapsState extends _$ShowPageGapsState {
  @override
  bool build() {
    return settingsRepository.current.showPageGaps ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showPageGaps = value);
  }
}

@riverpod
class AutoReadDuplicateChaptersState extends _$AutoReadDuplicateChaptersState {
  @override
  bool build() {
    return settingsRepository.current.autoReadDuplicateChapters ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.autoReadDuplicateChapters = value);
  }
}

@riverpod
class InvertColorsState extends _$InvertColorsState {
  @override
  bool build() {
    return settingsRepository.current.invertColors ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.invertColors = value);
  }
}

@riverpod
class GrayscaleState extends _$GrayscaleState {
  @override
  bool build() {
    return settingsRepository.current.grayscale ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.grayscale = value);
  }
}

@riverpod
class ReaderBrightnessState extends _$ReaderBrightnessState {
  @override
  double build() {
    return settingsRepository.current.readerBrightness ?? 0.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.readerBrightness = value);
  }
}

@riverpod
class ReaderContrastState extends _$ReaderContrastState {
  @override
  double build() {
    return settingsRepository.current.readerContrast ?? 1.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.readerContrast = value);
  }
}

@riverpod
class ReaderSaturationState extends _$ReaderSaturationState {
  @override
  double build() {
    return settingsRepository.current.readerSaturation ?? 1.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.readerSaturation = value);
  }
}

@riverpod
class ReaderNavigationLayoutState extends _$ReaderNavigationLayoutState {
  @override
  int build() {
    return settingsRepository.current.readerNavigationLayout ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.readerNavigationLayout = value);
  }
}

@riverpod
class TtsSpeechRateState extends _$TtsSpeechRateState {
  @override
  double build() {
    return settingsRepository.current.ttsSpeechRate ?? 0.5;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.ttsSpeechRate = value);
  }
}

@riverpod
class TtsPitchState extends _$TtsPitchState {
  @override
  double build() {
    return settingsRepository.current.ttsPitch ?? 1.0;
  }

  void set(double value) {
    state = value;
    settingsRepository.update((s) => s.ttsPitch = value);
  }
}

@riverpod
class TtsLanguageState extends _$TtsLanguageState {
  @override
  String? build() {
    return settingsRepository.current.ttsLanguage;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.ttsLanguage = value);
  }
}

@riverpod
class TtsVoiceState extends _$TtsVoiceState {
  @override
  String? build() {
    return settingsRepository.current.ttsVoice;
  }

  void set(String? value) {
    state = value;
    settingsRepository.update((s) => s.ttsVoice = value);
  }
}

@riverpod
class SplitWidePagesState extends _$SplitWidePagesState {
  @override
  bool build() {
    return settingsRepository.current.splitWidePages ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.splitWidePages = value);
  }
}

@riverpod
class DualPageInvertState extends _$DualPageInvertState {
  @override
  bool build() {
    return settingsRepository.current.dualPageInvert ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.dualPageInvert = value);
  }
}

@riverpod
class DualPageRotateToFitState extends _$DualPageRotateToFitState {
  @override
  bool build() {
    return settingsRepository.current.dualPageRotateToFit ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.dualPageRotateToFit = value);
  }
}

@riverpod
class DualPageRotateToFitInvertState extends _$DualPageRotateToFitInvertState {
  @override
  bool build() {
    return settingsRepository.current.dualPageRotateToFitInvert ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.dualPageRotateToFitInvert = value);
  }
}

@riverpod
class DoublePageSingleFirstPageState extends _$DoublePageSingleFirstPageState {
  @override
  bool build() {
    return settingsRepository.current.doublePageSingleFirstPage ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.doublePageSingleFirstPage = value);
  }
}

@riverpod
class LandscapeZoomState extends _$LandscapeZoomState {
  @override
  bool build() {
    return settingsRepository.current.landscapeZoom ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.landscapeZoom = value);
  }
}

@riverpod
class ZoomStartPositionState extends _$ZoomStartPositionState {
  @override
  int build() {
    return settingsRepository.current.zoomStartPosition ?? 1;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.zoomStartPosition = value);
  }
}

@riverpod
class NavigateToPanState extends _$NavigateToPanState {
  @override
  bool build() {
    return settingsRepository.current.navigateToPan ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.navigateToPan = value);
  }
}

@riverpod
class TappingInversionState extends _$TappingInversionState {
  @override
  int build() {
    return settingsRepository.current.tappingInversion ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.tappingInversion = value);
  }
}

@riverpod
class FlashOnPageChangeState extends _$FlashOnPageChangeState {
  @override
  bool build() {
    return settingsRepository.current.flashOnPageChange ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.flashOnPageChange = value);
  }
}

@riverpod
class FlashDurationState extends _$FlashDurationState {
  @override
  int build() {
    return settingsRepository.current.flashDuration ?? 100;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.flashDuration = value);
  }
}

@riverpod
class FlashIntervalState extends _$FlashIntervalState {
  @override
  int build() {
    return settingsRepository.current.flashInterval ?? 1;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.flashInterval = value);
  }
}

@riverpod
class FlashColorState extends _$FlashColorState {
  @override
  int build() {
    return settingsRepository.current.flashColor ?? 0;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.flashColor = value);
  }
}

@riverpod
class ShowNavigationOverlayOnStartState
    extends _$ShowNavigationOverlayOnStartState {
  @override
  bool build() {
    return settingsRepository.current.showNavigationOverlayOnStart ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.showNavigationOverlayOnStart = value);
  }
}

@riverpod
class WebtoonDisableZoomOutState extends _$WebtoonDisableZoomOutState {
  @override
  bool build() {
    return settingsRepository.current.webtoonDisableZoomOut ?? false;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.webtoonDisableZoomOut = value);
  }
}

@riverpod
class WebtoonDoubleTapZoomEnabledState
    extends _$WebtoonDoubleTapZoomEnabledState {
  @override
  bool build() {
    return settingsRepository.current.webtoonDoubleTapZoomEnabled ?? true;
  }

  void set(bool value) {
    state = value;
    settingsRepository.update((s) => s.webtoonDoubleTapZoomEnabled = value);
  }
}

@riverpod
class ReaderHideThresholdState extends _$ReaderHideThresholdState {
  @override
  int build() {
    return settingsRepository.current.readerHideThreshold ?? 1;
  }

  void set(int value) {
    state = value;
    settingsRepository.update((s) => s.readerHideThreshold = value);
  }
}
