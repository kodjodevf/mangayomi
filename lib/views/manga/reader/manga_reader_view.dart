// ignore_for_file: unnecessary_string_escapes, depend_on_referenced_packages
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/models/manga_history.dart';
import 'package:mangayomi/models/manga_reader.dart';
import 'package:mangayomi/models/model_manga.dart';
import 'package:mangayomi/providers/hive_provider.dart';
import 'package:mangayomi/services/get_manga_chapter_url.dart';
import 'package:mangayomi/utils/image_detail_info.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/views/manga/reader/image_view_horizontal.dart';
import 'package:mangayomi/views/manga/reader/image_view_vertical.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:collection/collection.dart';

class MangaReaderView extends ConsumerStatefulWidget {
  final MangaReaderModel mangaReaderModel;
  const MangaReaderView({
    super.key,
    required this.mangaReaderModel,
  });

  @override
  ConsumerState createState() => _MangaReaderViewState();
}

class _MangaReaderViewState extends ConsumerState<MangaReaderView> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int pageIndex = ref.watch(hiveBoxMangaInfo).get(
        "${widget.mangaReaderModel.modelManga.source}/${widget.mangaReaderModel.modelManga.name}/${widget.mangaReaderModel.modelManga.chapterTitle![widget.mangaReaderModel.index]}-page_index",
        defaultValue: 0);
    int length = ref.watch(hiveBoxMangaInfo).get(
        "${widget.mangaReaderModel.modelManga.name}/${widget.mangaReaderModel.modelManga.chapterTitle![widget.mangaReaderModel.index]}-length",
        defaultValue: 0);
    final chapterData = ref.watch(GetMangaChapterUrlProvider(
      modelManga: widget.mangaReaderModel.modelManga,
      index: widget.mangaReaderModel.index,
    ));
    return chapterData.when(
      data: (data) {
        return MangaChapterPageGallery(
          pageLength: length != 0 ? length : data.urll.length,
          initialIndex: pageIndex,
          scrollDirection: Axis.vertical,
          path: data.path!,
          url: data.urll,
          modelManga: widget.mangaReaderModel.modelManga,
          index: widget.mangaReaderModel.index,
          titleManga: widget.mangaReaderModel.modelManga.name!,
          source: widget.mangaReaderModel.modelManga.source!,
          chapter: widget.mangaReaderModel.modelManga
              .chapterTitle![widget.mangaReaderModel.index],
          selectedValue: ref.watch(hiveBoxMangaInfo).get(
              "${widget.mangaReaderModel.modelManga.source}/${widget.mangaReaderModel.modelManga.name}-scrollDirection",
              defaultValue: 'Vertical'),
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
  const MangaChapterPageGallery({
    super.key,
    required this.selectedValue,
    this.initialIndex = 0,
    required this.pageLength,
    this.scrollDirection = Axis.horizontal,
    required this.path,
    required this.url,
    required this.index,
    required this.titleManga,
    required this.modelManga,
    required this.source,
    required this.chapter,
  });
  final Directory path;
  final String titleManga;
  final ModelManga modelManga;
  final String source;
  final String selectedValue;
  final List url;
  final int index;
  final int initialIndex;
  final String chapter;

  final int pageLength;
  final Axis scrollDirection;

  @override
  ConsumerState createState() {
    return _MangaChapterPageGalleryState();
  }
}

class _MangaChapterPageGalleryState
    extends ConsumerState<MangaChapterPageGallery>
    with TickerProviderStateMixin {
  late int _currentIndex = widget.initialIndex;
  late int _indexJumpVertical = widget.initialIndex;
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
        duration: const Duration(milliseconds: 150), vsync: this);

    _scaleAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _animation = Tween(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController));
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    _initCurrentIndex();
    super.initState();
  }

  _initCurrentIndex() async {
    await Future.delayed(const Duration(milliseconds: 1));
    if (ref.watch(hiveBoxMangaInfo).get(
            "${widget.titleManga}/${widget.chapter}-length",
            defaultValue: 0) ==
        0) {
      ref.watch(hiveBoxMangaInfo).put(
          "${widget.titleManga}/${widget.chapter}-length", widget.pageLength);
    }
    ref.watch(hiveBoxMangaInfo).put(
        "${widget.source}/${widget.titleManga}-chapter_index",
        widget.index.toString());
    _selectedValue = widget.selectedValue;
    _axisHive(_selectedValue!, true);
  }

  void _onPageChanged(int index) {
    ref.watch(hiveBoxMangaHistory).put(
        widget.modelManga.link,
        MangaHistoryModel(
            date: DateTime.now().toString(), modelManga: widget.modelManga));
    if (mounted) {
      setState(() {
        _currentIndex = index;
        if (_imageDetailY != 0) {
          _imageDetailY = 0;
          _rebuildDetail.sink.add(_imageDetailY);
        }
      });
    }

    ref.watch(hiveBoxMangaInfo).put(
        "${widget.source}/${widget.titleManga}/${widget.chapter}-page_index",
        index);
  }

  void _onAddButtonTapped(int ok, bool isPrev, {bool isSlide = false}) {
    if (isPrev) {
      if (_selectedValue == 'Vertical continue' ||
          _selectedValue == 'Webtoon') {
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
      if (_selectedValue == 'Vertical continue' ||
          _selectedValue == 'Webtoon') {
        if (widget.pageLength != ok) {
          _itemScrollController.scrollTo(
              curve: Curves.ease,
              index: ok,
              duration: Duration(milliseconds: isSlide ? 2 : 150));
        }
      } else {
        if (widget.pageLength != ok) {
          if (_extendedController.hasClients) {
            _extendedController.animateToPage(ok.toInt(),
                duration: Duration(milliseconds: isSlide ? 2 : 150),
                curve: Curves.ease);
          }
        }
      }
    }
  }

  Axis _scrollDirection = Axis.vertical;
  bool _isReversHorizontal = false;
  final List<String> items = [
    'Vertical',
    'LTR',
    'RTL',
    'Vertical continue',
    'Webtoon',
  ];
  bool _showPagesNumber = true;
  _axisHive(String value, bool isInit) async {
    ref.watch(hiveBoxMangaInfo).put(
        "${widget.source}/${widget.titleManga}-scrollDirection",
        value.toString());
    if (value.toString() == 'Vertical') {
      if (mounted) {
        setState(() {
          _selectedValue = value;
          _scrollDirection = Axis.vertical;
          _isReversHorizontal = false;
        });
        if (isInit) {
          await Future.delayed(const Duration(milliseconds: 30));
        }
        _extendedController.jumpToPage(_currentIndex);
      }
    } else if (value.toString() == 'LTR' || value.toString() == 'RTL') {
      if (mounted) {
        setState(() {
          if (value.toString() == 'RTL') {
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
        _extendedController.jumpToPage(_currentIndex);
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
            index: _indexJumpVertical,
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
                        '${widget.titleManga} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: SizedBox(
                      width: mediaWidth(context, 0.7),
                      child: Text(
                        widget.chapter,
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
                                    modelManga: widget.modelManga,
                                    index: widget.index + 1);
                              },
                              icon: Transform.scale(
                                scaleX: 1,
                                child: Icon(
                                  Icons.skip_previous_rounded,
                                  color: widget.index + 1 !=
                                          widget.modelManga.chapterTitle!.length
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
                                        "${_currentIndex + 1} ",
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
                                        "${widget.pageLength}",
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
                                        divisions:
                                            max(widget.pageLength - 1, 1),
                                        value: _currentIndex.toDouble(),
                                        min: 0,
                                        max: (widget.pageLength - 1).toDouble(),
                                      ),
                                    ),
                                  ),
                                  if (_isReversHorizontal)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Text(
                                        "${_currentIndex + 1} ",
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
                                        "${widget.pageLength}",
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
                                  modelManga: widget.modelManga,
                                  index: widget.index - 1);
                            },
                            icon: Transform.scale(
                              scaleX: 1,
                              child: Icon(
                                Icons.skip_next_rounded,
                                color: widget.index != 0
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
                        IconButton(
                          onPressed: () {
                            _showModalSettings();
                          },
                          icon: const Icon(
                            Icons.app_settings_alt_outlined,
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
                      '${_currentIndex + 1} / ${widget.pageLength}',
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
    ref.watch(hiveBoxMangaHistory).put(
        widget.modelManga.link,
        MangaHistoryModel(
            date: DateTime.now().toString(), modelManga: widget.modelManga));
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
    ref.watch(hiveBoxMangaInfo).put(
        "${widget.source}/${widget.titleManga}/${widget.chapter}-page_index",
        index);
  }

  String? _selectedValue;
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
    initialPage: widget.initialIndex,
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
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(_currentIndex + 1, false);
                        } else {
                          _onAddButtonTapped(_currentIndex - 1, true);
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
                          _onAddButtonTapped(_currentIndex + 1, false);
                        } else {
                          _onAddButtonTapped(_currentIndex - 1, true);
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

            /// right region: toRight
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (_isReversHorizontal) {
                          _onAddButtonTapped(_currentIndex - 1, true);
                        } else {
                          _onAddButtonTapped(_currentIndex + 1, false);
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
                          _onAddButtonTapped(_currentIndex - 1, true);
                        } else {
                          _onAddButtonTapped(_currentIndex + 1, false);
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
        return Column(
          children: [
            /// top region
            _isVerticalContinous()
                ? Expanded(
                    flex: 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _onAddButtonTapped(_currentIndex - 1, true);
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
                        _onAddButtonTapped(_currentIndex - 1, true);
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
                        _onAddButtonTapped(_currentIndex + 1, false);
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
                        _onAddButtonTapped(_currentIndex + 1, false);
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }

  bool _isVerticalContinous() {
    return _selectedValue == 'Vertical continue' || _selectedValue == 'Webtoon';
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
    ref.watch(hiveBoxMangaHistory).put(
        widget.modelManga.link,
        MangaHistoryModel(
            date: DateTime.now().toString(), modelManga: widget.modelManga));
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
                      initialScrollIndex: widget.initialIndex,
                      itemCount: widget.pageLength,
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      itemBuilder: (context, index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onDoubleTapDown: (TapDownDetails details) {
                          _toggleScale(details.globalPosition);
                        },
                        onDoubleTap: () {},
                        child: ImageViewVertical(
                          titleManga: widget.titleManga,
                          source: widget.source,
                          index: index,
                          url: widget.url[index],
                          path: widget.path,
                          chapter: widget.chapter,
                          length: widget.pageLength,
                        ),
                      ),
                      separatorBuilder: (_, __) => Divider(
                          color: Colors.black,
                          height: _selectedValue == 'Webtoon' ? 0 : 6),
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
                        return widget.modelManga.source == 'japscan'
                            ? true
                            : !(gestureDetails!.totalScale! > 1.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ImageViewHorizontal(
                          titleManga: widget.titleManga,
                          source: widget.source,
                          index: index,
                          url: widget.url[index],
                          path: widget.path,
                          chapter: widget.chapter,
                          length: widget.pageLength,
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
                              inPageView: true,
                              initialScale: initialScale!,
                              maxScale: 10,
                              animationMaxScale: 10,
                              initialAlignment: InitialAlignment.center,
                              cacheGesture: false,
                              hitTestBehavior: HitTestBehavior.opaque,
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
                      itemCount: widget.pageLength,
                      onPageChanged: _onPageChanged)),
          _gestureRightLeft(),
          _gestureTopBottom(),
          _showMore(),
          _showPage(),
        ],
      ),
    );
  }

  String _readModeValue(String ok) {
    return ok == 'Vertical continue'
        ? 'Verical continuous'
        : ok == 'LTR'
            ? 'Left to Right'
            : ok == 'RTL'
                ? 'Right to Left'
                : ok;
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Read Mode'),
                        const Spacer(),
                        PopupMenuButton(
                          color: Colors.black,
                          child: Row(
                            children: [
                              Text(
                                _readModeValue(_selectedValue!),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.arrow_drop_down)
                            ],
                          ),
                          onSelected: (value) {
                            if (mounted) {
                              setState(() {
                                _selectedValue = value.toString();
                              });
                            }

                            if (value.toString() == 'Vertical continue' ||
                                value.toString() == 'Webtoon') {
                              if (mounted) {
                                setState(() {
                                  _indexJumpVertical = _currentIndex;
                                });
                              }
                            }
                            _axisHive(value.toString(), true);
                          },
                          itemBuilder: (context) => [
                            for (var ok in items)
                              PopupMenuItem(
                                  value: ok,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: _selectedValue == ok
                                            ? null
                                            : Colors.transparent,
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        _readModeValue(ok),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                              onChanged: (ss) {
                                setState(() {
                                  _showPagesNumber = ss;
                                });

                                ref.watch(hiveBoxMangaInfo).put(
                                    "${widget.source}/${widget.titleManga}-showPagesNumber",
                                    ss);
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
