import 'dart:async';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/providers/crop_borders_provider.dart';
import 'package:mangayomi/modules/manga/reader/services/page_navigation_service.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_memory_management.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_bottom_bar.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_gesture_handler.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_settings_modal.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/page_indicator.dart';
import 'package:mangayomi/modules/manga/reader/widgets/image_actions_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/riverpod.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_paged.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/manga/reader/providers/manga_reader_provider.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:photo_view/photo_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
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
            const Center(child: Text('Error: no pages available')),
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
        leading: BackButton(
          onPressed: () {
            if (restoreUi) {
              SystemChrome.setEnabledSystemUIMode(
                SystemUiMode.manual,
                overlays: SystemUiOverlay.values,
              );
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
        PageNavigationMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;

  late ReaderController _readerController = ref.read(
    readerControllerProvider(chapter: chapter).notifier,
  );

  bool isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _readerController.setMangaHistoryUpdate();
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    _scaleAnimationController.dispose();
    _failedToLoadImage.dispose();
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _itemPositionsListener.itemPositions.removeListener(_readProgressListener);
    _photoViewController.dispose();
    _photoViewScaleStateController.dispose();
    _extendedController.dispose();
    clearGestureDetailsCache();
    if (isDesktop) {
      setFullScreen(value: false);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
    discordRpc?.showIdleText();
    final index = pages[_currentIndex!].index;
    if (index != null) {
      _readerController.setPageIndex(_geCurrentIndex(index), true);
    }
    disposePreloadManager();
    _readerController.keepAliveLink?.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final index = pages[_currentIndex!].index;
      if (index != null) {
        _readerController.setPageIndex(_geCurrentIndex(index), true);
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

  late final ItemScrollController _itemScrollController =
      ItemScrollController();
  final ScrollOffsetController _pageOffsetController = ScrollOffsetController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  late AnimationController _doubleClickAnimationController;

  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    _doubleClickAnimationController = AnimationController(
      duration: _doubleTapAnimationDuration(),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: _doubleTapAnimationDuration(),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController),
    );
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    initPageNavigation(
      itemScrollController: _itemScrollController,
      extendedController: _extendedController,
    );
    _initCurrentIndex();
    discordRpc?.showChapterDetails(ref, chapter);
    WidgetsBinding.instance.addObserver(this);
  }

  // final double _horizontalScaleValue = 1.0;
  bool _isNextChapterPreloading = false;

  late int pagePreloadAmount = ref.read(pagePreloadAmountStateProvider);
  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isLastPageTransition = false;
  final _currentReaderMode = StateProvider<ReaderMode?>(() => null);
  PageMode? _pageMode;
  bool _isView = false;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();
  final List<int> _cropBorderCheckList = [];

  void _onScaleEnd(
    BuildContext context,
    ScaleEndDetails details,
    PhotoViewControllerValue controllerValue,
  ) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  late final _extendedController = ExtendedPageController(
    initialPage: _currentIndex!,
  );

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;
  Alignment _computeAlignmentByTapOffset(Offset offset) {
    return Alignment(
      (offset.dx - size.width / 2) / (size.width / 2),
      (offset.dy - size.height / 2) / (size.height / 2),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final cropBorders = ref.watch(cropBordersStateProvider);
    final readerMode = ref.watch(_currentReaderMode);
    final bool isHorizontalContinuaous =
        readerMode == ReaderMode.horizontalContinuous;
    if (cropBorders) {
      _processCropBorders();
    }

    final l10n = l10nLocalizations(context)!;
    return ReaderKeyboardHandler(
      onPreviousPage: () => navigationService.previousPage(
        readerMode: readerMode!,
        currentIndex: _currentIndex!,
        animate: true,
      ),
      onNextPage: () => navigationService.nextPage(
        readerMode: readerMode!,
        currentIndex: _currentIndex!,
        maxPages: pages.length,
        animate: true,
      ),
      onEscape: () => _goBack(context),
      onFullScreen: () => _setFullScreen(),
      onNextChapter: () {
        bool hasNextChapter = _readerController.getChapterIndex().$1 != 0;
        if (hasNextChapter) {
          pushReplacementMangaReaderView(
            context: context,
            chapter: _readerController.getNextChapter(),
          );
        }
      },
      onPreviousChapter: () {
        bool hasPrevChapter =
            _readerController.getChapterIndex().$1 + 1 !=
            _readerController.getChaptersLength(
              _readerController.getChapterIndex().$2,
            );
        if (hasPrevChapter) {
          pushReplacementMangaReaderView(
            context: context,
            chapter: _readerController.getPrevChapter(),
          );
        }
      },
    ).wrapWithKeyboardListener(
      isReverseHorizontal: _isReverseHorizontal,
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            if (_isView) {
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
                    _isContinuousMode()
                        ? ImageViewWebtoon(
                            pages: pages,
                            itemScrollController: _itemScrollController,
                            scrollOffsetController: _pageOffsetController,
                            itemPositionsListener: _itemPositionsListener,
                            scrollDirection: isHorizontalContinuaous
                                ? Axis.horizontal
                                : Axis.vertical,
                            minCacheExtent:
                                pagePreloadAmount * context.height(1),
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
                              // Handle failed image loading
                              if (_failedToLoadImage.value != value &&
                                  context.mounted) {
                                _failedToLoadImage.value = value;
                              }
                            },
                            backgroundColor: backgroundColor,
                            isDoublePageMode:
                                _pageMode == PageMode.doublePage &&
                                !isHorizontalContinuaous,
                            isHorizontalContinuous: isHorizontalContinuaous,
                            readerMode: ref.watch(_currentReaderMode)!,
                            photoViewController: _photoViewController,
                            photoViewScaleStateController:
                                _photoViewScaleStateController,
                            scalePosition: _scalePosition,
                            onScaleEnd: (details) => _onScaleEnd(
                              context,
                              details,
                              _photoViewController.value,
                            ),
                            onDoubleTapDown: (offset) => _toggleScale(offset),
                            onDoubleTap: () {},
                          )
                        : Material(
                            color: getBackgroundColor(backgroundColor),
                            shadowColor: getBackgroundColor(backgroundColor),
                            child:
                                (_pageMode == PageMode.doublePage &&
                                    !isHorizontalContinuaous)
                                ? ExtendedImageGesturePageView.builder(
                                    controller: _extendedController,
                                    scrollDirection: _scrollDirection,
                                    reverse: _isReverseHorizontal,
                                    physics: const ClampingScrollPhysics(),
                                    canScrollPage: (_) {
                                      return true;
                                    },
                                    itemBuilder: (context, index) {
                                      if (index < pages.length &&
                                          pages[index].isTransitionPage) {
                                        return TransitionViewPaged(
                                          data: pages[index],
                                        );
                                      }

                                      int index1 = index * 2 - 1;
                                      int index2 = index1 + 1;
                                      final pageList = (index == 0
                                          ? [pages[0], null]
                                          : [
                                              index1 < pages.length
                                                  ? pages[index1]
                                                  : null,
                                              index2 < pages.length
                                                  ? pages[index2]
                                                  : null,
                                            ]);
                                      return DoublePageView.paged(
                                        pages: _isReverseHorizontal
                                            ? pageList.reversed.toList()
                                            : pageList,
                                        backgroundColor: backgroundColor,
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
                                    itemCount: (pages.length / 2).ceil() + 1,
                                    onPageChanged: _onPageChanged,
                                  )
                                : ExtendedImageGesturePageView.builder(
                                    controller: _extendedController,
                                    scrollDirection: _scrollDirection,
                                    reverse: _isReverseHorizontal,
                                    physics: const ClampingScrollPhysics(),
                                    canScrollPage: (gestureDetails) {
                                      return true;
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      if (pages[index].isTransitionPage) {
                                        return TransitionViewPaged(
                                          data: pages[index],
                                        );
                                      }

                                      return ImageViewPaged(
                                        data: pages[index],
                                        loadStateChanged: (state) {
                                          if (state.extendedImageLoadState ==
                                              LoadState.loading) {
                                            final ImageChunkEvent?
                                            loadingProgress =
                                                state.loadingProgress;
                                            final double progress =
                                                loadingProgress
                                                        ?.expectedTotalBytes !=
                                                    null
                                                ? loadingProgress!
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : 0;
                                            return Container(
                                              color: getBackgroundColor(
                                                backgroundColor,
                                              ),
                                              height: context.height(0.8),
                                              child:
                                                  CircularProgressIndicatorAnimateRotate(
                                                    progress: progress,
                                                  ),
                                            );
                                          }
                                          if (state.extendedImageLoadState ==
                                              LoadState.completed) {
                                            if (_failedToLoadImage.value ==
                                                true) {
                                              Future.delayed(
                                                const Duration(
                                                  milliseconds: 10,
                                                ),
                                              ).then(
                                                (value) =>
                                                    _failedToLoadImage.value =
                                                        false,
                                              );
                                            }
                                            return ExtendedImageGesture(
                                              state,
                                              canScaleImage: (_) => true,
                                              imageBuilder:
                                                  (
                                                    Widget image, {
                                                    ExtendedImageGestureState?
                                                    imageGestureState,
                                                  }) {
                                                    return image;
                                                  },
                                            );
                                          }
                                          if (state.extendedImageLoadState ==
                                              LoadState.failed) {
                                            if (_failedToLoadImage.value ==
                                                false) {
                                              Future.delayed(
                                                const Duration(
                                                  milliseconds: 10,
                                                ),
                                              ).then(
                                                (value) =>
                                                    _failedToLoadImage.value =
                                                        true,
                                              );
                                            }
                                            return Container(
                                              color: getBackgroundColor(
                                                backgroundColor,
                                              ),
                                              height: context.height(0.8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    l10n.image_loading_error,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: GestureDetector(
                                                      onLongPress: () {
                                                        state.reLoadImage();
                                                        _failedToLoadImage
                                                                .value =
                                                            false;
                                                      },
                                                      onTap: () {
                                                        state.reLoadImage();
                                                        _failedToLoadImage
                                                                .value =
                                                            false;
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: context
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                30,
                                                              ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 8,
                                                                horizontal: 16,
                                                              ),
                                                          child: Text(
                                                            l10n.retry,
                                                          ),
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
                                        initGestureConfigHandler: (state) {
                                          return GestureConfig(
                                            inertialSpeed: 200,
                                            inPageView: true,
                                            maxScale: 8,
                                            animationMaxScale: 8,
                                            cacheGesture: true,
                                            hitTestBehavior:
                                                HitTestBehavior.translucent,
                                          );
                                        },
                                        onDoubleTap: (state) {
                                          final Offset? pointerDownPosition =
                                              state.pointerDownPosition;
                                          final double? begin =
                                              state.gestureDetails!.totalScale;
                                          double end;

                                          //remove old
                                          _doubleClickAnimation?.removeListener(
                                            _doubleClickAnimationListener,
                                          );

                                          //stop pre
                                          _doubleClickAnimationController
                                              .stop();

                                          //reset to use
                                          _doubleClickAnimationController
                                              .reset();

                                          if (begin == doubleTapScales[0]) {
                                            end = doubleTapScales[1];
                                          } else {
                                            end = doubleTapScales[0];
                                          }

                                          _doubleClickAnimationListener = () {
                                            state.handleDoubleTap(
                                              scale:
                                                  _doubleClickAnimation!.value,
                                              doubleTapPosition:
                                                  pointerDownPosition,
                                            );
                                          };

                                          _doubleClickAnimation =
                                              Tween(
                                                begin: begin,
                                                end: end,
                                              ).animate(
                                                CurvedAnimation(
                                                  curve: Curves.ease,
                                                  parent:
                                                      _doubleClickAnimationController,
                                                ),
                                              );

                                          _doubleClickAnimation!.addListener(
                                            _doubleClickAnimationListener,
                                          );

                                          _doubleClickAnimationController
                                              .forward();
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
                                    itemCount: pages.length,
                                    onPageChanged: _onPageChanged,
                                  ),
                          ),
                    Consumer(
                      builder: (context, ref, child) {
                        final usePageTapZones = ref.watch(
                          usePageTapZonesStateProvider,
                        );
                        return ReaderGestureHandler(
                          usePageTapZones: usePageTapZones,
                          isRTL: _isReverseHorizontal,
                          hasImageError: failedToLoadImage,
                          isContinuousMode: _isContinuousMode(),
                          onToggleUI: _isViewFunction,
                          onPreviousPage: () => navigationService.previousPage(
                            readerMode: readerMode!,
                            currentIndex: _currentIndex!,
                            animate: true,
                          ),
                          onNextPage: () => navigationService.nextPage(
                            readerMode: readerMode!,
                            currentIndex: _currentIndex!,
                            maxPages: pages.length,
                            animate: true,
                          ),
                          onDoubleTapDown: (position) => _toggleScale(position),
                          onDoubleTap: () {},
                          onSecondaryTapDown: (position) =>
                              _toggleScale(position),
                          onSecondaryTap: () {},
                        );
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
                      hasPreviousChapter:
                          _readerController.getChapterIndex().$1 + 1 !=
                          _readerController.getChaptersLength(
                            _readerController.getChapterIndex().$2,
                          ),
                      hasNextChapter:
                          _readerController.getChapterIndex().$1 != 0,
                      onPreviousChapter: () {
                        pushReplacementMangaReaderView(
                          context: context,
                          chapter: _readerController.getPrevChapter(),
                        );
                      },
                      onNextChapter: () {
                        pushReplacementMangaReaderView(
                          context: context,
                          chapter: _readerController.getNextChapter(),
                        );
                      },
                      onSliderChanged: (value, ref) {
                        ref
                            .read(currentIndexProvider(chapter).notifier)
                            .setCurrentIndex(value);
                      },
                      onSliderChangeEnd: (value) {
                        try {
                          final index = pages
                              .firstWhere(
                                (element) =>
                                    element.chapter == chapter &&
                                    element.index == value,
                              )
                              .pageIndex;
                          navigationService.jumpToPage(
                            index: index!,
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
                        if (!(readerMode == ReaderMode.horizontalContinuous)) {
                          navigationService.jumpToPage(
                            index: _pageMode == PageMode.onePage
                                ? (_geCurrentIndex(
                                            pages[_currentIndex!].index!,
                                          ) /
                                          2)
                                      .ceil()
                                : _geCurrentIndex(pages[_currentIndex!].index!),
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
                      currentIndexProvider: currentIndexProvider,
                      currentPageMode: _pageMode,
                      isReverseHorizontal: _isReverseHorizontal,
                      totalPages: _readerController.getPageLength(
                        _chapterUrlModel.pageUrls,
                      ),
                      currentIndexLabel: _currentIndexLabel,
                      backgroundColor: _backgroundColor,
                    ),
                    PageIndicator(
                      chapter: chapter,
                      isUiVisible: _isView,
                      totalPages: _readerController.getPageLength(
                        _chapterUrlModel.pageUrls,
                      ),
                      formatCurrentIndex: _currentIndexLabel,
                    ),
                    ReaderAutoScrollButton(
                      isContinuousMode: _isContinuousMode(),
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

  Duration? _doubleTapAnimationDuration() {
    int doubleTapAnimationValue = isar.settings
        .getSync(227)!
        .doubleTapAnimationSpeed!;
    if (doubleTapAnimationValue == 0) {
      return const Duration(milliseconds: 10);
    } else if (doubleTapAnimationValue == 1) {
      return const Duration(milliseconds: 800);
    }
    return const Duration(milliseconds: 200);
  }

  void _readProgressListener() async {
    final itemPositions = _itemPositionsListener.itemPositions.value;
    if (itemPositions.isNotEmpty) {
      _currentIndex = itemPositions.first.index;
      int pagesLength =
          (_pageMode == PageMode.doublePage &&
              !(ref.watch(_currentReaderMode) ==
                  ReaderMode.horizontalContinuous))
          ? (pages.length / 2).ceil() + 1
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
        if ((itemPositions.last.index == pagesLength - 1) &&
            !_isLastPageTransition) {
          if (_isNextChapterPreloading) return;
          try {
            _isNextChapterPreloading = true;
            if (!mounted) return;
            try {
              final idx = pages[_currentIndex!].index;
              if (idx != null) {
                _readerController.setPageIndex(_geCurrentIndex(idx), false);
              }
            } catch (_) {}
            final value = await ref.read(
              getChapterPagesProvider(
                chapter: _readerController.getNextChapter(),
              ).future,
            );
            if (mounted) {
              _preloadNextChapter(value, chapter);
              _isNextChapterPreloading = false;
            }
          } on RangeError {
            _isNextChapterPreloading = false;
            _addLastPageTransition(chapter);
          }
        }
        final idx = pages[_currentIndex!].index;
        if (idx != null) {
          ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(idx);
        }
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

  void _initCurrentIndex() async {
    final readerMode = _readerController.getReaderMode();

    // Initialize the preload manager with bounded memory (from ReaderMemoryManagement mixin)
    initializePreloadManager(
      _chapterUrlModel,
      startIndex: _currentIndex ?? 0,
      onPagesUpdated: () {
        if (mounted) setState(() {});
      },
    );

    _readerController.setMangaHistoryUpdate();
    await Future.delayed(const Duration(milliseconds: 1));
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
    // if (pageCount > 0 && _currentIndex != null && _currentIndex! < pageCount) {
    //   ref
    //       .read(currentIndexProvider(chapter).notifier)
    //       .setCurrentIndex(pages[_currentIndex!].index!);
    // }

    if (readerMode != ReaderMode.verticalContinuous &&
        readerMode != ReaderMode.webtoon) {
      _autoScroll.value = false;
    }
    _autoPagescroll();
    if (_readerController.getPageLength(_chapterUrlModel.pageUrls) == 1 &&
        (readerMode == ReaderMode.ltr ||
            readerMode == ReaderMode.rtl ||
            readerMode == ReaderMode.vertical)) {
      _onPageChanged(0);
    }
  }

  Future<void> _onPageChanged(int index) async {
    final cropBorders = ref.watch(cropBordersStateProvider);
    if (cropBorders) {
      _processCropBordersByIndex(index);
    }
    final idx = pages[_currentIndex!].index;
    if (idx != null) {
      _readerController.setPageIndex(_geCurrentIndex(idx), false);
    }
    if (_readerController.chapter.id != pages[index].chapter!.id) {
      if (mounted) {
        setState(() {
          _readerController = ref.read(
            readerControllerProvider(
              chapter: pages[index].chapter!,
            ).notifier,
          );
          chapter = pages[index].chapter!;
          final chapterUrlModel = pages[index].chapterUrlModel;
          if (chapterUrlModel != null) {
            _chapterUrlModel = chapterUrlModel;
          }
          _isBookmarked = _readerController.getChapterBookmarked();
        });
      }
    }
    _currentIndex = index;
    if (pages[index].index != null) {
      ref
          .read(currentIndexProvider(chapter).notifier)
          .setCurrentIndex(pages[index].index!);
    }

    if ((pages[index].pageIndex! == pages.length - 1) &&
        !_isLastPageTransition) {
      if (_isNextChapterPreloading) return;
      try {
        _isNextChapterPreloading = true;
        if (!mounted) return;
        final value = await ref.watch(
          getChapterPagesProvider(
            chapter: _readerController.getNextChapter(),
          ).future,
        );
        if (mounted) {
          _preloadNextChapter(value, chapter);
          _isNextChapterPreloading = false;
        }
      } on RangeError {
        _isNextChapterPreloading = false;
        _addLastPageTransition(chapter);
      }
    }
  }

  late final _pageOffset = ValueNotifier(
    _readerController.autoScrollValues().$2,
  );

  void _autoPagescroll() async {
    if (_isContinuousMode()) {
      for (int i = 0; i < 1; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (!_autoScroll.value) {
          return;
        }
        _pageOffsetController.animateScroll(
          offset: _pageOffset.value,
          duration: const Duration(milliseconds: 100),
        );
      }
      _autoPagescroll();
    }
  }

  void _toggleScale(Offset tapPosition) {
    if (mounted) {
      setState(() {
        if (_scaleAnimationController.isAnimating) {
          return;
        }

        if (_photoViewController.scale == 1.0) {
          _scalePosition = _computeAlignmentByTapOffset(tapPosition);

          if (_scaleAnimationController.isCompleted) {
            _scaleAnimationController.reset();
          }

          _scaleAnimationController.forward();
          return;
        }

        if (_photoViewController.scale == 2.0) {
          _scaleAnimationController.reverse();
          return;
        }

        _photoViewScaleStateController.reset();
      });
    }
  }

  void _setReaderMode(ReaderMode value, WidgetRef ref) async {
    if (value != ReaderMode.verticalContinuous && value != ReaderMode.webtoon) {
      _autoScroll.value = false;
    } else {
      if (_autoScrollPage.value) {
        _autoPagescroll();
        _autoScroll.value = true;
      }
    }

    _failedToLoadImage.value = false;
    _readerController.setReaderMode(value);

    int index =
        (_pageMode == PageMode.doublePage &&
            !(ref.watch(_currentReaderMode) == ReaderMode.horizontalContinuous))
        ? (_currentIndex! / 2).ceil()
        : _currentIndex!;
    ref.read(_currentReaderMode.notifier).state = value;
    if (value == ReaderMode.vertical) {
      if (mounted) {
        setState(() {
          _scrollDirection = Axis.vertical;
          _isReverseHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(index);
      }
    } else if (value == ReaderMode.ltr || value == ReaderMode.rtl) {
      if (mounted) {
        setState(() {
          if (value == ReaderMode.rtl) {
            _isReverseHorizontal = true;
          } else {
            _isReverseHorizontal = false;
          }

          _scrollDirection = Axis.horizontal;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(index);
      }
    } else {
      if (mounted) {
        setState(() {
          _isReverseHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));
        _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.ease,
        );
      }
    }
  }

  void _processCropBordersByIndex(int index) async {
    if (!_cropBorderCheckList.contains(index)) {
      _cropBorderCheckList.add(index);
      if (!mounted) return;
      final value = await ref.read(
        cropBordersProvider(data: pages[index], cropBorder: true).future,
      );
      if (mounted) {
        updatePageCropImage(index, value);
      }
    }
  }

  void _processCropBorders() async {
    if (_cropBorderCheckList.length == pages.length) return;

    for (var i = 0; i < pages.length; i++) {
      if (!_cropBorderCheckList.contains(i)) {
        _cropBorderCheckList.add(i);
        if (!mounted) return;
        final value = await ref.read(
          cropBordersProvider(data: pages[i], cropBorder: true).future,
        );
        if (mounted) {
          updatePageCropImage(i, value);
        }
      }
    }
  }

  void _goBack(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    Navigator.pop(context);
  }

  void _isViewFunction() {
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    if (context.mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (fullScreenReader) {
      if (_isView) {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
  }

  String _currentIndexLabel(int index) {
    if (_pageMode != PageMode.doublePage) {
      return "${index + 1}";
    }
    if (index == 0) {
      return "1";
    }
    int pageLength = _readerController.getPageLength(_chapterUrlModel.pageUrls);
    int index1 = index * 2;
    int index2 = index1 + 1;
    return !(index * 2 < pageLength) ? "$pageLength" : "$index1-$index2";
  }

  int _geCurrentIndex(int index) {
    if (_pageMode != PageMode.doublePage || index == 0) {
      return index;
    }
    int pageLength = _readerController.getPageLength(_chapterUrlModel.pageUrls);
    int index1 = index * 2;
    return !(index * 2 < pageLength) ? pageLength - 1 : index1 - 1;
  }

  bool _isContinuousMode() {
    final readerMode = ref.watch(_currentReaderMode);
    return readerMode == ReaderMode.verticalContinuous ||
        readerMode == ReaderMode.webtoon ||
        readerMode == ReaderMode.horizontalContinuous;
  }
}
