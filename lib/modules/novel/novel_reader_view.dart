import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/reader_common/key_bindings.dart';
import 'package:mangayomi/modules/novel/utils/reading_time.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/services/volume_keys.dart';
import 'package:mangayomi/modules/reader_common/utils/reader_orientation.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/services/discord_rpc.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/reader_common/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/reader_common/widgets/reader_app_bar.dart';
import 'package:mangayomi/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/mixins/novel_pagination_tts_mixin.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/modules/novel/tts/tts_player_bar.dart';
import 'package:mangayomi/modules/novel/tts/tts_settings_tab.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
import 'package:mangayomi/modules/novel/widgets/novel_bottom_bar.dart';
import 'package:mangayomi/modules/novel/widgets/novel_general_settings_tab.dart';
import 'package:mangayomi/modules/novel/widgets/novel_html_content.dart';
import 'package:mangayomi/modules/novel/widgets/novel_reader_settings_sheet.dart';
import 'package:mangayomi/modules/novel/widgets/novel_tap_zones.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_html_content.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/router/push_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mangayomi/modules/reader_common/mixins/reader_auto_scroll.dart';
import 'package:mangayomi/modules/reader_common/mixins/chapter_controller_mixin.dart';

class NovelReaderView extends ConsumerWidget {
  final int chapterId;
  NovelReaderView({super.key, required this.chapterId});
  late final Chapter chapter = chapterRepository.getById(chapterId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(getHtmlContentProvider(chapter: chapter));

    return NovelWebView(chapter: chapter, result: result);
  }
}

class NovelWebView extends ConsumerStatefulWidget {
  const NovelWebView({super.key, required this.chapter, required this.result});

  final Chapter chapter;
  final AsyncValue<(String, EpubNovel?)> result;

  @override
  ConsumerState createState() {
    return _NovelWebViewState();
  }
}

class _NovelWebViewState extends ConsumerState<NovelWebView>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver,
        ReaderAutoScroll,
        NovelPaginationAndTtsMixin<NovelWebView> {
  @override
  ValueNotifier<bool> get autoScrollEnabled => _autoScroll;
  @override
  ValueNotifier<double> get autoScrollSpeed => _pageOffset;
  @override
  ScrollController get autoScrollController => scrollController;
  @override
  bool get canAutoScroll => _isContinuousMode();

  /// Resolved in [initState], not lazily.
  ///
  /// As a `late` field with an initialiser this was read for the first time
  /// by whatever touched it first, and on a reader closed before its first
  /// build got that far, that was `dispose()`. Riverpod forbids `ref` there:
  /// it needs the BuildContext, and the element is already deactivated. See
  /// issue #949, reported from the novel reader on 0.8.9.
  @override
  late final NovelReaderController readerController;
  @override
  final scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  late PageMode _pageMode = readerController.getPageMode();
  late ReaderMode _readerMode = readerController.getReaderMode();

  @override
  bool scrolled = false;
  @override
  bool scrollRestoreScheduled = false;
  @override
  double offset = 0;
  @override
  double maxOffset = 0;
  int fontSize = 14;

  final Stopwatch _readingStopwatch = Stopwatch();
  int? _discordReaderSession;

  /// Hands the reading time measured so far to the chapter and starts
  /// counting again, so an app the system kills in the background loses at
  /// most what came after the last save.
  void _flushReadingTime() {
    final seconds = _readingStopwatch.elapsed.inSeconds;
    _readingStopwatch.reset();
    readerController.setHistoryUpdate(elapsedSeconds: seconds);
  }

  void onScroll() {
    if (scrollController.hasClients) {
      offset = scrollController.offset;
      maxOffset = scrollController.position.maxScrollExtent;
      rebuildDetail.add(offset);
    }
  }

  @override
  void dispose() {
    _readingStopwatch.stop();
    WidgetsBinding.instance.removeObserver(this);
    VolumeKeys.disable();
    releaseReaderOrientation();
    applyReaderScreenBrightness(-1);
    updatePaginatedOffsetBeforeDispose(_readerMode);
    readerController.setChapterOffset(offset, maxOffset, true);
    _flushReadingTime();
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    rebuildDetail.close();
    disposeAutoScroll();
    _autoScroll.removeListener(onAutoScrollChanged);
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _keyboardFocusNode.dispose();
    disposePaginationAndTts();
    if (isDesktop) {
      setFullScreen(value: false);
    } else {
      restoreSystemUI();
    }
    final discordReaderSession = _discordReaderSession;
    if (discordReaderSession != null) {
      unawaited(discordRpc?.endReaderSession(discordReaderSession));
    }
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _readingStopwatch.stop();
      _flushReadingTime();
      if (keepOn) {
        WakelockPlus.disable();
      }
      // The volume buttons are the system's again while away.
      VolumeKeys.disable();
      applyReaderScreenBrightness(-1);
    } else if (state == AppLifecycleState.resumed) {
      _readingStopwatch.start();
      if (keepOn) {
        WakelockPlus.enable();
      }
      _setVolumeKeys(ref.read(volumeKeysPagingStateProvider));
      applyReaderScreenBrightness(
        ref.read(readerScreenBrightnessStateProvider),
      );
    }
  }

  /// Takes the volume buttons for page turns while [on], as the manga
  /// reader does: volume down turns forward, volume up back, unless
  /// inverted.
  void _setVolumeKeys(bool on) {
    if (!on) {
      VolumeKeys.disable();
      return;
    }
    VolumeKeys.enable((up) {
      if (!mounted) return;
      final inverted = ref.read(volumeKeysInvertedStateProvider);
      _onBtnTapped((inverted ? up : !up) ? 100 : -100);
    });
  }

  void _initWakelock() {
    final keepOn = ref.read(keepScreenOnReaderStateProvider);
    if (keepOn) {
      WakelockPlus.enable();
    }
  }

  @override
  late Chapter chapter = widget.chapter;
  @override
  EpubNovel? epubBook;

  @override
  final StreamController<double> rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    beginReadingSession();
    // Before anything that can fail, so the controller dispose() needs is
    // always there: this is the whole point of not leaving it lazy.
    readerController = ref.read(
      novelReaderControllerProvider(chapter: chapter).notifier,
    );
    WidgetsBinding.instance.addObserver(this);
    _readingStopwatch.start();
    _autoScroll.addListener(onAutoScrollChanged);
    _initWakelock();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setVolumeKeys(ref.read(volumeKeysPagingStateProvider));
        applyReaderOrientation(ref.read(readerOrientationStateProvider));
        applyReaderScreenBrightness(
          ref.read(readerScreenBrightnessStateProvider),
        );
      }
      scrollController.addListener(onScroll);
      final initFontSize = ref.read(novelFontSizeStateProvider);
      setState(() {
        fontSize = initFontSize;
      });
      if (_autoScroll.value && _isContinuousMode()) {
        startAutoScroll();
      }
    });
    if (!isDesktop) SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _discordReaderSession = discordRpc?.beginReaderSession();
    discordRpc?.showChapterDetails(ref, chapter);

    initTtsSubscriptions();
  }

  late bool _isBookmarked = readerController.getChapterBookmarked();

  bool _isView = false;
  final _keyboardFocusNode = FocusNode();

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;

  Color _backgroundColor(BuildContext context) =>
      context.shiori.color.ink1.withValues(alpha: Alphas.chrome);

  void _setFullScreen({bool? value}) async {
    if (isDesktop) {
      value = await windowManager.isFullScreen();
      setFullScreen(value: !value);
    }
    ref.read(fullScreenReaderStateProvider.notifier).set(!value!);
  }

  late final _autoScroll = ValueNotifier(
    readerController.autoScrollValues().$1,
  );
  late final _pageOffset = ValueNotifier(
    readerController.autoScrollValues().$2,
  );
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);

  bool _isContinuousMode() {
    return _readerMode.isContinuous;
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
    if (next && !readerController.hasNextChapter) return;
    if (!next && !readerController.hasPreviousChapter) return;
    pushReplacementMangaReaderView(
      context: context,
      chapter: next
          ? readerController.getNextChapter()
          : readerController.getPrevChapter(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(volumeKeysPagingStateProvider, (_, on) {
      _setVolumeKeys(on);
    });
    ref.listen<int>(readerOrientationStateProvider, (_, value) {
      applyReaderOrientation(value);
    });
    ref.listen<int>(readerScreenBrightnessStateProvider, (_, value) {
      applyReaderScreenBrightness(value);
    });
    ref.listen(keepScreenOnReaderStateProvider, (_, next) {
      if (next) {
        WakelockPlus.enable();
      } else {
        WakelockPlus.disable();
      }
    });
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    final doublePageAuto = ref.watch(doublePageAutoStateProvider);
    final orientation = MediaQuery.orientationOf(context);
    final effectivePageMode = doublePageAuto
        ? (orientation == Orientation.landscape
              ? PageMode.doublePage
              : PageMode.onePage)
        : _pageMode;

    syncPaginationModeTransition(
      effectivePageMode: effectivePageMode,
      readerMode: _readerMode,
      autoScroll: _autoScroll,
      stopAutoScroll: stopAutoScroll,
      startAutoScroll: startAutoScroll,
    );

    return ReaderKeyboardHandler(
      onEscape: () => _goBack(context),
      onFullScreen: () => _setFullScreen(),
      onNextChapter: () => _goToChapter(true),
      onPreviousChapter: () => _goToChapter(false),
      onNextPage: () => _onBtnTapped(100),
      onPreviousPage: () => _onBtnTapped(-100),
      onToggleUI: _isViewFunction,
      onShowShortcuts: () => showReaderShortcuts(
        context,
        zoom: false,
        bindings: ref.read(keyBindingsStateProvider),
      ),
      bindings: ref.watch(keyBindingsStateProvider),
    ).wrapWithKeyboardListener(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              isUserDragging = true;
            }
          } else if (notification is ScrollEndNotification) {
            isUserDragging = false;
          }
          if (notification is UserScrollNotification) {
            if (notification.direction == ScrollDirection.idle) {
              if (_isView) {
                _isViewFunction();
              }
            }
          }
          return true;
        },
        child: Material(
          child: SafeArea(
            top: !fullScreenReader,
            bottom: false,
            child: widget.result.when(
              data: (data) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Flexible(
                          child: Builder(
                            builder: (context) {
                              epubBook = data.$2;
                              currentHtmlContent = data.$1;
                              chapterMinutes = readingMinutes(data.$1);

                              final padding = ref.watch(
                                novelReaderPaddingStateProvider,
                              );
                              final lineHeight = ref.watch(
                                novelReaderLineHeightStateProvider,
                              );
                              final textAlign = ref.watch(
                                novelTextAlignStateProvider,
                              );
                              final removeExtraSpacing = ref.watch(
                                novelRemoveExtraParagraphSpacingStateProvider,
                              );
                              final customBackgroundColor = ref.watch(
                                novelReaderThemeStateProvider,
                              );
                              final customTextColor = ref.watch(
                                novelReaderTextColorStateProvider,
                              );
                              // "Default" returns null, which causes the
                              // render to use the system default font.
                              final fontFamily = resolveNovelFontFamily(
                                ref.watch(novelFontFamilyStateProvider),
                              );

                              if (!scrollRestoreScheduled &&
                                  _readerMode.isContinuous) {
                                scrollRestoreScheduled = true;
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    if (!scrolled &&
                                        mounted &&
                                        scrollController.hasClients) {
                                      scrollController
                                          .animateTo(
                                            scrollController
                                                    .position
                                                    .maxScrollExtent *
                                                (double.tryParse(
                                                      chapter.lastPageRead!,
                                                    ) ??
                                                    0),
                                            duration: const Duration(
                                              seconds: 1,
                                            ),
                                            curve: Curves.fastOutSlowIn,
                                          )
                                          .then((value) {
                                            if (!mounted) return;
                                            scrolled = true;
                                            if (_autoScroll.value &&
                                                _isContinuousMode()) {
                                              startAutoScroll();
                                            }
                                          });
                                    }
                                  },
                                );
                              }
                              return Consumer(
                                builder: (context, ref, _) {
                                  final fontSize = ref.watch(
                                    novelFontSizeStateProvider,
                                  );
                                  return ValueListenableBuilder<
                                    ({
                                      int paragraph,
                                      int wordStart,
                                      int wordEnd,
                                    })
                                  >(
                                    valueListenable: ttsProgress,
                                    builder: (context, tts, _) {
                                      String htmlData = data.$1;
                                      if (showTts && tts.paragraph >= 0) {
                                        final result = NovelTtsService.instance
                                            .highlightHtml(
                                              data.$1,
                                              tts.paragraph,
                                              wordStart: tts.wordStart,
                                              wordEnd: tts.wordEnd,
                                            );
                                        htmlData = result.$1;
                                        ttsTotalBlocks = result.$2;
                                      }

                                      final parsedTextColor = parseNovelColor(
                                        customTextColor,
                                        fallback: Colors.white,
                                      );
                                      final parsedBackgroundColor =
                                          parseNovelColor(
                                            customBackgroundColor,
                                            // shiori: the book's own styles, set against whatever page colour the reader chose
                                            fallback: const Color(0xFF292832),
                                          );
                                      final textAlignEnum = getNovelTextAlign(
                                        textAlign,
                                      );

                                      if (!_readerMode.isContinuous) {
                                        return buildPaginatedSpreadView(
                                          effectivePageMode: effectivePageMode,
                                          htmlData: htmlData,
                                          fontSize: fontSize,
                                          lineHeight: lineHeight,
                                          padding: padding,
                                          fontFamily: fontFamily,
                                          removeExtraSpacing:
                                              removeExtraSpacing,
                                          textAlignEnum: textAlignEnum,
                                          parsedTextColor: parsedTextColor,
                                          parsedBackgroundColor:
                                              parsedBackgroundColor,
                                          tts: tts,
                                        );
                                      }

                                      return Scrollbar(
                                        controller: scrollController,
                                        interactive: true,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            _isViewFunction();
                                          },
                                          child: CustomScrollView(
                                            controller: scrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            slivers: [
                                              SliverToBoxAdapter(
                                                child: NovelHtmlContent(
                                                  htmlData: htmlData,
                                                  fontFamily: fontFamily,
                                                  fontSize: fontSize,
                                                  lineHeight: lineHeight,
                                                  padding: padding,
                                                  textAlign: textAlignEnum,
                                                  removeExtraSpacing:
                                                      removeExtraSpacing,
                                                  textColor: parsedTextColor,
                                                  backgroundColor:
                                                      parsedBackgroundColor,
                                                  showTts: showTts,
                                                  tts: tts,
                                                  epubBook: epubBook,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        if (ref.watch(novelShowScrollPercentageStateProvider))
                          NovelScrollProgressBanner(
                            rebuildStream: rebuildDetail.stream,
                            isContinuous: _readerMode.isContinuous,
                            cachedPagination: () => cachedPagination,
                            effectivePageMode: effectivePageMode,
                            currentSpreadIndex: () => currentSpreadIndex,
                            offset: () => offset,
                            maxOffset: () => maxOffset,
                          ),
                      ],
                    ),
                    NovelTapZones(
                      usePageTapZones: ref.watch(novelTapToScrollStateProvider),
                      isContinuousMode: _readerMode.isContinuous,
                      onPageStep: _onBtnTapped,
                      onToggleUi: _isViewFunction,
                    ),
                    _appBar(),
                    _bottomBar(backgroundColor, effectivePageMode),
                    ReaderAutoScrollButton(
                      isContinuousMode: _readerMode.isContinuous,
                      isUiVisible: _isView,
                      autoScrollPage: _autoScrollPage,
                      autoScroll: _autoScroll,
                      onToggle: () {
                        _autoScroll.value = !_autoScroll.value;
                      },
                    ),
                    if (ttsSupported && showTts && currentHtmlContent != null)
                      Positioned(
                        // Just above the panel while it is shown.
                        bottom: _isView
                            ? novelBottomBarHeightAbove(context)
                            : 0,
                        left: 0,
                        right: 0,
                        child: TtsPlayerBar(
                          htmlContent: currentHtmlContent!,
                          onClose: () {
                            if (mounted) {
                              setState(() => showTts = false);
                            }
                          },
                        ),
                      ),
                  ],
                );
              },
              loading: () => scaffoldWith(context, const ShioriLoading()),
              error: (err, stack) {
                if (widget.result.isRefreshing || widget.result.isReloading) {
                  return scaffoldWith(context, const ShioriLoading());
                }
                return scaffoldWith(
                  context,
                  ErrorState(
                    detail: err.toString(),
                    onRetry: () => ref.invalidate(
                      getHtmlContentProvider(chapter: widget.chapter),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      focusNode: _keyboardFocusNode,
    );
  }

  Widget scaffoldWith(
    BuildContext context,
    Widget body, {
    bool restoreUi = false,
  }) {
    return Scaffold(
      backgroundColor: context.shiori.color.ink0,
      appBar: AppBar(
        title: const Text(''),
        leading: BackButton(
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

  void _goBack(BuildContext context) {
    restoreSystemUI();
    Navigator.pop(context);
  }

  void _onBtnTapped(double value) {
    if (!_readerMode.isContinuous) {
      if (spreadController.hasClients) {
        if (value > 0) {
          spreadController.nextPage(
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        } else {
          spreadController.previousPage(
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        }
      }
      return;
    }
    if (scrollController.hasClients) {
      final currentOffset = scrollController.offset;
      final maxScroll = scrollController.position.maxScrollExtent;

      final newOffset = currentOffset + value;
      scrollController.animateTo(
        min(newOffset, maxScroll),
        duration: ShioriMotion.fast,
        curve: Curves.linear,
      );
    }
  }

  Widget _appBar() {
    return ReaderAppBar(
      chapter: chapter,
      mangaName: readerController.getMangaName(),
      chapterTitle: readerController.getChapterTitle(),
      isVisible: _isView,
      isBookmarked: _isBookmarked,
      backgroundColor: _backgroundColor,
      // In the bottom panel, within reach.
      showChapterList: false,
      onBackPressed: () => Navigator.pop(context),
      onBookmarkPressed: () {
        readerController.setChapterBookmarked();
        setState(() => _isBookmarked = !_isBookmarked);
      },
      onWebViewPressed: (chapter.manga.value!.isLocalArchive ?? false)
          ? null
          : () async {
              final manga = chapter.manga.value!;
              final source = getSource(
                manga.lang!,
                manga.source!,
                manga.sourceId,
                installedOnly: true,
              )!;
              final url = chapter.url!.startsWith('/')
                  ? '${source.baseUrl}/${chapter.url!}'
                  : chapter.url!;
              if (Platform.isLinux) {
                final uri = Uri.parse(url);
                await launchUrl(
                  uri,
                  mode: LaunchMode.inAppBrowserView,
                ).catchError(
                  (_) => launchUrl(uri, mode: LaunchMode.externalApplication),
                );
              } else {
                context.push(
                  '/mangawebview',
                  extra: {
                    'url': url,
                    'sourceId': source.id.toString(),
                    'title': chapter.name!,
                  },
                );
              }
            },
    );
  }

  Widget _bottomBar(
    BackgroundColor backgroundColor,
    PageMode effectivePageMode,
  ) {
    return NovelBottomBar(
      chapter: chapter,
      readerController: readerController,
      isVisible: _isView,
      backgroundColor: _backgroundColor,
      rebuildStream: rebuildDetail.stream,
      readerMode: _readerMode,
      effectivePageMode: effectivePageMode,
      cachedPagination: () => cachedPagination,
      currentSpreadIndex: () => currentSpreadIndex,
      spreadController: spreadController,
      scrollController: scrollController,
      offset: () => offset,
      maxOffset: () => maxOffset,
      chapterMinutes: () => chapterMinutes,
      ttsSupported: ttsSupported,
      showTts: showTts,
      onFontSizeChanged: (size) => setState(() => fontSize = size),
      onLayoutModeCycled: (mode, pageMode) {
        setState(() {
          _readerMode = mode;
          _pageMode = pageMode;
        });
      },
      onToggleTts: () {
        setState(() {
          showTts = !showTts;
        });
      },
      onOpenSettings: () async {
        bool autoScrollAlreadyFalse = _autoScroll.value == false;
        if (!autoScrollAlreadyFalse) {
          _autoScroll.value = false;
        }
        await customDraggableTabBar(
          tabs: [
            Tab(text: context.l10n.reader),
            Tab(text: context.l10n.general),
            if (ttsSupported) Tab(text: context.l10n.tts),
          ],
          children: [
            ReaderSettingsTab(
              readerController: readerController,
              currentReaderMode: _readerMode,
              onReaderModeChanged: (newMode) {
                setState(() {
                  _readerMode = newMode;
                });
              },
              currentPageMode: effectivePageMode,
              onPageModeChanged: (newMode) {
                setState(() {
                  _pageMode = newMode;
                });
              },
            ),
            GeneralSettingsTab(
              autoScrollPage: _autoScrollPage,
              autoScroll: _autoScroll,
              readerController: readerController,
              pageOffset: _pageOffset,
            ),
            if (ttsSupported) const TtsSettingsTab(),
          ],
          context: context,
          vsync: this,
        );
        if (!autoScrollAlreadyFalse || _autoScroll.value) {
          if (_autoScrollPage.value && _isContinuousMode()) {
            _autoScroll.value = true;
          }
        }
      },
    );
  }

  void _isViewFunction() {
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    if (mounted) {
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
