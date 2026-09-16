import 'dart:async';
import 'dart:io';

import 'package:mangayomi/repositories/settings_repository.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/services/downloaded_chapter.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
import 'package:mangayomi/modules/library/providers/file_scanner.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_overlays.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_page_content.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_settings_modal.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/double_page_zoom_pan.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

typedef DoubleClickAnimationListener = void Function();

class MangaReaderView extends ConsumerWidget {
  final int chapterId;
  const MangaReaderView({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final chapterData = ref.watch(mangaReaderProvider(chapterId));

    return chapterData.when(
      loading: () => scaffoldWith(context, const ProgressCenter()),
      error: (error, _) {
        if (chapterData.isRefreshing || chapterData.isReloading) {
          return scaffoldWith(context, const ProgressCenter());
        }
        return scaffoldWith(
          context,
          ErrorState(
            detail: error.toString(),
            onRetry: () => ref.invalidate(mangaReaderProvider(chapterId)),
          ),
        );
      },
      data: (data) {
        final chapter = data.chapter;
        final model = data.pages;

        if (model.pageUrls.isEmpty &&
            !(chapter.manga.value?.isLocalArchive ?? false)) {
          return scaffoldWith(
            context,
            Center(child: Text(l10n.error_no_pages_available)),
            restoreUi: true,
          );
        }

        return MangaChapterPageGallery(
          chapter: chapter,
          chapterUrlModel: model,
        );
      },
    );
  }

  Widget scaffoldWith(
    BuildContext context,
    Widget body, {
    bool restoreUi = false,
  }) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(''),
        // scaffoldWith is only the loading / error / no-pages states, whose
        // bodies have nothing focusable. Without this the d-pad has no starting
        // point on TV and cannot even reach the back button. IconButton, not
        // BackButton, because only IconButton takes autofocus.
        leading: IconButton(
          autofocus: isTv,
          icon: const BackButtonIcon(),
          onPressed: () {
            if (restoreUi) {
              restoreSystemUI();
            }
            Navigator.of(context).pop();
          },
        ),
      ),
      body: body,
    );
  }
}

class MangaChapterPageGalleryState {
  static void setNavigatingToChapter() {
    _MangaChapterPageGalleryState._isNavigatingToChapter = true;
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery({
    super.key,
    required this.chapter,
    required this.chapterUrlModel,
  });
  final GetChapterPagesModel chapterUrlModel;

  final Chapter chapter;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState
    extends ConsumerState<MangaChapterPageGallery>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        ReaderMemoryManagement,
        PageNavigationMixin {
  late ReaderController _readerController = ref.read(
    readerControllerProvider(chapter: chapter).notifier,
  );

  final Stopwatch _readingStopwatch = Stopwatch();
  int? _discordReaderSession;

  /// Flag to prevent fullscreen from being disabled when navigating between
  /// chapters via pushReplacement. The old widget's dispose runs after the new
  /// widget is created, which would clobber the new reader's fullscreen state.
  static bool _isNavigatingToChapter = false;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _readingStopwatch.stop();
    _readerController.setHistoryUpdate(
      elapsedSeconds: _readingStopwatch.elapsed.inSeconds,
    );
    _rebuildDetail.close();

    _failedPageIndexes.dispose();
    _currentPageViewIndex.dispose();
    _panAnimator.dispose();
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _currentPageDisplayIndex.dispose();
    _keyboardFocusNode.dispose();
    _itemPositionsListener.itemPositions.removeListener(_readProgressListener);

    _extendedController.dispose();
    if (_isNavigatingToChapter) {
      _isNavigatingToChapter = false;
    } else if (isDesktop) {
      setFullScreen(value: false);
    } else {
      restoreSystemUI();
    }
    final discordReaderSession = _discordReaderSession;
    if (discordReaderSession != null) {
      unawaited(discordRpc?.endReaderSession(discordReaderSession));
    }
    final actualIdx = _pageViewToActualIndexSync(_currentIndex!);
    final index = pages[actualIdx].index;
    if (index != null) {
      _readerController.setPageIndex(index, true, _chapterUrlModel.pageUrls);
    }
    for (final controller in _pageControllers.values) {
      controller.dispose();
    }
    _pageControllers.clear();
    disposePreloadManager();
    _readerController.keepAliveLink?.close();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _readingStopwatch.stop();
      if (keepOn) {
        WakelockPlus.disable();
      }
      final actualIdx = _pageViewToActualIndex(_currentIndex!);
      final index = pages[actualIdx].index;
      if (index != null) {
        _readerController.setPageIndex(index, true, _chapterUrlModel.pageUrls);
      }
    } else if (state == AppLifecycleState.resumed) {
      _readingStopwatch.start();
      if (keepOn) {
        WakelockPlus.enable();
      }
    }
  }

  late final _autoScroll = ValueNotifier(
    _readerController.autoScrollValues().$1,
  );
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);
  late GetChapterPagesModel _chapterUrlModel = widget.chapterUrlModel;

  late Chapter chapter = widget.chapter;

  final _failedPageIndexes = ValueNotifier<Set<int>>({});

  void _onFailedToLoadImage(int index, bool failed) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = Set<int>.from(_failedPageIndexes.value);
      final bool changed = failed ? current.add(index) : current.remove(index);
      if (changed) {
        _failedPageIndexes.value = current;
      }
    });
  }

  late ReaderMode _cachedReaderMode = _readerController.getReaderMode();
  late PageMode _pageMode = _readerController.getPageMode();
  late final _currentReaderMode = StateProvider<ReaderMode?>(
    () => _cachedReaderMode,
  );

  late int? _currentIndex = () {
    final saved = _readerController.getPageIndex();
    if (_isDoublePageActiveSync) {
      return _actualToPageViewIndexSync(saved);
    }
    return saved;
  }();
  late final ValueNotifier<int?> _currentPageViewIndex = ValueNotifier(
    _currentIndex,
  );
  late final ValueNotifier<int> _currentPageDisplayIndex = ValueNotifier(
    _readerController.getPageIndex(),
  );

  late final ItemScrollController _itemScrollController =
      ItemScrollController();
  final ScrollOffsetController _pageOffsetController = ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    _readingStopwatch.start();

    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    initPageNavigation(
      itemScrollController: _itemScrollController,
      extendedController: _extendedController,
    );
    _initCurrentIndex();
    _discordReaderSession = discordRpc?.beginReaderSession();
    discordRpc?.showChapterDetails(ref, chapter);
    WidgetsBinding.instance.addObserver(this);
    _initWakelock();
  }

  void _initWakelock() {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  // final double _horizontalScaleValue = 1.0; TODO
  bool _isNextChapterPreloading = false;
  int _prefetchSessionId = 0;
  // bool _isPrevChapterPreloading = false; TODO

  int get pagePreloadAmount => ref.read(pagePreloadAmountStateProvider);
  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isLastPageTransition = false;
  bool _isView = false;
  final _keyboardFocusNode = FocusNode();
  final List<int> _cropBorderCheckList = [];
  final Map<int, ssiv.SubsamplingScaleImageViewController> _pageControllers =
      {};

  int _flashPageCount = 0;
  bool _isFlashing = false;
  Color _flashOverlayColor = Colors.black;
  bool _showNavigationOverlay = false;
  bool _isCurrentPageZoomed = false;
  final Map<int, PhotoViewController> _doublePageControllers = {};
  late final _panAnimator = DoublePagePanAnimator(this);
  static const _zoomNav = DoublePageZoomNavigation();

  void _handleNextPageZoomed() {
    final controller = _doublePageControllers[_currentIndex];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;

    final targetDx = _zoomNav.nextPanTarget(
      dx: controller.position.dx,
      maxX: maxX,
      step: screenWidth * 0.4,
      isReverseHorizontal: _isReverseHorizontal,
    );
    if (targetDx == null) {
      _handlePageNavigation(forward: true);
    } else {
      _panAnimator.animateTo(
        controllerLookup: () => _doublePageControllers[_currentIndex],
        targetDx: targetDx,
      );
    }
  }

  void _handlePreviousPageZoomed() {
    final controller = _doublePageControllers[_currentIndex];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;

    final targetDx = _zoomNav.previousPanTarget(
      dx: controller.position.dx,
      maxX: maxX,
      step: screenWidth * 0.4,
      isReverseHorizontal: _isReverseHorizontal,
    );
    if (targetDx == null) {
      _handlePageNavigation(forward: false);
    } else {
      _panAnimator.animateTo(
        controllerLookup: () => _doublePageControllers[_currentIndex],
        targetDx: targetDx,
      );
    }
  }

  void _updateZoomStateForIndex(int index) {
    if (!mounted) return;
    if (index != _pageViewToActualIndex(_currentIndex ?? 0)) return;
    final controller = _pageControllers[index];
    if (controller == null) return;
    final bool isZoomed = controller.scale > controller.minScale * 1.01;
    if (_isCurrentPageZoomed != isZoomed) {
      setState(() {
        _isCurrentPageZoomed = isZoomed;
      });
    }
  }

  void _triggerFlash() async {
    if (!mounted) return;
    final flashOn = ref.read(flashOnPageChangeStateProvider);
    if (!flashOn) return;

    final interval = ref.read(flashIntervalStateProvider);
    _flashPageCount++;
    if (_flashPageCount % interval != 0) return;

    final durationMs = ref.read(flashDurationStateProvider);
    final colorOption = ref.read(flashColorStateProvider);

    setState(() {
      _isFlashing = true;
      _flashOverlayColor = colorOption == 0 ? Colors.black : Colors.white;
    });

    if (colorOption == 2) {
      await Future.delayed(Duration(milliseconds: (durationMs ~/ 2)));
      if (!mounted) return;
      setState(() {
        _flashOverlayColor = Colors.black;
      });
      await Future.delayed(Duration(milliseconds: (durationMs ~/ 2)));
    } else {
      await Future.delayed(Duration(milliseconds: durationMs));
    }

    if (!mounted) return;
    setState(() {
      _isFlashing = false;
    });
  }

  late final _extendedController = PageController(initialPage: _currentIndex!);

  Axis _scrollDirection = Axis.vertical;
  bool _isReverseHorizontal = false;

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9);

  void _setFullScreen({bool? value}) async {
    if (isDesktop) {
      value = await windowManager.isFullScreen();
      setFullScreen(value: !value);
    }
    ref.read(fullScreenReaderStateProvider.notifier).set(!value!);
  }

  /// Goes to either next or previous chapter
  ///
  /// The [next] parameter determines the navigation direction:
  /// - `true` -> navigate to next chapter
  /// - `false` -> navigate to previous chapter
  ///
  /// If the reader is already at the first or last chapter (depending on
  /// the direction), the method returns without navigating.
  void _goToChapter(bool next) {
    if (next && !_readerController.hasNextChapter) return;
    if (!next && !_readerController.hasPreviousChapter) return;
    _isNavigatingToChapter = true;
    try {
      pushReplacementMangaReaderView(
        context: context,
        chapter: next
            ? _readerController.getNextChapter()
            : _readerController.getPrevChapter(),
      );
    } catch (_) {
      // If the replacement fails, dispose() never runs to reset this flag, so reset it here instead.
      _isNavigatingToChapter = false;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final readerMode = ref.watch(_currentReaderMode);
    if (readerMode == null) return const SizedBox.shrink();
    ref.listen<bool>(doublePageSingleFirstPageStateProvider, (previous, next) {
      if (previous != null &&
          previous != next &&
          _isDoublePageActive &&
          mounted) {
        final currentActual = _currentPageDisplayIndex.value;
        final newPvIndex = next
            ? (currentActual <= 0 ? 0 : (currentActual + 1) ~/ 2)
            : currentActual ~/ 2;
        _currentIndex = newPvIndex;
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          navigationService.jumpToPage(
            index: newPvIndex,
            readerMode: ref.read(_currentReaderMode)!,
          );
        });
      }
    });

    return ReaderKeyboardHandler(
      onPreviousPage: () {
        if (_isCurrentPageZoomed &&
            _doublePageControllers[_currentIndex] != null) {
          _handlePreviousPageZoomed();
        } else {
          _handlePageNavigation(forward: false);
        }
      },
      onNextPage: () {
        if (_isCurrentPageZoomed &&
            _doublePageControllers[_currentIndex] != null) {
          _handleNextPageZoomed();
        } else {
          _handlePageNavigation(forward: true);
        }
      },
      onEscape: () => _goBack(context),
      onFullScreen: () => _setFullScreen(),
      onNextChapter: () => _goToChapter(true),
      onPreviousChapter: () => _goToChapter(false),
    ).wrapWithKeyboardListener(
      isReverseHorizontal: _isReverseHorizontal,
      focusNode: _keyboardFocusNode,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final delta = notification.scrollDelta ?? 0.0;
            final thresholdIdx = ref.read(readerHideThresholdStateProvider);
            final double threshold = switch (thresholdIdx) {
              0 => 5.0,
              1 => 13.0,
              2 => 31.0,
              _ => 47.0,
            };
            if (delta.abs() > threshold && _isView) {
              _isViewFunction();
            }
          }
          return true;
        },
        child: Material(
          child: SafeArea(
            top: !fullScreenReader,
            bottom: false,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _failedPageIndexes,
                _currentPageViewIndex,
                _currentPageDisplayIndex,
              ]),
              builder: (context, child) {
                final failedPageIndexes = _failedPageIndexes.value;
                final curPvIndex = _currentPageViewIndex.value ?? 0;
                final curActualIndex = _currentPageDisplayIndex.value;
                final bool hasCurrentError =
                    failedPageIndexes.contains(curPvIndex) ||
                    failedPageIndexes.contains(curActualIndex);
                return Stack(
                  children: [
                    ReaderPageContent(
                      pages: pages,
                      chapter: widget.chapter,
                      readerMode: readerMode,
                      pageMode: _pageMode,
                      backgroundColor: backgroundColor,
                      pagePreloadAmount: pagePreloadAmount,
                      initialScrollIndex: _currentIndex!,
                      currentPageViewIndex: _currentIndex!,
                      pageViewPageCount: _pageViewPageCount,
                      isReverseHorizontal: _isReverseHorizontal,
                      isCurrentPageZoomed: _isCurrentPageZoomed,
                      itemScrollController: _itemScrollController,
                      scrollOffsetController: _pageOffsetController,
                      itemPositionsListener: _itemPositionsListener,
                      extendedController: _extendedController,
                      scrollDirection: _scrollDirection,
                      pageControllerFor: (index) =>
                          _pageControllers.putIfAbsent(
                            index,
                            () => ssiv.SubsamplingScaleImageViewController()
                              ..addListener(
                                () => _updateZoomStateForIndex(index),
                              ),
                          ),
                      onFailedToLoadImage: _onFailedToLoadImage,
                      onWidePage: _splitWidePage,
                      onWideSinglePageLoaded: (index) {
                        Future.delayed(const Duration(milliseconds: 600), () {
                          setState(() {});
                        });
                      },
                      onDoublePageZoomChanged: (index, zoomed) {
                        if (index == _currentIndex) {
                          if (mounted && _isCurrentPageZoomed != zoomed) {
                            setState(() {
                              _isCurrentPageZoomed = zoomed;
                            });
                          }
                        }
                      },
                      onDoublePageControllerCreated: (index, controller) {
                        if (controller != null) {
                          _doublePageControllers[index] = controller;
                        } else {
                          _doublePageControllers.remove(index);
                        }
                      },
                      onPageChanged: _onPageChanged,
                    ),
                    ReaderOverlays(
                      isReverseHorizontal: _isReverseHorizontal,
                      hasCurrentPageImageError: hasCurrentError,
                      isContinuousMode: readerMode.isContinuous,
                      onToggleUI: _isViewFunction,
                      onPreviousPage: () {
                        if (_isCurrentPageZoomed &&
                            _doublePageControllers[_currentIndex] != null) {
                          _handlePreviousPageZoomed();
                        } else {
                          _handlePageNavigation(forward: false);
                        }
                      },
                      onNextPage: () {
                        if (_isCurrentPageZoomed &&
                            _doublePageControllers[_currentIndex] != null) {
                          _handleNextPageZoomed();
                        } else {
                          _handlePageNavigation(forward: true);
                        }
                      },
                      isFlashing: _isFlashing,
                      flashOverlayColor: _flashOverlayColor,
                      showNavigationOverlay: _showNavigationOverlay,
                      onCloseNavigationOverlay: () {
                        setState(() {
                          _showNavigationOverlay = false;
                        });
                      },
                    ),
                    ReaderAppBar(
                      chapter: chapter,
                      mangaName: _readerController.getMangaName(),
                      chapterTitle: _readerController.getChapterTitle(),
                      isVisible: _isView,
                      isBookmarked: _isBookmarked,
                      backgroundColor: _backgroundColor,
                      onBackPressed: () => Navigator.pop(context),
                      onBookmarkPressed: () {
                        _readerController.setChapterBookmarked();
                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });
                      },
                      onWebViewPressed:
                          (chapter.manga.value!.isLocalArchive ?? false) ==
                              false
                          ? () {
                              final data = buildWebViewData(chapter);
                              if (data != null) {
                                context.push("/mangawebview", extra: data);
                              }
                            }
                          : null,
                    ),
                    ReaderBottomBar(
                      chapter: chapter,
                      isVisible: _isView,
                      hasPreviousChapter: _readerController.hasPreviousChapter,
                      hasNextChapter: _readerController.hasNextChapter,
                      onPreviousChapter: () => _goToChapter(false),
                      onNextChapter: () => _goToChapter(true),
                      onSliderChanged: (value, ref) {
                        _currentPageDisplayIndex.value = value;
                        ref
                            .read(currentIndexProvider(chapter).notifier)
                            .setCurrentIndex(value);
                      },
                      onSliderChangeEnd: (value) {
                        try {
                          final page = pages.firstWhere(
                            (element) =>
                                element.chapter == chapter &&
                                element.index == value,
                          );
                          int jumpIndex = page.pageIndex!;
                          // In double page mode, convert array index to page view index
                          if (_isDoublePageActive) {
                            jumpIndex = _actualToPageViewIndex(jumpIndex);
                          }
                          _currentIndex = jumpIndex;
                          _currentPageViewIndex.value = jumpIndex;
                          navigationService.jumpToPage(
                            index: jumpIndex,
                            readerMode: ref.read(_currentReaderMode)!,
                          );
                        } catch (_) {}
                      },
                      onReaderModeChanged: (mode, ref) {
                        ref.read(_currentReaderMode.notifier).state = mode;
                        _setReaderMode(mode, ref);
                      },
                      onPageModeToggle: () async {
                        final readerMode = ref.read(_currentReaderMode);
                        if (!(readerMode?.isHorizontalContinuous ?? false)) {
                          final currentActual = _currentPageDisplayIndex.value;
                          final PageMode newPageMode =
                              _pageMode == PageMode.onePage
                              ? PageMode.doublePage
                              : PageMode.onePage;
                          _readerController.setPageMode(newPageMode);

                          final singleFirst = ref.read(
                            doublePageSingleFirstPageStateProvider,
                          );
                          final int targetIndex;
                          if (newPageMode == PageMode.doublePage) {
                            targetIndex = singleFirst
                                ? (currentActual <= 0
                                      ? 0
                                      : (currentActual + 1) ~/ 2)
                                : currentActual ~/ 2;
                          } else {
                            targetIndex = currentActual;
                          }

                          _currentIndex = targetIndex;
                          _currentPageViewIndex.value = targetIndex;
                          if (mounted) {
                            setState(() {
                              _pageMode = newPageMode;
                            });
                          }

                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            navigationService.jumpToPage(
                              index: targetIndex,
                              readerMode: ref.read(_currentReaderMode)!,
                            );
                          });
                        }
                      },
                      onSettingsPressed: () => ReaderSettingsModal.show(
                        context: context,
                        vsync: this,
                        currentReaderModeProvider: _currentReaderMode,
                        autoScroll: _autoScroll,
                        autoScrollPage: _autoScrollPage,
                        pageOffset: _pageOffset,
                        onAutoPageScroll: _autoPagescroll,
                        onReaderModeChanged: (mode, widgetRef) {
                          widgetRef.read(_currentReaderMode.notifier).state =
                              mode;
                          _setReaderMode(mode, widgetRef);
                        },
                        onAutoScrollSave: (enabled, offset) {
                          _readerController.setAutoScroll(enabled, offset);
                        },
                        onFullScreenToggle: () {
                          final fullScreen = ref.read(
                            fullScreenReaderStateProvider,
                          );
                          _setFullScreen(value: !fullScreen);
                        },
                      ),
                      currentReaderModeProvider: _currentReaderMode,
                      currentPageListenable: _currentPageDisplayIndex,
                      currentPageMode: _pageMode,
                      isReverseHorizontal: _isReverseHorizontal,
                      totalPages: _readerController.getPageLength(
                        _chapterUrlModel.pageUrls,
                      ),
                      currentIndexLabel: _currentIndexLabel,
                      backgroundColor: _backgroundColor,
                    ),
                    PageIndicator(
                      isUiVisible: _isView,
                      currentPageListenable: _currentPageDisplayIndex,
                      totalPages: _readerController.getPageLength(
                        _chapterUrlModel.pageUrls,
                      ),
                      formatCurrentIndex: _currentIndexLabel,
                    ),
                    ReaderAutoScrollButton(
                      isContinuousMode: readerMode.isContinuous,
                      isUiVisible: _isView,
                      autoScrollPage: _autoScrollPage,
                      autoScroll: _autoScroll,
                      onToggle: () {
                        _autoPagescroll();
                        _autoScroll.value = !_autoScroll.value;
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _splitWidePage(int index, double width, double height) {
    if (index < 0 || index >= pages.length) return;
    final page = pages[index];
    if (page.srcRect != null || page.isTransitionPage) return;

    final isRTL = _isReverseHorizontal;
    final dualPageInvert = ref.read(dualPageInvertStateProvider);
    final shouldInvert = isRTL ^ dualPageInvert;
    final halfWidth = width / 2;

    final Rect firstRect;
    final Rect secondRect;

    if (shouldInvert) {
      firstRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(0, 0, halfWidth, height);
    } else {
      firstRect = Rect.fromLTWH(0, 0, halfWidth, height);
      secondRect = Rect.fromLTWH(halfWidth, 0, halfWidth, height);
    }

    final page1 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: firstRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    final page2 =
        UChapDataPreload(
            page.chapter,
            page.directory,
            page.pageUrl,
            page.isLocale,
            page.archiveImage,
            page.index,
            page.chapterUrlModel,
            page.pageIndex,
            srcRect: secondRect,
            localImagePath: page.localImagePath,
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    setState(() {
      preloadManager.splitPage(index, page1, page2);
    });
  }

  void _handlePageNavigation({required bool forward}) {
    final readerMode = ref.read(_currentReaderMode);
    final animatePageTransitions = ref.read(
      animatePageTransitionsStateProvider,
    );
    if (readerMode == null || _currentIndex == null) return;

    if (readerMode == ReaderMode.webtoon) {
      final isHorizontal = readerMode.isHorizontalContinuous;
      final viewportSize = MediaQuery.sizeOf(context);
      final dimension = isHorizontal ? viewportSize.width : viewportSize.height;
      final offset = dimension * 0.60 * (forward ? 1 : -1);
      final duration = animatePageTransitions
          ? const Duration(milliseconds: 160)
          : const Duration(milliseconds: 10);
      _pageOffsetController.animateScroll(
        offset: offset,
        duration: duration,
        curve: Curves.easeInOut,
      );
      return;
    }

    final navigateToPan = ref.read(navigateToPanStateProvider);
    final actualIdx = _pageViewToActualIndex(_currentIndex!);
    final controller = _pageControllers[actualIdx];
    if (navigateToPan && controller != null && controller.isReady) {
      if (forward) {
        if (_isReverseHorizontal) {
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
        if (_isReverseHorizontal) {
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
        currentIndex: _currentIndex!,
        maxPages: _pageViewPageCount,
        animate: animatePageTransitions,
      );
    } else {
      navigationService.previousPage(
        readerMode: readerMode,
        currentIndex: _currentIndex!,
        animate: animatePageTransitions,
      );
    }
  }

  /// Handles scroll-based page changes in continuous mode (vertical or horizontal).
  ///
  /// Responsibilities:
  /// - Determine the first visible item from the scroll position listener.
  /// - Detect page changes and trigger flash animation.
  /// - Update chapter when scrolling into a page from another chapter.
  /// - Trigger next-chapter preloading when nearing the end.
  /// - Update display index and persist progress.
  ///
  /// This is the continuous-mode equivalent of `_onPageChanged`, but optimized
  /// for list-based scrolling instead of discrete PageView swipes.
  void _readProgressListener() async {
    final itemPositions = _itemPositionsListener.itemPositions.value;
    if (itemPositions.isEmpty) return;
    final newIndex = itemPositions.first.index;
    final bool pageChanged = _currentIndex != newIndex;
    _currentIndex = newIndex;
    _currentPageViewIndex.value = newIndex;
    if (pageChanged) _triggerFlash();
    final currentReaderMode = ref.read(_currentReaderMode);
    int pagesLength =
        (_pageMode == PageMode.doublePage &&
            !(currentReaderMode?.isHorizontalContinuous ?? false))
        ? _pageViewPageCount
        : pages.length;
    if (_currentIndex! >= 0 && _currentIndex! < pagesLength) {
      final actualIndex = _pageViewToActualIndex(_currentIndex!);
      _updateChapterIfNeeded(actualIndex);

      // ── Next-chapter preloading: trigger when near the end ──
      final distToEnd = pagesLength - 1 - itemPositions.last.index;
      if (distToEnd <= pagePreloadAmount && !_isLastPageTransition) {
        _triggerNextChapterPreload();
      }

      // // ── Previous-chapter preloading: trigger when near the start ──
      // if (itemPositions.first.index <= pagePreloadAmount) {
      //   _triggerPrevChapterPreload();
      // }

      // Ensure the current chapter's pages are reloaded if they were evicted,
      // and evict old chapters' pages to free memory. Gated on pageChanged
      // (not just index-in-bounds) since this listener fires on every scroll
      // frame during a fling, not just once per settled page - unlike the
      // paged-mode handler, which only runs on discrete PageView transitions.
      // Both checks below do a linear scan over `pages`, so running them
      // unconditionally here would re-scan dozens of times per second during
      // continuous scrolling.
      if (pageChanged) await _handleEvictionsAndPrefetch();

      _updateDisplayIndex(actualIndex, false /*Not Paged, Continuous*/);
    }
  }

  void _addLastPageTransition(Chapter chap) {
    if (_isLastPageTransition) return;
    try {
      if (!mounted || pageCount == 0) return;
      if (pages.last.isLastChapter ?? false) return;

      final added = addLastChapterTransition(chap);
      if (added && mounted) {
        setState(() {
          _isLastPageTransition = true;
        });
      }
    } catch (_) {}
  }

  void _preloadNextChapter(GetChapterPagesModel chapterData, Chapter chap) {
    try {
      if (chapterData.uChapDataPreload.isEmpty || !mounted) return;

      final firstChapter = chapterData.uChapDataPreload.first.chapter;
      if (firstChapter == null) return;

      // Use mixin's method for memory-bounded preloading with auto-eviction
      preloadNextChapter(chapterData, chap).then((success) {
        if (success && mounted) {
          setState(() {});
        }
      });
    } catch (_) {}
  }

  // bidirectional proactive chapter preloading ──

  /// Proactively starts loading both adjacent chapters at reader init.
  void _proactivePreload() {
    _triggerNextChapterPreload();
    // _triggerPrevChapterPreload();
  }

  /// Fires off next-chapter page fetching if not already in progress.
  void _triggerNextChapterPreload() async {
    if (_isNextChapterPreloading || _isLastPageTransition) return;
    _isNextChapterPreloading = true;
    try {
      if (!mounted) {
        _isNextChapterPreloading = false;
        return;
      }
      final nextChapter = _readerController.getNextChapter();
      if (isChapterLoaded(nextChapter)) {
        _isNextChapterPreloading = false;
        return;
      }
      final value = await ref.read(
        getChapterPagesProvider(chapter: nextChapter).future,
      );
      if (mounted) {
        _preloadNextChapter(value, chapter);
      }
      _isNextChapterPreloading = false;
    } on RangeError {
      _isNextChapterPreloading = false;
      _addLastPageTransition(chapter);
    } catch (_) {
      _isNextChapterPreloading = false;
    }
  }

  void _initCurrentIndex() async {
    final readerMode = _cachedReaderMode;
    _currentPageDisplayIndex.value = _readerController.getPageIndex();

    // Initialize the preload manager with bounded memory (from ReaderMemoryManagement mixin)
    initializePreloadManager(_chapterUrlModel, onPagesUpdated: () {});

    // Kick off ordered prefetch before the first frame so lower-indexed pages
    // win the HTTP race against the simultaneous widget-driven loads.
    _prefetchPagesInOrder(); // intentionally not awaited

    // proactively start loading adjacent chapters in background
    _proactivePreload();

    _readerController.setHistoryUpdate();
    // Use post-frame callback instead of Future.delayed(1ms) timing hack
    await Future(() {});
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    if (fullScreenReader) {
      if (isDesktop) {
        setFullScreen(value: true);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
    ref.read(_currentReaderMode.notifier).state = readerMode;
    _setReaderMode(readerMode, ref);

    if (!readerMode.isVerticalContinuous) {
      _autoScroll.value = false;
    }
    _autoPagescroll();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode.isHorizontalPaged || readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  /// Reloads a chapter's page image data if it was previously evicted by
  /// [ChapterPreloadManager.evictOldChapters] (e.g. the reader scrolled
  /// forward far enough that this chapter's data was cleared to free memory,
  /// then scrolled back into it). Re-reads the local `.cbz` archive and
  /// re-populates each page's `archiveImage`.
  ///
  /// Only applies to archive-backed local chapters (cbz/zip/etc.) - plain
  /// image-folder chapters carry [UChapDataPreload.localImagePath] pointing
  /// straight at their real file on disk, so there's nothing to evict or
  /// reload for them in the first place.
  ///
  /// Cheap no-op for the common case where [currentChapter] was never
  /// evicted, via [ChapterPreloadManager.isChapterEvicted] - avoids scanning
  /// every page of the chapter on every page-change.
  Future<void> _checkAndReloadEvictedPages(Chapter currentChapter) async {
    if (!preloadManager.isChapterEvicted(currentChapter)) return;

    final chapterId = currentChapter.id;
    bool needsReload = false;
    for (final page in pages) {
      if (page.chapter?.id == chapterId &&
          !page.isTransitionPage &&
          page.isLocale == true &&
          page.archiveImage == null &&
          page.localImagePath == null) {
        needsReload = true;
        break;
      }
    }

    if (needsReload) {
      final isLocalArchive = (currentChapter.archivePath ?? '').isNotEmpty;
      final archivePath = isLocalArchive
          ? await resolveLocalArchivePath(currentChapter.archivePath!)
          : (await findDownloadedChapter(currentChapter))?.archive?.path;

      if (archivePath != null && await File(archivePath).exists()) {
        try {
          final local = await ref.read(
            getArchiveDataFromFileProvider(archivePath).future,
          );
          final images = local.images ?? [];
          int imgIdx = 0;
          for (final page in pages) {
            if (page.chapter?.id == currentChapter.id &&
                !page.isTransitionPage) {
              if (imgIdx < images.length) {
                page.archiveImage = images[imgIdx].image;
              }
              imgIdx++;
            }
          }
          preloadManager.markChapterAsLoaded(currentChapter);
          if (mounted) {
            setState(() {});
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error reloading evicted chapter pages: $e');
          }
        }
      }
    }
  }

  /// Warms Flutter's [ImageCache] and pre-resolves each page’s
  /// local/archive file path in reading order before the widget tree renders.
  ///
  /// Instead of letting [ScrollablePositionedList] trigger many
  /// simultaneous network requests in arbitrary server-response order,
  /// this method starts image fetches early and in a prioritized sequence.
  /// Pages near the current reading position are queued first,
  /// and multiple background workers resolve their providers concurrently,
  /// giving earlier pages a head start without strictly serializing downloads.
  ///
  /// Flutter deduplicates identical image providers, so pages already within
  /// the cache extent attach to existing pending requests without
  /// issuing duplicates. Pages beyond the cache extent are fetched in
  /// reading order but may overlap due to parallel workers.
  ///
  /// The work is fully asynchronous and does not block UI interaction.
  Future<void> _prefetchPagesInOrder() async {
    final sessionId = ++_prefetchSessionId;
    final actualIdx = _pageViewToActualIndexSync(_currentIndex ?? 0);
    final startIdx = actualIdx.clamp(0, pages.length - 1);

    final preloadAmount = ref.read(pagePreloadAmountStateProvider);
    final forwardLimit = (startIdx + preloadAmount).clamp(0, pages.length - 1);
    final backwardLimit = (startIdx - 2).clamp(0, pages.length - 1);

    final indices = [
      for (var i = startIdx; i <= forwardLimit; i++) i,
      for (var i = startIdx - 1; i >= backwardLimit; i--) i,
    ];

    final queue = List<int>.from(indices);

    Future<void> worker() async {
      while (queue.isNotEmpty) {
        if (sessionId != _prefetchSessionId || !mounted) return;
        final i = queue.removeAt(0);
        final page = pages[i];
        if (page.isTransitionPage) continue;
        try {
          // Pre-resolve the local/archive file path in advance to avoid load delays
          if (page.resolvedFilePath == null) {
            final path = await page.getLocalFilePath;
            if (path != null) {
              page.resolvedFilePath = path;
            }
          }

          final provider = page.getImageProvider(ref, true);
          if (provider is CustomExtendedNetworkImageProvider) {
            await provider.getNetworkImageData();
            // Resolve again if just downloaded
            if (page.resolvedFilePath == null) {
              final path = await page.getLocalFilePath;
              if (path != null) {
                page.resolvedFilePath = path;
              }
            }
          }
        } catch (_) {
          // Swallow errors: network failures, widget disposal, etc.
        }
      }
    }

    await Future.wait([worker(), worker(), worker()]);
  }

  /// Handles page changes in PageView mode (discrete pages).
  ///
  /// Responsibilities:
  /// - Convert PageView index -> actual page index (handles double-page mode).
  /// - Update reader progress and chapter if the new page belongs to another chapter.
  /// - Reset zoom/scale of the previous page so swiping back works smoothly.
  /// - Trigger flash animation on page change.
  /// - Update display index and persist progress.
  /// - Preload next chapter when nearing the end of the current one.
  /// - Reload evicted pages if needed and evict old chapter pages to free memory.
  /// - Prefetch pages in correct order for smoother reading.
  ///
  /// This is the main handler for all logic that should occur when the user
  /// swipes to a new page in PageView mode.
  Future<void> _onPageChanged(int index) async {
    // In non-continuous double page mode, convert page view index to actual
    // pages array index for correct lookups.
    final int actualIndex = _pageViewToActualIndex(index);
    final int prevActualIndex = _pageViewToActualIndex(_currentIndex!);

    _updateChapterIfNeeded(actualIndex);
    // Avoid rebuilding the tile map when an untransformed page crosses
    // PageView's 50% onPageChanged threshold.
    if (_isCurrentPageZoomed) {
      _pageControllers[prevActualIndex]?.resetScaleAndCenter();
      if (_isDoublePageActive) {
        final previousController = _doublePageControllers[_currentIndex!];
        if (previousController != null) {
          previousController.scale = 1.0;
          previousController.position = Offset.zero;
        }
      }
    }

    final bool pageChanged = _currentIndex != index;
    _currentIndex = index;
    _currentPageViewIndex.value = index;

    if (pageChanged) _triggerFlash();
    _updateDisplayIndex(actualIndex, true /*Paged*/);

    // ── Next-chapter preloading: trigger when near the end ──
    final distToEnd = pages.length - 1 - actualIndex;
    if (distToEnd <= pagePreloadAmount && !_isLastPageTransition) {
      _triggerNextChapterPreload();
    }

    // // ── Previous-chapter preloading: trigger when near the start ──
    // if (actualIndex <= pagePreloadAmount) {
    //   _triggerPrevChapterPreload();
    // }

    await _handleEvictionsAndPrefetch();
  }

  Future<void> _handleEvictionsAndPrefetch() async {
    // Ensure the current chapter's pages are reloaded if they were evicted
    await _checkAndReloadEvictedPages(chapter);

    // Evict old chapters' pages to free memory
    final evictedIndices = preloadManager.evictOldChapters(chapter);
    for (final evictedIdx in evictedIndices) {
      _cropBorderCheckList.remove(evictedIdx);
    }

    // Prefetch pages in order for the new page window
    _prefetchPagesInOrder();
  }

  /// Updates the active chapter when the user scrolls or swipes into a page
  /// belonging to a different chapter.
  ///
  /// This:
  /// - Detects if the newly visible page belongs to another chapter.
  /// - Rebuilds the reader controller for that chapter.
  /// - Updates the current chapter, chapter URL model, and bookmark state.
  ///
  /// Called by both page‑based and continuous scrolling listeners to keep
  /// chapter state in sync with the visible page.
  void _updateChapterIfNeeded(int actualIndex) {
    final newChapter = pages[actualIndex].chapter!;
    if (_readerController.chapter.id == newChapter.id) return;

    if (!mounted) return;

    final previousController = _readerController;

    setState(() {
      _readerController = ref.read(
        readerControllerProvider(chapter: newChapter).notifier,
      );
      chapter = newChapter;

      final chapterUrlModel = pages[actualIndex].chapterUrlModel;
      if (chapterUrlModel != null) {
        _chapterUrlModel = chapterUrlModel;
      }

      _isBookmarked = _readerController.getChapterBookmarked();
    });

    // dispose() only closes the last controller, so this releases every chapter crossed during continuous scrolling.
    previousController.keepAliveLink?.close();
  }

  /// Updates the user-facing page index (e.g., "Page 5 of 32") and syncs
  /// progress to the reader controller + Riverpod state.
  ///
  /// This:
  /// - Converts the actual page index into the display index used in UI.
  /// - Updates the reader controller's internal page index.
  /// - Persists the current index via `currentIndexProvider`.
  ///
  /// Used by both PageView mode and continuous scrolling mode.
  void _updateDisplayIndex(int actualIndex, bool pageView) {
    final idx = pages[actualIndex].index;
    if (idx == null) return;
    _currentPageDisplayIndex.value = idx;
    _readerController.setPageIndex(idx, false, _chapterUrlModel.pageUrls);
    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
  }

  late final _pageOffset = ValueNotifier(
    _readerController.autoScrollValues().$2,
  );

  void _autoPagescroll() async {
    if (_isContinuousMode() && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted || !_autoScroll.value) {
        return;
      }
      _pageOffsetController.animateScroll(
        offset: _pageOffset.value,
        duration: const Duration(milliseconds: 100),
      );
      _autoPagescroll();
    }
  }

  void _setReaderMode(ReaderMode value, WidgetRef ref) async {
    final showOverlay = ref.read(showNavigationOverlayOnStartStateProvider);
    if (!value.isVerticalContinuous) {
      _autoScroll.value = false;
    } else if (_autoScrollPage.value) {
      _autoPagescroll();
      _autoScroll.value = true;
    }

    _failedPageIndexes.value = {};
    _readerController.setReaderMode(value);

    // Cache the reader mode for safe access in dispose
    _cachedReaderMode = value;

    final int actualIndex = _currentPageDisplayIndex.value;
    ref.read(_currentReaderMode.notifier).state = value;
    if (!mounted) return;
    setState(() {
      _isReverseHorizontal = value.isRTL;

      if (value == ReaderMode.vertical) {
        _scrollDirection = Axis.vertical;
      } else if (value.isHorizontalPaged) {
        _scrollDirection = Axis.horizontal;
      }

      if (showOverlay) {
        _showNavigationOverlay = true;
      }
    });
    // Wait for the next frame so the scroll view rebuilds
    await WidgetsBinding.instance.endOfFrame;

    final isDoubleInNewMode =
        _pageMode == PageMode.doublePage && !value.isHorizontalContinuous;
    final int targetIndex = isDoubleInNewMode
        ? _actualToPageViewIndex(actualIndex)
        : actualIndex;
    _currentIndex = targetIndex;
    _currentPageViewIndex.value = targetIndex;

    if (value == ReaderMode.vertical || value.isHorizontalPaged) {
      if (_extendedController.hasClients) {
        _extendedController.jumpToPage(targetIndex);
      }
    } else {
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: targetIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      }
    }
  }

  void _goBack(BuildContext context) {
    restoreSystemUI();
    Navigator.pop(context);
  }

  void _isViewFunction() {
    final fullScreenReader = ref.read(fullScreenReaderStateProvider);
    if (context.mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (fullScreenReader) {
      if (_isView) {
        restoreSystemUI();
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
  }

  /// Live inputs for [ReaderPageIndexMath], read via the current provider
  /// state. Not safe to call during dispose - use [_indexMathSync] there.
  ReaderPageIndexMath get _indexMath => ReaderPageIndexMath(
    isDoublePageActive: _isDoublePageActive,
    singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
    pageCount: pages.length,
  );

  /// Same as [_indexMath] but sourced entirely from cached/settings-only
  /// state, safe to call during dispose (reading a provider there would hit
  /// a Riverpod assertion error).
  ReaderPageIndexMath get _indexMathSync => ReaderPageIndexMath(
    isDoublePageActive: _isDoublePageActiveSync,
    singleFirst: settingsRepository.current.doublePageSingleFirstPage ?? false,
    pageCount: pages.length,
  );

  String _currentIndexLabel(int index) => _indexMath.currentIndexLabel(
    index,
    _readerController.getPageLength(_chapterUrlModel.pageUrls),
  );

  /// Whether double page mode is active (continuous or paged).
  /// Horizontal continuous mode does NOT use double page layout.
  /// Uses ref.read() so cannot be called during dispose.
  bool get _isDoublePageActive {
    final currentMode = ref.read(_currentReaderMode) ?? _cachedReaderMode;
    return _pageMode == PageMode.doublePage &&
        !currentMode.isHorizontalContinuous;
  }

  /// Safe version of _isDoublePageActive that uses cached reader mode.
  /// Safe to call during dispose without Riverpod assertion errors.
  bool get _isDoublePageActiveSync =>
      _pageMode == PageMode.doublePage &&
      !_cachedReaderMode.isHorizontalContinuous;

  /// Converts a page view index (from ExtendedPageController) to the actual
  /// index in the [pages] array for double page mode.
  int _pageViewToActualIndex(int pageViewIndex) =>
      _indexMath.pageViewToActualIndex(pageViewIndex);

  /// Safe version that uses cached reader mode for use in dispose.
  int _pageViewToActualIndexSync(int pageViewIndex) =>
      _indexMathSync.pageViewToActualIndex(pageViewIndex);

  /// Converts an actual [pages] array index to a page view index
  /// for double page mode.
  int _actualToPageViewIndex(int actualIndex) =>
      _indexMath.actualToPageViewIndex(actualIndex);

  /// Safe version of _actualToPageViewIndex that uses cached reader mode and repository settings.
  int _actualToPageViewIndexSync(int actualIndex) =>
      _indexMathSync.actualToPageViewIndex(actualIndex);

  /// Total page count as seen by the page view controller.
  /// In double page mode, each PV page shows 2 actual pages (except PV 0 if singleFirst).
  int get _pageViewPageCount => _indexMath.pageViewPageCount;

  bool _isContinuousMode([ReaderMode? mode]) {
    final readerMode = mode ?? ref.read(_currentReaderMode);
    return readerMode!.isContinuous;
  }
}
