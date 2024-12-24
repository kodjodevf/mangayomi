import 'dart:async';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/page.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/anime/widgets/desktop.dart';
import 'package:mangayomi/modules/manga/reader/widgets/btn_chapter_list_dialog.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/novel/novel_reader_controller_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/services/get_html_content.dart';
import 'package:mangayomi/utils/utils.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/services/get_chapter_pages.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:mangayomi/utils/global_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

typedef DoubleClickAnimationListener = void Function();

class NovelReaderView extends ConsumerWidget {
  final Chapter chapter;
  const NovelReaderView({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final htmlContent = ref.watch(getHtmlContentProvider(chapter: chapter));

    return NovelWebView(
      chapter: chapter,
      htmlContent: htmlContent,
    );
  }
}

class NovelWebView extends ConsumerStatefulWidget {
  const NovelWebView({
    super.key,
    required this.chapter,
    required this.htmlContent,
  });

  final Chapter chapter;
  final AsyncValue<String> htmlContent;

  @override
  ConsumerState createState() {
    return _NovelWebViewState();
  }
}

class _NovelWebViewState extends ConsumerState<NovelWebView>
    with TickerProviderStateMixin {
  late final NovelReaderController _readerController =
      ref.read(novelReaderControllerProvider(chapter: chapter).notifier);
  final _scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );
  bool scrolled = false;
  double offset = 0;
  double maxOffset = 0;
  bool isDesktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  void onScroll() {
    if (_scrollController.hasClients) {
      offset = _scrollController.offset;
      maxOffset = _scrollController.position.maxScrollExtent;
    }
  }

  @override
  void dispose() {
    _readerController.setChapterOffset(offset, maxOffset, true);
    _readerController.setMangaHistoryUpdate();
    _scrollController.removeListener(onScroll);
    _scrollController.dispose();
    _rebuildDetail.close();
    clearGestureDetailsCache();
    if (isDesktop) {
      setFullScreen(value: false);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
    super.dispose();
  }

  late Chapter chapter = widget.chapter;

  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(onScroll);
    });
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
        bool hasPrevChapter = _readerController.getChapterIndex().$1 + 1 !=
            _readerController
                .getChaptersLength(_readerController.getChapterIndex().$2);
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
          LogicalKeyboardKey.keyN ||
          LogicalKeyboardKey.pageDown =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyN) ||
                    !isLogicalKeyPressed(LogicalKeyboardKey.pageDown)))
                ? switch (hasNextChapter) {
                    true => pushReplacementMangaReaderView(
                        context: context,
                        chapter: _readerController.getNextChapter(),
                      ),
                    _ => null
                  }
                : null,
          LogicalKeyboardKey.keyP ||
          LogicalKeyboardKey.pageUp =>
            ((!isLogicalKeyPressed(LogicalKeyboardKey.keyP) ||
                    !isLogicalKeyPressed(LogicalKeyboardKey.pageUp)))
                ? switch (hasPrevChapter) {
                    true => pushReplacementMangaReaderView(
                        context: context,
                        chapter: _readerController.getPrevChapter()),
                    _ => null
                  }
                : null,
          _ => null
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
            child: Stack(
              children: [
                Row(
                  children: [
                    widget.htmlContent.when(
                        data: (htmlContent) {
                          Future.delayed(const Duration(milliseconds: 1000),
                              () {
                            if (!scrolled && _scrollController.hasClients) {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent *
                                      (double.tryParse(chapter.lastPageRead!) ??
                                          0),
                                  duration: Duration(seconds: 2),
                                  curve: Curves.fastOutSlowIn);
                              scrolled = true;
                            }
                          });
                          return Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _isViewFunction();
                                },
                                child: Column(
                                  children: [
                                    HtmlWidget(
                                      htmlContent,
                                      customStylesBuilder: (element) {
                                        switch (backgroundColor) {
                                          case BackgroundColor.black:
                                            return {
                                              'background-color': 'black',
                                            };
                                          default:
                                            return {
                                              'background-color': '#F0F0F0',
                                            };
                                        }
                                      },
                                      onTapUrl: (url) {
                                        context.push("/mangawebview",
                                            extra: {'url': url, 'title': url});
                                        return true;
                                      },
                                      renderMode: RenderMode.column,
                                      textStyle: TextStyle(
                                          color: backgroundColor ==
                                                  BackgroundColor.white
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 14),
                                    ),
                                    Center(
                                      heightFactor: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(5),
                                            onPressed: () =>
                                                pushReplacementMangaReaderView(
                                              context: context,
                                              chapter: _readerController
                                                  .getPrevChapter(),
                                            ),
                                            icon: Icon(
                                              size: 32,
                                              Icons.arrow_back,
                                              color: backgroundColor ==
                                                      BackgroundColor.white
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                          IconButton(
                                            padding: const EdgeInsets.all(5),
                                            onPressed: () =>
                                                pushReplacementMangaReaderView(
                                              context: context,
                                              chapter: _readerController
                                                  .getNextChapter(),
                                            ),
                                            icon: Icon(
                                              size: 32,
                                              Icons.arrow_forward,
                                              color: backgroundColor ==
                                                      BackgroundColor.white
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        loading: () => const Expanded(
                                child: Center(
                              child: CircularProgressIndicator(),
                            )),
                        error: (err, stack) => Center(
                              child: Text(err.toString()),
                            )),
                  ],
                ),
                //_gestureRightLeft(),
                //_gestureTopBottom(),
                _appBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBack(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    Navigator.pop(context);
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
                  context, context.l10n.chapters, widget.chapter),
              IconButton(
                  onPressed: () {
                    _readerController.setChapterBookmarked();
                    setState(() {
                      _isBookmarked = !_isBookmarked;
                    });
                  },
                  icon: Icon(_isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined)),
              if ((chapter.manga.value!.isLocalArchive ?? false) == false)
                IconButton(
                    onPressed: () async {
                      final manga = chapter.manga.value!;
                      final source = getSource(manga.lang!, manga.source!)!;
                      String url = chapter.url!.startsWith('/')
                          ? "${source.baseUrl}/${chapter.url!}"
                          : chapter.url!;
                      Map<String, dynamic> data = {
                        'url': url,
                        'sourceId': source.id.toString(),
                        'title': chapter.name!
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
                    icon: const Icon(Icons.public)),
            ],
            backgroundColor: _backgroundColor(context),
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
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
    }
  }

  Widget _gestureRightLeft() {
    return Consumer(
      builder: (context, ref, child) {
        return Row(
          children: [
            /// left region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _isViewFunction();
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
                  _isViewFunction();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _gestureTopBottom() {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          children: [
            /// top region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _isViewFunction();
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
                  _isViewFunction();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class UChapDataPreload {
  Chapter? chapter;
  Directory? directory;
  PageUrl? pageUrl;
  bool? isLocale;
  Uint8List? archiveImage;
  int? index;
  GetChapterPagesModel? chapterUrlModel;
  int? pageIndex;
  Uint8List? cropImage;
  UChapDataPreload(this.chapter, this.directory, this.pageUrl, this.isLocale,
      this.archiveImage, this.index, this.chapterUrlModel, this.pageIndex,
      {this.cropImage});
}

class CustomPopupMenuButton<T> extends StatelessWidget {
  final String label;
  final String title;
  final ValueChanged<T> onSelected;
  final T value;
  final List<T> list;
  final String Function(T) itemText;
  const CustomPopupMenuButton(
      {super.key,
      required this.label,
      required this.title,
      required this.onSelected,
      required this.value,
      required this.list,
      required this.itemText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: PopupMenuButton(
        popUpAnimationStyle: popupAnimationStyle,
        tooltip: "",
        offset: Offset.fromDirection(1),
        color: Colors.black,
        onSelected: onSelected,
        itemBuilder: (context) => [
          for (var d in list)
            PopupMenuItem(
                value: d,
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: d == value ? Colors.white : Colors.transparent,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      itemText(d),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                )),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withValues(alpha: 0.9)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                children: [
                  Text(title),
                  const SizedBox(width: 20),
                  const Icon(Icons.keyboard_arrow_down_outlined)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
