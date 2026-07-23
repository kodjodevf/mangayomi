import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:mangayomi/providers/storage_provider.dart';
import 'package:mangayomi/modules/manga/archive_reader/providers/archive_reader_providers.dart';
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
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_gesture_handler.dart';
import 'package:mangayomi/modules/manga/reader/widgets/navigation_overlay.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_settings_modal.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/modules/manga/reader/widgets/image_actions_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/others.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/widgets/custom_extended_image_provider.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_paged.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

typedef DoubleClickAnimationListener = void Function();

class MangaReaderView extends ConsumerStatefulWidget {
  final int chapterId;
  const MangaReaderView({super.key, required this.chapterId});

  @override
  ConsumerState<MangaReaderView> createState() => _MangaReaderViewState();
}

class _MangaReaderViewState extends ConsumerState<MangaReaderView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(mangaReaderProvider(widget.chapterId));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = l10nLocalizations(context)!;
    final chapterData = ref.watch(mangaReaderProvider(widget.chapterId));

    return chapterData.when(
      loading: () => scaffoldWith(context, const ProgressCenter()),
      error: (error, _) =>
          scaffoldWith(context, Center(child: Text(error.toString()))),
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

    _failedToLoadImage.dispose();
    _panAnimationController?.dispose();
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
    discordRpc?.showIdleText();
    final actualIdx = _pageViewToActualIndexSync(_currentIndex!);
    final index = pages[actualIdx].index;
    if (index != null) {
      _readerController.setPageIndex(
        _isDoublePageActiveSync ? index : _geCurrentIndex(index),
        true,
      );
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
    final keepOn = isar.settings.getSync(227)!.keepScreenOnReader ?? true;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _readingStopwatch.stop();
      if (keepOn) {
        WakelockPlus.disable();
      }
      final actualIdx = _pageViewToActualIndex(_currentIndex!);
      final index = pages[actualIdx].index;
      if (index != null) {
        _readerController.setPageIndex(
          _isDoublePageActive ? index : _geCurrentIndex(index),
          true,
        );
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

  final _failedToLoadImage = ValueNotifier<bool>(false);

  late int? _currentIndex = _readerController.getPageIndex();
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
    discordRpc?.showChapterDetails(ref, chapter);
    WidgetsBinding.instance.addObserver(this);
    _initWakelock();
  }

  void _initWakelock() {
    final keepOn = isar.settings.getSync(227)!.keepScreenOnReader ?? true;
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  // final double _horizontalScaleValue = 1.0;
  bool _isNextChapterPreloading = false;
  int _prefetchSessionId = 0;
  // bool _isPrevChapterPreloading = false;

  late int pagePreloadAmount = ref.read(pagePreloadAmountStateProvider);
  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isLastPageTransition = false;
  final _currentReaderMode = StateProvider<ReaderMode?>(() => null);
  PageMode? _pageMode;
  bool _isView = false;
  final _keyboardFocusNode = FocusNode();

  /// Cached reader mode to safely access in dispose without ref.read()
  ReaderMode? _cachedReaderMode;
  final List<int> _cropBorderCheckList = [];
  final Map<int, ssiv.SubsamplingScaleImageViewController> _pageControllers =
      {};

  int _flashPageCount = 0;
  bool _isFlashing = false;
  Color _flashOverlayColor = Colors.black;
  bool _showNavigationOverlay = false;
  bool _isCurrentPageZoomed = false;
  final Map<int, PhotoViewController> _doublePageControllers = {};
  AnimationController? _panAnimationController;

  void _animateDoublePagePan(double targetDx) {
    final controller = _doublePageControllers[_currentIndex];
    if (controller == null) return;
    _panAnimationController?.dispose();

    final startDx = controller.position.dx;
    final dy = controller.position.dy;

    _panAnimationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    final animation = Tween<double>(begin: startDx, end: targetDx).animate(
      CurvedAnimation(
        parent: _panAnimationController!,
        curve: Curves.easeOutCubic,
      ),
    );

    animation.addListener(() {
      final activeController = _doublePageControllers[_currentIndex];
      if (activeController != null) {
        activeController.position = Offset(animation.value, dy);
      }
    });

    _panAnimationController!.forward();
  }

  void _handleNextPageZoomed() {
    final controller = _doublePageControllers[_currentIndex];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;
    final dx = controller.position.dx;

    if (maxX < 15.0) {
      _handlePageNavigation(forward: true);
      return;
    }

    final step = screenWidth * 0.4;

    if (_isReverseHorizontal) {
      final targetDx = (dx + step).clamp(-maxX, maxX);
      if (dx >= maxX - 15.0) {
        _handlePageNavigation(forward: true);
      } else {
        _animateDoublePagePan(targetDx);
      }
    } else {
      final targetDx = (dx - step).clamp(-maxX, maxX);
      if (dx <= -maxX + 15.0) {
        _handlePageNavigation(forward: true);
      } else {
        _animateDoublePagePan(targetDx);
      }
    }
  }

  void _handlePreviousPageZoomed() {
    final controller = _doublePageControllers[_currentIndex];
    if (controller == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final scale = controller.scale ?? 1.0;
    final maxX = screenWidth * (scale - 1.0) / 2.0;
    final dx = controller.position.dx;

    if (maxX < 15.0) {
      _handlePageNavigation(forward: false);
      return;
    }

    final step = screenWidth * 0.4;

    if (_isReverseHorizontal) {
      final targetDx = (dx - step).clamp(-maxX, maxX);
      if (dx <= -maxX + 15.0) {
        _handlePageNavigation(forward: false);
      } else {
        _animateDoublePagePan(targetDx);
      }
    } else {
      final targetDx = (dx + step).clamp(-maxX, maxX);
      if (dx >= maxX - 15.0) {
        _handlePageNavigation(forward: false);
      } else {
        _animateDoublePagePan(targetDx);
      }
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
    pushReplacementMangaReaderView(
      context: context,
      chapter: next
          ? _readerController.getNextChapter()
          : _readerController.getPrevChapter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final readerMode = ref.watch(_currentReaderMode);
    if (readerMode == null) return const SizedBox.shrink();
    final bool isHorizontalContinuous = readerMode.isHorizontalContinuous;
    final webtoonDisableZoomOut = ref.watch(webtoonDisableZoomOutStateProvider);
    final webtoonDoubleTapZoomEnabled = ref.watch(
      webtoonDoubleTapZoomEnabledStateProvider,
    );

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
            child: ValueListenableBuilder(
              valueListenable: _failedToLoadImage,
              builder: (context, failedToLoadImage, child) {
                return Stack(
                  children: [
                    readerMode.isContinuous
                        ? ImageViewWebtoon(
                            pages: pages,
                            itemScrollController: _itemScrollController,
                            scrollOffsetController: _pageOffsetController,
                            itemPositionsListener: _itemPositionsListener,
                            scrollDirection: isHorizontalContinuous
                                ? Axis.horizontal
                                : Axis.vertical,
                            minCacheExtent: isHorizontalContinuous
                                ? (pagePreloadAmount * 2.0) * context.width(1)
                                : (pagePreloadAmount * 2.0) * context.height(1),
                            initialScrollIndex: _readerController
                                .getPageIndex(),
                            physics: const ClampingScrollPhysics(),
                            onLongPressData: (data) => ImageActionsDialog.show(
                              context: context,
                              data: data,
                              manga: widget.chapter.manga.value!,
                              chapterName: widget.chapter.name!,
                            ),
                            onFailedToLoadImage: (value) {
                              // TODO: Handle failed image loading
                              // if (_failedToLoadImage.value != value &&
                              //     context.mounted) {
                              //   _failedToLoadImage.value = value;
                              // }
                            },
                            backgroundColor: backgroundColor,
                            isDoublePageMode:
                                _pageMode == PageMode.doublePage &&
                                !isHorizontalContinuous,
                            isHorizontalContinuous: isHorizontalContinuous,
                            readerMode: ref.watch(_currentReaderMode)!,
                            webtoonSidePadding: ref.watch(
                              webtoonSidePaddingStateProvider,
                            ),
                            showPageGaps: ref.watch(showPageGapsStateProvider),
                            reverse: _isReverseHorizontal,
                            zoomOutDisabled: webtoonDisableZoomOut,
                            doubleTapZoomEnabled: webtoonDoubleTapZoomEnabled,
                            onImageLoaded: (index, width, height) {
                              if (ref.read(splitWidePagesStateProvider) &&
                                  width > height * 1.2) {
                                _splitWidePage(index, width, height);
                              }
                            },
                          )
                        : TweenAnimationBuilder<Color?>(
                            tween: ColorTween(
                              end: getBackgroundColor(backgroundColor),
                            ),
                            duration: const Duration(milliseconds: 300),
                            builder: (context, animColor, animChild) {
                              return Material(
                                color: animColor,
                                shadowColor: animColor,
                                child: animChild,
                              );
                            },
                            child:
                                (_pageMode == PageMode.doublePage &&
                                    !isHorizontalContinuous)
                                ? PageView.builder(
                                    controller: _extendedController,
                                    scrollDirection: _scrollDirection,
                                    reverse: _isReverseHorizontal,
                                    physics: _isCurrentPageZoomed
                                        ? const NeverScrollableScrollPhysics()
                                        : const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      int index1 = index * 2;
                                      int index2 = index1 + 1;
                                      final pageList = [
                                        index1 < pages.length
                                            ? pages[index1]
                                            : null,
                                        index2 < pages.length
                                            ? pages[index2]
                                            : null,
                                      ];
                                      return DoublePageView.paged(
                                        pages: _isReverseHorizontal
                                            ? pageList.reversed.toList()
                                            : pageList,
                                        backgroundColor: backgroundColor,
                                        scrollDirection: _scrollDirection,
                                        onZoomChanged: (zoomed) {
                                          if (index == _currentIndex) {
                                            if (mounted &&
                                                _isCurrentPageZoomed !=
                                                    zoomed) {
                                              setState(() {
                                                _isCurrentPageZoomed = zoomed;
                                              });
                                            }
                                          }
                                        },
                                        onControllerCreated: (controller) {
                                          if (controller != null) {
                                            _doublePageControllers[index] =
                                                controller;
                                          } else {
                                            _doublePageControllers.remove(
                                              index,
                                            );
                                          }
                                        },
                                        onFailedToLoadImage: (val) {
                                          if (_failedToLoadImage.value != val &&
                                              mounted) {
                                            _failedToLoadImage.value = val;
                                          }
                                        },
                                        onLongPressData: (datas) {
                                          ImageActionsDialog.show(
                                            context: context,
                                            data: datas,
                                            manga: widget.chapter.manga.value!,
                                            chapterName: widget.chapter.name!,
                                          );
                                        },
                                      );
                                    },
                                    itemCount: (pages.length / 2).ceil(),
                                    onPageChanged: _onPageChanged,
                                  )
                                : PageView.builder(
                                    controller: _extendedController,
                                    scrollDirection: _scrollDirection,
                                    reverse: _isReverseHorizontal,
                                    physics: _isCurrentPageZoomed
                                        ? const NeverScrollableScrollPhysics()
                                        : const ClampingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                          return _buildPagedItem(
                                            index,
                                            backgroundColor,
                                          );
                                        },
                                    itemCount: pages.length,
                                    onPageChanged: _onPageChanged,
                                  ),
                          ),
                    Consumer(
                      builder: (context, ref, child) {
                        final usePageTapZones = ref.watch(
                          usePageTapZonesStateProvider,
                        );
                        final navigationLayout = ref.watch(
                          readerNavigationLayoutStateProvider,
                        );
                        final tappingInversion = ref.watch(
                          tappingInversionStateProvider,
                        );
                        return ReaderGestureHandler(
                          usePageTapZones: usePageTapZones,
                          navigationLayout: navigationLayout,
                          tappingInversion: tappingInversion,
                          isRTL: _isReverseHorizontal,
                          hasImageError: failedToLoadImage,
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
                        );
                      },
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: _isFlashing ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeInOut,
                          child: Container(color: _flashOverlayColor),
                        ),
                      ),
                    ),
                    if (_showNavigationOverlay)
                      Positioned.fill(
                        child: ReaderNavigationOverlay(
                          navigationLayout: ref.watch(
                            readerNavigationLayoutStateProvider,
                          ),
                          tappingInversion: ref.watch(
                            tappingInversionStateProvider,
                          ),
                          isRTL: _isReverseHorizontal,
                          onClose: () {
                            setState(() {
                              _showNavigationOverlay = false;
                            });
                          },
                        ),
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
                          // Get the actual page index being viewed
                          final actualIdx = _pageViewToActualIndex(
                            _currentIndex!,
                          );
                          final pageIdx = pages[actualIdx].index ?? 0;
                          // Compute target index for the new mode
                          final int targetIndex;
                          if (_pageMode == PageMode.onePage) {
                            // Switching to double page: convert actual index to page view index
                            targetIndex = pageIdx ~/ 2;
                          } else {
                            // Switching to single page: use the actual page index
                            targetIndex = pageIdx;
                          }
                          navigationService.jumpToPage(
                            index: targetIndex,
                            readerMode: ref.read(_currentReaderMode)!,
                          );
                          PageMode newPageMode = _pageMode == PageMode.onePage
                              ? PageMode.doublePage
                              : PageMode.onePage;
                          _readerController.setPageMode(newPageMode);
                          if (mounted) {
                            setState(() {
                              _pageMode = newPageMode;
                            });
                          }
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
          )
          ..loadedWidth = halfWidth
          ..loadedHeight = height;

    setState(() {
      preloadManager.splitPage(index, page1, page2);
    });
  }

  Widget _buildPagedItem(int index, BackgroundColor backgroundColor) {
    final page = pages[index];
    if (page.isTransitionPage) return TransitionViewPaged(data: page);

    final controller = _pageControllers.putIfAbsent(
      index,
      () =>
          ssiv.SubsamplingScaleImageViewController()
            ..addListener(() => _updateZoomStateForIndex(index)),
    );

    final bool isVisible = index == _currentIndex;

    return ImageViewPaged(
      data: page,
      pageController: _extendedController,
      controller: controller,
      isVisible: isVisible,
      onImageLoaded: (width, height) {
        if (ref.read(splitWidePagesStateProvider) && width > height * 1.2) {
          _splitWidePage(index, width.toDouble(), height.toDouble());
        }
        if (width > height) {
          Future.delayed(Duration(milliseconds: 600), () {
            setState(() {});
          });
        }
      },
      loadStateChanged: (state) {
        if (state.loadState == ssiv.LoadState.loading) {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : 0;
          return Container(
            color: getBackgroundColor(backgroundColor),
            height: context.height(0.8),
            child: CircularProgressIndicatorAnimateRotate(progress: progress),
          );
        }
        if (state.loadState == ssiv.LoadState.completed) {
          if (_failedToLoadImage.value) {
            Future.delayed(
              const Duration(milliseconds: 10),
            ).then((value) => _failedToLoadImage.value = false);
          }
          return null; // Dessine l'image via SubsamplingScaleImageView
        }
        if (state.loadState == ssiv.LoadState.failed) {
          if (!_failedToLoadImage.value) {
            Future.delayed(
              const Duration(milliseconds: 10),
            ).then((value) => _failedToLoadImage.value = true);
          }
          final l10n = l10nLocalizations(context)!;
          return Container(
            color: getBackgroundColor(backgroundColor),
            height: context.height(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.image_loading_error,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onLongPress: () {
                      state.reLoadImage();
                      _failedToLoadImage.value = false;
                    },
                    onTap: () {
                      state.reLoadImage();
                      _failedToLoadImage.value = false;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(l10n.retry),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      onLongPressData: (datas) => ImageActionsDialog.show(
        context: context,
        data: datas,
        manga: widget.chapter.manga.value!,
        chapterName: widget.chapter.name!,
      ),
    );
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
    final controller = _pageControllers[_currentIndex!];
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

  void _readProgressListener() async {
    final itemPositions = _itemPositionsListener.itemPositions.value;
    if (itemPositions.isEmpty) return;
    final newIndex = itemPositions.first.index;
    final bool pageChanged = _currentIndex != newIndex;
    _currentIndex = newIndex;
    if (pageChanged) {
      _triggerFlash();
    }
    final currentReaderMode = ref.read(_currentReaderMode);
    int pagesLength =
        (_pageMode == PageMode.doublePage &&
            !(currentReaderMode?.isHorizontalContinuous ?? false))
        ? (pages.length / 2).ceil()
        : pages.length;
    if (_currentIndex! >= 0 && _currentIndex! < pagesLength) {
      if (_readerController.chapter.id != pages[_currentIndex!].chapter!.id) {
        if (mounted) {
          setState(() {
            _readerController = ref.read(
              readerControllerProvider(
                chapter: pages[_currentIndex!].chapter!,
              ).notifier,
            );

            chapter = pages[_currentIndex!].chapter!;
            final chapterUrlModel = pages[_currentIndex!].chapterUrlModel;

            if (chapterUrlModel != null) {
              _chapterUrlModel = chapterUrlModel;
            }

            _isBookmarked = _readerController.getChapterBookmarked();
          });
        }
      }

      // ── Next-chapter preloading: trigger when near the end ──
      final distToEnd = pagesLength - 1 - itemPositions.last.index;
      if (distToEnd <= pagePreloadAmount && !_isLastPageTransition) {
        _triggerNextChapterPreload();
      }

      // // ── Previous-chapter preloading: trigger when near the start ──
      // if (itemPositions.first.index <= pagePreloadAmount) {
      //   _triggerPrevChapterPreload();
      // }

      final idx = pages[_currentIndex!].index;
      if (idx != null) {
        _currentPageDisplayIndex.value = idx;
        _readerController.setPageIndex(
          _isDoublePageActive ? idx : _geCurrentIndex(idx),
          false,
        );
        ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
      }
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
    final readerMode = _readerController.getReaderMode();
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
    if (mounted) {
      setState(() {
        _pageMode = _readerController.getPageMode();
      });
    }
    _setReaderMode(readerMode, ref);

    if (!readerMode.isVerticalContinuous) {
      _autoScroll.value = false;
    }
    _autoPagescroll();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode.isHorizontalPaged || readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
    final showOverlay = ref.read(showNavigationOverlayOnStartStateProvider);
    if (showOverlay && mounted) {
      setState(() {
        _showNavigationOverlay = true;
      });
    }
  }

  /// Warms Flutter's [ImageCache] in page order before the widget tree renders.
  ///
  /// [ScrollablePositionedList] builds all items within [minCacheExtent] in a
  /// single frame, firing every network request simultaneously, which means
  /// pages complete in arbitrary (server-response) order.  By resolving each
  /// provider sequentially here — starting before that first frame — we seed
  /// the cache so that earlier pages win the HTTP race: lower-indexed pages
  /// start their requests first and are therefore ready sooner.
  ///
  /// For pages already within the cache extent the widget will attach to the
  /// already-pending Future (Flutter deduplicates by provider key), so no
  /// extra requests are made.  Pages beyond the cache extent are fetched
  /// strictly one at a time in reading order, so the reader never sees a
  /// later page appear before an earlier one.
  ///
  /// This is fully async — [await] inside a fire-and-forget call — so the
  /// UI stays interactive throughout.
  Future<void> _checkAndReloadEvictedPages(Chapter currentChapter) async {
    final chapterId = currentChapter.id;
    bool needsReload = false;
    for (final page in pages) {
      if (page.chapter?.id == chapterId &&
          !page.isTransitionPage &&
          page.isLocale == true &&
          page.archiveImage == null) {
        needsReload = true;
        break;
      }
    }

    if (needsReload) {
      final isLocalArchive = (currentChapter.archivePath ?? '').isNotEmpty;
      final storageProvider = StorageProvider();
      final mangaDirectory = await storageProvider.getMangaMainDirectory(
        currentChapter,
      );
      final archivePath = isLocalArchive
          ? currentChapter.archivePath
          : (mangaDirectory != null
                ? p.join(mangaDirectory.path, "${currentChapter.name}.cbz")
                : null);

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

  Future<void> _prefetchPagesInOrder() async {
    final sessionId = ++_prefetchSessionId;
    final startIdx = (_currentIndex ?? 0).clamp(0, pages.length - 1);

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

  Future<void> _onPageChanged(int index) async {
    // In non-continuous double page mode, convert page view index to actual
    // pages array index for correct lookups.
    final int actualIndex = _pageViewToActualIndex(index);
    final int prevActualIndex = _pageViewToActualIndex(_currentIndex!);

    final idx = pages[prevActualIndex].index;
    if (idx != null) {
      _readerController.setPageIndex(
        _isDoublePageActive ? idx : _geCurrentIndex(idx),
        false,
      );
    }
    if (_readerController.chapter.id != pages[actualIndex].chapter!.id) {
      if (mounted) {
        setState(() {
          _readerController = ref.read(
            readerControllerProvider(
              chapter: pages[actualIndex].chapter!,
            ).notifier,
          );
          chapter = pages[actualIndex].chapter!;
          final chapterUrlModel = pages[actualIndex].chapterUrlModel;
          if (chapterUrlModel != null) {
            _chapterUrlModel = chapterUrlModel;
          }
          _isBookmarked = _readerController.getChapterBookmarked();
        });
      }
    }
    // Reset zoom of the previous page so user can swipe back freely (#443).
    _pageControllers[prevActualIndex]?.resetScaleAndCenter();
    if (_isDoublePageActive) {
      final prevController = _doublePageControllers[prevActualIndex];
      if (prevController != null) {
        prevController.scale = 1.0;
        prevController.position = Offset.zero;
      }
    }

    final bool pageChanged = _currentIndex != index;
    _currentIndex = index;

    if (pageChanged) {
      _triggerFlash();
    }
    if (pages[actualIndex].index != null) {
      _currentPageDisplayIndex.value = pages[actualIndex].index!;
      ref
          .read(currentIndexProvider(chapter).notifier)
          .setCurrentIndex(pages[actualIndex].index!);
    }

    // ── Next-chapter preloading: trigger when near the end ──
    final distToEnd = pages.length - 1 - actualIndex;
    if (distToEnd <= pagePreloadAmount && !_isLastPageTransition) {
      _triggerNextChapterPreload();
    }

    // // ── Previous-chapter preloading: trigger when near the start ──
    // if (actualIndex <= pagePreloadAmount) {
    //   _triggerPrevChapterPreload();
    // }

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
    if (!value.isVerticalContinuous) {
      _autoScroll.value = false;
    } else if (_autoScrollPage.value) {
      _autoPagescroll();
      _autoScroll.value = true;
    }

    _failedToLoadImage.value = false;
    _readerController.setReaderMode(value);

    // Cache the reader mode for safe access in dispose
    _cachedReaderMode = value;

    int index = _pageViewToActualIndex(_currentIndex!);
    ref.read(_currentReaderMode.notifier).state = value;
    if (!mounted) return;
    setState(() {
      _isReverseHorizontal = value.isRTL;

      if (value == ReaderMode.vertical) {
        _scrollDirection = Axis.vertical;
      } else if (value.isHorizontalPaged) {
        _scrollDirection = Axis.horizontal;
      }
      _showNavigationOverlay = true;
    });
    // Wait for the next frame so the scroll view rebuilds
    await WidgetsBinding.instance.endOfFrame;

    if (value == ReaderMode.vertical || value.isHorizontalPaged) {
      _extendedController.jumpToPage(index);
    } else {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 1),
        curve: Curves.ease,
      );
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

  String _currentIndexLabel(int index) {
    if (_pageMode != PageMode.doublePage) {
      return "${index + 1}";
    }
    int pageLength = _readerController.getPageLength(_chapterUrlModel.pageUrls);
    int page1 = index + 1;
    int page2 = index + 2;
    return page2 > pageLength ? "$pageLength" : "$page1-$page2";
  }

  int _geCurrentIndex(int index) {
    return index;
  }

  /// Whether double page mode is active (continuous or paged).
  /// Horizontal continuous mode does NOT use double page layout.
  /// Uses ref.read() so cannot be called during dispose.
  bool get _isDoublePageActive =>
      _pageMode == PageMode.doublePage &&
      !(ref.read(_currentReaderMode)?.isHorizontalContinuous ?? false);

  /// Safe version of _isDoublePageActive that uses cached reader mode.
  /// Safe to call during dispose without Riverpod assertion errors.
  bool get _isDoublePageActiveSync =>
      _pageMode == PageMode.doublePage &&
      !(_cachedReaderMode?.isHorizontalContinuous ?? false);

  /// Converts a page view index (from ExtendedPageController) to the actual
  /// index in the [pages] array for double page mode.
  ///
  /// In double page mode:
  ///   PV 0 → pages[0] (first page shown solo)
  ///   PV n (n>0) → pages[2n-1] (first page of the pair)
  int _pageViewToActualIndex(int pageViewIndex) {
    if (!_isDoublePageActive) return pageViewIndex;
    return (pageViewIndex * 2).clamp(0, pages.length - 1);
  }

  /// Safe version that uses cached reader mode for use in dispose.
  int _pageViewToActualIndexSync(int pageViewIndex) {
    if (!_isDoublePageActiveSync) return pageViewIndex;
    return (pageViewIndex * 2).clamp(0, pages.length - 1);
  }

  /// Converts an actual [pages] array index to a page view index
  /// for double page mode.
  int _actualToPageViewIndex(int actualIndex) {
    if (!_isDoublePageActive) return actualIndex;
    return actualIndex ~/ 2;
  }

  /// Total page count as seen by the page view controller.
  /// In double page mode, each PV page shows 2 actual pages.
  int get _pageViewPageCount =>
      _isDoublePageActive ? (pages.length / 2).ceil() : pages.length;

  bool _isContinuousMode([ReaderMode? mode]) {
    final readerMode = mode ?? ref.read(_currentReaderMode);
    return readerMode!.isContinuous;
  }
}
