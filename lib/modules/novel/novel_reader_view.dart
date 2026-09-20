import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/repositories/chapter_repository.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/mixins/reader_gestures.dart';
import 'package:mangayomi/modules/manga/reader/widgets/auto_scroll_button.dart';
import 'package:mangayomi/modules/manga/reader/widgets/chapter_transition_page.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_app_bar.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/tts/novel_tts_service.dart';
import 'package:mangayomi/modules/novel/tts/tts_player_bar.dart';
import 'package:mangayomi/modules/novel/tts/tts_settings_tab.dart';
import 'package:mangayomi/modules/novel/utils/novel_paginator.dart';
import 'package:mangayomi/modules/novel/utils/novel_reader_fonts.dart';
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
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/widgets.dart' as widgets;

typedef DoubleClickAnimationListener = void Function();

class NovelReaderView extends ConsumerWidget {
  final int chapterId;
  final bool startAtEnd;
  NovelReaderView({
    super.key,
    required this.chapterId,
    this.startAtEnd = false,
  });
  late final Chapter chapter = chapterRepository.getById(chapterId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(getHtmlContentProvider(chapter: chapter));

    return NovelWebView(
      chapter: chapter,
      result: result,
      startAtEnd: startAtEnd,
    );
  }
}

class NovelWebView extends ConsumerStatefulWidget {
  const NovelWebView({
    super.key,
    required this.chapter,
    required this.result,
    this.startAtEnd = false,
  });

  final Chapter chapter;
  final AsyncValue<(String, EpubNovel?)> result;
  final bool startAtEnd;

  @override
  ConsumerState createState() {
    return _NovelWebViewState();
  }
}

class _NovelWebViewState extends ConsumerState<NovelWebView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
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
  bool _isNavigatingChapter = false;
  double _backwardOverscrollAmount = 0;
  double _forwardOverscrollAmount = 0;
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
    _autoScrollTicker?.dispose();
    _autoScroll.removeListener(_onAutoScrollChanged);
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
    } else if (state == AppLifecycleState.resumed) {
      _readingStopwatch.start();
      if (keepOn) {
        WakelockPlus.enable();
      }
    }
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
    _autoScroll.addListener(_onAutoScrollChanged);
    _initWakelock();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(onScroll);
      final initFontSize = ref.read(novelFontSizeStateProvider);
      setState(() {
        fontSize = initFontSize;
      });
      if (_autoScroll.value && _isContinuousMode()) {
        _startAutoScroll();
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
            duration: const Duration(milliseconds: 300),
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
  final ValueNotifier<({int paragraph, int wordStart, int wordEnd})>
  _ttsProgress = ValueNotifier((paragraph: -1, wordStart: -1, wordEnd: -1));
  int _ttsTotalBlocks = 0;
  StreamSubscription<int>? _ttsIndexSub;
  StreamSubscription<TtsState>? _ttsStateSub;
  StreamSubscription<TtsWordProgress>? _ttsWordSub;

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9);

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

  Ticker? _autoScrollTicker;
  Duration _lastAutoScrollTick = Duration.zero;
  bool _isUserDragging = false;

  bool _isContinuousMode() {
    return _readerMode.isContinuous;
  }

  void _onAutoScrollChanged() {
    if (_autoScroll.value && _isContinuousMode()) {
      _startAutoScroll();
    } else {
      _stopAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTicker ??= createTicker(_onAutoScrollTick);
    _lastAutoScrollTick = Duration.zero;
    if (!_autoScrollTicker!.isActive) {
      _autoScrollTicker!.start();
    }
  }

  void _stopAutoScroll() {
    if (_autoScrollTicker != null && _autoScrollTicker!.isActive) {
      _autoScrollTicker!.stop();
    }
    _lastAutoScrollTick = Duration.zero;
  }

  void _onAutoScrollTick(Duration elapsed) {
    if (!mounted || !_autoScroll.value || !_isContinuousMode()) {
      _stopAutoScroll();
      return;
    }
    if (_isUserDragging) {
      _lastAutoScrollTick = elapsed;
      return;
    }
    if (_lastAutoScrollTick == Duration.zero) {
      _lastAutoScrollTick = elapsed;
      return;
    }
    final double dt =
        (elapsed - _lastAutoScrollTick).inMicroseconds / 1000000.0;
    _lastAutoScrollTick = elapsed;

    if (dt <= 0 || dt > 0.1) return;

    if (_scrollController.hasClients) {
      final position = _scrollController.position;
      final double pixelsPerSecond = _pageOffset.value * 10.0;
      final double delta = pixelsPerSecond * dt;
      final double currentOffset = position.pixels;
      final double maxScroll = position.maxScrollExtent;
      final double minScroll = position.minScrollExtent;

      if (currentOffset >= maxScroll && delta > 0) {
        _autoScroll.value = false;
        _stopAutoScroll();
        return;
      }

      final double newOffset = (currentOffset + delta).clamp(
        minScroll,
        maxScroll,
      );
      if (newOffset != currentOffset) {
        _scrollController.jumpTo(newOffset);
      }
    }
  }

  void _scrollToTtsParagraph(int index) {
    if (!_scrollController.hasClients || _ttsTotalBlocks <= 0) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final targetOffset = (index / _ttsTotalBlocks) * maxScroll;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, maxScroll),
      duration: const Duration(milliseconds: 400),
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
  void _goToChapter(bool next, {bool? startAtEnd}) {
    if (_isNavigatingChapter) return;
    if (next && !_readerController.hasNextChapter) return;
    if (!next && !_readerController.hasPreviousChapter) return;
    _isNavigatingChapter = true;
    final bool shouldStartAtEnd = startAtEnd ?? !next;
    pushReplacementMangaReaderView(
      context: context,
      chapter: next
          ? _readerController.getNextChapter()
          : _readerController.getPrevChapter(),
      startAtEnd: shouldStartAtEnd,
    );
  }

  @override
  Widget build(BuildContext context) {
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
        _stopAutoScroll();
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
              _startAutoScroll();
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
    ).wrapWithKeyboardListener(
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            if (notification.dragDetails != null) {
              _isUserDragging = true;
            }
          } else if (notification is ScrollEndNotification) {
            _isUserDragging = false;
          }
          if (notification is OverscrollNotification) {
            if (notification.overscroll < 0) {
              _backwardOverscrollAmount += (-notification.overscroll);
              _forwardOverscrollAmount = 0;
              if (_backwardOverscrollAmount > 80) {
                _backwardOverscrollAmount = 0;
                _goToChapter(false, startAtEnd: true);
              }
            } else if (notification.overscroll > 0) {
              _forwardOverscrollAmount += notification.overscroll;
              _backwardOverscrollAmount = 0;
              if (_forwardOverscrollAmount > 80) {
                _forwardOverscrollAmount = 0;
                _goToChapter(true, startAtEnd: false);
              }
            }
          } else if (notification is ScrollUpdateNotification) {
            if (notification.scrollDelta != null) {
              if (notification.scrollDelta! > 0) {
                _backwardOverscrollAmount = 0;
              } else if (notification.scrollDelta! < 0) {
                _forwardOverscrollAmount = 0;
              }
            }
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
                              final fontFamily = resolveNovelFontFamily(
                                ref.watch(novelFontFamilyStateProvider),
                              );

                              if (!_scrollRestoreScheduled &&
                                  _readerMode.isContinuous) {
                                _scrollRestoreScheduled = true;
                                final screenHeight =
                                    MediaQuery.of(context).size.height;
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () {
                                    if (!scrolled &&
                                        mounted &&
                                        _scrollController.hasClients) {
                                      final targetProgress = widget.startAtEnd
                                          ? 1.0
                                          : (double.tryParse(
                                                chapter.lastPageRead ?? '',
                                              ) ??
                                              0);
                                      if (widget.startAtEnd) {
                                        final maxScroll = _scrollController
                                            .position.maxScrollExtent;
                                        _scrollController.jumpTo(
                                          (maxScroll - screenHeight)
                                              .clamp(0.0, maxScroll),
                                        );
                                        scrolled = true;
                                      } else {
                                        _scrollController
                                            .animateTo(
                                              _scrollController
                                                      .position
                                                      .maxScrollExtent *
                                                  targetProgress,
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
                                                _startAutoScroll();
                                              }
                                            });
                                      }
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

                                            final pagination =
                                                _cachedPagination!;
                                            final contentCount = isDouble
                                                ? pagination.spreadCount
                                                : pagination.pageCount;
                                            final totalCount =
                                                contentCount + 1;

                                            if (!_scrollRestoreScheduled) {
                                              _scrollRestoreScheduled = true;
                                              final progress = widget.startAtEnd
                                                  ? 1.0
                                                  : (double.tryParse(
                                                        chapter.lastPageRead ?? '',
                                                      ) ??
                                                      0.0);
                                              final targetIndex = widget.startAtEnd
                                                  ? (contentCount > 0 ? contentCount - 1 : 0)
                                                  : (isDouble
                                                      ? pagination
                                                          .spreadForProgress(
                                                            progress,
                                                          )
                                                      : pagination
                                                          .pageForProgress(
                                                            progress,
                                                          ));
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
                                                  _currentSpreadIndex =
                                                      pageIndex;
                                                  final progress = pageIndex >=
                                                          contentCount
                                                      ? 1.0
                                                      : (isDouble
                                                          ? pagination
                                                              .progressForSpread(
                                                                pageIndex,
                                                              )
                                                          : pagination
                                                              .progressForPage(
                                                                pageIndex,
                                                              ));
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
                                                  if (index >= contentCount) {
                                                    return _buildTransitionPage(
                                                      chapter,
                                                    );
                                                  }
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
                                                          color: Colors.grey
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
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
                                              SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: MediaQuery.of(
                                                    context,
                                                  ).size.height,
                                                  child: _buildTransitionPage(
                                                    chapter,
                                                  ),
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
                                    final contentCount = effectivePageMode ==
                                            PageMode.doublePage
                                        ? _cachedPagination!.spreadCount
                                        : _cachedPagination!.pageCount;
                                    if (_currentSpreadIndex >= contentCount) {
                                      displayLabel =
                                          context.l10n.end_of_chapter;
                                    } else {
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
                                    }
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
                                                4.0,
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
                                                  fontSize: 14,
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
                        bottom: _isView ? 145 : 0,
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
                Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) {
                if (widget.result.isRefreshing || widget.result.isReloading) {
                  return scaffoldWith(
                    context,
                    Center(child: CircularProgressIndicator()),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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

  Widget _buildTransitionPage(Chapter chapter) {
    final nextChapter = _readerController.hasNextChapter
        ? _readerController.getNextChapter()
        : null;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _isViewFunction();
      },
      child: SizedBox.expand(
        child: ChapterTransitionPage(
          currentChapter: chapter,
          nextChapter: nextChapter,
          mangaName: chapter.manga.value?.name ?? '',
          readerMode: _readerMode,
          onNextChapter: nextChapter != null
              ? () => _goToChapter(true, startAtEnd: false)
              : null,
        ),
      ),
    );
  }

  void _onBtnTapped(double value) {
    if (!_readerMode.isContinuous) {
      if (_spreadController.hasClients) {
        final contentCount = _cachedPagination != null
            ? (_lastEffectivePageMode == PageMode.doublePage
                ? _cachedPagination!.spreadCount
                : _cachedPagination!.pageCount)
            : 1;
        final maxIndex = contentCount; // Transition page is at index contentCount
        if (value > 0) {
          if (_currentSpreadIndex >= maxIndex) {
            _goToChapter(true, startAtEnd: false);
            return;
          }
          _spreadController.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        } else {
          if (_currentSpreadIndex <= 0) {
            _goToChapter(false, startAtEnd: true);
            return;
          }
          _spreadController.previousPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      }
      return;
    }
    if (_scrollController.hasClients) {
      final currentOffset = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (value > 0 && currentOffset >= maxScroll - 20) {
        _goToChapter(true, startAtEnd: false);
        return;
      } else if (value < 0 && currentOffset <= 20) {
        _goToChapter(false, startAtEnd: true);
        return;
      }

      final newOffset = currentOffset + value;
      _scrollController.animateTo(
        newOffset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 100),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currentFontSize = ref.watch(novelFontSizeStateProvider);
            final primaryColor = Theme.of(context).primaryColor;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_size_rounded,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.font_size,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$currentFontSize px',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        onPressed: currentFontSize > 8
                            ? () {
                                final newSize = currentFontSize - 1;
                                ref
                                    .read(novelFontSizeStateProvider.notifier)
                                    .set(newSize);
                                setState(() => fontSize = newSize);
                              }
                            : null,
                        icon: const Icon(Icons.remove_rounded, size: 18),
                        tooltip: context.l10n.decrease,
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 12,
                            ),
                            activeTrackColor: primaryColor,
                            inactiveTrackColor: primaryColor.withValues(
                              alpha: 0.2,
                            ),
                            thumbColor: primaryColor,
                            overlayColor: primaryColor.withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: currentFontSize.toDouble().clamp(8.0, 40.0),
                            min: 8,
                            max: 40,
                            divisions: 32,
                            onChanged: (val) {
                              final newSize = val.toInt();
                              ref
                                  .read(novelFontSizeStateProvider.notifier)
                                  .set(newSize);
                              setState(() => fontSize = newSize);
                            },
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                        onPressed: currentFontSize < 40
                            ? () {
                                final newSize = currentFontSize + 1;
                                ref
                                    .read(novelFontSizeStateProvider.notifier)
                                    .set(newSize);
                                setState(() => fontSize = newSize);
                              }
                            : null,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        tooltip: context.l10n.increase,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [12, 14, 16, 18, 20, 24, 28].map((size) {
                        final isSelected = currentFontSize == size;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ChoiceChip(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            labelStyle: const TextStyle(fontSize: 11),
                            label: Text('$size'),
                            selected: isSelected,
                            onSelected: (_) {
                              ref
                                  .read(novelFontSizeStateProvider.notifier)
                                  .set(size);
                              setState(() => fontSize = size);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomBar(
    BackgroundColor backgroundColor,
    PageMode effectivePageMode,
  ) {
    if (!_isView && Platform.isIOS) {
      return const SizedBox.shrink();
    }
    bool hasPrevChapter = _readerController.hasPreviousChapter;
    bool hasNextChapter = _readerController.hasNextChapter;
    final bodyLargeColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
        width: context.width(1),
        height: (_isView ? 116 : 0),
        // The Column's natural content height briefly exceeds this box
        // mid-animation (it's animating between 0 and 116), which is a
        // transient overflow, not a real layout bug - clip it during the
        // transition instead of restructuring content that fits fine once
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.topCenter,
            minHeight: 0,
            maxHeight: 116,
            child: SizedBox(
              height: 116,
              child: Column(
                children: [
                  if (_isView)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: _backgroundColor(context),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              onPressed: hasPrevChapter
                                  ? () => _goToChapter(false, startAtEnd: false)
                                  : null,
                              icon: Icon(
                                Icons.skip_previous_rounded,
                                size: 22,
                                color: hasPrevChapter
                                    ? bodyLargeColor
                                    : bodyLargeColor!.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                            const SizedBox(width: 12),
                                            Text(
                                              currentLabel,
                                              style: TextStyle(
                                                color: bodyLargeColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
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
                                                      activeTrackColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      thumbColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
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
                                              style: TextStyle(
                                                color: bodyLargeColor
                                                    ?.withValues(alpha: 0.6),
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
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
                                          const SizedBox(width: 12),
                                          Text(
                                            '$scrollPercentage%',
                                            style: TextStyle(
                                              color: bodyLargeColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                                    activeTrackColor: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    thumbColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary,
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
                                          Text(
                                            '100%',
                                            style: TextStyle(
                                              color: bodyLargeColor?.withValues(
                                                alpha: 0.6,
                                              ),
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: _backgroundColor(context),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 36,
                                minHeight: 36,
                              ),
                              onPressed: hasNextChapter
                                  ? () => _goToChapter(true, startAtEnd: false)
                                  : null,
                              icon: Icon(
                                Icons.skip_next_rounded,
                                size: 22,
                                color: hasNextChapter
                                    ? bodyLargeColor
                                    : bodyLargeColor!.withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isView)
                    Expanded(
                      child: Container(
                        color: _backgroundColor(context),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              onPressed: () =>
                                  _showFontSizeBottomSheet(context),
                              icon: const Icon(
                                Icons.format_size_rounded,
                                size: 22,
                              ),
                              tooltip: context.l10n.font_size,
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
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
                                    ? Icons.swap_vert_rounded
                                    : (effectivePageMode == PageMode.doublePage
                                          ? Icons.auto_stories
                                          : Icons.article_outlined),
                                size: 22,
                                color: !_readerMode.isContinuous
                                    ? Theme.of(context).colorScheme.primary
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
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showTts = !_showTts;
                                  });
                                },
                                icon: Icon(
                                  _showTts
                                      ? Icons.record_voice_over_rounded
                                      : Icons.record_voice_over_outlined,
                                  size: 22,
                                  color: _showTts
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                                tooltip: context.l10n.tts,
                              ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
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
                              icon: const Icon(Icons.tune_rounded),
                              tooltip: context.l10n.settings,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
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
          color: Colors.blue,
          textDecoration: TextDecoration.underline,
        ),
        "img": Style(width: Width(100, Unit.percent), height: Height.auto()),
        "table": Style(
          border: Border.all(color: Colors.grey, width: 1),
          margin: Margins.symmetric(vertical: 10),
        ),
        "td, th": Style(
          border: Border.all(color: Colors.grey, width: 0.5),
          padding: HtmlPaddings.all(8),
        ),
        "th": Style(
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
        ),
        "blockquote": Style(
          border: Border(left: BorderSide(color: Colors.grey, width: 4)),
          padding: HtmlPaddings.only(left: 15),
          margin: Margins.symmetric(vertical: 10),
          fontStyle: FontStyle.italic,
        ),
        "pre, code": Style(
          backgroundColor: Colors.grey.withValues(alpha: 0.2),
          padding: HtmlPaddings.all(8),
          fontFamily: 'monospace',
        ),
        "hr": Style(margin: Margins.symmetric(vertical: 20)),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-active]": Style(
            backgroundColor: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.10),
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            padding: HtmlPaddings.only(left: 8),
          ),
        if (showTts && tts.paragraph >= 0)
          "[data-tts-word]": Style(
            backgroundColor: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.35),
            textDecoration: TextDecoration.underline,
            textDecorationColor: Theme.of(context).colorScheme.primary,
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: widgets.Image(
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red.withValues(alpha: 0.1),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.broken_image, color: Colors.red),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Image not loaded: $fileName',
                      style: const TextStyle(color: Colors.red),
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
