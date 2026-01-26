import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qjs/quickjs/ffi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/modules/novel/widgets/novel_reader_settings_sheet.dart';
import 'package:mangayomi/modules/widgets/custom_draggable_tabbar.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_html_content.dart';
import 'package:mangayomi/src/rust/api/epub.dart';
import 'package:mangayomi/utils/extensions/dom_extensions.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/widgets.dart' as widgets;

typedef DoubleClickAnimationListener = void Function();

class NovelReaderView extends ConsumerWidget {
  final int chapterId;
  NovelReaderView({super.key, required this.chapterId});
  late final Chapter chapter = isar.chapters.getSync(chapterId)!;
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
    with TickerProviderStateMixin {
  late final NovelReaderController _readerController = ref.read(
    novelReaderControllerProvider(chapter: chapter).notifier,
  );
  final _scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  bool scrolled = false;
  double offset = 0;
  double maxOffset = 0;
  int fontSize = 14;
  bool isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  void onScroll() {
    if (_scrollController.hasClients) {
      offset = _scrollController.offset;
      maxOffset = _scrollController.position.maxScrollExtent;
      _rebuildDetail.add(offset);
    }
  }

  @override
  void dispose() {
    _readerController.setChapterOffset(offset, maxOffset, true);
    _readerController.setMangaHistoryUpdate();
    _scrollController.removeListener(onScroll);
    _scrollController.dispose();
    _rebuildDetail.close();
    _autoScroll.value = false;
    _autoScroll.dispose();
    _autoScrollPage.dispose();
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
    super.dispose();
  }

  late Chapter chapter = widget.chapter;
  EpubNovel? epubBook;

  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(onScroll);
      final initFontSize = ref.read(novelFontSizeStateProvider);
      setState(() {
        fontSize = initFontSize;
      });
    });
    if (!isDesktop) SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    discordRpc?.showChapterDetails(ref, chapter);
  }

  late bool _isBookmarked = _readerController.getChapterBookmarked();

  bool _isView = false;

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
  void _autoPagescroll() async {
    for (int i = 0; i < 1; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!_autoScroll.value) {
        return;
      }
      if (_scrollController.hasClients) {
        final currentOffset = _scrollController.offset;
        final maxScroll = _scrollController.position.maxScrollExtent;

        if (!(currentOffset >= maxScroll)) {
          final newOffset = currentOffset + _pageOffset.value;
          _scrollController.animateTo(
            min(newOffset, maxScroll),
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    }
    _autoPagescroll();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = ref.watch(backgroundColorStateProvider);
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    return KeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKeyEvent: (event) {
        bool isLogicalKeyPressed(LogicalKeyboardKey key) =>
            HardwareKeyboard.instance.isLogicalKeyPressed(key);
        bool hasNextChapter = _readerController.getChapterIndex().$1 != 0;
        bool hasPrevChapter =
            _readerController.getChapterIndex().$1 + 1 !=
            _readerController.getChaptersLength(
              _readerController.getChapterIndex().$2,
            );
        final action = switch (event.logicalKey) {
          LogicalKeyboardKey.f11 =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.f11))
                ? _setFullScreen()
                : null,
          LogicalKeyboardKey.escape =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.escape))
                ? _goBack(context)
                : null,
          LogicalKeyboardKey.backspace =>
            (!isLogicalKeyPressed(LogicalKeyboardKey.backspace))
                ? _goBack(context)
                : null,
          LogicalKeyboardKey.keyN || LogicalKeyboardKey.pageDown =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyN) ||
                    !isLogicalKeyPressed(LogicalKeyboardKey.pageDown)))
                ? switch (hasNextChapter) {
                    true => pushReplacementMangaReaderView(
                      context: context,
                      chapter: _readerController.getNextChapter(),
                    ),
                    _ => null,
                  }
                : null,
          LogicalKeyboardKey.keyP || LogicalKeyboardKey.pageUp =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyP) ||
                    !isLogicalKeyPressed(LogicalKeyboardKey.pageUp)))
                ? switch (hasPrevChapter) {
                    true => pushReplacementMangaReaderView(
                      context: context,
                      chapter: _readerController.getPrevChapter(),
                    ),
                    _ => null,
                  }
                : null,
          _ => null,
        };
        action;
      },
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

                              Color parseColor(String hex, {Color? fallback}) {
                                try {
                                  String hexColor = hex.trim().replaceAll(
                                    '#',
                                    '',
                                  );
                                  // Ensure we have a valid 6-character hex color
                                  if (hexColor.length == 6) {
                                    return Color(
                                      int.parse('FF$hexColor', radix: 16),
                                    );
                                  } else if (hexColor.length == 8) {
                                    // Already has alpha channel
                                    return Color(
                                      int.parse(hexColor, radix: 16),
                                    );
                                  }
                                } catch (_) {
                                  // If parsing fails, use fallback
                                }
                                return fallback ?? Colors.grey;
                              }

                              TextAlign getTextAlign() {
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

                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () {
                                  if (!scrolled &&
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
                                          duration: Duration(seconds: 1),
                                          curve: Curves.fastOutSlowIn,
                                        )
                                        .then((value) {
                                          _autoPagescroll();
                                          scrolled = true;
                                        });
                                  }
                                },
                              );
                              return Consumer(
                                builder: (context, ref, _) {
                                  final fontSize = ref.read(
                                    novelFontSizeStateProvider,
                                  );
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
                                        physics: const BouncingScrollPhysics(),
                                        slivers: [
                                          SliverToBoxAdapter(
                                            child: Html(
                                              data: data.$1,
                                              style: {
                                                "body": Style(
                                                  fontSize: FontSize(
                                                    fontSize.toDouble(),
                                                  ),
                                                  color: parseColor(
                                                    customTextColor,
                                                    fallback: Colors.white,
                                                  ),
                                                  backgroundColor: parseColor(
                                                    customBackgroundColor,
                                                    fallback: const Color(
                                                      0xFF292832,
                                                    ),
                                                  ),
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.all(
                                                    padding.toDouble(),
                                                  ),
                                                  lineHeight: LineHeight(
                                                    lineHeight,
                                                  ),
                                                  textAlign: getTextAlign(),
                                                ),
                                                "p": Style(
                                                  margin: removeExtraSpacing
                                                      ? Margins.only(bottom: 4)
                                                      : Margins.only(bottom: 8),
                                                  fontSize: FontSize(
                                                    fontSize.toDouble(),
                                                  ),
                                                  lineHeight: LineHeight(
                                                    lineHeight,
                                                  ),
                                                  textAlign: getTextAlign(),
                                                ),
                                                "div": Style(
                                                  fontSize: FontSize(
                                                    fontSize.toDouble(),
                                                  ),
                                                  lineHeight: LineHeight(
                                                    lineHeight,
                                                  ),
                                                  textAlign: getTextAlign(),
                                                ),
                                                "span": Style(
                                                  fontSize: FontSize(
                                                    fontSize.toDouble(),
                                                  ),
                                                  lineHeight: LineHeight(
                                                    lineHeight,
                                                  ),
                                                ),
                                                "h1, h2, h3, h4, h5, h6": Style(
                                                  color: parseColor(
                                                    customTextColor,
                                                    fallback: Colors.white,
                                                  ),
                                                  lineHeight: LineHeight(
                                                    lineHeight,
                                                  ),
                                                  textAlign: getTextAlign(),
                                                ),
                                                "a": Style(
                                                  color: Colors.blue,
                                                  textDecoration:
                                                      TextDecoration.underline,
                                                ),
                                                "img": Style(
                                                  width: Width(
                                                    100,
                                                    Unit.percent,
                                                  ),
                                                  height: Height.auto(),
                                                ),
                                                "table": Style(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  ),
                                                  margin: Margins.symmetric(
                                                    vertical: 10,
                                                  ),
                                                ),
                                                "td, th": Style(
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5,
                                                  ),
                                                  padding: HtmlPaddings.all(8),
                                                ),
                                                "th": Style(
                                                  fontWeight: FontWeight.bold,
                                                  backgroundColor: Colors.grey
                                                      .withValues(alpha: 0.2),
                                                ),
                                                "blockquote": Style(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: Colors.grey,
                                                      width: 4,
                                                    ),
                                                  ),
                                                  padding: HtmlPaddings.only(
                                                    left: 15,
                                                  ),
                                                  margin: Margins.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                "pre, code": Style(
                                                  backgroundColor: Colors.grey
                                                      .withValues(alpha: 0.2),
                                                  padding: HtmlPaddings.all(8),
                                                  fontFamily: 'monospace',
                                                ),
                                                "hr": Style(
                                                  margin: Margins.symmetric(
                                                    vertical: 20,
                                                  ),
                                                ),
                                              },
                                              extensions: [
                                                TagExtension(
                                                  tagsToExtend: {
                                                    "img",
                                                    "source",
                                                  },
                                                  builder: (extensionContext) {
                                                    final element =
                                                        extensionContext.node
                                                            as dom.Element;
                                                    final customWidget =
                                                        _buildCustomWidgets(
                                                          element,
                                                        );
                                                    if (customWidget != null) {
                                                      return customWidget;
                                                    }

                                                    return const SizedBox.shrink();
                                                  },
                                                ),
                                              ],
                                              onLinkTap:
                                                  (url, attributes, element) {
                                                    if (url != null) {
                                                      context.push(
                                                        "/mangawebview",
                                                        extra: {
                                                          'url': url,
                                                          'title': url,
                                                        },
                                                      );
                                                    }
                                                  },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                  final scrollPercentage = maxOffset > 0
                                      ? ((offset / maxOffset) * 100)
                                            .clamp(0, 100)
                                            .toInt()
                                      : 0;
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
                                                '$scrollPercentage %',
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
                    _bottomBar(backgroundColor),
                    _autoScrollPlayPauseBtn(),
                  ],
                );
              },
              loading: () => scaffoldWith(
                context,
                Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) =>
                  scaffoldWith(context, Center(child: Text(err.toString()))),
            ),
          ),
        ),
      ),
    );
  }

  Widget _autoScrollPlayPauseBtn() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: !_isView
          ? ValueListenableBuilder(
              valueListenable: _autoScrollPage,
              builder: (context, valueT, child) => valueT
                  ? ValueListenableBuilder(
                      valueListenable: _autoScroll,
                      builder: (context, value, child) => IconButton(
                        onPressed: () {
                          _autoPagescroll();
                          _autoScroll.value = !value;
                        },
                        icon: Icon(
                          value ? Icons.pause_circle : Icons.play_circle,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            )
          : const SizedBox.shrink(),
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

  void _goBack(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    Navigator.pop(context);
  }

  void _onBtnTapped(double value) {
    final currentOffset = _scrollController.offset;
    final maxScroll = _scrollController.position.maxScrollExtent;

    final newOffset = currentOffset + value;
    _scrollController.animateTo(
      min(newOffset, maxScroll),
      duration: Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  Widget _gestureRightLeft(bool usePageTapZones) {
    return Row(
      children: [
        /// left region
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
              usePageTapZones ? _onBtnTapped(100) : _isViewFunction();
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
    if (!_isView && Platform.isIOS) {
      return const SizedBox.shrink();
    }
    final fullScreenReader = ref.watch(fullScreenReaderStateProvider);
    double height = _isView
        ? Platform.isIOS
              ? 120
              : !fullScreenReader && !isDesktop
              ? 55
              : 80
        : 0;
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        width: context.width(1),
        height: height,
        curve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        child: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: AppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: ListTile(
              dense: true,
              title: SizedBox(
                width: context.width(0.8),
                child: Text(
                  '${_readerController.getMangaName()} ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              subtitle: SizedBox(
                width: context.width(0.8),
                child: Text(
                  _readerController.getChapterTitle(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              btnToShowChapterListDialog(
                context,
                context.l10n.chapters,
                widget.chapter,
              ),
              IconButton(
                onPressed: () {
                  _readerController.setChapterBookmarked();
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                },
                icon: Icon(
                  _isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined,
                ),
              ),
              if ((chapter.manga.value!.isLocalArchive ?? false) == false)
                IconButton(
                  onPressed: () async {
                    final manga = chapter.manga.value!;
                    final source = getSource(
                      manga.lang!,
                      manga.source!,
                      manga.sourceId,
                    )!;
                    String url = chapter.url!.startsWith('/')
                        ? "${source.baseUrl}/${chapter.url!}"
                        : chapter.url!;
                    Map<String, dynamic> data = {
                      'url': url,
                      'sourceId': source.id.toString(),
                      'title': chapter.name!,
                    };
                    if (Platform.isLinux) {
                      final urll = Uri.parse(url);
                      if (!await launchUrl(
                        urll,
                        mode: LaunchMode.inAppBrowserView,
                      )) {
                        if (!await launchUrl(
                          urll,
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw 'Could not launch $url';
                        }
                      }
                    } else {
                      context.push("/mangawebview", extra: data);
                    }
                  },
                  icon: const Icon(Icons.public),
                ),
            ],
            backgroundColor: _backgroundColor(context),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar(BackgroundColor backgroundColor) {
    if (!_isView && Platform.isIOS) {
      return const SizedBox.shrink();
    }
    bool hasPrevChapter =
        _readerController.getChapterIndex().$1 + 1 !=
        _readerController.getChaptersLength(
          _readerController.getChapterIndex().$2,
        );
    bool hasNextChapter = _readerController.getChapterIndex().$1 != 0;
    final bodyLargeColor = Theme.of(context).textTheme.bodyLarge!.color;
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: const Duration(milliseconds: 300),
        width: context.width(1),
        height: (_isView ? 140 : 0),
        child: Column(
          children: [
            if (_isView)
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: _backgroundColor(context),
                      child: IconButton(
                        onPressed: hasPrevChapter
                            ? () {
                                pushReplacementMangaReaderView(
                                  context: context,
                                  chapter: _readerController.getPrevChapter(),
                                );
                              }
                            : null,
                        icon: Icon(
                          Icons.skip_previous_rounded,
                          color: hasPrevChapter
                              ? bodyLargeColor
                              : bodyLargeColor!.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _backgroundColor(context),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: StreamBuilder(
                        stream: _rebuildDetail.stream,
                        builder: (context, asyncSnapshot) {
                          return Consumer(
                            builder: (context, ref, child) {
                              final scrollPercentage = maxOffset > 0
                                  ? ((offset / maxOffset) * 100)
                                        .clamp(0, 100)
                                        .toInt()
                                  : 0;
                              return Row(
                                children: [
                                  SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      scrollPercentage.toInt().toString(),
                                      style: TextStyle(
                                        color: bodyLargeColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (_isView)
                                    Expanded(
                                      flex: 14,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          trackHeight: 2.0,
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                enabledThumbRadius: 6.0,
                                              ),
                                          overlayShape:
                                              const RoundSliderOverlayShape(
                                                overlayRadius: 12.0,
                                              ),
                                        ),
                                        child: Slider(
                                          onChanged: (value) {
                                            _scrollController.jumpTo(
                                              _scrollController
                                                      .position
                                                      .maxScrollExtent *
                                                  value,
                                            );
                                          },
                                          value: scrollPercentage / 100,
                                          min: 0,
                                          max: 1,
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      '100',
                                      style: TextStyle(
                                        color: bodyLargeColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: _backgroundColor(context),
                      child: IconButton(
                        onPressed: hasNextChapter
                            ? () {
                                pushReplacementMangaReaderView(
                                  context: context,
                                  chapter: _readerController.getNextChapter(),
                                );
                              }
                            : null,
                        icon: Transform.scale(
                          scaleX: 1,
                          child: Icon(
                            Icons.skip_next_rounded,
                            color: hasNextChapter
                                ? bodyLargeColor
                                : bodyLargeColor!.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (_isView)
              Expanded(
                child: Container(
                  color: _backgroundColor(context),
                  child: Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: bodyLargeColor!,
                                    width: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      context.l10n.text_size,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: bodyLargeColor,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final newFontSize = max(
                                          4,
                                          fontSize - 1,
                                        );
                                        ref
                                            .read(
                                              novelFontSizeStateProvider
                                                  .notifier,
                                            )
                                            .set(newFontSize);
                                        setState(() {
                                          fontSize = newFontSize;
                                        });
                                      },
                                      icon: Icon(Icons.text_decrease),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer
                                              .withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Consumer(
                                          builder: (context, ref, child) {
                                            final currentFontSize = ref.watch(
                                              novelFontSizeStateProvider,
                                            );
                                            return Text(
                                              "$currentFontSize px",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final newFontSize = min(
                                          40,
                                          fontSize + 1,
                                        );
                                        ref
                                            .read(
                                              novelFontSizeStateProvider
                                                  .notifier,
                                            )
                                            .set(newFontSize);
                                        setState(() {
                                          fontSize = newFontSize;
                                        });
                                      },
                                      icon: const Icon(Icons.text_increase),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () async {
                                  bool autoScrollAreadyFalse =
                                      _autoScroll.value == false;
                                  if (!autoScrollAreadyFalse) {
                                    _autoScroll.value = false;
                                  }
                                  await customDraggableTabBar(
                                    tabs: [
                                      Tab(text: context.l10n.reader),
                                      Tab(text: context.l10n.general),
                                    ],
                                    children: [
                                      ReaderSettingsTab(),
                                      GeneralSettingsTab(
                                        autoScrollPage: _autoScrollPage,
                                        autoScroll: _autoScroll,
                                        readerController: _readerController,
                                        pageOffset: _pageOffset,
                                      ),
                                    ],
                                    context: context,
                                    vsync: this,
                                  );
                                  if (!autoScrollAreadyFalse ||
                                      _autoScroll.value) {
                                    if (_autoScrollPage.value) {
                                      _autoPagescroll();
                                      _autoScroll.value = true;
                                    }
                                  }
                                },
                                icon: const Icon(Icons.settings),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
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
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
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
