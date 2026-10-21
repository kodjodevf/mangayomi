import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_double_page_mixin.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_zoom_control.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/services/volume_keys.dart';

/// Handles hardware volume keys, desktop wheel navigation, e-ink page-turn
/// flashing, and zoomed/paged/webtoon page navigation for the manga reader.
mixin ReaderInputAndModeMixin<T extends ConsumerStatefulWidget>
    on
        ConsumerState<T>,
        ReaderMemoryManagement,
        ReaderDoublePageMixin<T>,
        ReaderZoomControl<T>,
        PageNavigationMixin<T> {
  int _flashPageCount = 0;
  bool isFlashing = false;
  Color flashOverlayColor = Colors.black;
  bool showNavigationOverlay = false;

  ScrollController get inputContinuousScrollController;
  bool get isReverseHorizontalForInput;

  /// When the wheel last turned a page, so one flick of it turns one page
  /// rather than every notch of a trackpad's inertia.
  DateTime _lastWheelTurn = DateTime.fromMillisecondsSinceEpoch(0);

  void triggerFlash() async {
    if (!mounted) return;
    final flashOn = ref.read(flashOnPageChangeStateProvider);
    if (!flashOn) return;

    final interval = ref.read(flashIntervalStateProvider);
    _flashPageCount++;
    if (_flashPageCount % interval != 0) return;

    final durationMs = ref.read(flashDurationStateProvider);
    final colorOption = ref.read(flashColorStateProvider);

    setState(() {
      isFlashing = true;
      flashOverlayColor = colorOption == 0 ? Colors.black : Colors.white;
    });

    if (colorOption == 2) {
      await Future.delayed(Duration(milliseconds: durationMs ~/ 2));
      if (!mounted) return;
      setState(() {
        flashOverlayColor = Colors.black;
      });
      await Future.delayed(Duration(milliseconds: durationMs ~/ 2));
    } else {
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    if (!mounted) return;
    setState(() {
      isFlashing = false;
    });
  }

  void handlePageNavigation({required bool forward}) {
    final readerMode = activeReaderMode;
    final animatePageTransitions = ref.read(
      animatePageTransitionsStateProvider,
    );
    final curIdx = currentDoublePageViewIndex;
    if (readerMode == null || curIdx == null) return;

    if (readerMode == ReaderMode.webtoon) {
      final isHorizontal = readerMode.isHorizontalContinuous;
      final viewportSize = MediaQuery.sizeOf(context);
      final dimension = isHorizontal ? viewportSize.width : viewportSize.height;
      final offset = dimension * 0.60 * (forward ? 1 : -1);
      final duration = animatePageTransitions
          ? const Duration(milliseconds: 160)
          : const Duration(milliseconds: 10);
      if (inputContinuousScrollController.hasClients) {
        final target = (inputContinuousScrollController.offset + offset).clamp(
          inputContinuousScrollController.position.minScrollExtent,
          inputContinuousScrollController.position.maxScrollExtent,
        );
        inputContinuousScrollController.animateTo(
          target,
          duration: duration,
          curve: Curves.easeInOut,
        );
      }
      return;
    }

    final navigateToPan = ref.read(navigateToPanStateProvider);
    final actualIdx = pageViewToActualIndex(curIdx);
    final controller = pageControllers[actualIdx];
    if (navigateToPan && controller != null && controller.isReady) {
      if (forward) {
        if (isReverseHorizontalForInput) {
          if (controller.canPanLeft()) {
            controller.panLeft();
            return;
          }
        } else {
          if (controller.canPanRight()) {
            controller.panRight();
            return;
          }
        }
      } else {
        if (isReverseHorizontalForInput) {
          if (controller.canPanRight()) {
            controller.panRight();
            return;
          }
        } else {
          if (controller.canPanLeft()) {
            controller.panLeft();
            return;
          }
        }
      }
    }

    if (forward) {
      navigationService.nextPage(
        readerMode: readerMode,
        currentIndex: curIdx,
        maxPages: pageViewPageCount,
        animate: animatePageTransitions,
      );
    } else {
      navigationService.previousPage(
        readerMode: readerMode,
        currentIndex: curIdx,
        animate: animatePageTransitions,
      );
    }
  }

  /// Turns the page forward or back, panning first across a zoomed double
  /// spread, as the keyboard and the tap zones do.
  void turnPage({required bool forward}) {
    final curIdx = currentDoublePageViewIndex;
    final zoomedSpread =
        isCurrentPageZoomed && doublePageControllers[curIdx] != null;
    if (zoomedSpread) {
      forward ? handleNextPageZoomed() : handlePreviousPageZoomed();
    } else {
      handlePageNavigation(forward: forward);
    }
  }

  /// Takes the volume buttons for page turns while [on]: volume down turns
  /// forward, volume up back, unless the reader inverted them.
  void setVolumeKeys(bool on) {
    if (!on) {
      VolumeKeys.disable();
      return;
    }
    VolumeKeys.enable((up) {
      if (!mounted) return;
      final inverted = ref.read(volumeKeysInvertedStateProvider);
      turnPage(forward: inverted ? up : !up);
    });
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || isCurrentPageZoomed) return;
    final delta = event.scrollDelta.dy.abs() >= event.scrollDelta.dx.abs()
        ? event.scrollDelta.dy
        : event.scrollDelta.dx;
    if (delta.abs() < 4) return;
    final now = DateTime.now();
    if (now.difference(_lastWheelTurn) < const Duration(milliseconds: 250)) {
      return;
    }
    _lastWheelTurn = now;
    handlePageNavigation(forward: delta > 0);
  }
}
