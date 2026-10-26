import 'dart:async';
import 'dart:math';

import 'package:mangayomi/modules/reader_common/key_bindings.dart';
import 'package:mangayomi/modules/manga/reader/utils/download_ahead.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:mangayomi/services/volume_keys.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart'
    show getReaderModeName;
import 'package:mangayomi/modules/reader_common/utils/reader_orientation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/reader_common/reader_chapter_navigation.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/modules/reader_common/providers/chapter_display.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/services/discord_rpc.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_double_page_mixin.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_input_and_mode_mixin.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_prefetch_mixin.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_zoom_control.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_auto_scroll_sheet.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_overlays.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_page_content.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_settings_modal.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_slider_preview_overlay.dart';
import 'package:mangayomi/modules/reader_common/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/services/chapter_cache.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/modules/reader_common/widgets/chapter_bar_title.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/services/reader/decoded_image_budget.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_auto_scroll.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';

class MangaReaderView extends ConsumerWidget {
  final int chapterId;
  const MangaReaderView({super.key, required this.chapterId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = l10nLocalizations(context)!;
    final chapterData = ref.watch(mangaReaderProvider(chapterId));
    // The chapter as stored, for the bar and the way to the web while its
    // pages are not there yet.
    final stored = chapterRepository.findByIdSync(chapterId);
    Future<void> retry() async {
      final chapter = await chapterRepository.findById(chapterId);
      if (chapter != null) {
        await ChapterCache().remove(chapter);
        ref.invalidate(getChapterPagesProvider(chapter: chapter));
      }
      ref.invalidate(mangaReaderProvider(chapterId));
    }

    // The source's own page for the chapter, where a reader can see why it
    // gives nothing; local archives have none.
    final webView =
        stored == null || (stored.manga.value?.isLocalArchive ?? true)
        ? null
        : buildWebViewData(stored);
    void openWebView() => context.push("/mangawebview", extra: webView);

    if (chapterData.isRefreshing || chapterData.isReloading) {
      return scaffoldWith(context, ref, stored, const ProgressCenter());
    }
    return chapterData.when(
      loading: () => scaffoldWith(context, ref, stored, const ProgressCenter()),
      error: (error, _) {
        if (chapterData.isRefreshing || chapterData.isReloading) {
          return scaffoldWith(context, ref, stored, const ProgressCenter());
        }
        return scaffoldWith(
          context,
          ref,
          stored,
          ErrorState(
            detail: error.toString(),
            onRetry: retry,
            secondaryLabel: webView == null ? null : l10n.webview,
            secondaryIcon: Symbols.public_rounded,
            onSecondary: webView == null ? null : openWebView,
          ),
        );
      },
      data: (data) {
        final chapter = data.chapter;
        final model = data.pages;

        if (model.pageUrls.isEmpty &&
            !(chapter.manga.value?.isLocalArchive ?? false)) {
          // No pages is a failure like another: say so, and offer to try
          // again or to look at the source's page.
          return scaffoldWith(
            context,
            ref,
            chapter,
            ErrorState(
              message: l10n.error_no_pages_available,
              onRetry: retry,
              secondaryLabel: webView == null ? null : l10n.webview,
              secondaryIcon: Symbols.public_rounded,
              onSecondary: webView == null ? null : openWebView,
            ),
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

  /// The loading, failure and no-page states, under a bar that says which
  /// chapter is being opened, as the reader's own top bar does.
  Widget scaffoldWith(
    BuildContext context,
    WidgetRef ref,
    Chapter? chapter,
    Widget body, {
    bool restoreUi = false,
  }) {
    return Scaffold(
      backgroundColor: context.shiori.color.ink0,
      appBar: AppBar(
        titleSpacing: 0,
        title: ChapterBarTitle(chapter: chapter),
        // scaffoldWith is only the loading / error / no-pages states, whose
        // bodies have nothing focusable. Without this the d-pad has no starting
        // point on TV and cannot even reach the back button. IconButton, not
        // BackButton, because only IconButton takes autofocus.
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
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
        ReaderDoublePageMixin,
        ReaderPrefetchMixin,
        ReaderZoomControl,
        PageNavigationMixin,
        ReaderInputAndModeMixin,
        ReaderAutoScroll {
  @override
  ValueNotifier<bool> get autoScrollEnabled => _autoScroll;
  @override
  ValueNotifier<double> get autoScrollSpeed => _pageOffset;
  @override
  ScrollController get autoScrollController => _continuousScrollController;
  @override
  bool get canAutoScroll => isContinuousMode();

  @override
  Chapter get activeChapterForDoublePage => chapter;
  @override
  ReaderController get activeReaderControllerForDoublePage => _readerController;
  @override
  GetChapterPagesModel get activeChapterUrlModelForDoublePage =>
      _chapterUrlModel;
  @override
  ReaderMode get cachedReaderMode => _cachedReaderMode;
  @override
  ReaderMode? get activeReaderMode => ref.read(_currentReaderMode);
  @override
  PageMode get configuredPageMode => _pageMode;
  @override
  Orientation? get lastKnownOrientation => _lastOrientation;
  @override
  int? get currentDoublePageViewIndex => _currentIndex;
  @override
  int get currentDoublePageDisplayIndex => _currentPageDisplayIndex.value;

  @override
  ScrollController get inputContinuousScrollController =>
      _continuousScrollController;
  @override
  bool get isReverseHorizontalForInput => _isReverseHorizontal;

  @override
  Chapter get activeChapterForPrefetch => chapter;
  @override
  ReaderController get activeReaderControllerForPrefetch => _readerController;
  @override
  int? get currentPrefetchPageViewIndex => _currentIndex;
  @override
  bool get isReverseHorizontalForPrefetch => _isReverseHorizontal;
  @override
  bool get isDoublePageActiveForPrefetch => isDoublePageActive;
  @override
  int pageViewToActualIndexSyncForPrefetch(int pageViewIndex) =>
      pageViewToActualIndexSync(pageViewIndex);

  @override
  int? get currentZoomPageViewIndex => _currentIndex;
  @override
  bool get isReverseHorizontalForZoom => _isReverseHorizontal;
  @override
  bool get isDoublePageActiveForZoom => isDoublePageActive;
  @override
  int pageViewToActualIndexForZoom(int pageViewIndex) =>
      pageViewToActualIndex(pageViewIndex);
  @override
  void handlePageNavigationFromZoom({required bool forward}) =>
      handlePageNavigation(forward: forward);

  late ReaderController _readerController = ref.read(
    readerControllerProvider(chapter: chapter).notifier,
  );

  final Stopwatch _readingStopwatch = Stopwatch();
  int? _discordReaderSession;

  // Fullscreen is kept when navigating between chapters via pushReplacement:
  // the old widget's dispose runs after the new widget is created, which
  // would clobber the new reader's fullscreen state. See
  // [ReaderChapterNavigation].

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    VolumeKeys.disable();
    releaseReaderOrientation();
    applyReaderScreenBrightness(-1);
    _readingStopwatch.stop();
    _flushReadingTime(_readerController);
    _rebuildDetail.close();

    disposePrefetchMixin();
    _failedPageIndexes.dispose();
    _hasCurrentPageImageError.dispose();
    _currentPageViewIndex.dispose();
    disposeZoomControl();
    disposeAutoScroll();
    _autoScroll.removeListener(onAutoScrollChanged);
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _currentPageDisplayIndex.dispose();
    _sliderPreviewIndex.dispose();
    _keyboardFocusNode.dispose();
    _continuousScrollController.removeListener(_scheduleReadProgressListener);
    _listController.removeListener(_scheduleReadProgressListener);
    _continuousScrollController.dispose();
    _listController.dispose();

    _extendedController.dispose();
    if (ReaderChapterNavigation.consume()) {
      // Chapter switch: the new reader owns fullscreen now.
    } else if (isDesktop) {
      setFullScreen(value: false);
    } else {
      restoreSystemUI();
    }
    final discordReaderSession = _discordReaderSession;
    if (discordReaderSession != null) {
      unawaited(discordRpc?.endReaderSession(discordReaderSession));
    }
    _saveCurrentPage(pageViewToActualIndexSync(_currentIndex ?? 0));
    // Releases this reader's own decoded pages. The budget itself is shared
    // with the reader replacing this one on a chapter switch, so clearing it
    // here would throw away images the new reader just decoded.
    disposePreloadManager();
    _readerController.keepAliveLink?.close();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didHaveMemoryPressure() {
    DecodedImageBudget.instance.clear();
    super.didHaveMemoryPressure();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _readingStopwatch.stop();
      _flushReadingTime(_readerController);
      if (keepOn) {
        WakelockPlus.disable();
      }
      _saveCurrentPage(pageViewToActualIndex(_currentIndex ?? 0));
      // The volume buttons are the system's again while away (on iOS the
      // volume comes back too), and the reader's on return.
      VolumeKeys.disable();
      applyReaderScreenBrightness(-1);
    } else if (state == AppLifecycleState.resumed) {
      _readingStopwatch.start();
      if (keepOn) {
        WakelockPlus.enable();
      }
      setVolumeKeys(ref.read(volumeKeysPagingStateProvider));
      applyReaderScreenBrightness(
        ref.read(readerScreenBrightnessStateProvider),
      );
    }
  }

  /// Persists the page at [actualIndex] as this chapter's reading position.
  /// Bounds-checked: it runs from dispose, where a throw would skip the rest
  /// of the cleanup (wakelock, super.dispose).
  void _saveCurrentPage(int actualIndex) {
    if (actualIndex < 0 || actualIndex >= pages.length) return;
    final index = pages[actualIndex].index;
    if (index != null) {
      _readerController.setPageIndex(index, true, _chapterUrlModel.pageUrls);
    }
  }

  late final _autoScroll = ValueNotifier(
    _readerController.autoScrollValues().$1,
  );
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);
  late GetChapterPagesModel _chapterUrlModel = widget.chapterUrlModel;

  late Chapter chapter = widget.chapter;

  final _failedPageIndexes = ValueNotifier<Set<int>>({});
  final _hasCurrentPageImageError = ValueNotifier<bool>(false);

  void _updateHasCurrentError() {
    final failedPageIndexes = _failedPageIndexes.value;
    if (failedPageIndexes.isEmpty || _cachedReaderMode.isContinuous) {
      if (_hasCurrentPageImageError.value) {
        _hasCurrentPageImageError.value = false;
      }
      return;
    }
    final curPvIndex = _currentPageViewIndex.value ?? 0;
    final curActualIndex = getCurrentPagesActualIndex();
    final bool hasError =
        failedPageIndexes.contains(curPvIndex) ||
        failedPageIndexes.contains(curActualIndex);
    if (_hasCurrentPageImageError.value != hasError) {
      _hasCurrentPageImageError.value = hasError;
    }
  }

  void _onFailedToLoadImage(int index, bool failed) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = Set<int>.from(_failedPageIndexes.value);
      final bool changed = failed ? current.add(index) : current.remove(index);
      if (changed) {
        _failedPageIndexes.value = current;
        _updateHasCurrentError();
      }
    });
  }

  late ReaderMode _cachedReaderMode = _readerController.getReaderMode();
  late PageMode _pageMode = _readerController.getPageMode();
  Orientation? _lastOrientation;
  PageMode? _lastEffectivePageMode;
  late final _currentReaderMode = StateProvider<ReaderMode?>(
    () => _cachedReaderMode,
  );

  /// The saved position within the chapter. It can point past the end when
  /// the source now serves fewer pages than when the chapter was last read.
  late final int _savedPageIndex = min(
    _readerController.getPageIndex(),
    max(0, widget.chapterUrlModel.uChapDataPreload.length - 1),
  );

  late int? _currentIndex = () {
    final saved = _savedPageIndex;
    if (isDoublePageActiveSync) {
      return actualToPageViewIndexSync(saved);
    }
    return saved;
  }();
  late final ValueNotifier<int?> _currentPageViewIndex = ValueNotifier(
    _currentIndex,
  );

  /// The page the slider is being dragged over, for its preview; null when
  /// the slider is not being dragged.
  final ValueNotifier<int?> _sliderPreviewIndex = ValueNotifier(null);

  late final ValueNotifier<int> _currentPageDisplayIndex = ValueNotifier(
    _savedPageIndex,
  );

  late final ListController _listController = ListController();
  late final ScrollController _continuousScrollController = ScrollController();
  bool _readProgressScheduled = false;
  bool _initialContinuousJumpPending = false;
  int? _initialContinuousTargetIndex;

  void _scheduleReadProgressListener() {
    if (_readProgressScheduled) return;
    _readProgressScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _readProgressScheduled = false;
      if (!mounted) return;
      _readProgressListener();
    });
  }

  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    beginReadingSession();
    _readingStopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // The reading mode's name for a moment, then gone.
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _showModeHint = false);
      });
      setVolumeKeys(ref.read(volumeKeysPagingStateProvider));
      applyReaderOrientation(ref.read(readerOrientationStateProvider));
      applyReaderScreenBrightness(
        ref.read(readerScreenBrightnessStateProvider),
      );
      downloadAhead(ref, chapter);
    });

    final saved = _savedPageIndex;
    if (saved > 0 && _cachedReaderMode.isContinuous) {
      _initialContinuousJumpPending = true;
      _initialContinuousTargetIndex = _currentIndex;
    }

    _continuousScrollController.addListener(_scheduleReadProgressListener);
    _listController.addListener(_scheduleReadProgressListener);
    initPageNavigation(
      listController: _listController,
      continuousScrollController: _continuousScrollController,
      extendedController: _extendedController,
    );
    _initCurrentIndex();
    _discordReaderSession = discordRpc?.beginReaderSession();
    discordRpc?.showChapterDetails(ref, chapter);
    WidgetsBinding.instance.addObserver(this);
    _autoScroll.addListener(onAutoScrollChanged);
    if (_autoScroll.value && isContinuousMode()) {
      startAutoScroll();
    }
    _initWakelock();
  }

  void _initWakelock() {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isView = false;
  final _keyboardFocusNode = FocusNode();

  /// Whether the reading mode's name is shown, as a chapter opens.
  bool _showModeHint = true;

  late final _extendedController = PageController(initialPage: _currentIndex!);

  late Axis _scrollDirection = _cachedReaderMode == ReaderMode.vertical
      ? Axis.vertical
      : Axis.horizontal;
  late bool _isReverseHorizontal = _cachedReaderMode.isRTL;

  Color _backgroundColor(BuildContext context) =>
      context.shiori.color.ink1.withValues(alpha: Alphas.chrome);

  /// Toggles fullscreen. [value] is whether it is on now; F11 passes none,
  /// so off desktop the reader's own setting stands in for it.
  void _setFullScreen({bool? value}) async {
    if (isDesktop) {
      value = await windowManager.isFullScreen();
      setFullScreen(value: !value);
    }
    if (!mounted) return;
    final bool isOn = value ?? ref.read(fullScreenReaderStateProvider);
    ref.read(fullScreenReaderStateProvider.notifier).set(!isOn);
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
    ReaderChapterNavigation.markNavigatingToChapter();
    try {
      pushReplacementMangaReaderView(
        context: context,
        chapter: next
            ? _readerController.getNextChapter()
            : _readerController.getPrevChapter(),
      );
    } catch (_) {
      // If the replacement fails, dispose() never runs to reset this flag, so reset it here instead.
      ReaderChapterNavigation.reset();
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final readerMode = ref.watch(_currentReaderMode);
    if (readerMode == null) return const SizedBox.shrink();
    ref.listen<bool>(volumeKeysPagingStateProvider, (_, on) {
      setVolumeKeys(on);
    });
    ref.listen<int>(readerOrientationStateProvider, (_, value) {
      applyReaderOrientation(value);
    });
    ref.listen<int>(readerScreenBrightnessStateProvider, (_, value) {
      applyReaderScreenBrightness(value);
    });

    final thresholdIdx = ref.watch(readerHideThresholdStateProvider);
    final double scrollHideThreshold = switch (thresholdIdx) {
      0 => 5.0,
      1 => 13.0,
      2 => 31.0,
      _ => 47.0,
    };

    final doublePageAuto = ref.watch(doublePageAutoStateProvider);
    final orientation = MediaQuery.orientationOf(context);
    final currentEffectivePageMode = doublePageAuto
        ? (orientation == Orientation.landscape
              ? PageMode.doublePage
              : PageMode.onePage)
        : _pageMode;

    final prevEffectiveMode = _lastEffectivePageMode ?? _pageMode;
    if (prevEffectiveMode != currentEffectivePageMode) {
      final currentActual = getCurrentPagesActualIndex(prevEffectiveMode);
      final targetIndex = currentEffectivePageMode == PageMode.doublePage
          ? ReaderPageIndexMath(
              isDoublePageActive: true,
              singleFirst: ref.read(doublePageSingleFirstPageStateProvider),
              pageCount: pages.length,
              pages: pages,
            ).actualToPageViewIndex(currentActual)
          : currentActual;
      _currentIndex = targetIndex;
      _currentPageViewIndex.value = targetIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final mode = ref.read(_currentReaderMode);
        if (mode != null) {
          navigationService.jumpToPage(index: targetIndex, readerMode: mode);
        }
      });
    }
    _lastOrientation = orientation;
    _lastEffectivePageMode = currentEffectivePageMode;

    ref.listen<bool>(doublePageSingleFirstPageStateProvider, (previous, next) {
      if (previous != null &&
          previous != next &&
          isDoublePageActive &&
          mounted) {
        final currentActual = getCurrentPagesActualIndex();
        final newPvIndex = ReaderPageIndexMath(
          isDoublePageActive: true,
          singleFirst: next,
          pageCount: pages.length,
          pages: pages,
        ).actualToPageViewIndex(currentActual);
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
        if (isCurrentPageZoomed &&
            doublePageControllers[_currentIndex] != null) {
          handlePreviousPageZoomed();
        } else {
          handlePageNavigation(forward: false);
        }
      },
      onNextPage: () {
        if (isCurrentPageZoomed &&
            doublePageControllers[_currentIndex] != null) {
          handleNextPageZoomed();
        } else {
          handlePageNavigation(forward: true);
        }
      },
      onEscape: () => _goBack(context),
      onFullScreen: () => _setFullScreen(),
      onNextChapter: () => _goToChapter(true),
      onPreviousChapter: () => _goToChapter(false),
      onToggleUI: _isViewFunction,
      onZoomIn: () => zoomBy(1.5),
      onZoomOut: () => zoomBy(1 / 1.5),
      onZoomReset: zoomReset,
      onShowShortcuts: () => showReaderShortcuts(
        context,
        isReverseHorizontal: _isReverseHorizontal,
        bindings: ref.read(keyBindingsStateProvider),
      ),
      bindings: ref.watch(keyBindingsStateProvider),
    ).wrapWithKeyboardListener(
      isReverseHorizontal: _isReverseHorizontal,
      focusNode: _keyboardFocusNode,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              isUserDragging = true;
            }
          } else if (notification is ScrollEndNotification) {
            isUserDragging = false;
          }
          if (notification is ScrollUpdateNotification) {
            final delta = notification.scrollDelta ?? 0.0;
            if (delta.abs() > scrollHideThreshold && _isView) {
              _isViewFunction();
            }
          }
          return true;
        },
        child: Material(
          child: SafeArea(
            top: !fullScreenReader,
            bottom: false,
            child: Stack(
              children: [
                Listener(
                  // A wheel turns the page in the paged modes, on desktop;
                  // the continuous ones scroll with it already.
                  onPointerSignal: isDesktop && !readerMode.isContinuous
                      ? onPointerSignal
                      : null,
                  child: ReaderPageContent(
                    pages: pages,
                    chapter: widget.chapter,
                    readerMode: readerMode,
                    pageMode: currentEffectivePageMode,
                    backgroundColor: backgroundColor,
                    pagePreloadAmount: pagePreloadAmount,
                    initialScrollIndex: _currentIndex!,
                    currentPageViewIndex: _currentIndex!,
                    pageViewPageCount: pageViewPageCount,
                    isReverseHorizontal: _isReverseHorizontal,
                    isCurrentPageZoomed: isCurrentPageZoomed,
                    listController: _listController,
                    continuousScrollController: _continuousScrollController,
                    extendedController: _extendedController,
                    scrollDirection: _scrollDirection,
                    pageControllerFor: (index) => pageControllers.putIfAbsent(
                      index,
                      () =>
                          ssiv.SubsamplingScaleImageViewController()
                            ..addListener(() => updateZoomStateForIndex(index)),
                    ),
                    onFailedToLoadImage: _onFailedToLoadImage,
                    onWidePage: splitWidePage,
                    onTallPage: splitTallPage,
                    onPageImageLoaded: _onContinuousPageImageLoaded,
                    onWideSinglePageLoaded: (index) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (!mounted) return;
                        final currentActual = getCurrentPagesActualIndex();
                        final targetIndex = isDoublePageActive
                            ? actualToPageViewIndex(currentActual)
                            : currentActual;
                        setState(() {
                          if (_currentIndex != targetIndex) {
                            _currentIndex = targetIndex;
                            _currentPageViewIndex.value = targetIndex;
                            if (_extendedController.hasClients) {
                              _extendedController.jumpToPage(targetIndex);
                            }
                          }
                        });
                      });
                    },
                    onDoublePageZoomChanged: (index, zoomed) {
                      if (index == _currentIndex) {
                        if (mounted && isCurrentPageZoomed != zoomed) {
                          setState(() {
                            isCurrentPageZoomed = zoomed;
                          });
                        }
                      }
                    },
                    onDoublePageControllerChanged:
                        (index, controller, attached) {
                          if (attached) {
                            doublePageControllers[index] = controller;
                          } else if (identical(
                            doublePageControllers[index],
                            controller,
                          )) {
                            // A spread rebuilt under a new key registers its
                            // controller before the old one is disposed; only
                            // drop the entry if it is still the disposed one's.
                            doublePageControllers.remove(index);
                          }
                        },
                    onPageChanged: _onPageChanged,
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _hasCurrentPageImageError,
                  builder: (context, hasCurrentError, child) {
                    return ReaderOverlays(
                      isReverseHorizontal: _isReverseHorizontal,
                      hasCurrentPageImageError: hasCurrentError,
                      isContinuousMode: readerMode.isContinuous,
                      onToggleUI: _isViewFunction,
                      onPreviousPage: () {
                        if (isCurrentPageZoomed &&
                            doublePageControllers[_currentIndex] != null) {
                          handlePreviousPageZoomed();
                        } else {
                          handlePageNavigation(forward: false);
                        }
                      },
                      onNextPage: () {
                        if (isCurrentPageZoomed &&
                            doublePageControllers[_currentIndex] != null) {
                          handleNextPageZoomed();
                        } else {
                          handlePageNavigation(forward: true);
                        }
                      },
                      isFlashing: isFlashing,
                      flashOverlayColor: flashOverlayColor,
                      showNavigationOverlay: showNavigationOverlay,
                      onCloseNavigationOverlay: () {
                        setState(() {
                          showNavigationOverlay = false;
                        });
                      },
                    );
                  },
                ),
                // On desktop, a pointer reaching the top or bottom edge
                // brings the bars back. Translucent: the page still takes
                // the clicks under them.
                if (isDesktop && !_isView) ...[
                  for (final top in [true, false])
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top ? 0 : null,
                      bottom: top ? null : 0,
                      height: 40,
                      child: MouseRegion(
                        hitTestBehavior: HitTestBehavior.translucent,
                        onEnter: (_) {
                          if (!_isView) _isViewFunction();
                        },
                      ),
                    ),
                ],
                ReaderAppBar(
                  chapter: chapter,
                  mangaName: _readerController.getMangaName(),
                  // Named as in the series' own list.
                  chapterTitle: chapterDisplayName(
                    chapter,
                    _readerController.getManga(),
                    context.l10n,
                    byNumber: ref.watch(
                      chapterNumberDisplayProvider.select(
                        (ids) => ids.contains(_readerController.getManga().id),
                      ),
                    ),
                  ),
                  isVisible: _isView,
                  isBookmarked: _isBookmarked,
                  backgroundColor: _backgroundColor,
                  // In the bottom panel, within reach.
                  showChapterList: false,
                  onBackPressed: () => Navigator.pop(context),
                  onBookmarkPressed: () {
                    _readerController.setChapterBookmarked();
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                  },
                  onWebViewPressed:
                      (chapter.manga.value!.isLocalArchive ?? false) == false
                      ? () {
                          final data = buildWebViewData(chapter);
                          if (data != null) {
                            context.push("/mangawebview", extra: data);
                          }
                        }
                      : null,
                  onRefreshPressed:
                      (chapter.manga.value!.isLocalArchive ?? false) == false
                      ? () async {
                          // Drop the cached page list first: rebuilding the
                          // reader reads it, and a list left in place would be
                          // reused as-is.
                          await ChapterCache().remove(chapter);
                          ref.invalidate(
                            getChapterPagesProvider(chapter: chapter),
                          );
                          if (chapter.id != null) {
                            ref.invalidate(mangaReaderProvider(chapter.id!));
                          }
                          if (context.mounted) {
                            pushReplacementMangaReaderView(
                              chapter: chapter,
                              context: context,
                            );
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
                    _sliderPreviewIndex.value = value;
                    _currentPageDisplayIndex.value = value;
                    ref
                        .read(currentIndexProvider(chapter).notifier)
                        .setCurrentIndex(value);
                  },
                  onSliderChangeEnd: (value) {
                    _sliderPreviewIndex.value = null;
                    // Looked up rather than read from the page's pageIndex,
                    // which goes stale once a wide page before it is split.
                    int jumpIndex = actualIndexOfChapterPage(value);
                    if (jumpIndex == -1) return;
                    // In double page mode, convert array index to page view index
                    if (isDoublePageActive) {
                      jumpIndex = actualToPageViewIndex(jumpIndex);
                    }
                    _currentIndex = jumpIndex;
                    _currentPageViewIndex.value = jumpIndex;
                    navigationService.jumpToPage(
                      index: jumpIndex,
                      readerMode: ref.read(_currentReaderMode)!,
                    );
                  },
                  onReaderModeChanged: (mode, ref) {
                    ref.read(_currentReaderMode.notifier).state = mode;
                    _setReaderMode(mode, ref, fromUser: true);
                  },
                  onPageModeToggle: () async {
                    final readerMode = ref.read(_currentReaderMode);
                    if (!(readerMode?.isHorizontalContinuous ?? false)) {
                      final currentEffective = effectivePageMode;
                      final currentActual = getCurrentPagesActualIndex(
                        currentEffective,
                      );
                      final PageMode newPageMode =
                          currentEffective == PageMode.onePage
                          ? PageMode.doublePage
                          : PageMode.onePage;
                      ref.read(doublePageAutoStateProvider.notifier).set(false);
                      _readerController.setPageMode(newPageMode);

                      final singleFirst = ref.read(
                        doublePageSingleFirstPageStateProvider,
                      );
                      final int targetIndex = newPageMode == PageMode.doublePage
                          ? ReaderPageIndexMath(
                              isDoublePageActive: true,
                              singleFirst: singleFirst,
                              pageCount: pages.length,
                              pages: pages,
                            ).actualToPageViewIndex(currentActual)
                          : currentActual;

                      _currentIndex = targetIndex;
                      _currentPageViewIndex.value = targetIndex;
                      if (mounted) {
                        setState(() {
                          _pageMode = newPageMode;
                          _lastEffectivePageMode = newPageMode;
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
                    seriesName: _readerController.getManga().name ?? '',
                    onReaderModeChanged: (mode, widgetRef) {
                      widgetRef.read(_currentReaderMode.notifier).state = mode;
                      _setReaderMode(mode, widgetRef, fromUser: true);
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
                  currentPageMode: currentEffectivePageMode,
                  isReverseHorizontal: _isReverseHorizontal,
                  totalPages: _readerController.getCachedPageLength(
                    _chapterUrlModel.pageUrls,
                  ),
                  currentIndexLabel: currentIndexLabel,
                  backgroundColor: _backgroundColor,
                  autoScrollEnabled: _autoScrollPage,
                  onAutoScrollPressed: _showAutoScrollSheet,
                ),
                // The page under the slider while it is dragged.
                ReaderSliderPreviewOverlay(
                  sliderPreviewIndex: _sliderPreviewIndex,
                  isUiVisible: _isView,
                  pages: pages,
                  totalPages: _readerController.getCachedPageLength(
                    _chapterUrlModel.pageUrls,
                  ),
                  isReverseHorizontal: _isReverseHorizontal,
                  actualIndexOfChapterPage: actualIndexOfChapterPage,
                  currentIndexLabel: currentIndexLabel,
                ),
                RepaintBoundary(
                  child: PageIndicator(
                    isUiVisible: _isView,
                    currentPageListenable: _currentPageDisplayIndex,
                    totalPages: _readerController.getCachedPageLength(
                      _chapterUrlModel.pageUrls,
                    ),
                    formatCurrentIndex: currentIndexLabel,
                  ),
                ),
                // As a chapter opens, which way it reads: the reading mode's
                // name for a moment, the series keeping a mode of its own.
                Positioned(
                  top: MediaQuery.paddingOf(context).top + ShioriSpace.s16,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _showModeHint && !_isView ? 1 : 0,
                        duration: ShioriMotion.of(
                          context,
                          ShioriMotion.standard,
                        ),
                        child: ShioriOverlayLabel(
                          getReaderModeName(readerMode, context),
                        ),
                      ),
                    ),
                  ),
                ),
                // Zoomed in with the bars away: the way back to the whole
                // page, rather than a double tap or a pinch to guess at.
                if (isCurrentPageZoomed && !_isView)
                  Positioned(
                    left: ShioriSpace.s12,
                    bottom:
                        MediaQuery.paddingOf(context).bottom + ShioriSpace.s12,
                    child: TextButton.icon(
                      onPressed: zoomReset,
                      style: TextButton.styleFrom(
                        backgroundColor: ShioriScrim.underText,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      icon: const Icon(Symbols.fit_screen_rounded),
                      label: Text(context.l10n.shortcut_zoom_reset),
                    ),
                  ),
                ReaderAutoScrollButton(
                  isContinuousMode: readerMode.isContinuous,
                  isUiVisible: _isView,
                  autoScrollPage: _autoScrollPage,
                  autoScroll: _autoScroll,
                  onToggle: () {
                    _autoScroll.value = !_autoScroll.value;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles scroll-based page changes in continuous mode (vertical or horizontal).
  void _readProgressListener() async {
    if (!mounted || !_listController.isAttached) return;
    final range = _listController.visibleRange;
    if (range == null) return;
    final (first, last) = range;
    if (_initialContinuousJumpPending) {
      if (!isUserDragging) {
        final targetIndex = _initialContinuousTargetIndex;
        if (targetIndex != null && _currentIndex != targetIndex) {
          _currentIndex = targetIndex;
          _currentPageViewIndex.value = targetIndex;
        }
        return;
      }
      _initialContinuousJumpPending = false;
      _initialContinuousTargetIndex = null;
    }
    final newIndex = first;
    final bool pageChanged = _currentIndex != newIndex;
    _currentIndex = newIndex;
    _currentPageViewIndex.value = newIndex;
    if (pageChanged) triggerFlash();
    final currentReaderMode = ref.read(_currentReaderMode);
    int pagesLength =
        (effectivePageMode == PageMode.doublePage &&
            !(currentReaderMode?.isHorizontalContinuous ?? false))
        ? pageViewPageCount
        : pages.length;
    if (_currentIndex! >= 0 && _currentIndex! < pagesLength) {
      final actualIndex = pageViewToActualIndex(_currentIndex!);
      _updateChapterIfNeeded(actualIndex);

      // ── Next-chapter preloading: trigger when near the end ──
      // On a new page only: this runs on every frame of a scroll, and even a
      // preload already done works out the next chapter from the whole
      // chapter list, which made webtoon scrolling stutter near the end.
      final distToEnd = pagesLength - 1 - last;
      if (pageChanged &&
          distToEnd <= pagePreloadAmount &&
          !isLastPageTransition) {
        triggerNextChapterPreload();
      }

      _updateDisplayIndex(actualIndex, false /*Not Paged, Continuous*/);
      if (pageChanged) {
        _updateHasCurrentError();
        scheduleEvictionsAndPrefetch();
      }
    }
  }

  void _onContinuousPageImageLoaded(int index) {
    if (!_initialContinuousJumpPending ||
        !_cachedReaderMode.isContinuous ||
        _initialContinuousTargetIndex == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_initialContinuousJumpPending) return;
      final targetIndex = _initialContinuousTargetIndex;
      if (targetIndex == null ||
          !_listController.isAttached ||
          !_continuousScrollController.hasClients) {
        return;
      }
      _listController.jumpToItem(
        index: targetIndex,
        scrollController: _continuousScrollController,
        alignment: 0.0,
      );
    });
  }

  void _initCurrentIndex() async {
    final readerMode = _cachedReaderMode;
    _currentPageDisplayIndex.value = _savedPageIndex;

    // Initialize the preload manager with bounded memory (from ReaderMemoryManagement mixin)
    initializePreloadManager(_chapterUrlModel, onPagesUpdated: () {});

    // Kick off ordered prefetch before the first frame so lower-indexed pages
    // win the HTTP race against the simultaneous widget-driven loads.
    prefetchPagesInOrder(); // intentionally not awaited

    // proactively start loading adjacent chapters in background
    proactivePreload();

    _readerController.setHistoryUpdate();
    // Use post-frame callback instead of Future.delayed(1ms) timing hack
    await Future(() {});
    if (!mounted) return;
    final fullScreenReader = ref.read(fullScreenReaderStateProvider);
    if (fullScreenReader) {
      if (isDesktop) {
        setFullScreen(value: true);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
    ref.read(_currentReaderMode.notifier).state = readerMode;
    _setReaderMode(readerMode, ref, forceIndex: _currentIndex);

    if (!readerMode.isVerticalContinuous) {
      _autoScroll.value = false;
    }
    _autoPagescroll();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode.isHorizontalPaged || readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  /// Handles page changes in PageView mode (discrete pages).
  Future<void> _onPageChanged(int index) async {
    final int actualIndex = pageViewToActualIndex(index);
    final int prevActualIndex = pageViewToActualIndex(_currentIndex!);

    _updateChapterIfNeeded(actualIndex);
    if (isCurrentPageZoomed) {
      pageControllers[prevActualIndex]?.resetScaleAndCenter();
      if (isDoublePageActive) {
        final previousController = doublePageControllers[_currentIndex!];
        if (previousController != null) {
          previousController.scale = 1.0;
          previousController.position = Offset.zero;
        }
      }
    }

    final bool pageChanged = _currentIndex != index;
    _currentIndex = index;
    _currentPageViewIndex.value = index;

    if (pageChanged) triggerFlash();
    _updateDisplayIndex(actualIndex, true /*Paged*/);

    // ── Next-chapter preloading: trigger when near the end ──
    final distToEnd = pages.length - 1 - actualIndex;
    if (distToEnd <= pagePreloadAmount && !isLastPageTransition) {
      triggerNextChapterPreload();
    }

    await handleEvictionsAndPrefetch();
  }

  /// Hands the reading time measured so far to [controller]'s chapter and
  /// starts counting again, so each chapter gets its own time and an app the
  /// system kills in the background loses at most what came after the last
  /// save.
  void _flushReadingTime(ReaderController controller) {
    final seconds = _readingStopwatch.elapsed.inSeconds;
    _readingStopwatch.reset();
    controller.setHistoryUpdate(elapsedSeconds: seconds);
  }

  /// Updates the active chapter when the user scrolls or swipes into a page
  /// belonging to a different chapter.
  void _updateChapterIfNeeded(int actualIndex) {
    final newChapter = pages[actualIndex].chapter!;
    if (_readerController.chapter.id == newChapter.id) return;

    if (!mounted) return;

    final previousController = _readerController;
    _flushReadingTime(previousController);

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
  void _updateDisplayIndex(int actualIndex, bool pageView) {
    final idx = pages[actualIndex].index;
    if (idx == null) return;
    if (_currentPageDisplayIndex.value != idx) {
      _currentPageDisplayIndex.value = idx;
      _updateHasCurrentError();
      _readerController.setPageIndex(idx, false, _chapterUrlModel.pageUrls);
      ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
    }
  }

  late final _pageOffset = ValueNotifier(
    _readerController.autoScrollValues().$2,
  );

  void _showAutoScrollSheet() {
    showReaderAutoScrollSheet(
      context,
      autoScrollPage: _autoScrollPage,
      autoScroll: _autoScroll,
      pageOffset: _pageOffset,
      onSave: (enabled, offset) =>
          _readerController.setAutoScroll(enabled, offset),
      onAutoPageScroll: _autoPagescroll,
    );
  }

  void _autoPagescroll() {
    onAutoScrollChanged();
  }

  void _setReaderMode(
    ReaderMode value,
    WidgetRef ref, {
    int? forceIndex,
    bool fromUser = false,
  }) async {
    // A new reading mode moves the tap zones; show where they went, for a
    // moment, whether or not the map is set to show on start.
    final showOverlay =
        fromUser || ref.read(showNavigationOverlayOnStartStateProvider);
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

    final int actualIndex = forceIndex ?? getCurrentPagesActualIndex();
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
        showNavigationOverlay = true;
      }
    });
    if (fromUser) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && showNavigationOverlay) {
          setState(() => showNavigationOverlay = false);
        }
      });
    }
    // Wait for the next frame so the scroll view rebuilds
    await WidgetsBinding.instance.endOfFrame;

    final isDoubleInNewMode =
        effectivePageMode == PageMode.doublePage &&
        !value.isHorizontalContinuous;
    final int targetIndex = isDoubleInNewMode
        ? actualToPageViewIndex(actualIndex)
        : actualIndex;
    _currentIndex = targetIndex;
    _currentPageViewIndex.value = targetIndex;

    if (value == ReaderMode.vertical || value.isHorizontalPaged) {
      if (_extendedController.hasClients) {
        _extendedController.jumpToPage(targetIndex);
      }
    } else {
      if (_listController.isAttached &&
          _continuousScrollController.hasClients) {
        _listController.jumpToItem(
          index: targetIndex,
          scrollController: _continuousScrollController,
          alignment: 0.0,
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
}
