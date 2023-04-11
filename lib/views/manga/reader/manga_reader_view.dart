// ignore_for_file: unnecessary_string_escapes, depend_on_referenced_packages
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/services/get_manga_chapter_url.dart';
import 'package:mangayomi/utils/image_detail_info.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/reader/image_view_horizontal.dart';
import 'package:mangayomi/views/manga/reader/image_view_vertical.dart';
import 'package:mangayomi/views/manga/reader/providers/reader_controller_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';

class MangaReaderView extends ConsumerWidget {
  final MangaReaderModel mangaReaderModel;
  const MangaReaderView({
    super.key,
    required this.mangaReaderModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    final chapterData = ref.watch(GetMangaChapterUrlProvider(
      modelManga: mangaReaderModel.modelManga,
      index: mangaReaderModel.index,
    ));
    final readerController = ref.read(
        readerControllerProvider(mangaReaderModel: mangaReaderModel).notifier);
    return chapterData.when(
      data: (data) {
        return MangaChapterPageGallery(
          path: data.path!,
          url: data.urll,
          readerController: readerController,
        );
      },
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(''),
          leading: BackButton(
            color: Colors.white,
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
              color: Colors.white,
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
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery(
      {super.key,
      required this.path,
      required this.url,
      required this.readerController});
  final ReaderController readerController;
  final Directory path;
  final List url;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState
    extends ConsumerState<MangaChapterPageGallery>
    with TickerProviderStateMixin {
  late final ItemScrollController _itemScrollController =
      ItemScrollController();
  late AnimationController _scaleAnimationController;
  late Animation<double> _animation;

  @override
  void dispose() {
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  void initState() {
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController));
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    widget.readerController.setMangaHistoryUpdate();
    _initCurrentIndex();
    super.initState();
  }

  _initCurrentIndex() async {
    await Future.delayed(const Duration(milliseconds: 1));
    widget.readerController.setChapterIndex();
    _selectedValue = widget.readerController.getReaderMode();
    _axisHive(_selectedValue!, true);
  }

  void _onPageChanged(int index) {
    widget.readerController.setMangaHistoryUpdate();
    if (mounted) {
      ref
          .read(currentIndexProvider(widget.readerController.mangaReaderModel)
              .notifier)
          .setCurrentIndex(index);
      if (_imageDetailY != 0) {
        _imageDetailY = 0;
        _rebuildDetail.sink.add(_imageDetailY);
      }
    }
    widget.readerController.setPageIndex(index);
  }

  void _onAddButtonTapped(int ok, bool isPrev, {bool isSlide = false}) {
    if (isPrev) {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (ok != -1) {
          _itemScrollController.scrollTo(
              curve: Curves.ease,
              index: ok,
              duration: Duration(milliseconds: isSlide ? 2 : 150));
        }
      } else {
        if (ok != -1) {
          if (_extendedController.hasClients) {
            _extendedController.animateToPage(ok.toInt(),
                duration: Duration(milliseconds: isSlide ? 2 : 150),
                curve: Curves.ease);
          }
        }
      }
    } else {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (widget.readerController.getPageLength(widget.url) != ok) {
          _itemScrollController.scrollTo(
              curve: Curves.ease,
              index: ok,
              duration: Duration(milliseconds: isSlide ? 2 : 150));
        }
      } else {
        if (widget.readerController.getPageLength(widget.url) != ok) {
          if (_extendedController.hasClients) {
            _extendedController.animateToPage(ok.toInt(),
                duration: Duration(milliseconds: isSlide ? 2 : 150),
                curve: Curves.ease);
          }
        }
      }
    }
  }

  List<ItemPosition> _filterAndSortItems(Iterable<ItemPosition> positions) {
    positions = positions
        .where(
            (item) => !(item.itemTrailingEdge < 0 || item.itemLeadingEdge > 1))
        .toList();
    (positions as List<ItemPosition>).sort((a, b) => a.index - b.index);
    return positions;
  }

  List<ItemPosition> getCurrentVisibleItems() {
    return _filterAndSortItems(_itemPositionsListener.itemPositions.value);
  }

  void _readProgressListener() {
    int? firstImageIndex = getCurrentVisibleItems().firstOrNull?.index;

    if (firstImageIndex == null) {
      return;
    }

    _recordReadProgress(firstImageIndex);
  }

  void _recordReadProgress(int index) {
    widget.readerController.setMangaHistoryUpdate();
    if (mounted) {
      ref
          .read(currentIndexProvider(widget.readerController.mangaReaderModel)
              .notifier)
          .setCurrentIndex(index);
    }
    widget.readerController.setPageIndex(index);
  }

  ReaderMode? _selectedValue;
  bool _isView = false;
  double maxScale = 4.1;
  Alignment scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  void onScaleEnd(BuildContext context, ScaleEndDetails details,
      PhotoViewControllerValue controllerValue) {
    if (controllerValue.scale! < 1) {
      _photoViewScaleStateController.reset();
    }
  }

  late final _extendedController = ExtendedPageController(
    initialPage: widget.readerController.getPageIndex(),
    shouldIgnorePointerWhenScrolling: false,
  );
  double get pixelRatio => ui.window.devicePixelRatio;

  Size get size => ui.window.physicalSize / pixelRatio;
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
        scalePosition = _computeAlignmentByTapOffset(tapPosition);

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

  late bool _showPagesNumber = widget.readerController.getShowPageNumber();
  _axisHive(ReaderMode value, bool isInit) async {
    widget.readerController.setReaderMode(value);

    if (value == ReaderMode.vertical) {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _scrollDirection = Axis.vertical;
          _isReversHorizontal = false;
        });
        if (isInit) {
          await Future.delayed(const Duration(milliseconds: 30));
        }
        _extendedController.jumpToPage(ref.watch(
            currentIndexProvider(widget.readerController.mangaReaderModel)));
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
        if (isInit) {
          await Future.delayed(const Duration(milliseconds: 30));
        }
        _extendedController.jumpToPage(ref.watch(
            currentIndexProvider(widget.readerController.mangaReaderModel)));
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _isReversHorizontal = false;
        });
        if (isInit) {
          await Future.delayed(const Duration(milliseconds: 30));
        }
        _itemScrollController.scrollTo(
            index: ref.watch(
                currentIndexProvider(widget.readerController.mangaReaderModel)),
            duration: const Duration(milliseconds: 1));
      }
    }
  }

  Color colorsBlack(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9);

  Widget _showMore() {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              height: _isView ? 90 : 0,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 200),
              child: PreferredSize(
                preferredSize: Size.fromHeight(_isView ? 90 : 0),
                child: AppBar(
                  leading: BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: ListTile(
                    title: SizedBox(
                      width: mediaWidth(context, 0.7),
                      child: Text(
                        '${widget.readerController.getMangaName()} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: SizedBox(
                      width: mediaWidth(context, 0.7),
                      child: Text(
                        widget.readerController.getChapterTitle(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.public)),
                  ],
                  backgroundColor: colorsBlack(context),
                ),
              ),
            ),
            AnimatedContainer(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 300),
              width: mediaWidth(context, 1),
              height: _isView ? 108 : 0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: colorsBlack(context),
                          child: IconButton(
                              onPressed: () {
                                pushReplacementMangaReaderView(
                                    context: context,
                                    modelManga:
                                        widget.readerController.getModelManga(),
                                    index: widget.readerController
                                            .getChapterIndex() +
                                        1);
                              },
                              icon: Transform.scale(
                                scaleX: 1,
                                child: Icon(
                                  Icons.skip_previous_rounded,
                                  color: widget.readerController
                                                  .getChapterIndex() +
                                              1 !=
                                          widget.readerController
                                              .getModelManga()
                                              .chapterTitle!
                                              .length
                                      ? Colors.white
                                      : Colors.grey,
                                  // size: 17,
                                ),
                              )),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: colorsBlack(context),
                                borderRadius: BorderRadius.circular(25)),
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  if (!_isReversHorizontal)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        "${ref.watch(currentIndexProvider(widget.readerController.mangaReaderModel)) + 1} ",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (_isReversHorizontal)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Text(
                                        "${widget.readerController.getPageLength(widget.url)}",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  Flexible(
                                    child: Transform.scale(
                                      scaleX: !_isReversHorizontal ? 1 : -1,
                                      child: Slider(
                                        onChanged: (newValue) {
                                          _onAddButtonTapped(
                                              newValue.toInt(), true,
                                              isSlide: true);
                                        },
                                        divisions: max(
                                            widget.readerController
                                                    .getPageLength(widget.url) -
                                                1,
                                            1),
                                        value: ref
                                            .watch(currentIndexProvider(widget
                                                .readerController
                                                .mangaReaderModel))
                                            .toDouble(),
                                        min: 0,
                                        max: (widget.readerController
                                                    .getPageLength(widget.url) -
                                                1)
                                            .toDouble(),
                                      ),
                                    ),
                                  ),
                                  if (_isReversHorizontal)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        "${ref.watch(currentIndexProvider(widget.readerController.mangaReaderModel)) + 1} ",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  if (!_isReversHorizontal)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        "${widget.readerController.getPageLength(widget.url)}",
                                        style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
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
                          backgroundColor: colorsBlack(context),
                          child: IconButton(
                            onPressed: () {
                              pushReplacementMangaReaderView(
                                  context: context,
                                  modelManga:
                                      widget.readerController.getModelManga(),
                                  index: widget.readerController
                                          .getChapterIndex() -
                                      1);
                            },
                            icon: Transform.scale(
                              scaleX: 1,
                              child: Icon(
                                Icons.skip_next_rounded,
                                color:
                                    widget.readerController.getChapterIndex() !=
                                            0
                                        ? Colors.white
                                        : Colors.grey,
                                // size: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: colorsBlack(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PopupMenuButton(
                          color: Colors.black,
                          child: const Icon(
                            Icons.app_settings_alt_outlined,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            if (mounted) {
                              setState(() {
                                _selectedValue = value;
                              });
                            }
                            _axisHive(value, true);
                          },
                          itemBuilder: (context) => [
                            for (var ok in ReaderMode.values)
                              PopupMenuItem(
                                  value: ok,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: _selectedValue == ok
                                            ? Colors.white
                                            : Colors.transparent,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        widget.readerController
                                            .getReaderModeValue(ok),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.screen_rotation,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _showModalSettings();
                          },
                          icon: const Icon(
                            Icons.settings_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _showPage() {
    return Consumer(
      builder: (context, ref, child) {
        return _isView
            ? Container()
            : _showPagesNumber
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '${ref.watch(currentIndexProvider(widget.readerController.mangaReaderModel)) + 1} / ${widget.readerController.getPageLength(widget.url)}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(offset: Offset(0.0, 0.0), blurRadius: 10.0)
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Container();
      },
    );
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
        final currentIndex = ref.watch(
            currentIndexProvider(widget.readerController.mangaReaderModel));
        return Row(
          children: [
            /// left region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(currentIndex + 1, false);
                        } else {
                          _onAddButtonTapped(currentIndex - 1, true);
                        }
                      },
                      onDoubleTapDown: (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      },
                      onDoubleTap: () {},
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(currentIndex + 1, false);
                        } else {
                          _onAddButtonTapped(currentIndex - 1, true);
                        }
                      },
                    ),
                  ),

            /// center region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _isViewFunction();
                      },
                      onDoubleTapDown: (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      },
                      onDoubleTap: () {},
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _isViewFunction();
                      },
                    ),
                  ),

            /// right region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(currentIndex - 1, true);
                        } else {
                          _onAddButtonTapped(currentIndex + 1, false);
                        }
                      },
                      onDoubleTapDown: (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      },
                      onDoubleTap: () {},
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(currentIndex - 1, true);
                        } else {
                          _onAddButtonTapped(currentIndex + 1, false);
                        }
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
        final currentIndex = ref.watch(
            currentIndexProvider(widget.readerController.mangaReaderModel));
        return Column(
          children: [
            /// top region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _onAddButtonTapped(currentIndex - 1, true);
                      },
                      onDoubleTapDown: (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      },
                      onDoubleTap: () {},
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _onAddButtonTapped(currentIndex - 1, true);
                      },
                    ),
                  ),

            /// center region
            Expanded(flex: 5, child: Container()),

            /// bottom region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _onAddButtonTapped(currentIndex + 1, false);
                      },
                      onDoubleTapDown: (TapDownDetails details) {
                        _toggleScale(details.globalPosition);
                      },
                      onDoubleTap: () {},
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _onAddButtonTapped(currentIndex + 1, false);
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  bool _isVerticalContinous() {
    return _selectedValue == ReaderMode.verticalContinuous ||
        _selectedValue == ReaderMode.webtoon;
  }

  final StreamController<double> _rebuildDetail =
      StreamController<double>.broadcast();
  final Map<int, ImageDetailInfo> detailKeys = <int, ImageDetailInfo>{};
  late AnimationController _doubleClickAnimationController;

  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  List<double> doubleTapScales = <double>[1.0, 2.0];
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  double _imageDetailY = 0;
  @override
  Widget build(BuildContext context) {
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
                    basePosition: scalePosition,
                    onScaleEnd: onScaleEnd,
                    child: ScrollablePositionedList.separated(
                      physics: const ClampingScrollPhysics(),
                      minCacheExtent: 8 * (MediaQuery.of(context).size.height),
                      initialScrollIndex:
                          widget.readerController.getPageIndex(),
                      itemCount:
                          widget.readerController.getPageLength(widget.url),
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onDoubleTapDown: (TapDownDetails details) {
                          _toggleScale(details.globalPosition);
                        },
                        onDoubleTap: () {},
                        child: ImageViewVertical(
                          titleManga: widget.readerController.getMangaName(),
                          source: widget.readerController.getSourceName(),
                          index: index,
                          url: widget.url[index],
                          path: widget.path,
                          chapter: widget.readerController.getChapterTitle(),
                          length:
                              widget.readerController.getPageLength(widget.url),
                        ),
                      ),
                      separatorBuilder: (_, __) => Divider(
                          color: Colors.black,
                          height: _selectedValue == ReaderMode.webtoon ? 0 : 6),
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
                      canScrollPage: (GestureDetails? gestureDetails) {
                        return !(gestureDetails!.totalScale! > 1.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ImageViewHorizontal(
                          titleManga: widget.readerController.getMangaName(),
                          source: widget.readerController.getSourceName(),
                          index: index,
                          url: widget.url[index],
                          path: widget.path,
                          chapter: widget.readerController.getChapterTitle(),
                          length:
                              widget.readerController.getPageLength(widget.url),
                          loadStateChanged: (ExtendedImageState state) {
                            if (state.extendedImageLoadState ==
                                LoadState.loading) {
                              final ImageChunkEvent? loadingProgress =
                                  state.loadingProgress;
                              final double? progress =
                                  loadingProgress?.expectedTotalBytes != null
                                      ? loadingProgress!.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null;
                              return SizedBox(
                                height: mediaHeight(context, 0.5),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: progress,
                                  ),
                                ),
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
                              return Center(
                                child: ElevatedButton(
                                    onPressed: () {
                                      state.reLoadImage();
                                    },
                                    child: const Icon(
                                      Icons.replay_outlined,
                                      size: 30,
                                    )),
                              );
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
                              cacheGesture: false,
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
                              end = doubleTapScales[1];
                            } else {
                              end = doubleTapScales[0];
                            }

                            _doubleClickAnimationListener = () {
                              //print(_animation.value);
                              state.handleDoubleTap(
                                  scale: _doubleClickAnimation!.value,
                                  doubleTapPosition: pointerDownPosition);
                            };
                            _doubleClickAnimation =
                                _doubleClickAnimationController.drive(
                                    Tween<double>(begin: begin, end: end));

                            _doubleClickAnimation!
                                .addListener(_doubleClickAnimationListener);

                            _doubleClickAnimationController.forward();
                          },
                        );
                      },
                      itemCount:
                          widget.readerController.getPageLength(widget.url),
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
    showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      enableDrag: true,
      expand: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
          height: mediaHeight(context, 0.4),
          child: StatefulBuilder(builder: (context, setState) {
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
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(height: 0.1, color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Show Page Number'),
                            const Spacer(),
                            Switch(
                              value: _showPagesNumber,
                              onChanged: (value) {
                                setState(() {
                                  _showPagesNumber = value;
                                });
                                widget.readerController
                                    .setShowPageNumber(value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          })),
    );
  }
}
