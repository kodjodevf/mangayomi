import 'package:flutter/material.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// Service for handling page navigation in the manga reader.
///
/// Abstracts the complexity of navigating between different reader modes:
/// - Paged modes (vertical, LTR, RTL)
/// - Continuous modes (vertical continuous, webtoon, horizontal continuous)
class PageNavigationService {
  final ListController listController;
  final ScrollController continuousScrollController;
  final PageController extendedController;

  const PageNavigationService({
    required this.listController,
    required this.continuousScrollController,
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

    if (readerMode.isContinuous) {
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

    if (readerMode.isContinuous) {
      if (listController.isAttached && continuousScrollController.hasClients) {
        listController.jumpToItem(
          index: index,
          scrollController: continuousScrollController,
          alignment: 0.0,
        );
      }
    } else {
      if (extendedController.hasClients) {
        extendedController.jumpToPage(index);
      }
    }
  }

  void _navigateContinuous(int index, bool animate) {
    if (!listController.isAttached || !continuousScrollController.hasClients) {
      return;
    }

    if (animate) {
      // ignore: invalid_use_of_visible_for_testing_member
      final offset = listController.getOffsetToReveal(index, 0.0);
      if (offset.isFinite) {
        final minExtent = continuousScrollController.position.minScrollExtent;
        final maxExtent = continuousScrollController.position.maxScrollExtent;
        final clampedOffset = offset.clamp(minExtent, maxExtent);
        continuousScrollController.animateTo(
          clampedOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
        );
      } else {
        listController.jumpToItem(
          index: index,
          scrollController: continuousScrollController,
          alignment: 0.0,
        );
      }
    } else {
      listController.jumpToItem(
        index: index,
        scrollController: continuousScrollController,
        alignment: 0.0,
      );
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
}

/// Mixin to add page navigation capabilities to reader state.
mixin PageNavigationMixin<T extends StatefulWidget> on State<T> {
  PageNavigationService? _navigationService;

  /// Initializes the navigation service with the required controllers.
  void initPageNavigation({
    required ListController listController,
    required ScrollController continuousScrollController,
    required PageController extendedController,
  }) {
    _navigationService = PageNavigationService(
      listController: listController,
      continuousScrollController: continuousScrollController,
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
