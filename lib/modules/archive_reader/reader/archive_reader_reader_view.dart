import 'dart:async';
import 'dart:math';
import 'package:draggable_menu/draggable_menu.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:mangayomi/main.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/archive_reader/models/models.dart';
import 'package:mangayomi/utils/image_detail_info.dart';
import 'package:mangayomi/utils/media_query.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef DoubleClickAnimationListener = void Function();

class ArchiveReaderReaderView extends ConsumerWidget {
  final LocalArchive localArchive;
  const ArchiveReaderReaderView({
    super.key,
    required this.localArchive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
        overlays: []);

    return MangaChapterPageGallery(localArchive: localArchive);
  }
}

class MangaChapterPageGallery extends ConsumerStatefulWidget {
  const MangaChapterPageGallery({super.key, required this.localArchive});
  final LocalArchive localArchive;

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
  late int _currentIndex = 0;
  @override
  void dispose() {
    _rebuildDetail.close();
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

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

  Future setIndex(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    _doubleClickAnimationController = AnimationController(
        duration: _doubleTapAnimationDuration(), vsync: this);

    _scaleAnimationController = AnimationController(
        duration: _doubleTapAnimationDuration(), vsync: this);
    _animation = Tween(begin: 1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.ease, parent: _scaleAnimationController));
    _animation.addListener(() => _photoViewController.scale = _animation.value);
    _initCurrentIndex();
    _itemPositionsListener.itemPositions.addListener(_readProgressListener);
    super.initState();
  }

  _readProgressListener() {
    var posIndex = _itemPositionsListener.itemPositions.value.first.index;
    if (posIndex >= 0 && posIndex < widget.localArchive.images!.length) {
      if (_currentIndex != posIndex) {
        setState(() {
          _currentIndex = posIndex;
        });
      }
    }
  }

  _initCurrentIndex() async {
    await Future.delayed(const Duration(milliseconds: 1));
    _selectedValue = ReaderMode.vertical;
    _(_selectedValue!, true);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_imageDetailY != 0) {
      _imageDetailY = 0;
      _rebuildDetail.sink.add(_imageDetailY);
    }
  }

  void _onBtnTapped(int index, bool isPrev, {bool isSlide = false}) {
    if (isPrev) {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (index != -1) {
          if (isSlide) {
            _itemScrollController.jumpTo(
              index: index,
            );
          } else {
            animatePageTransitions
                ? _itemScrollController.scrollTo(
                    curve: Curves.ease,
                    index: index,
                    duration: Duration(milliseconds: isSlide ? 2 : 150))
                : _itemScrollController.jumpTo(
                    index: index,
                  );
          }
        }
      } else {
        if (index != -1) {
          if (_extendedController.hasClients) {
            setState(() {
              _isZoom = false;
            });
            animatePageTransitions
                ? _extendedController.animateToPage(index,
                    duration: Duration(milliseconds: isSlide ? 2 : 150),
                    curve: Curves.ease)
                : _extendedController.jumpToPage(index);
          }
        }
      }
    } else {
      if (_selectedValue == ReaderMode.verticalContinuous ||
          _selectedValue == ReaderMode.webtoon) {
        if (widget.localArchive.images!.length != index) {
          if (isSlide) {
            _itemScrollController.jumpTo(
              index: index,
            );
          } else {
            animatePageTransitions
                ? _itemScrollController.scrollTo(
                    curve: Curves.ease,
                    index: index,
                    duration: Duration(milliseconds: isSlide ? 2 : 150))
                : _itemScrollController.jumpTo(
                    index: index,
                  );
          }
        }
      } else {
        if (widget.localArchive.images!.length != index) {
          if (_extendedController.hasClients) {
            setState(() {
              _isZoom = false;
            });
            animatePageTransitions
                ? _extendedController.animateToPage(index,
                    duration: Duration(milliseconds: isSlide ? 2 : 150),
                    curve: Curves.ease)
                : _extendedController.jumpToPage(index);
          }
        }
      }
    }
  }

  ReaderMode? _selectedValue;
  bool _isView = false;
  Alignment _scalePosition = Alignment.center;
  final PhotoViewController _photoViewController = PhotoViewController();
  final PhotoViewScaleStateController _photoViewScaleStateController =
      PhotoViewScaleStateController();

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
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

  late bool _showPagesNumber = true;
  _(ReaderMode value, bool isInit) async {
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
        _extendedController.jumpToPage(_currentIndex);
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
            index: _currentIndex, duration: const Duration(milliseconds: 1));
      }
    }
  }

  Color _backgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9);

  Widget _showMore() {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = _currentIndex;

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
                        '${widget.localArchive.name} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle: SizedBox(
                      width: mediaWidth(context, 0.8),
                      child: const Text(
                        "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
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
                                          width: 25,
                                          child: Text(
                                            "${currentIndex + 1} ",
                                            style: const TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Slider(
                                        onChanged: (newValue) {
                                          _onBtnTapped(newValue.toInt(), true,
                                              isSlide: true);
                                        },
                                        divisions: max(
                                            widget.localArchive.images!.length -
                                                1,
                                            1),
                                        value: min(
                                            _currentIndex.toDouble(),
                                            widget.localArchive.images!.length
                                                .toDouble()),
                                        min: 0,
                                        max: (widget.localArchive.images!
                                                    .length -
                                                1)
                                            .toDouble(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: Transform.scale(
                                        scaleX: !_isReversHorizontal ? 1 : -1,
                                        child: SizedBox(
                                          width: 25,
                                          child: Text(
                                            "${widget.localArchive.images!.length}",
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
                              _(value, true);
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
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.screen_rotation,
                            ),
                          ),
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
      },
    );
  }

  Widget _showPage() {
    return Consumer(
      builder: (context, ref, child) {
        final currentIndex = _currentIndex;
        return _isView
            ? Container()
            : _showPagesNumber
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '${currentIndex + 1} / ${widget.localArchive.images!.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
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
                    basePosition: _scalePosition,
                    onScaleEnd: _onScaleEnd,
                    child: ScrollablePositionedList.separated(
                      physics: const ClampingScrollPhysics(),
                      minCacheExtent: 8 * (MediaQuery.of(context).size.height),
                      initialScrollIndex: _currentIndex,
                      itemCount: widget.localArchive.images!.length,
                      itemScrollController: _itemScrollController,
                      itemPositionsListener: _itemPositionsListener,
                      itemBuilder: (context, index) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onDoubleTapDown: (TapDownDetails details) {
                            _toggleScale(details.globalPosition);
                          },
                          onDoubleTap: () {},
                          child: Image.memory(
                              widget.localArchive.images![index].image!)),
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
                      preloadPagesCount:
                          _isZoom ? 0 : widget.localArchive.images!.length,
                      canScrollPage: (GestureDetails? gestureDetails) {
                        return gestureDetails != null
                            ? !(gestureDetails.totalScale! > 1.0)
                            : true;
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ExtendedImage.memory(
                          widget.localArchive.images![index].image!,
                          clearMemoryCacheWhenDispose: true,
                          enableMemoryCache: false,
                          mode: ExtendedImageMode.gesture,
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
                        );
                      },
                      itemCount: widget.localArchive.images!.length,
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
