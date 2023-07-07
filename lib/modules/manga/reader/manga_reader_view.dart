import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/chapter_interval_page_view.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
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

  late int _currentIndex = _readerController.getPageIndex();

  T? ambiguate<T>(T? value) => value;

  BuildContext? _listViewContext;
  late ListObserverController _observerController;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _observerController = ListObserverController(
      controller: _scrollController,
    );

    ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((timeStamp) {
      ListViewOnceObserveNotification().dispatch(_listViewContext);
    });

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

  _preloadNextChapter(
    GetChapterUrlModel chapterData,
    Chapter chapter,
  ) {
    bool isExist = false;
    List<UChapDataPreload> preChap = [];
    for (var ee in _uChapDataPreload) {
      if (chapterData.uChapDataPreload.first.chapter!.name ==
          ee.chapter!.name) {
        isExist = true;
      }
    }
    if (!isExist) {
      for (var aa in chapterData.uChapDataPreload) {
        preChap.add(aa);
      }
    }

    if (preChap.isNotEmpty) {
      preChap.add(UChapDataPreload(
          chapter, null, null, null, null, null, true, false, null));
      _uChapDataPreload.addAll(preChap);
    }
    setState(() {});
  }

  _preloadPrevChapter(GetChapterUrlModel chapterData, Chapter chapter) {
    // bool isExist = false;
    // List<UChapDataPreload> preChap = [];
    // for (var ee in uChapDataPreload) {
    //   if (chapterData.uChapDataPreload.first.chapter!.name == ee.chapter!.name) {
    //     isExist = true;
    //   }
    // }
    // if (!isExist) {
    //   for (var aa in chapterData.uChapDataPreload) {
    //     preChap.add(aa);
    //   }
    // }
    // if (preChap.isNotEmpty) {
    //   preChap.add(UChapDataPreload(chapter, null, null, null, null, null, false, true));
    //   uChapDataPreload.insertAll(0, preChap);
    //   _currentIndex = _currentIndex + preChap.length - 1;
    // }
    // print({"leng${preChap.length}"});
    // _currentIndex = chapterData.pageUrls.length - 1 + _currentIndex;
    // print(_currentIndex);
    // _chapterUrlModel = chapterData;
    // _readerController = ReaderController(chapter: chapter);
    // setState(() {});
  }

  late bool _isBookmarked = _readerController.getChapterBookmarked();
  _initCurrentIndex() async {
    _uChapDataPreload.addAll(_chapterUrlModel.uChapDataPreload);
    _uChapDataPreload.add(UChapDataPreload(
        chapter, null, null, null, null, null, true, false, null));
    _readerController.setMangaHistoryUpdate();
    await Future.delayed(const Duration(milliseconds: 1));
    _selectedValue = _readerController.getReaderMode();
    _setReaderMode(_selectedValue!, true);
  }

  void _onPageChanged(int index) {
    if (!(_uChapDataPreload[index].hasNextPrePage ||
        _uChapDataPreload[index].hasPrevPrePage)) {
      _readerController =
          ReaderController(chapter: _uChapDataPreload[index].chapter!);
      _chapterUrlModel = _uChapDataPreload[_posIndex ?? 0].chapterUrlModel!;
      _readerController.setMangaHistoryUpdate();
      _readerController.setPageIndex(_currentIndex + 1);
      _readerController.setChapterPageLastRead(_currentIndex + 1);
      _isBookmarked = _readerController.getChapterBookmarked();
      _posIndex = index;
      _currentIndex = _uChapDataPreload[index].index!;

      ref.read(currentIndexProvider(chapter).notifier).setCurrentIndex(
            _currentIndex,
          );

      setState(() {});
    }
  }

  final double _imageDetailY = 0;

  void _onBtnTapped(int index, bool isPrev,
      {bool isSlide = false, int? slideAddValueIndex}) {
    if (_uChapDataPreload[_posIndex ?? 0].chapter!.name !=
        _uChapDataPreload.first.chapter!.name) {
      if (_uChapDataPreload[_posIndex ?? 0].index != null) {
        int plu = 0;
        if (isPrev && isSlide && slideAddValueIndex != null) {
          plu = slideAddValueIndex;
        } else if (isPrev) {
          plu = -1;
        } else {
          plu = 1;
        }
        index = _uChapDataPreload.indexWhere(
                (element) => element == _uChapDataPreload[_posIndex ?? 0]) +
            plu;
      }
    }
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
    initialPage: _currentIndex,
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
    final indexPos = _posIndex == null
        ? _currentIndex
        : isInit
            ? _currentIndex
            : _posIndex;
    _readerController.setReaderMode(value);
    if (value == ReaderMode.vertical) {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _scrollDirection = Axis.vertical;
          _isReversHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));

        _extendedController.jumpToPage(indexPos!);
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

        _extendedController.jumpToPage(indexPos!);
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _isReversHorizontal = false;
        });
        await Future.delayed(const Duration(milliseconds: 30));
        _observerController.animateTo(
            index: indexPos!,
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
          height: _isView ? 80 : 0,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 200),
          child: PreferredSize(
            preferredSize: Size.fromHeight(_isView ? 80 : 0),
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
                                Flexible(
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    final currentIndex = ref
                                        .watch(currentIndexProvider(chapter));
                                    return Slider(
                                      onChanged: (newValue) {
                                        if (_readerController.getPageLength(
                                                _chapterUrlModel.pageUrls) !=
                                            _currentIndex + 1) {
                                          int slideAddValueIndex = 0;
                                          if (newValue < _currentIndex) {
                                            slideAddValueIndex = -1;
                                          } else {
                                            slideAddValueIndex = 1;
                                          }
                                          _onBtnTapped(newValue.toInt(), true,
                                              isSlide: true,
                                              slideAddValueIndex:
                                                  slideAddValueIndex);
                                        }
                                      },
                                      divisions: max(
                                          _readerController.getPageLength(
                                                  _chapterUrlModel.pageUrls) -
                                              1,
                                          1),
                                      value: min(
                                          currentIndex.toDouble(),
                                          _readerController
                                              .getPageLength(
                                                  _chapterUrlModel.pageUrls)
                                              .toDouble()),
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
                                      getReaderModeName(readerMode),
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
                      fontSize: 12.0,
                      shadows: <Shadow>[
                        Shadow(offset: Offset(0.0, 0.0), blurRadius: 10.0)
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
                    _onBtnTapped(_currentIndex + 1, false);
                  } else {
                    _onBtnTapped(_currentIndex - 1, true);
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
                    _onBtnTapped(_currentIndex - 1, true);
                  } else {
                    _onBtnTapped(_currentIndex + 1, false);
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
                  _onBtnTapped(_currentIndex - 1, true);
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
                  _onBtnTapped(_currentIndex + 1, false);
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

  int? _posIndex;
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
      child: Stack(
        children: [
          _isVerticalContinous()
              ? PhotoViewGallery.builder(
                  itemCount: 1,
                  builder: (_, __) => PhotoViewGalleryPageOptions.customChild(
                    controller: _photoViewController,
                    scaleStateController: _photoViewScaleStateController,
                    basePosition: _scalePosition,
                    onScaleEnd: _onScaleEnd,
                    child: ListViewObserver(
                      controller: _observerController,
                      sliverListContexts: () {
                        return [
                          if (_listViewContext != null) _listViewContext!
                        ];
                      },
                      onObserveAll: (resultMap) {
                        final model = resultMap[_listViewContext];
                        if (model == null) return;
                        _posIndex = model.firstChild?.index ?? 0;
                        if (!(_uChapDataPreload[_posIndex ?? 0].hasNextPrePage ||
                            _uChapDataPreload[_posIndex ?? 0].hasPrevPrePage)) {
                          _readerController = ReaderController(
                              chapter:
                                  _uChapDataPreload[_posIndex ?? 0].chapter!);

                          _chapterUrlModel = _uChapDataPreload[_posIndex ?? 0]
                              .chapterUrlModel!;

                          _currentIndex =
                              _uChapDataPreload[_posIndex ?? 0].index!;

                          ref
                              .read(currentIndexProvider(chapter).notifier)
                              .setCurrentIndex(
                                _currentIndex,
                              );
                          _isBookmarked =
                              _readerController.getChapterBookmarked();
                          _readerController.setMangaHistoryUpdate();
                          _readerController.setPageIndex(_currentIndex);
                          _readerController
                              .setChapterPageLastRead(_currentIndex);
                          setState(() {});
                        }
                      },
                      child: ListView.separated(
                        cacheExtent: 5 * mediaHeight(context, 1),
                        itemCount: _uChapDataPreload.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (_listViewContext != context) {
                            _listViewContext = context;
                          }
                          _scrollController.addListener(() {
                            if (_scrollController.position.pixels ==
                                _scrollController.position.maxScrollExtent) {
                              if (_uChapDataPreload[index].hasNextPrePage ||
                                  _uChapDataPreload[index].hasPrevPrePage) {
                                bool hasPrevChapter =
                                    _readerController.getChapterIndex() + 1 !=
                                        _readerController.getChaptersLength();
                                bool hasNextChapter =
                                    _readerController.getChapterIndex() != 0;
                                final chapter = _uChapDataPreload[index]
                                            .hasNextPrePage &&
                                        hasNextChapter
                                    ? _readerController.getNextChapter()
                                    : _uChapDataPreload[index].hasPrevPrePage &&
                                            hasPrevChapter
                                        ? _readerController.getPrevChapter()
                                        : null;
                                if (chapter != null) {
                                  ref
                                      .watch(getChapterUrlProvider(
                                    chapter: chapter,
                                  ).future)
                                      .then((value) {
                                    if (_uChapDataPreload[index]
                                        .hasNextPrePage) {
                                      _preloadNextChapter(value, chapter);
                                    } else {
                                      _preloadPrevChapter(value, chapter);
                                    }
                                  });
                                }
                              }
                            }
                          });
                          if (_uChapDataPreload[index].hasNextPrePage ||
                              _uChapDataPreload[index].hasPrevPrePage) {
                            bool hasPrevChapter =
                                _readerController.getChapterIndex() + 1 !=
                                    _readerController.getChaptersLength();
                            bool hasNextChapter =
                                _readerController.getChapterIndex() != 0;
                            final chapter =
                                _uChapDataPreload[index].hasNextPrePage &&
                                        hasNextChapter
                                    ? _readerController.getNextChapter()
                                    : _uChapDataPreload[index].hasPrevPrePage &&
                                            hasPrevChapter
                                        ? _readerController.getPrevChapter()
                                        : null;
                            if (chapter == null) {
                              return ChapterIntervalPageView(
                                uChapDataPreload: _uChapDataPreload[index],
                                onTap: () async {},
                                hasNextChapter: hasNextChapter,
                                hasPrevChapter: hasPrevChapter,
                              );
                            }

                            return ChapterIntervalPageView(
                              uChapDataPreload: _uChapDataPreload[index],
                              onTap: () async {},
                              hasNextChapter: hasNextChapter,
                              hasPrevChapter: hasPrevChapter,
                            );
                          }
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onDoubleTapDown: (TapDownDetails details) {
                              _toggleScale(details.globalPosition);
                            },
                            onDoubleTap: () {},
                            child: ImageViewVertical(
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
                            height:
                                _selectedValue == ReaderMode.webtoon ? 0 : 6),
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
                        if (_uChapDataPreload[index].hasNextPrePage ||
                            _uChapDataPreload[index].hasPrevPrePage) {
                          bool hasPrevChapter =
                              _readerController.getChapterIndex() + 1 !=
                                  _readerController.getChaptersLength();
                          bool hasNextChapter =
                              _readerController.getChapterIndex() != 0;
                          final chapter =
                              _uChapDataPreload[index].hasNextPrePage &&
                                      hasNextChapter
                                  ? _readerController.getNextChapter()
                                  : _uChapDataPreload[index].hasPrevPrePage &&
                                          hasPrevChapter
                                      ? _readerController.getPrevChapter()
                                      : null;
                          if (chapter == null) {
                            return ChapterIntervalPageView(
                              uChapDataPreload: _uChapDataPreload[index],
                              onTap: () async {},
                              hasNextChapter: hasNextChapter,
                              hasPrevChapter: hasPrevChapter,
                            );
                          }

                          return ChapterIntervalPageView(
                            uChapDataPreload: _uChapDataPreload[index],
                            onTap: () async {},
                            hasNextChapter: hasNextChapter,
                            hasPrevChapter: hasPrevChapter,
                          );
                        }
                        return ImageViewCenter(
                          archiveImage:
                              _cropImagesList.isNotEmpty && cropBorders == true
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
                                  loadingProgress?.expectedTotalBytes != null
                                      ? loadingProgress!.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : 0;
                              return Container(
                                color: Colors.black,
                                height: mediaHeight(context, 0.8),
                                child: CircularProgressIndicatorAnimateRotate(
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
                                    canScaleImage: (_) => _imageDetailY == 0,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          initGestureConfigHandler: (ExtendedImageState state) {
                            double? initialScale = 1.0;
                            final size = MediaQuery.of(context).size;
                            if (state.extendedImageInfo != null) {
                              initialScale = initScale(
                                  size: size,
                                  initialScale: initialScale,
                                  imageSize: Size(
                                      state.extendedImageInfo!.image.width
                                          .toDouble(),
                                      state.extendedImageInfo!.image.height
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
                              hitTestBehavior: HitTestBehavior.translucent,
                            );
                          },
                          onDoubleTap: (ExtendedImageGestureState state) {
                            final Offset? pointerDownPosition =
                                state.pointerDownPosition;
                            final double? begin =
                                state.gestureDetails!.totalScale;
                            double end;

                            //remove old
                            _doubleClickAnimation
                                ?.removeListener(_doubleClickAnimationListener);

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
                                  doubleTapPosition: pointerDownPosition);
                            };

                            _doubleClickAnimation = Tween(
                                    begin: begin, end: end)
                                .animate(CurvedAnimation(
                                    curve: Curves.ease,
                                    parent: _doubleClickAnimationController));

                            _doubleClickAnimation!
                                .addListener(_doubleClickAnimationListener);

                            _doubleClickAnimationController.forward();
                          },
                          isLocale:
                              _cropImagesList.isNotEmpty && cropBorders == true
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
      ),
    );
  }

  _showModalSettings() {
    DraggableMenu.open(
        context,
        DraggableMenu(
            ui: ClassicDraggableMenu(barItem: Container()),
            expandable: false,
            maxHeight: mediaHeight(context, 0.4),
            fastDrag: false,
            minimizeBeforeFastDrag: false,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Settings',
                          style: TextStyle(
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
                              title: const Text('Show Page Number'),
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
  final Chapter? chapter;
  final Directory? path;
  final String? url;
  final bool? isLocale;
  final Uint8List? archiveImage;
  final int? index;
  final bool hasNextPrePage;
  final bool hasPrevPrePage;
  final GetChapterUrlModel? chapterUrlModel;
  UChapDataPreload(
    this.chapter,
    this.path,
    this.url,
    this.isLocale,
    this.archiveImage,
    this.index,
    this.hasNextPrePage,
    this.hasPrevPrePage,
    this.chapterUrlModel,
  );
}
