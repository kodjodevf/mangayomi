import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/modules/more/settings/keyboard_shortcuts/key_bindings.dart';
import 'package:mangayomi/modules/novel/utils/reading_time.dart';
import 'package:shiori/shiori.dart';
import 'package:mangayomi/services/volume_keys.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_orientation.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/modules/novel/tts/tts_player_bar.dart';
import 'package:mangayomi/modules/novel/tts/tts_settings_tab.dart';
import 'package:mangayomi/modules/novel/utils/novel_paginator.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
import 'package:mangayomi/modules/novel/widgets/novel_general_settings_tab.dart';
import 'package:mangayomi/modules/novel/widgets/novel_reader_settings_sheet.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/modules/widgets/error_state.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_html_content.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/platform_utils.dart';
import 'package:mangayomi/utils/system_ui.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/widgets.dart' as widgets;
import 'package:mangayomi/modules/manga/reader/mixins/reader_auto_scroll.dart';

typedef DoubleClickAnimationListener = void Function();

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
        ReaderAutoScroll {
  @override
  ValueNotifier<bool> get autoScrollEnabled => _autoScroll;
  @override
  ValueNotifier<double> get autoScrollSpeed => _pageOffset;
  @override
  ScrollController get autoScrollController => _scrollController;
  @override
  bool get canAutoScroll => _isContinuousMode();
  /// Resolved in [initState], not lazily.
  ///
  /// As a `late` field with an initialiser this was read for the first time
  /// by whatever touched it first, and on a reader closed before its first
  /// build got that far, that was `dispose()`. Riverpod forbids `ref` there:
  /// it needs the BuildContext, and the element is already deactivated. See
  /// issue #949, reported from the novel reader on 0.8.9.
  late final NovelReaderController _readerController;
  final _scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  late PageMode _pageMode = _readerController.getPageMode();
  PageMode? _lastEffectivePageMode;
  late ReaderMode _readerMode = _readerController.getReaderMode();
  ReaderMode? _lastReaderMode;
  late final PageController _spreadController = PageController();
  int _currentSpreadIndex = 0;
  NovelPaginationResult? _cachedPagination;
  String? _cachedPaginationHtml;
  double? _cachedPaginationWidth;
  double? _cachedPaginationHeight;
  int? _cachedPaginationFontSize;
  double? _cachedPaginationLineHeight;
  int? _cachedPaginationPadding;
  String? _cachedPaginationFontFamily;
  bool? _cachedPaginationRemoveExtraSpacing;
  TextAlign? _cachedPaginationTextAlign;

  bool scrolled = false;
  bool _scrollRestoreScheduled = false;
  double offset = 0;
  double maxOffset = 0;
  int fontSize = 14;
  bool get _ttsSupported => !Platform.isLinux;

  final Stopwatch _readingStopwatch = Stopwatch();
  int? _discordReaderSession;

  void onScroll() {
    if (_scrollController.hasClients) {
      offset = _scrollController.offset;
      maxOffset = _scrollController.position.maxScrollExtent;
      _rebuildDetail.add(offset);
    }
  }

  @override
  void dispose() {
    _readingStopwatch.stop();
    WidgetsBinding.instance.removeObserver(this);
    VolumeKeys.disable();
    releaseReaderOrientation();
    applyReaderScreenBrightness(-1);
    if (!_readerMode.isContinuous &&
        _cachedPagination != null &&
        _cachedPagination!.pageCount > 0) {
      final progress = _lastEffectivePageMode == PageMode.doublePage
          ? _cachedPagination!.progressForSpread(_currentSpreadIndex)
          : _cachedPagination!.progressForPage(_currentSpreadIndex);
      offset = progress * (maxOffset > 0 ? maxOffset : 100);
      maxOffset = (maxOffset > 0 ? maxOffset : 100);
    }
    _readerController.setChapterOffset(offset, maxOffset, true);
    _readerController.setHistoryUpdate(
      elapsedSeconds: _readingStopwatch.elapsed.inSeconds,
    );
    _scrollController.removeListener(onScroll);
    _scrollController.dispose();
    _spreadController.dispose();
    _rebuildDetail.close();
    disposeAutoScroll();
    _autoScroll.removeListener(onAutoScrollChanged);
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
    _keyboardFocusNode.dispose();
    _ttsIndexSub?.cancel();
    _ttsStateSub?.cancel();
    _ttsWordSub?.cancel();
    _ttsProgress.dispose();
    NovelTtsService.instance.stop();
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
      applyReaderScreenBrightness(ref.read(readerScreenBrightnessStateProvider));
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

  late Chapter chapter = widget.chapter;
  EpubNovel? epubBook;

  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    // Before anything that can fail, so the controller dispose() needs is
    // always there: this is the whole point of not leaving it lazy.
    _readerController = ref.read(
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
      _scrollController.addListener(onScroll);
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

    _ttsIndexSub = NovelTtsService.instance.paragraphIndexStream.listen((i) {
      _ttsProgress.value = (paragraph: i, wordStart: -1, wordEnd: -1);
      _scrollToTtsParagraph(i);
      if (_lastEffectivePageMode == PageMode.doublePage &&
          _cachedPagination != null) {
        final targetSpread = _cachedPagination!.spreadForBlock(i);
        if (_spreadController.hasClients &&
            targetSpread != _currentSpreadIndex) {
          _currentSpreadIndex = targetSpread;
          _spreadController.animateToPage(
            targetSpread,
            duration: ShioriMotion.enter,
            curve: Curves.easeInOut,
          );
        }
      }
    });
    _ttsStateSub = NovelTtsService.instance.stateStream.listen((s) {
      if (s == TtsState.stopped) {
        _ttsProgress.value = (paragraph: -1, wordStart: -1, wordEnd: -1);
      }
    });
    _ttsWordSub = NovelTtsService.instance.wordProgressStream.listen((wp) {
      _ttsProgress.value = (
        paragraph: wp.paragraphIndex,
        wordStart: wp.startOffset,
        wordEnd: wp.endOffset,
      );
    });
  }

  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isView = false;
  final _keyboardFocusNode = FocusNode();
  bool _showTts = false;
  String? _currentHtmlContent;

  /// How long the current chapter takes to read, worked out once when its
  /// text arrives, for the time left beside the progress slider.
  double? _chapterMinutes;
  final ValueNotifier<({int paragraph, int wordStart, int wordEnd})>
  _ttsProgress = ValueNotifier((paragraph: -1, wordStart: -1, wordEnd: -1));
  int _ttsTotalBlocks = 0;
  StreamSubscription<int>? _ttsIndexSub;
  StreamSubscription<TtsState>? _ttsStateSub;
  StreamSubscription<TtsWordProgress>? _ttsWordSub;

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
    _readerController.autoScrollValues().$1,
  );
  late final _pageOffset = ValueNotifier(
    _readerController.autoScrollValues().$2,
  );
  late final _autoScrollPage = ValueNotifier(_autoScroll.value);

  bool _isContinuousMode() {
    return _readerMode.isContinuous;
  }


  void _scrollToTtsParagraph(int index) {
    if (!_scrollController.hasClients || _ttsTotalBlocks <= 0) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetOffset = (index / _ttsTotalBlocks) * maxScroll;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, maxScroll),
      duration: ShioriMotion.enter,
      curve: Curves.easeInOut,
    );
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
    pushReplacementMangaReaderView(
      context: context,
      chapter: next
          ? _readerController.getNextChapter()
          : _readerController.getPrevChapter(),
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

    final prevEffectiveMode = _lastEffectivePageMode ?? effectivePageMode;
    final prevReaderMode = _lastReaderMode ?? _readerMode;
    if (prevEffectiveMode != effectivePageMode || prevReaderMode != _readerMode) {
      if (!_readerMode.isContinuous) {
        _autoScroll.value = false;
        stopAutoScroll();
        final double progress;
        if (prevReaderMode.isContinuous) {
          progress = maxOffset > 0 ? (offset / maxOffset).clamp(0.0, 1.0) : 0.0;
        } else if (_cachedPagination != null && _cachedPagination!.pageCount > 0) {
          progress = prevEffectiveMode == PageMode.doublePage
              ? _cachedPagination!.progressForSpread(_currentSpreadIndex)
              : _cachedPagination!.progressForPage(_currentSpreadIndex);
        } else {
          progress = maxOffset > 0 ? (offset / maxOffset).clamp(0.0, 1.0) : 0.0;
        }
        _cachedPagination = null;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_cachedPagination != null && _spreadController.hasClients) {
            final targetSpread = effectivePageMode == PageMode.doublePage
                ? _cachedPagination!.spreadForProgress(progress)
                : _cachedPagination!.pageForProgress(progress);
            _currentSpreadIndex = targetSpread;
            _spreadController.jumpToPage(targetSpread);
          }
        });
      } else {
        final progress = _cachedPagination != null && _cachedPagination!.pageCount > 0
            ? (prevEffectiveMode == PageMode.doublePage
                ? _cachedPagination!.progressForSpread(_currentSpreadIndex)
                : _cachedPagination!.progressForPage(_currentSpreadIndex))
            : (maxOffset > 0 ? (offset / maxOffset).clamp(0.0, 1.0) : 0.0);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (_scrollController.hasClients) {
            final targetOffset =
                progress * _scrollController.position.maxScrollExtent;
            _scrollController.jumpTo(targetOffset);
            if (_autoScroll.value) {
              startAutoScroll();
            }
          }
        });
      }
      _lastEffectivePageMode = effectivePageMode;
      _lastReaderMode = _readerMode;
    }

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
                              _currentHtmlContent = data.$1;
                              _chapterMinutes = readingMinutes(data.$1);

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
                              final fontFamily =
                                  resolveNovelFontFamily(
                                    ref.watch(novelFontFamilyStateProvider),
                                  );

                              if (!_scrollRestoreScheduled &&
                                  _readerMode.isContinuous) {
                                _scrollRestoreScheduled = true;
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    if (!scrolled &&
                                        mounted &&
                                        _scrollController.hasClients) {
                                      _scrollController
                                          .animateTo(
                                            _scrollController
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
                                    valueListenable: _ttsProgress,
                                    builder: (context, tts, _) {
                                      String htmlData = data.$1;
                                      if (_showTts && tts.paragraph >= 0) {
                                        final result = NovelTtsService.instance
                                            .highlightHtml(
                                              data.$1,
                                              tts.paragraph,
                                              wordStart: tts.wordStart,
                                              wordEnd: tts.wordEnd,
                                            );
                                        htmlData = result.$1;
                                        _ttsTotalBlocks = result.$2;
                                      }

                                      final parsedTextColor = _parseColor(
                                        customTextColor,
                                        fallback: Colors.white,
                                      );
                                      final parsedBackgroundColor = _parseColor(
                                        customBackgroundColor,
                                        // shiori: the book's own styles, set against whatever page colour the reader chose
                                        fallback: const Color(0xFF292832),
                                      );
                                      final textAlignEnum = _getTextAlign(
                                        textAlign,
                                      );

                                      if (!_readerMode.isContinuous) {
                                        return LayoutBuilder(
                                          builder: (context, constraints) {
                                            final isDouble =
                                                effectivePageMode ==
                                                PageMode.doublePage;
                                            final singlePageWidth = isDouble
                                                ? (constraints.maxWidth - 1.0) /
                                                    2
                                                : constraints.maxWidth;
                                            final pageHeight =
                                                constraints.maxHeight;

                                            if (_cachedPagination == null ||
                                                _cachedPaginationWidth !=
                                                    singlePageWidth ||
                                                _cachedPaginationHeight !=
                                                    pageHeight ||
                                                _cachedPaginationFontSize !=
                                                    fontSize ||
                                                _cachedPaginationLineHeight !=
                                                    lineHeight ||
                                                _cachedPaginationPadding !=
                                                    padding ||
                                                _cachedPaginationHtml !=
                                                    htmlData ||
                                                _cachedPaginationFontFamily !=
                                                    fontFamily ||
                                                _cachedPaginationRemoveExtraSpacing !=
                                                    removeExtraSpacing ||
                                                _cachedPaginationTextAlign !=
                                                    textAlignEnum) {
                                              _cachedPagination =
                                                  NovelPaginator.paginate(
                                                    htmlContent: htmlData,
                                                    pageWidth: singlePageWidth,
                                                    pageHeight: pageHeight,
                                                    fontSize: fontSize
                                                        .toDouble(),
                                                    lineHeight: lineHeight,
                                                    padding: padding.toDouble(),
                                                    fontFamily: fontFamily,
                                                    removeExtraSpacing:
                                                        removeExtraSpacing,
                                                    textAlign: textAlignEnum,
                                                  );
                                              _cachedPaginationWidth =
                                                  singlePageWidth;
                                              _cachedPaginationHeight =
                                                  pageHeight;
                                              _cachedPaginationFontSize =
                                                  fontSize;
                                              _cachedPaginationLineHeight =
                                                  lineHeight;
                                              _cachedPaginationPadding =
                                                  padding;
                                              _cachedPaginationHtml = htmlData;
                                              _cachedPaginationFontFamily =
                                                  fontFamily;
                                              _cachedPaginationRemoveExtraSpacing =
                                                  removeExtraSpacing;
                                              _cachedPaginationTextAlign =
                                                  textAlignEnum;
                                            }

                                            if (!_scrollRestoreScheduled) {
                                              _scrollRestoreScheduled = true;
                                              final progress =
                                                  double.tryParse(
                                                    chapter.lastPageRead ?? '',
                                                  ) ??
                                                  0.0;
                                              final targetIndex = isDouble
                                                  ? _cachedPagination!
                                                      .spreadForProgress(
                                                        progress,
                                                      )
                                                  : _cachedPagination!
                                                      .pageForProgress(
                                                        progress,
                                                      );
                                              _currentSpreadIndex =
                                                  targetIndex;
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    if (!mounted) return;
                                                    if (_spreadController
                                                        .hasClients) {
                                                      _spreadController
                                                          .jumpToPage(
                                                            targetIndex,
                                                          );
                                                      scrolled = true;
                                                    }
                                                  });
                                            }

                                            final pagination =
                                                _cachedPagination!;
                                            final totalCount = isDouble
                                                ? pagination.spreadCount
                                                : pagination.pageCount;

                                            return Container(
                                              color: parsedBackgroundColor,
                                              child: PageView.builder(
                                                controller: _spreadController,
                                                itemCount: totalCount,
                                                onPageChanged: (pageIndex) {
                                                  // Keep the page swipe isolated
                                                  // from the expensive reader
                                                  // tree. The bottom bar already
                                                  // listens to this stream.
                                                  _currentSpreadIndex = pageIndex;
                                                  final progress = isDouble
                                                      ? pagination
                                                          .progressForSpread(
                                                            pageIndex,
                                                          )
                                                      : pagination
                                                          .progressForPage(
                                                            pageIndex,
                                                          );
                                                  offset =
                                                      progress *
                                                      (maxOffset > 0
                                                          ? maxOffset
                                                          : 100);
                                                  maxOffset = (maxOffset > 0
                                                      ? maxOffset
                                                      : 100);
                                                  _readerController
                                                      .setChapterOffset(
                                                        offset,
                                                        maxOffset,
                                                        true,
                                                      );
                                                  _rebuildDetail.add(offset);
                                                },
                                                itemBuilder: (context, index) {
                                                  if (isDouble) {
                                                    final leftHtml = pagination
                                                        .leftPageForSpread(
                                                          index,
                                                        );
                                                    final rightHtml = pagination
                                                        .rightPageForSpread(
                                                          index,
                                                        );

                                                    return Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          child: ClipRect(
                                                            child: SingleChildScrollView(
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              child: _buildNovelHtmlWidget(
                                                                context: context,
                                                                htmlData: leftHtml,
                                                                fontFamily:
                                                                    fontFamily,
                                                                fontSize: fontSize,
                                                                lineHeight:
                                                                    lineHeight,
                                                                padding: padding,
                                                                textAlign:
                                                                    textAlignEnum,
                                                                removeExtraSpacing:
                                                                    removeExtraSpacing,
                                                                textColor:
                                                                    parsedTextColor,
                                                                backgroundColor:
                                                                    parsedBackgroundColor,
                                                                showTts: _showTts,
                                                                tts: tts,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        VerticalDivider(
                                                          width: 1,
                                                          thickness: 0.5,
                                                          color: context
                                                              .shiori
                                                              .color
                                                              .hairline,
                                                        ),
                                                        Expanded(
                                                          child: rightHtml != null
                                                              ? ClipRect(
                                                                  child: SingleChildScrollView(
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    child: _buildNovelHtmlWidget(
                                                                      context:
                                                                          context,
                                                                      htmlData:
                                                                          rightHtml,
                                                                      fontFamily:
                                                                          fontFamily,
                                                                      fontSize:
                                                                          fontSize,
                                                                      lineHeight:
                                                                          lineHeight,
                                                                      padding:
                                                                          padding,
                                                                      textAlign:
                                                                          textAlignEnum,
                                                                      removeExtraSpacing:
                                                                          removeExtraSpacing,
                                                                      textColor:
                                                                          parsedTextColor,
                                                                      backgroundColor:
                                                                          parsedBackgroundColor,
                                                                      showTts:
                                                                          _showTts,
                                                                      tts: tts,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  color:
                                                                      parsedBackgroundColor,
                                                                ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    final pageHtml = pagination
                                                        .pageForIndex(index);
                                                    return ClipRect(
                                                      child: SingleChildScrollView(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        child: _buildNovelHtmlWidget(
                                                          context: context,
                                                          htmlData: pageHtml,
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
                                                          showTts: _showTts,
                                                          tts: tts,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      return Scrollbar(
                                        controller: _scrollController,
                                        interactive: true,
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            _isViewFunction();
                                          },
                                          child: CustomScrollView(
                                            controller: _scrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            slivers: [
                                              SliverToBoxAdapter(
                                                child: _buildNovelHtmlWidget(
                                                  context: context,
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
                                                  showTts: _showTts,
                                                  tts: tts,
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
                          StreamBuilder(
                            stream: _rebuildDetail.stream,
                            builder: (context, asyncSnapshot) {
                              return Consumer(
                                builder: (context, ref, child) {
                                  final customBackgroundColor = ref.watch(
                                    novelReaderThemeStateProvider,
                                  );
                                  final customTextColor = ref.watch(
                                    novelReaderTextColorStateProvider,
                                  );
                                  final String displayLabel;
                                  if (!_readerMode.isContinuous &&
                                      _cachedPagination != null &&
                                      _cachedPagination!.pageCount > 0) {
                                    displayLabel = effectivePageMode ==
                                            PageMode.doublePage
                                        ? _cachedPagination!
                                            .pageLabelForSpread(
                                              _currentSpreadIndex,
                                            )
                                        : _cachedPagination!
                                            .pageLabelForIndex(
                                              _currentSpreadIndex,
                                            );
                                  } else {
                                    final scrollPercentage = maxOffset > 0
                                        ? ((offset / maxOffset) * 100)
                                              .clamp(0, 100)
                                              .toInt()
                                        : 0;
                                    displayLabel = '$scrollPercentage %';
                                  }
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          color: Color(
                                            int.parse(
                                              'FF${customBackgroundColor.replaceAll('#', '')}',
                                              radix: 16,
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                ShioriSpace.s4,
                                              ),
                                              child: Text(
                                                displayLabel,
                                                style: TextStyle(
                                                  color: Color(
                                                    int.parse(
                                                      'FF${customTextColor.replaceAll('#', '')}',
                                                      radix: 16,
                                                    ),
                                                  ),
                                                  fontSize: context.shiori.text.row.fontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    _gestureRightLeft(ref.watch(novelTapToScrollStateProvider)),
                    _gestureTopBottom(ref.watch(novelTapToScrollStateProvider)),
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
                    if (_ttsSupported &&
                        _showTts &&
                        _currentHtmlContent != null)
                      Positioned(
                        // Just above the panel while it is shown.
                        bottom: _isView ? _panelHeightAbove(context) : 0,
                        left: 0,
                        right: 0,
                        child: TtsPlayerBar(
                          htmlContent: _currentHtmlContent!,
                          onClose: () {
                            if (mounted) {
                              setState(() => _showTts = false);
                            }
                          },
                        ),
                      ),
                  ],
                );
              },
              loading: () => scaffoldWith(
                context,
                const ShioriLoading(),
              ),
              error: (err, stack) {
                if (widget.result.isRefreshing || widget.result.isReloading) {
                  return scaffoldWith(
                    context,
                    const ShioriLoading(),
                  );
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
      if (_spreadController.hasClients) {
        if (value > 0) {
          _spreadController.nextPage(
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        } else {
          _spreadController.previousPage(
            duration: ShioriMotion.standard,
            curve: Curves.easeOut,
          );
        }
      }
      return;
    }
    if (_scrollController.hasClients) {
      final currentOffset = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;

      final newOffset = currentOffset + value;
      _scrollController.animateTo(
        min(newOffset, maxScroll),
        duration: ShioriMotion.fast,
        curve: Curves.linear,
      );
    }
  }

  Widget _gestureRightLeft(bool usePageTapZones) {
    final enableTapPaging = usePageTapZones || !_readerMode.isContinuous;
    return Row(
      children: [
        /// left region
        Expanded(
          flex: 2,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              enableTapPaging ? _onBtnTapped(-100) : _isViewFunction();
            },
          ),
        ),

        /// center region
        Expanded(
          flex: 2,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _isViewFunction();
            },
          ),
        ),

        /// right region
        Expanded(
          flex: 2,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              enableTapPaging ? _onBtnTapped(100) : _isViewFunction();
            },
          ),
        ),
      ],
    );
  }

  Widget _gestureTopBottom(bool usePageTapZones) {
    return Column(
      children: [
        /// top region
        Expanded(
          flex: 2,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              usePageTapZones ? _onBtnTapped(-100) : _isViewFunction();
            },
          ),
        ),

        /// center region
        const Expanded(flex: 5, child: SizedBox.shrink()),

        /// bottom region
        Expanded(
          flex: 2,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              usePageTapZones ? _onBtnTapped(100) : _isViewFunction();
            },
          ),
        ),
      ],
    );
  }

  Widget _appBar() {
    return ReaderAppBar(
      chapter: chapter,
      mangaName: _readerController.getMangaName(),
      chapterTitle: _readerController.getChapterTitle(),
      isVisible: _isView,
      isBookmarked: _isBookmarked,
      backgroundColor: _backgroundColor,
      // In the bottom panel, within reach.
      showChapterList: false,
      onBackPressed: () => Navigator.pop(context),
      onBookmarkPressed: () {
        _readerController.setChapterBookmarked();
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

  void _showFontSizeBottomSheet(BuildContext context) {
    showShioriSheet<void>(
      context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final currentFontSize = ref.watch(novelFontSizeStateProvider);
          void setSize(int size) {
            ref.read(novelFontSizeStateProvider.notifier).set(size);
            setState(() => fontSize = size);
          }

          return SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShioriSliderRow(
                  icon: Symbols.format_size_rounded,
                  title: context.l10n.font_size,
                  value: currentFontSize.toDouble().clamp(8, 40),
                  min: 8,
                  max: 40,
                  divisions: 32,
                  valueLabel: (v) => '${v.round()} px',
                  stepTooltips: (context.l10n.decrease, context.l10n.increase),
                  defaultValue: 14,
                  onReset: () => setSize(14),
                  resetTooltip: context.l10n.reset,
                  onChanged: (v) => setSize(v.round()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ShioriSpace.s16,
                    0,
                    ShioriSpace.s16,
                    ShioriSpace.s16,
                  ),
                  child: Wrap(
                    spacing: ShioriSpace.s8,
                    runSpacing: ShioriSpace.s8,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final size in [12, 14, 16, 18, 20, 24, 28])
                        ChoiceChip(
                          label: Text('$size'),
                          selected: currentFontSize == size,
                          onSelected: (_) => setSize(size),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// A chapter button beside the slider, as in the manga reader: on the
  /// panel, dimmed when there is no chapter that way.
  Widget _chapterButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    final c = context.shiori.color;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: context.shiori.scaled(22),
      style: IconButton.styleFrom(
        foregroundColor: c.fg,
        disabledForegroundColor: c.fg.withValues(alpha: Alphas.disabled),
        fixedSize: const Size.square(40),
        minimumSize: const Size.square(40),
      ),
      icon: Icon(icon, fill: 1),
    );
  }

  /// The page or progress figures either side of the slider, tabular so the
  /// slider does not shift as they change width; the end one muted.
  TextStyle _pageLabelStyle(BuildContext context, {bool muted = false}) =>
      context.shiori.text.meta.copyWith(
        color: muted ? context.shiori.color.fgMuted : context.shiori.color.fg,
        fontWeight: FontWeight.w700,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// How far above the bottom edge the panel's top sits, plus a margin:
  /// where the speech bar rests while the panel is shown.
  double _panelHeightAbove(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = max(
      mediaQuery.viewPadding.bottom,
      mediaQuery.systemGestureInsets.bottom,
    );
    // The slider row (38 and its padding), the rule, the actions.
    return bottomInset +
        ShioriSpace.s8 +
        38 +
        ShioriSpace.s8 +
        1 +
        context.shiori.density.rowHeight +
        ShioriSpace.s8;
  }

  Widget _bottomBar(
    BackgroundColor backgroundColor,
    PageMode effectivePageMode,
  ) {
    bool hasPrevChapter = _readerController.hasPreviousChapter;
    bool hasNextChapter = _readerController.hasNextChapter;
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = max(
      mediaQuery.viewPadding.bottom,
      mediaQuery.systemGestureInsets.bottom,
    );
    final duration = ShioriMotion.of(context, ShioriMotion.enter);
    final curve = _isView ? ShioriMotion.enterCurve : ShioriMotion.exitCurve;
    // The manga reader's panel: one floating card that slides up, the
    // slider between the chapters, what is changed while reading under it.
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: ReaderChromeGate(
        shown: _isView,
        child: AnimatedSlide(
          offset: _isView ? Offset.zero : const Offset(0, 1),
          duration: duration,
          curve: curve,
          child: AnimatedOpacity(
            opacity: _isView ? 1 : 0,
            duration: duration,
            curve: curve,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                ShioriSpace.s8,
                0,
                ShioriSpace.s8,
                bottomInset + ShioriSpace.s8,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Material(
                    color: _backgroundColor(context),
                    borderRadius: BorderRadius.circular(ShioriShape.sheet),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ShioriSpace.s4,
                        vertical: ShioriSpace.s4,
                      ),
                      child: Row(
                        children: [
                          _chapterButton(
                            icon: Symbols.skip_previous_rounded,
                            tooltip: context.l10n.previous_chapter,
                            onPressed: hasPrevChapter
                                ? () {
                                    pushReplacementMangaReaderView(
                                      context: context,
                                      chapter: _readerController.getPrevChapter(),
                                    );
                                  }
                                : null,
                          ),
                          const SizedBox(width: ShioriSpace.s8),
                          Expanded(
                            child: SizedBox(
                              height: 38,
                              child: StreamBuilder(
                                stream: _rebuildDetail.stream,
                                builder: (context, asyncSnapshot) {
                                  return Consumer(
                                    builder: (context, ref, child) {
                                      if (!_readerMode.isContinuous) {
                                        final pagination = _cachedPagination;
                                        final isDouble = effectivePageMode ==
                                            PageMode.doublePage;
                                        final totalItems = isDouble
                                            ? (pagination?.spreadCount ?? 1)
                                            : (pagination?.pageCount ?? 1);
                                        final currentIndex =
                                            _currentSpreadIndex.clamp(
                                              0,
                                              max(0, totalItems - 1),
                                            ).toInt();
                                        final currentLabel = isDouble
                                            ? (pagination?.spreadLabelForSpread(
                                                    currentIndex,
                                                  ) ??
                                                  '${currentIndex + 1}')
                                            : '${currentIndex + 1}';
                                        final totalLabel =
                                            '${pagination?.pageCount ?? totalItems}';
                                        final sliderValue = totalItems > 1
                                            ? (currentIndex / (totalItems - 1))
                                                  .clamp(0.0, 1.0)
                                            : 0.0;

                                        return Row(
                                          children: [
                                            const SizedBox(width: ShioriSpace.s12),
                                            Text(
                                              currentLabel,
                                              style: _pageLabelStyle(context),
                                            ),
                                            Expanded(
                                              child: SliderTheme(
                                                data: SliderTheme.of(context)
                                                    .copyWith(
                                                      trackHeight: 2.5,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6.0,
                                                          ),
                                                      overlayShape:
                                                          const RoundSliderOverlayShape(
                                                            overlayRadius: 12.0,
                                                          ),
                                                    ),
                                                child: Slider(
                                                  onChanged: (value) {
                                                    if (totalItems > 1 &&
                                                        _spreadController
                                                            .hasClients) {
                                                      final targetIndex =
                                                          (value *
                                                                  (totalItems -
                                                                      1))
                                                              .round();
                                                      _spreadController
                                                          .jumpToPage(
                                                            targetIndex,
                                                          );
                                                    }
                                                  },
                                                  value: sliderValue,
                                                  min: 0,
                                                  max: 1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              totalLabel,
                                              style: _pageLabelStyle(context, muted: true),
                                            ),
                                            const SizedBox(width: ShioriSpace.s12),
                                          ],
                                        );
                                      }

                                      final scrollPercentage = maxOffset > 0
                                          ? ((offset / maxOffset) * 100)
                                                .clamp(0, 100)
                                                .toInt()
                                          : 0;
                                      return Row(
                                        children: [
                                          const SizedBox(width: ShioriSpace.s12),
                                          Text(
                                            '$scrollPercentage%',
                                            style: _pageLabelStyle(context),
                                          ),
                                          Expanded(
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                    trackHeight: 2.5,
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              6.0,
                                                        ),
                                                    overlayShape:
                                                        const RoundSliderOverlayShape(
                                                          overlayRadius: 12.0,
                                                        ),
                                                  ),
                                              child: Slider(
                                                onChanged: (value) {
                                                  if (_scrollController
                                                      .hasClients) {
                                                    _scrollController.jumpTo(
                                                      _scrollController
                                                              .position
                                                              .maxScrollExtent *
                                                          value,
                                                    );
                                                  }
                                                },
                                                value: (scrollPercentage / 100)
                                                    .clamp(0.0, 1.0),
                                                min: 0,
                                                max: 1,
                                              ),
                                            ),
                                          ),
                                          // Time left in the chapter rather
                                          // than a fixed "100%".
                                          Text(
                                            _chapterMinutes == null
                                                ? '100%'
                                                : context.l10n.minutes_left(
                                                    minutesLeft(
                                                      _chapterMinutes!,
                                                      scrollPercentage / 100,
                                                    ),
                                                  ),
                                            style: _pageLabelStyle(
                                              context,
                                              muted: true,
                                            ),
                                          ),
                                          const SizedBox(width: ShioriSpace.s12),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: ShioriSpace.s8),
                          _chapterButton(
                            icon: Symbols.skip_next_rounded,
                            tooltip: context.l10n.next_chapter,
                            onPressed: hasNextChapter
                                ? () {
                                    pushReplacementMangaReaderView(
                                      context: context,
                                      chapter: _readerController.getNextChapter(),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                        const Divider(height: 1),
                        Container(
                        height: context.shiori.density.rowHeight,
                        padding: const EdgeInsets.symmetric(horizontal: ShioriSpace.s12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // The chapter list, here within reach as in the
                            // manga reader's panel.
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: context.shiori.density.minTarget,
                                minHeight: context.shiori.density.minTarget,
                              ),
                              onPressed: () => showChapterListPanel(
                                context,
                                title: context.l10n.chapters,
                                chapter: chapter,
                              ),
                              icon: const Icon(
                                Symbols.format_list_numbered_rounded,
                                size: 22,
                              ),
                              tooltip: context.l10n.chapters,
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: context.shiori.density.minTarget,
                                minHeight: context.shiori.density.minTarget,
                              ),
                              onPressed: () =>
                                  _showFontSizeBottomSheet(context),
                              icon: const Icon(
                                Symbols.format_size_rounded,
                                size: 22,
                              ),
                              tooltip: context.l10n.font_size,
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: context.shiori.density.minTarget,
                                minHeight: context.shiori.density.minTarget,
                              ),
                              onPressed: () {
                                if (_readerMode.isContinuous) {
                                  _readerController.setReaderMode(
                                    ReaderMode.ltr,
                                  );
                                  _readerController.setPageMode(
                                    PageMode.onePage,
                                  );
                                  ref
                                      .read(doublePageAutoStateProvider.notifier)
                                      .set(false);
                                  setState(() {
                                    _readerMode = ReaderMode.ltr;
                                    _pageMode = PageMode.onePage;
                                  });
                                } else if (effectivePageMode ==
                                    PageMode.onePage) {
                                  _readerController.setPageMode(
                                    PageMode.doublePage,
                                  );
                                  ref
                                      .read(doublePageAutoStateProvider.notifier)
                                      .set(false);
                                  setState(() {
                                    _pageMode = PageMode.doublePage;
                                  });
                                } else {
                                  _readerController.setReaderMode(
                                    ReaderMode.verticalContinuous,
                                  );
                                  setState(() {
                                    _readerMode =
                                        ReaderMode.verticalContinuous;
                                  });
                                }
                              },
                              icon: Icon(
                                _readerMode.isContinuous
                                    ? Symbols.swap_vert_rounded
                                    : (effectivePageMode == PageMode.doublePage
                                          ? Symbols.auto_stories_rounded
                                          : Symbols.article_rounded),
                                size: 22,
                                color: !_readerMode.isContinuous
                                    ? context.shiori.color.accentInk
                                    : null,
                              ),
                              tooltip: _readerMode.isContinuous
                                  ? context
                                      .l10n
                                      .reading_mode_vertical_continuous
                                  : (effectivePageMode == PageMode.doublePage
                                        ? context.l10n.double_page
                                        : context.l10n.single_page),
                            ),
                            if (_ttsSupported)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                  minWidth: context.shiori.density.minTarget,
                                  minHeight: context.shiori.density.minTarget,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showTts = !_showTts;
                                  });
                                },
                                icon: Icon(
                                  Symbols.record_voice_over_rounded,
                                  fill: _showTts ? 1 : 0,
                                  size: 22,
                                  color: _showTts
                                      ? context.shiori.color.accentInk
                                      : null,
                                ),
                                tooltip: context.l10n.tts,
                              ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: context.shiori.density.minTarget,
                                minHeight: context.shiori.density.minTarget,
                              ),
                              onPressed: () async {
                                bool autoScrollAlreadyFalse =
                                    _autoScroll.value == false;
                                if (!autoScrollAlreadyFalse) {
                                  _autoScroll.value = false;
                                }
                                await customDraggableTabBar(
                                  tabs: [
                                    Tab(text: context.l10n.reader),
                                    Tab(text: context.l10n.general),
                                    if (_ttsSupported)
                                      Tab(text: context.l10n.tts),
                                  ],
                                  children: [
                                    ReaderSettingsTab(
                                      readerController: _readerController,
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
                                      readerController: _readerController,
                                      pageOffset: _pageOffset,
                                    ),
                                    if (_ttsSupported) const TtsSettingsTab(),
                                  ],
                                  context: context,
                                  vsync: this,
                                );
                                if (!autoScrollAlreadyFalse ||
                                    _autoScroll.value) {
                                  if (_autoScrollPage.value &&
                                      _isContinuousMode()) {
                                    _autoScroll.value = true;
                                  }
                                }
                              },
                              icon: const Icon(Symbols.tune_rounded),
                              tooltip: context.l10n.settings,
                            ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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

  Color _parseColor(String hex, {Color? fallback}) {
    try {
      String hexColor = hex.trim().replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      } else if (hexColor.length == 8) {
        return Color(int.parse(hexColor, radix: 16));
      }
    } catch (_) {}
    // shiori: the book's own styles, set against whatever page colour the reader chose
    return fallback ?? Colors.grey;
  }

  TextAlign _getTextAlign(NovelTextAlign textAlign) {
    switch (textAlign) {
      case NovelTextAlign.left:
        return TextAlign.left;
      case NovelTextAlign.center:
        return TextAlign.center;
      case NovelTextAlign.right:
        return TextAlign.right;
      case NovelTextAlign.block:
        return TextAlign.justify;
    }
  }

  Widget _buildNovelHtmlWidget({
    required BuildContext context,
    required String htmlData,
    required String? fontFamily,
    required int fontSize,
    required double lineHeight,
    required int padding,
    required TextAlign textAlign,
    required bool removeExtraSpacing,
    required Color textColor,
    required Color backgroundColor,
    required bool showTts,
    required ({int paragraph, int wordStart, int wordEnd}) tts,
  }) {
    return Html(
      data: htmlData,
      style: {
        "body": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          color: textColor,
          backgroundColor: backgroundColor,
          margin: Margins.zero,
          padding: HtmlPaddings.all(padding.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "p": Style(
          fontFamily: fontFamily,
          margin: removeExtraSpacing
              ? Margins.only(bottom: 4)
              : Margins.only(bottom: 8),
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "div": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "span": Style(
          fontFamily: fontFamily,
          fontSize: FontSize(fontSize.toDouble()),
          lineHeight: LineHeight(lineHeight),
        ),
        "h1, h2, h3, h4, h5, h6": Style(
          fontFamily: fontFamily,
          color: textColor,
          lineHeight: LineHeight(lineHeight),
          textAlign: textAlign,
        ),
        "a": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          color: Colors.blue,
          textDecoration: TextDecoration.underline,
        ),
        "img": Style(width: Width(100, Unit.percent), height: Height.auto()),
        "table": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: Border.all(color: Colors.grey, width: 1),
          margin: Margins.symmetric(vertical: 10),
        ),
        "td, th": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: Border.all(color: Colors.grey, width: 0.5),
          padding: HtmlPaddings.all(8),
        ),
        "th": Style(
          fontWeight: FontWeight.bold,
          // shiori: the book's own styles, set against whatever page colour the reader chose
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
        ),
        "blockquote": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          border: Border(left: BorderSide(color: Colors.grey, width: 4)),
          padding: HtmlPaddings.only(left: 15),
          margin: Margins.symmetric(vertical: 10),
          fontStyle: FontStyle.italic,
        ),
        "pre, code": Style(
          // shiori: the book's own styles, set against whatever page colour the reader chose
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          padding: HtmlPaddings.all(8),
          fontFamily: 'monospace',
        ),
        "hr": Style(margin: Margins.symmetric(vertical: 20)),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-active]": Style(
            backgroundColor: context.shiori.color.accentInk
                .withValues(alpha: 0.10),
            border: Border(
              left: BorderSide(
                color: context.shiori.color.accentInk,
                width: 3,
              ),
            ),
            padding: HtmlPaddings.only(left: 8),
          ),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-word]": Style(
            backgroundColor: context.shiori.color.accentInk
                .withValues(alpha: 0.35),
            textDecoration: TextDecoration.underline,
            textDecorationColor: context.shiori.color.accentInk,
          ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"img", "source"},
          builder: (extensionContext) {
            final element = extensionContext.node as dom.Element;
            final customWidget = _buildCustomWidgets(element);
            if (customWidget != null) {
              return customWidget;
            }
            return const SizedBox.shrink();
          },
        ),
      ],
      onLinkTap: (url, attributes, element) {
        if (url != null) {
          context.push("/mangawebview", extra: {'url': url, 'title': url});
        }
      },
    );
  }

  Widget? _buildCustomWidgets(dom.Element element) {
    if (epubBook == null) return null;

    if (element.localName == "img" && element.getSrc != null) {
      final src = element.getSrc!;
      final fileName = src.split("/").last;
      final image = epubBook!.images
          .firstWhereOrNull(
            (img) =>
                img.name.endsWith(fileName) ||
                img.name.contains(fileName.replaceAll('%20', ' ')),
          )
          ?.content;

      if (image != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: ShioriSpace.s8),
          child: widgets.Image(
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(ShioriSpace.s8),
              color: context.shiori.color.error.background,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.broken_image_rounded,
                    color: context.shiori.color.error.foreground,
                  ),
                  const SizedBox(width: ShioriSpace.s8),
                  Flexible(
                    child: Text(
                      'Image not loaded: $fileName',
                      style: TextStyle(
                        color: context.shiori.color.error.foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            fit: BoxFit.contain,
            image: MemoryImage(image) as ImageProvider,
          ),
        );
      }
    }

    return null;
  }
}
