import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Service for handling page navigation in the manga reader.
///
/// Abstracts the complexity of navigating between different reader modes:
/// - Paged modes (vertical, LTR, RTL)
/// - Continuous modes (vertical continuous, webtoon, horizontal continuous)
class PageNavigationService {
  final ItemScrollController itemScrollController;
  final ExtendedPageController extendedController;

  const PageNavigationService({
    required this.itemScrollController,
    required this.extendedController,
  });

  /// Navigates to a specific page index.
  ///
  /// Parameters:
  /// - [index]: The target page index
  /// - [readerMode]: Current reader mode
  /// - [animate]: Whether to animate the transition
  void navigateToPage({
    required int index,
    required ReaderMode readerMode,
    required bool animate,
  }) {
    if (index < 0) return;

    if (_isContinuousMode(readerMode)) {
      _navigateContinuous(index, animate);
    } else {
      _navigatePaged(index, animate);
    }
  }

  /// Navigates to next page.
  void nextPage({
    required ReaderMode readerMode,
    required int currentIndex,
    required int maxPages,
    required bool animate,
  }) {
    if (currentIndex >= maxPages - 1) return;
    navigateToPage(
      index: currentIndex + 1,
      readerMode: readerMode,
      animate: animate,
    );
  }

  /// Navigates to previous page.
  void previousPage({
    required ReaderMode readerMode,
    required int currentIndex,
    required bool animate,
  }) {
    if (currentIndex <= 0) return;
    navigateToPage(
      index: currentIndex - 1,
      readerMode: readerMode,
      animate: animate,
    );
  }

  /// Jumps to a page without animation (for slider).
  void jumpToPage({required int index, required ReaderMode readerMode}) {
    if (index < 0) return;

    if (_isContinuousMode(readerMode)) {
      itemScrollController.jumpTo(index: index);
    } else {
      if (extendedController.hasClients) {
        extendedController.jumpToPage(index);
      }
    }
  }

  void _navigateContinuous(int index, bool animate) {
    if (animate) {
      itemScrollController.scrollTo(
        curve: Curves.ease,
        index: index,
        duration: const Duration(milliseconds: 150),
      );
    } else {
      itemScrollController.jumpTo(index: index);
    }
  }

  void _navigatePaged(int index, bool animate) {
    if (!extendedController.hasClients) return;

    if (animate) {
      extendedController.animateToPage(
        index,
        duration: const Duration(milliseconds: 150),
        curve: Curves.ease,
      );
    } else {
      extendedController.jumpToPage(index);
    }
  }

  bool _isContinuousMode(ReaderMode mode) {
    return mode == ReaderMode.verticalContinuous ||
        mode == ReaderMode.webtoon ||
        mode == ReaderMode.horizontalContinuous;
  }
}

/// Mixin to add page navigation capabilities to reader state.
mixin PageNavigationMixin<T extends StatefulWidget> on State<T> {
  PageNavigationService? _navigationService;

  /// Initializes the navigation service with the required controllers.
  void initPageNavigation({
    required ItemScrollController itemScrollController,
    required ExtendedPageController extendedController,
  }) {
    _navigationService = PageNavigationService(
      itemScrollController: itemScrollController,
      extendedController: extendedController,
    );
  }

  /// Gets the navigation service.
  PageNavigationService get navigationService {
    assert(
      _navigationService != null,
      'PageNavigationService not initialized. Call initPageNavigation first.',
    );
    return _navigationService!;
  }
}
