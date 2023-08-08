import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/sources/utils/utils.dart';
import 'package:mangayomi/modules/manga/reader/providers/push_router.dart';
import 'package:mangayomi/services/get_chapter_url.dart';
import 'package:mangayomi/utils/image_detail_info.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/manga/reader/image_view_center.dart';
import 'package:mangayomi/modules/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/modules/manga/reader/providers/reader_controller_provider.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/modules/widgets/progress_center.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

typedef DoubleClickAnimationListener = void Function();

class MangaReaderView extends ConsumerWidget {
  final Chapter chapter;
  const MangaReaderView({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    final chapterData = ref.watch(getChapterUrlProvider(
      chapter: chapter,
    ));

    return chapterData.when(
      data: (data) {
        if (data.pageUrls.isEmpty &&
            (chapter.manga.value!.isLocalArchive ?? false) == false) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text(''),
              leading: BackButton(
                onPressed: () {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                      overlays: SystemUiOverlay.values);
                  Navigator.pop(context);
                },
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                Navigator.pop(context);
                return false;
              },
              child: const Center(
                child: Text("Error"),
              ),
            ),
          );
        }
        return MangaChapterPageGallery(
          chapter: chapter,
          chapterUrlModel: data,
        );
      },
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(''),
          leading: BackButton(
            onPressed: () {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              Navigator.pop(context);
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            Navigator.pop(context);
            return false;
          },
          child: Center(
            child: Text(error.toString()),
          ),
        ),
      ),
      loading: () {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(''),
            leading: BackButton(
              onPressed: () {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
                Navigator.pop(context);
              },
            ),
          ),
          body: WillPopScope(
            onWillPop: () async {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: SystemUiOverlay.values);
              Navigator.pop(context);
              return false;
            },
            child: const ProgressCenter(),
          ),
        );
      },
    );
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery({
    super.key,
    required this.chapter,
    required this.chapterUrlModel,
  });
  final GetChapterUrlModel chapterUrlModel;

  final Chapter chapter;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState
    extends ConsumerState<MangaChapterPageGallery>
    with TickerProviderStateMixin {
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;
  late ReaderController _readerController = ReaderController(chapter: chapter);

  @override
  void dispose() {
    _readerController.setMangaHistoryUpdate();
    _readerController
        .setPageIndex(_uChapDataPreload[_currentIndex ?? 0].index!);
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  late GetChapterUrlModel _chapterUrlModel = widget.chapterUrlModel;

  late Chapter chapter = widget.chapter;

  final List<UChapDataPreload> _uChapDataPreload = [];
  bool animatePageTransitions =
      isar.settings.getSync(227)!.animatePageTransitions!;
  Duration? _doubleTapAnimationDuration() {
    int doubleTapAnimationValue =
        isar.settings.getSync(227)!.doubleTapAnimationSpeed!;
    if (doubleTapAnimationValue == 0) {
      return const Duration(milliseconds: 10);
    } else if (doubleTapAnimationValue == 1) {
      return const Duration(milliseconds: 800);
    }
    return const Duration(milliseconds: 200);
  }

  late int? _currentIndex = _readerController.getPageIndex();

  late ListObserverController _observerController;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _observerController = ListObserverController(
      controller: _scrollController,
    );

    _doubleClickAnimationController = AnimationController(
        duration: _doubleTapAnimationDuration(), vsync: this);

    _scaleAnimationController = AnimationController(
        duration: _doubleTapAnimationDuration(), vsync: this);
    _animation = Tween(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController));
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _initCurrentIndex();

    super.initState();
  }

  _preloadNextChapter(GetChapterUrlModel chapterData, Chapter chap) {
    try {
      int length = 0;
      bool isExist = false;
      List<UChapDataPreload> uChapDataPreloadP = [];
      List<UChapDataPreload> uChapDataPreloadL = _uChapDataPreload;
      List<UChapDataPreload> preChap = [];
      for (var data in _uChapDataPreload) {
        if (chapterData.uChapDataPreload.first.chapter!.url ==
            data.chapter!.url) {
          isExist = true;
        }
      }
      if (!isExist) {
        for (var data in chapterData.uChapDataPreload) {
          preChap.add(data);
        }
      }

      if (preChap.isNotEmpty) {
        length = _uChapDataPreload.length;
        for (var i = 0; i < preChap.length; i++) {
          int index = i + length;
          final dataPreload = preChap[i];
          uChapDataPreloadP.add(dataPreload..index = index);
        }
        if (mounted) {
          uChapDataPreloadL.addAll(uChapDataPreloadP);
        }
      }
    } catch (_) {}
  }

  late bool _isBookmarked = _readerController.getChapterBookmarked();
  _initCurrentIndex() async {
    _uChapDataPreload.addAll(_chapterUrlModel.uChapDataPreload);
    _readerController.setMangaHistoryUpdate();
    await Future.delayed(const Duration(milliseconds: 1));
    _selectedValue = _readerController.getReaderMode();
    _setReaderMode(_selectedValue!, true);
    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(
          _uChapDataPreload[_currentIndex ?? 0].index!,
        );
  }

  void _onPageChanged(int index) {
    _currentIndex = index;
    if (_chapterId != _uChapDataPreload[_currentIndex ?? 0].chapter!.id) {
      if (mounted) {
        setState(() {
          _chapterUrlModel =
              _uChapDataPreload[_currentIndex ?? 0].chapterUrlModel!;
          _chapterId = _uChapDataPreload[_currentIndex ?? 0].chapter!.id;
        });
      }
    }

    ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(
          _uChapDataPreload[index].index!,
        );
    if (_uChapDataPreload[index].index! ==
        _readerController.getPageLength([]) - 1) {
      try {
        bool hasNextChapter = _readerController.getChapterIndex() != 0;
        final chapter =
            hasNextChapter ? _readerController.getNextChapter() : null;
        if (chapter != null) {
          ref
              .watch(getChapterUrlProvider(
            chapter: chapter,
          ).future)
              .then((value) {
            _preloadNextChapter(value, chapter);
          });
        }
      } catch (_) {}
    }
  }

  final double _imageDetailY = 0;

  void _onBtnTapped(int index, bool isPrev, {bool isSlide = false}) {
    if (isPrev) {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (index != -1) {
          if (isSlide) {
            _observerController.jumpTo(
              index: index,
            );
          } else {
            animatePageTransitions
                ? _observerController.animateTo(
                    curve: Curves.ease,
                    index: index,
                    duration: const Duration(milliseconds: 150))
                : _observerController.jumpTo(
                    index: index,
                  );
          }
        }
      } else {
        if (index != -1) {
          setState(() {
            _isZoom = false;
          });
          if (_extendedController.hasClients) {
            if (isSlide) {
              _extendedController.jumpToPage(index);
            } else {
              animatePageTransitions
                  ? _extendedController.animateToPage(index,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.ease)
                  : _extendedController.jumpToPage(index);
            }
          }
        }
      }
    } else {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (isSlide) {
          _observerController.jumpTo(
            index: index,
          );
        } else {
          animatePageTransitions
              ? _observerController.animateTo(
                  curve: Curves.ease,
                  index: index,
                  duration: const Duration(milliseconds: 150))
              : _observerController.jumpTo(
                  index: index,
                );
        }
      } else {
        if (_extendedController.hasClients) {
          setState(() {
            _isZoom = false;
          });
          if (isSlide) {
            _observerController.jumpTo(
              index: index,
            );
          } else {
            animatePageTransitions
                ? _extendedController.animateToPage(index,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.ease)
                : _extendedController.jumpToPage(index);
          }
        }
      }
    }
  }

  final List<Uint8List?> _cropImagesList = [];
  bool isOk = false;
  // _cropImage() async {
  //   if (!isOk) {
  //     isOk = true;
  //     _cropImagesList = await ref.watch(autoCropBorderProvider(
  //             archiveImages: _chapterUrlModel.archiveImages,
  //             isLocaleList: _chapterUrlModel.isLocaleList,
  //             path: _chapterUrlModel.path!,
  //             url: _chapterUrlModel.pageUrls)
  //         .future);
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }

  ReaderMode? _selectedValue;
  bool _isView = false;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();

  void _onScaleEnd(BuildContext context, ScaleEndDetails details,
      PhotoViewControllerValue controllerValue) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  late final _extendedController = ExtendedPageController(
    initialPage: _currentIndex ?? 0,
    shouldIgnorePointerWhenScrolling: false,
  );

  double get pixelRatio => View.of(context).devicePixelRatio;

  Size get size => View.of(context).physicalSize / pixelRatio;
  Alignment _computeAlignmentByTapOffset(Offset offset) {
    return Alignment((offset.dx - size.width / 2) / (size.width / 2),
        (offset.dy - size.height / 2) / (size.height / 2));
  }

  void _toggleScale(Offset tapPosition) {
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

  Axis _scrollDirection = Axis.vertical;
  bool _isReversHorizontal = false;

  late bool _showPagesNumber = _readerController.getShowPageNumber();
  _setReaderMode(ReaderMode value, bool isInit) async {
    _readerController.setReaderMode(value);
    if (value == ReaderMode.vertical) {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _scrollDirection = Axis.vertical;
          _isReversHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(_currentIndex!);
      }
    } else if (value == ReaderMode.ltr || value == ReaderMode.rtl) {
      if (mounted) {
        setState(() {
          if (value == ReaderMode.rtl) {
            _isReversHorizontal = true;
          } else {
            _isReversHorizontal = false;
          }
          _selectedValue = value;
          _scrollDirection = Axis.horizontal;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(_currentIndex!);
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _isReversHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));
        _observerController.animateTo(
            index: _currentIndex!,
            duration: const Duration(milliseconds: 1),
            curve: Curves.ease);
      }
    }
  }

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9);

  Widget _showMore() {
    bool hasPrevChapter = _readerController.getChapterIndex() + 1 !=
        _readerController.getChaptersLength();
    bool hasNextChapter = _readerController.getChapterIndex() != 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AnimatedContainer(
          height: _isView ? Platform.isIOS?120:80 : 0,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 200),
          child: PreferredSize(
            preferredSize: Size.fromHeight(_isView ?Platform.isIOS?120: 80 : 0),
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
                  width: mediaWidth(context, 0.8),
                  child: Text(
                    '${_readerController.getMangaName()} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: SizedBox(
                  width: mediaWidth(context, 0.8),
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
                      onPressed: () {
                        final manga = chapter.manga.value!;
                        final source = getSource(manga.lang!, manga.source!);
                        String url = source.apiUrl!.isEmpty
                            ? chapter.url!
                            : "${source.baseUrl}/${chapter.url!}";
                        Map<String, String> data = {
                          'url': url,
                          'sourceId': source.id.toString(),
                          'title': chapter.name!
                        };
                        context.push("/mangawebview", extra: data);
                      },
                      icon: const Icon(Icons.public)),
              ],
              backgroundColor: _backgroundColor(context),
            ),
          ),
        ),
        AnimatedContainer(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          width: mediaWidth(context, 1),
          height: _isView ? 130 : 0,
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 23,
                        backgroundColor: _backgroundColor(context),
                        child: IconButton(
                            onPressed: hasPrevChapter
                                ? () {
                                    pushReplacementMangaReaderView(
                                        context: context,
                                        chapter:
                                            _readerController.getPrevChapter());
                                  }
                                : null,
                            icon: Transform.scale(
                              scaleX: 1,
                              child: Icon(Icons.skip_previous_rounded,
                                  color: hasPrevChapter
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(0.4)),
                            )),
                      ),
                    ),
                    Expanded(
                      child: Transform.scale(
                        scaleX: !_isReversHorizontal ? 1 : -1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                                color: _backgroundColor(context),
                                borderRadius: BorderRadius.circular(25)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Transform.scale(
                                    scaleX: !_isReversHorizontal ? 1 : -1,
                                    child: SizedBox(
                                      width: 30,
                                      child: Consumer(
                                          builder: (context, ref, child) {
                                        final currentIndex = ref.watch(
                                            currentIndexProvider(chapter));
                                        return Text(
                                          "${currentIndex + 1} ",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                if (_isView)
                                  Flexible(
                                    child: Consumer(
                                        builder: (context, ref, child) {
                                      final currentIndex = ref
                                          .watch(currentIndexProvider(chapter));
                                      return Slider(
                                        onChanged: (value) {
                                          ref
                                              .read(
                                                  currentIndexProvider(chapter)
                                                      .notifier)
                                              .setCurrentIndex(value.toInt());
                                        },
                                        onChangeEnd: (newValue) {
                                          try {
                                            final index = _uChapDataPreload
                                                .where((element) =>
                                                    element.chapter ==
                                                        chapter &&
                                                    element.index ==
                                                        newValue.toInt())
                                                .toList()
                                                .first
                                                .pageIndex;

                                            _onBtnTapped(
                                              index!,
                                              true,
                                              isSlide: true,
                                            );
                                          } catch (_) {}
                                        },
                                        divisions:
                                            _readerController.getPageLength(
                                                    _chapterUrlModel.pageUrls) -
                                                1,
                                        value: min(
                                            currentIndex.toDouble(),
                                            _readerController
                                                .getPageLength(
                                                    _chapterUrlModel.pageUrls)
                                                .toDouble()),
                                        label: '${currentIndex + 1}',
                                        min: 0,
                                        max: (_readerController.getPageLength(
                                                    _chapterUrlModel.pageUrls) -
                                                1)
                                            .toDouble(),
                                      );
                                    }),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Transform.scale(
                                    scaleX: !_isReversHorizontal ? 1 : -1,
                                    child: SizedBox(
                                      width: 30,
                                      child: Text(
                                        "${_readerController.getPageLength(_chapterUrlModel.pageUrls)}",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 23,
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
                                  ? Theme.of(context).textTheme.bodyLarge!.color
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color!
                                      .withOpacity(0.4),
                              // size: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  height: 65,
                  color: _backgroundColor(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PopupMenuButton(
                        color: Colors.black,
                        child: const Icon(
                          Icons.app_settings_alt_outlined,
                        ),
                        onSelected: (value) {
                          if (mounted) {
                            setState(() {
                              _selectedValue = value;
                            });
                          }
                          _setReaderMode(value, false);
                        },
                        itemBuilder: (context) => [
                          for (var readerMode in ReaderMode.values)
                            PopupMenuItem(
                                value: readerMode,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: _selectedValue == readerMode
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      getReaderModeName(readerMode, context),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )),
                        ],
                      ),
                      Consumer(builder: (context, ref, child) {
                        final cropBorders = ref.watch(cropBordersStateProvider);
                        return IconButton(
                          onPressed: () {
                            // _cropImage();
                            ref
                                .read(cropBordersStateProvider.notifier)
                                .set(!cropBorders);
                          },
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.crop_rounded,
                              ),
                              if (cropBorders)
                                Positioned(
                                  right: 8,
                                  child: Transform.scale(
                                    scaleX: 2.5,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\\',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                      IconButton(
                        onPressed: () {
                          _showModalSettings();
                        },
                        icon: const Icon(
                          Icons.settings_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _showPage() {
    return _isView
        ? Container()
        : _showPagesNumber
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Consumer(builder: (context, ref, child) {
                  final currentIndex = ref.watch(currentIndexProvider(chapter));
                  return Text(
                    '${currentIndex + 1} / ${_readerController.getPageLength(_chapterUrlModel.pageUrls)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      shadows: <Shadow>[
                        Shadow(offset: Offset(0.0, 0.0), blurRadius: 7.0)
                      ],
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              )
            : Container();
  }

  _isViewFunction() {
    if (mounted) {
      setState(() {
        _isView = !_isView;
      });
    }
    if (_isView) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
          overlays: []);
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
                  if (_isReversHorizontal) {
                    _onBtnTapped(_currentIndex! + 1, false);
                  } else {
                    _onBtnTapped(_currentIndex! - 1, true);
                  }
                },
                onDoubleTapDown: _isVerticalContinous()
                    ? (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      }
                    : null,
                onDoubleTap: _isVerticalContinous() ? () {} : null,
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
                onDoubleTapDown: _isVerticalContinous()
                    ? (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      }
                    : null,
                onDoubleTap: _isVerticalContinous() ? () {} : null,
              ),
            ),

            /// right region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_isReversHorizontal) {
                    _onBtnTapped(_currentIndex! - 1, true);
                  } else {
                    _onBtnTapped(_currentIndex! + 1, false);
                  }
                },
                onDoubleTapDown: _isVerticalContinous()
                    ? (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      }
                    : null,
                onDoubleTap: _isVerticalContinous() ? () {} : null,
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
                  _onBtnTapped(_currentIndex! - 1, true);
                },
                onDoubleTapDown: _isVerticalContinous()
                    ? (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      }
                    : null,
                onDoubleTap: _isVerticalContinous() ? () {} : null,
              ),
            ),

            /// center region
            Expanded(flex: 5, child: Container()),

            /// bottom region
            Expanded(
              flex: 2,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _onBtnTapped(_currentIndex! + 1, false);
                },
                onDoubleTapDown: _isVerticalContinous()
                    ? (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      }
                    : null,
                onDoubleTap: _isVerticalContinous() ? () {} : null,
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isZoom = false;
  bool _isVerticalContinous() {
    return _selectedValue == ReaderMode.verticalContinuous ||
        _selectedValue == ReaderMode.webtoon;
  }

  late int? _chapterId = widget.chapter.id;
  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  final Map<int, ImageDetailInfo> detailKeys = <int, ImageDetailInfo>{};
  late AnimationController _doubleClickAnimationController;

  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  @override
  Widget build(BuildContext context) {
    final cropBorders = ref.watch(cropBordersStateProvider);

    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        Navigator.pop(context);

        return false;
      },
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            _readerController.setMangaHistoryUpdate();
            _readerController
                .setPageIndex(_uChapDataPreload[_currentIndex ?? 0].index!);
          }
          return true;
        },
        child: StreamBuilder(
            stream:
                isar.chapters.watchObject(_chapterId!, fireImmediately: true),
            builder: (context, snapshot) {
              final chapterData = snapshot.hasData && snapshot.data != null
                  ? snapshot.data
                  : chapter;
              if (chapterData != null) {
                _readerController = ReaderController(chapter: chapterData);
                _isBookmarked = chapterData.isBookmarked!;
              }
              return Stack(
                children: [
                  _isVerticalContinous()
                      ? PhotoViewGallery.builder(
                          itemCount: 1,
                          builder: (_, __) =>
                              PhotoViewGalleryPageOptions.customChild(
                            controller: _photoViewController,
                            scaleStateController:
                                _photoViewScaleStateController,
                            basePosition: _scalePosition,
                            onScaleEnd: _onScaleEnd,
                            child: ListViewObserver(
                              controller: _observerController,
                              onObserve: (result) {
                                _currentIndex = result.firstChild?.index ?? 0;

                                if (_chapterId !=
                                    _uChapDataPreload[_currentIndex ?? 0]
                                        .chapter!
                                        .id) {
                                  if (mounted) {
                                    setState(() {
                                      _chapterUrlModel =
                                          _uChapDataPreload[_currentIndex ?? 0]
                                              .chapterUrlModel!;
                                      _chapterId =
                                          _uChapDataPreload[_currentIndex ?? 0]
                                              .chapter!
                                              .id;
                                    });
                                  }
                                }
                                ref
                                    .read(
                                        currentIndexProvider(chapter).notifier)
                                    .setCurrentIndex(
                                      _uChapDataPreload[_currentIndex ?? 0]
                                          .index!,
                                    );
                              },
                              child: ListView.separated(
                                cacheExtent: 15 * mediaHeight(context, 1),
                                itemCount: _uChapDataPreload.length,
                                controller: _scrollController,
                                itemBuilder: (context, index) {
                                  _scrollController.addListener(() {
                                    if (_scrollController.position.pixels ==
                                        _scrollController
                                            .position.maxScrollExtent) {
                                      try {
                                        bool hasNextChapter = _readerController
                                                .getChapterIndex() !=
                                            0;
                                        final chapter = hasNextChapter
                                            ? _readerController.getNextChapter()
                                            : null;
                                        if (chapter != null) {
                                          ref
                                              .watch(getChapterUrlProvider(
                                            chapter: chapter,
                                          ).future)
                                              .then((value) {
                                            _preloadNextChapter(value, chapter);
                                          });
                                        }
                                      } catch (_) {}
                                    }
                                  });

                                  return GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onDoubleTapDown: (TapDownDetails details) {
                                      _toggleScale(details.globalPosition);
                                    },
                                    onDoubleTap: () {},
                                    child: ImageViewVertical(
                                      archiveImage:
                                          _cropImagesList.isNotEmpty &&
                                                  cropBorders == true
                                              ? _cropImagesList[index]
                                              : _uChapDataPreload[index]
                                                  .archiveImage,
                                      titleManga:
                                          _readerController.getMangaName(),
                                      source: _readerController.getSourceName(),
                                      index: _uChapDataPreload[index].index!,
                                      url: _uChapDataPreload[index].url!,
                                      path: _uChapDataPreload[index].path!,
                                      chapter:
                                          _readerController.getChapterTitle(),
                                      length: _readerController.getPageLength(
                                          _chapterUrlModel.pageUrls),
                                      isLocale: _cropImagesList.isNotEmpty &&
                                              cropBorders == true
                                          ? true
                                          : _uChapDataPreload[index].isLocale!,
                                      lang: _uChapDataPreload[index]
                                          .chapter!
                                          .manga
                                          .value!
                                          .lang!,
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) => Divider(
                                    color: Colors.black,
                                    height: _selectedValue == ReaderMode.webtoon
                                        ? 0
                                        : 6),
                              ),
                            ),
                          ),
                        )
                      : Material(
                          color: Colors.black,
                          shadowColor: Colors.black,
                          child: ExtendedImageGesturePageView.builder(
                              controller: _extendedController,
                              scrollDirection: _scrollDirection,
                              reverse: _isReversHorizontal,
                              physics: const ClampingScrollPhysics(),
                              preloadPagesCount: _isZoom ? 0 : 6,
                              canScrollPage: (GestureDetails? gestureDetails) {
                                return gestureDetails != null
                                    ? !(gestureDetails.totalScale! > 1.0)
                                    : true;
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return ImageViewCenter(
                                  archiveImage: _cropImagesList.isNotEmpty &&
                                          cropBorders == true
                                      ? _cropImagesList[index]
                                      : _uChapDataPreload[index].archiveImage,
                                  titleManga: _readerController.getMangaName(),
                                  source: _readerController.getSourceName(),
                                  index: _uChapDataPreload[index].index!,
                                  url: _uChapDataPreload[index].url!,
                                  path: _uChapDataPreload[index].path!,
                                  chapter: _readerController.getChapterTitle(),
                                  length: _readerController
                                      .getPageLength(_chapterUrlModel.pageUrls),
                                  loadStateChanged: (ExtendedImageState state) {
                                    if (state.extendedImageLoadState ==
                                        LoadState.loading) {
                                      final ImageChunkEvent? loadingProgress =
                                          state.loadingProgress;
                                      final double progress =
                                          loadingProgress?.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress!
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : 0;
                                      return Container(
                                        color: Colors.black,
                                        height: mediaHeight(context, 0.8),
                                        child:
                                            CircularProgressIndicatorAnimateRotate(
                                                progress: progress),
                                      );
                                    }
                                    if (state.extendedImageLoadState ==
                                        LoadState.completed) {
                                      return StreamBuilder<double>(
                                        builder: (BuildContext context,
                                            AsyncSnapshot<double> data) {
                                          return ExtendedImageGesture(
                                            state,
                                            canScaleImage: (_) =>
                                                _imageDetailY == 0,
                                            imageBuilder: (Widget image) {
                                              return Stack(
                                                children: <Widget>[
                                                  Positioned.fill(
                                                    top: _imageDetailY,
                                                    bottom: -_imageDetailY,
                                                    child: image,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        initialData: _imageDetailY,
                                        stream: _rebuildDetail.stream,
                                      );
                                    }
                                    if (state.extendedImageLoadState ==
                                        LoadState.failed) {
                                      return Container(
                                          color: Colors.black,
                                          height: mediaHeight(context, 0.8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    state.reLoadImage();
                                                  },
                                                  child: const Icon(
                                                    Icons.replay_outlined,
                                                    size: 30,
                                                  )),
                                            ],
                                          ));
                                    }
                                    return Container();
                                  },
                                  initGestureConfigHandler:
                                      (ExtendedImageState state) {
                                    double? initialScale = 1.0;
                                    final size = MediaQuery.of(context).size;
                                    if (state.extendedImageInfo != null) {
                                      initialScale = initScale(
                                          size: size,
                                          initialScale: initialScale,
                                          imageSize: Size(
                                              state.extendedImageInfo!.image
                                                  .width
                                                  .toDouble(),
                                              state.extendedImageInfo!.image
                                                  .height
                                                  .toDouble()));
                                    }
                                    return GestureConfig(
                                      inertialSpeed: 200,
                                      inPageView: true,
                                      initialScale: initialScale!,
                                      maxScale: 8,
                                      animationMaxScale: 8,
                                      initialAlignment: InitialAlignment.center,
                                      cacheGesture: true,
                                      hitTestBehavior:
                                          HitTestBehavior.translucent,
                                    );
                                  },
                                  onDoubleTap:
                                      (ExtendedImageGestureState state) {
                                    final Offset? pointerDownPosition =
                                        state.pointerDownPosition;
                                    final double? begin =
                                        state.gestureDetails!.totalScale;
                                    double end;

                                    //remove old
                                    _doubleClickAnimation?.removeListener(
                                        _doubleClickAnimationListener);

                                    //stop pre
                                    _doubleClickAnimationController.stop();

                                    //reset to use
                                    _doubleClickAnimationController.reset();

                                    if (begin == doubleTapScales[0]) {
                                      setState(() {
                                        _isZoom = true;
                                      });
                                      end = doubleTapScales[1];
                                    } else {
                                      setState(() {
                                        _isZoom = false;
                                      });
                                      end = doubleTapScales[0];
                                    }

                                    _doubleClickAnimationListener = () {
                                      state.handleDoubleTap(
                                          scale: _doubleClickAnimation!.value,
                                          doubleTapPosition:
                                              pointerDownPosition);
                                    };

                                    _doubleClickAnimation = Tween(
                                            begin: begin, end: end)
                                        .animate(CurvedAnimation(
                                            curve: Curves.ease,
                                            parent:
                                                _doubleClickAnimationController));

                                    _doubleClickAnimation!.addListener(
                                        _doubleClickAnimationListener);

                                    _doubleClickAnimationController.forward();
                                  },
                                  isLocale: _cropImagesList.isNotEmpty &&
                                          cropBorders == true
                                      ? true
                                      : _uChapDataPreload[index].isLocale!,
                                  lang: _uChapDataPreload[index]
                                      .chapter!
                                      .manga
                                      .value!
                                      .lang!,
                                );
                              },
                              itemCount: _uChapDataPreload.length,
                              onPageChanged: _onPageChanged)),
                  _gestureRightLeft(),
                  _gestureTopBottom(),
                  _showMore(),
                  _showPage(),
                ],
              );
            }),
      ),
    );
  }

  _showModalSettings() {
    DraggableMenu.open(
        context,
        DraggableMenu(
            ui: ClassicDraggableMenu(barItem: Container()),
            levels: [
              DraggableMenuLevel.ratio(ratio: 0.4),
            ],
            fastDrag: false,
            minimizeBeforeFastDrag: false,
            child: StatefulBuilder(
              builder: (context, setState) {
                final l10n = l10nLocalizations(context)!;
                return Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          l10n.settings,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SwitchListTile(
                              dense: true,
                              title: Text(l10n.show_page_number),
                              value: _showPagesNumber,
                              onChanged: (value) {
                                setState(() {
                                  _showPagesNumber = value;
                                });
                                _readerController.setShowPageNumber(value);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )));
  }
}

class UChapDataPreload {
  Chapter? chapter;
  Directory? path;
  String? url;
  bool? isLocale;
  Uint8List? archiveImage;
  int? index;
  GetChapterUrlModel? chapterUrlModel;
  int? pageIndex;
  UChapDataPreload(
    this.chapter,
    this.path,
    this.url,
    this.isLocale,
    this.archiveImage,
    this.index,
    this.chapterUrlModel,
    this.pageIndex,
  );
}
