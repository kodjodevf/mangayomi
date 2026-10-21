import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shiori/shiori.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/l10n/generated/app_localizations.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';

/// The reader's on/off settings, described once: what each is called, what
/// it says under its name, and the setting it reads and writes. The reader's
/// own sheet and Settings › Reader both draw them from here, so the two can
/// no longer drift apart in wording or behaviour, as they had in style.
enum ReaderSwitch {
  cropBorders,
  webtoonDisableZoomOut,
  webtoonDoubleTapZoom,
  navigateToPan,
  splitWidePages,
  dualPageInvert,
  dualPageRotateToFit,
  dualPageRotateToFitInvert,
  doublePageSingleFirstPage,
  doublePageAuto,
  landscapeZoom,
  usePageTapZones,
  keepScreenOn,
  showPageGaps,
  flashOnPageChange,
  showNavigationOverlayOnStart,
  showPageNumber,
  animatePageTransitions,
  markDuplicateChaptersRead,
  volumeKeysPaging,
  volumeKeysInverted;

  String title(AppLocalizations l10n) => switch (this) {
    cropBorders => l10n.crop_borders,
    webtoonDisableZoomOut => l10n.webtoon_disable_zoom_out,
    webtoonDoubleTapZoom => l10n.webtoon_double_tap_zoom_enabled,
    navigateToPan => l10n.navigate_to_pan,
    splitWidePages => l10n.split_wide_pages,
    dualPageInvert => l10n.dual_page_invert,
    dualPageRotateToFit => l10n.dual_page_rotate_to_fit,
    dualPageRotateToFitInvert => l10n.dual_page_rotate_to_fit_invert,
    doublePageSingleFirstPage => l10n.double_page_single_first_page,
    doublePageAuto => l10n.double_page_auto,
    landscapeZoom => l10n.landscape_zoom,
    usePageTapZones => l10n.use_page_tap_zones,
    keepScreenOn => l10n.keep_screen_on,
    showPageGaps => l10n.show_page_gaps,
    flashOnPageChange => l10n.flash_on_page_change,
    showNavigationOverlayOnStart => l10n.show_navigation_overlay_on_start,
    showPageNumber => l10n.show_page_number,
    animatePageTransitions => l10n.animate_page_transitions,
    markDuplicateChaptersRead => l10n.mark_duplicate_chapters_read,
    volumeKeysPaging => l10n.volume_keys_paging,
    volumeKeysInverted => l10n.volume_keys_inverted,
  };

  String? subtitle(AppLocalizations l10n) => switch (this) {
    navigateToPan => l10n.navigate_to_pan_subtitle,
    doublePageSingleFirstPage => l10n.double_page_single_first_page_subtitle,
    doublePageAuto => l10n.double_page_auto_subtitle,
    flashOnPageChange => l10n.flash_on_page_change_subtitle,
    // iOS can only watch the volume, and says what that does to it.
    volumeKeysPaging => Platform.isIOS ? l10n.volume_keys_paging_ios : null,
    _ => null,
  };

  bool watch(WidgetRef ref) => switch (this) {
    cropBorders => ref.watch(cropBordersStateProvider),
    webtoonDisableZoomOut => ref.watch(webtoonDisableZoomOutStateProvider),
    webtoonDoubleTapZoom => ref.watch(webtoonDoubleTapZoomEnabledStateProvider),
    navigateToPan => ref.watch(navigateToPanStateProvider),
    splitWidePages => ref.watch(splitWidePagesStateProvider),
    dualPageInvert => ref.watch(dualPageInvertStateProvider),
    dualPageRotateToFit => ref.watch(dualPageRotateToFitStateProvider),
    dualPageRotateToFitInvert => ref.watch(
      dualPageRotateToFitInvertStateProvider,
    ),
    doublePageSingleFirstPage => ref.watch(
      doublePageSingleFirstPageStateProvider,
    ),
    doublePageAuto => ref.watch(doublePageAutoStateProvider),
    landscapeZoom => ref.watch(landscapeZoomStateProvider),
    usePageTapZones => ref.watch(usePageTapZonesStateProvider),
    keepScreenOn => ref.watch(keepScreenOnReaderStateProvider),
    showPageGaps => ref.watch(showPageGapsStateProvider),
    flashOnPageChange => ref.watch(flashOnPageChangeStateProvider),
    showNavigationOverlayOnStart => ref.watch(
      showNavigationOverlayOnStartStateProvider,
    ),
    showPageNumber => ref.watch(showPagesNumberStateProvider),
    animatePageTransitions => ref.watch(animatePageTransitionsStateProvider),
    markDuplicateChaptersRead => ref.watch(
      autoReadDuplicateChaptersStateProvider,
    ),
    volumeKeysPaging => ref.watch(volumeKeysPagingStateProvider),
    volumeKeysInverted => ref.watch(volumeKeysInvertedStateProvider),
  };

  void set(WidgetRef ref, bool value) {
    switch (this) {
      case cropBorders:
        ref.read(cropBordersStateProvider.notifier).set(value);
      case webtoonDisableZoomOut:
        ref.read(webtoonDisableZoomOutStateProvider.notifier).set(value);
      case webtoonDoubleTapZoom:
        ref.read(webtoonDoubleTapZoomEnabledStateProvider.notifier).set(value);
      case navigateToPan:
        ref.read(navigateToPanStateProvider.notifier).set(value);
      case splitWidePages:
        ref.read(splitWidePagesStateProvider.notifier).set(value);
      case dualPageInvert:
        ref.read(dualPageInvertStateProvider.notifier).set(value);
      case dualPageRotateToFit:
        ref.read(dualPageRotateToFitStateProvider.notifier).set(value);
      case dualPageRotateToFitInvert:
        ref.read(dualPageRotateToFitInvertStateProvider.notifier).set(value);
      case doublePageSingleFirstPage:
        ref.read(doublePageSingleFirstPageStateProvider.notifier).set(value);
      case doublePageAuto:
        ref.read(doublePageAutoStateProvider.notifier).set(value);
      case landscapeZoom:
        ref.read(landscapeZoomStateProvider.notifier).set(value);
      case usePageTapZones:
        ref.read(usePageTapZonesStateProvider.notifier).set(value);
      case keepScreenOn:
        ref.read(keepScreenOnReaderStateProvider.notifier).set(value);
      case showPageGaps:
        ref.read(showPageGapsStateProvider.notifier).set(value);
      case flashOnPageChange:
        ref.read(flashOnPageChangeStateProvider.notifier).set(value);
      case showNavigationOverlayOnStart:
        ref.read(showNavigationOverlayOnStartStateProvider.notifier).set(value);
      case showPageNumber:
        ref.read(showPagesNumberStateProvider.notifier).set(value);
      case animatePageTransitions:
        ref.read(animatePageTransitionsStateProvider.notifier).set(value);
      case markDuplicateChaptersRead:
        ref.read(autoReadDuplicateChaptersStateProvider.notifier).set(value);
      case volumeKeysPaging:
        ref.read(volumeKeysPagingStateProvider.notifier).set(value);
      case volumeKeysInverted:
        ref.read(volumeKeysInvertedStateProvider.notifier).set(value);
    }
  }
}

/// One [ReaderSwitch] as a settings row.
class ReaderSwitchRow extends ConsumerWidget {
  const ReaderSwitchRow(this.option, {super.key});

  final ReaderSwitch option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final subtitle = option.subtitle(l10n);
    return ShioriSwitchRow(
      value: option.watch(ref),
      title: option.title(l10n),
      subtitle: subtitle,
      onChanged: (value) => option.set(ref, value),
    );
  }
}
