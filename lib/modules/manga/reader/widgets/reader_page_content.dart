import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangayomi/models/chapter.dart';
import 'package:mangayomi/models/settings.dart';
import 'package:mangayomi/modules/manga/reader/image_view_paged.dart';
import 'package:mangayomi/modules/manga/reader/image_view_webtoon.dart';
import 'package:mangayomi/modules/manga/reader/subsampling_scale_image_view/subsampling_scale_image_view.dart'
    as ssiv;
import 'package:mangayomi/modules/manga/reader/u_chap_data_preload.dart';
import 'package:mangayomi/modules/manga/reader/utils/reader_page_index_math.dart';
import 'package:mangayomi/modules/manga/reader/widgets/circular_progress_indicator_animate_rotate.dart';
import 'package:mangayomi/modules/manga/reader/widgets/double_page_view.dart';
import 'package:mangayomi/modules/manga/reader/widgets/image_actions_dialog.dart';
import 'package:mangayomi/modules/manga/reader/widgets/reader_interactive_region.dart';
import 'package:mangayomi/modules/manga/reader/widgets/transition_view_paged.dart';
import 'package:mangayomi/modules/more/settings/reader/providers/reader_state_provider.dart';
import 'package:mangayomi/modules/more/settings/reader/reader_screen.dart';
import 'package:mangayomi/providers/l10n_providers.dart';
import 'package:mangayomi/utils/extensions/build_context_extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

/// The reader's actual page content: the continuous (webtoon) list, or the
/// paged (single/double-page) PageView, depending on [readerMode] and
/// [pageMode]. Everything else in the reader (app bar, bottom bar, gesture
/// overlay, flash overlay...) is layered on top of this by the caller, which
/// also owns all the mutable state this widget only reads or reports back
/// through callbacks.
class ReaderPageContent extends ConsumerWidget {
  final List<UChapDataPreload> pages;
  final Chapter chapter;
  final ReaderMode readerMode;
  final PageMode pageMode;
  final BackgroundColor backgroundColor;
  final int pagePreloadAmount;

  /// Index the continuous list should open on. Read once, at construction:
  /// this is [ImageViewWebtoon.initialScrollIndex], not a live "which page is
  /// visible now" value.
  final int initialScrollIndex;

  /// The page currently shown by the paged PageView, for the single-page
  /// branch's `isVisible` check.
  final int currentPageViewIndex;

  /// Total pages as seen by the page-view controller (halved in double-page
  /// mode) - depends on state (double-page toggle, singleFirst setting) that
  /// lives on the caller, so it is passed in rather than recomputed here.
  final int pageViewPageCount;

  final bool isReverseHorizontal;
  final bool isCurrentPageZoomed;

  final ListController listController;
  final ScrollController continuousScrollController;
  final PageController extendedController;
  final Axis scrollDirection;

  /// Looks up (creating if needed) the single-page zoom controller for
  /// [index]. Owned by the caller so the zoom-state listener it attaches
  /// keeps seeing the same instances across rebuilds.
  final ssiv.SubsamplingScaleImageViewController Function(int index)
  pageControllerFor;

  final void Function(int index, bool failed) onFailedToLoadImage;
  final void Function(int index, double width, double height) onWidePage;
  final void Function(int index) onPageImageLoaded;

  /// A single page's image finished loading wider than tall; the caller
  /// schedules a delayed rebuild once the layout has had a chance to settle.
  final void Function(int index) onWideSinglePageLoaded;

  final void Function(int index, bool zoomed) onDoublePageZoomChanged;
  final void Function(int index, PhotoViewController? controller)
  onDoublePageControllerCreated;
  final Future<void> Function(int index) onPageChanged;

  const ReaderPageContent({
    super.key,
    required this.pages,
    required this.chapter,
    required this.readerMode,
    required this.pageMode,
    required this.backgroundColor,
    required this.pagePreloadAmount,
    required this.initialScrollIndex,
    required this.currentPageViewIndex,
    required this.pageViewPageCount,
    required this.isReverseHorizontal,
    required this.isCurrentPageZoomed,
    required this.listController,
    required this.continuousScrollController,
    required this.extendedController,
    required this.scrollDirection,
    required this.pageControllerFor,
    required this.onFailedToLoadImage,
    required this.onWidePage,
    required this.onPageImageLoaded,
    required this.onWideSinglePageLoaded,
    required this.onDoublePageZoomChanged,
    required this.onDoublePageControllerCreated,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isHorizontalContinuous = readerMode.isHorizontalContinuous;
    final singleFirst = ref.watch(
      doublePageSingleFirstPageStateProvider,
    );

    if (readerMode.isContinuous) {
      return ImageViewWebtoon(
        pages: pages,
        listController: listController,
        scrollController: continuousScrollController,
        scrollDirection: isHorizontalContinuous
            ? Axis.horizontal
            : Axis.vertical,
        // Keep the *built* (decoded, in-memory) range small and constant;
        // pagePreloadAmount only drives the network prefetch in
        // _prefetchPagesInOrder. Tying this to pagePreloadAmount pinned up to
        // 20 screens of decoded pages at once (OOM on webtoons).
        minCacheExtent: isHorizontalContinuous
            ? (pagePreloadAmount.clamp(1, 3) * 1.5) * context.width(1)
            : (pagePreloadAmount.clamp(1, 3) * 1.5) * context.height(1),
        initialScrollIndex: initialScrollIndex,
        physics: const ClampingScrollPhysics(),
        onLongPressData: (data) => ImageActionsDialog.show(
          context: context,
          data: data,
          manga: chapter.manga.value!,
          chapterName: chapter.name!,
        ),
        onFailedToLoadImage: onFailedToLoadImage,
        backgroundColor: backgroundColor,
        isDoublePageMode:
            pageMode == PageMode.doublePage && !isHorizontalContinuous,
        isHorizontalContinuous: isHorizontalContinuous,
        readerMode: readerMode,
        webtoonSidePadding: ref.watch(webtoonSidePaddingStateProvider),
        showPageGaps: ref.watch(showPageGapsStateProvider),
        reverse: isReverseHorizontal,
        zoomOutDisabled: ref.watch(webtoonDisableZoomOutStateProvider),
        doubleTapZoomEnabled: ref.watch(
          webtoonDoubleTapZoomEnabledStateProvider,
        ),
        onImageLoaded: (index, width, height) {
          if (ref.read(splitWidePagesStateProvider) && width > height * 1.2) {
            onWidePage(index, width, height);
          }
          onPageImageLoaded(index);
        },
      );
    }

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        end:
            getBackgroundColor(backgroundColor) ??
            Theme.of(context).scaffoldBackgroundColor,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, animColor, animChild) {
        return Material(
          color: animColor,
          shadowColor: animColor,
          child: animChild,
        );
      },
      child: (pageMode == PageMode.doublePage && !isHorizontalContinuous)
          ? PageView.builder(
              controller: extendedController,
              scrollDirection: scrollDirection,
              reverse: isReverseHorizontal,
              physics: isCurrentPageZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final spreads = ReaderPageIndexMath.buildSpreads(
                  pages,
                  singleFirst: singleFirst,
                );
                final spread = index < spreads.length ? spreads[index] : null;
                final index1 = spread?.firstIndex ?? index * 2;
                final index2 = spread?.secondIndex;
                final List<UChapDataPreload?> pageList = [
                  if (index1 < pages.length) pages[index1],
                  if (index2 != null && index2 < pages.length) pages[index2],
                ];

                // If spread is a transition page, render it directly full-screen
                // without wrapping in PhotoView/DoublePageView zoom machinery.
                if (pageList.isNotEmpty &&
                    pageList.any((p) => p?.isTransitionPage ?? false)) {
                  final transPage =
                      pageList.firstWhere((p) => p?.isTransitionPage ?? false)!;
                  return SizedBox.expand(
                    key: ValueKey(
                      'trans_${index}_${transPage.chapter?.id}_${transPage.pageIndex}',
                    ),
                    child: TransitionViewPaged(
                      data: transPage,
                      readerMode: readerMode,
                    ),
                  );
                }

                if (pageList.isEmpty) {
                  return const SizedBox.shrink();
                }

                return DoublePageView.paged(
                  key: ValueKey('spread_${index}_${index1}_$index2'),
                  pages: isReverseHorizontal
                      ? pageList.reversed.toList()
                      : pageList,
                  backgroundColor: backgroundColor,
                  readerMode: readerMode,
                  scrollDirection: scrollDirection,
                  onZoomChanged: (zoomed) {
                    onDoublePageZoomChanged(index, zoomed);
                  },
                  onControllerCreated: (controller) {
                    onDoublePageControllerCreated(index, controller);
                  },
                  onFailedToLoadImage: (val) {
                    onFailedToLoadImage(index, val);
                  },
                  onImageLoaded: (pIdx, width, height) {
                    if (ref.read(splitWidePagesStateProvider) &&
                        width > height * 1.2) {
                      onWidePage(pIdx, width, height);
                    }
                  },
                  onWideSinglePageLoaded: onWideSinglePageLoaded,
                  onLongPressData: (datas) {
                    ImageActionsDialog.show(
                      context: context,
                      data: datas,
                      manga: chapter.manga.value!,
                      chapterName: chapter.name!,
                    );
                  },
                );
              },
              itemCount: pageViewPageCount,
              onPageChanged: onPageChanged,
            )
          : PageView.builder(
              controller: extendedController,
              scrollDirection: scrollDirection,
              reverse: isReverseHorizontal,
              physics: isCurrentPageZoomed
                  ? const NeverScrollableScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final page = pages[index];
                return ReaderPagedItem(
                  key: ValueKey(
                    'paged-${page.chapter?.id ?? "trans"}-${page.index ?? index}',
                  ),
                  index: index,
                  page: page,
                  chapter: chapter,
                  readerMode: readerMode,
                  pageController: extendedController,
                  controller: pageControllerFor(index),
                  isVisible: index == currentPageViewIndex,
                  backgroundColor: backgroundColor,
                  onFailedToLoadImage: onFailedToLoadImage,
                  onWidePage: onWidePage,
                  onWideSinglePageLoaded: onWideSinglePageLoaded,
                );
              },
              itemCount: pages.length,
              onPageChanged: onPageChanged,
            ),
    );
  }
}

/// A single page in the (non-double-page) paged PageView: a transition page,
/// or a zoomable [ImageViewPaged] with its own loading/error/retry states.
class ReaderPagedItem extends ConsumerWidget {
  final int index;
  final UChapDataPreload page;
  final Chapter chapter;
  final ReaderMode readerMode;
  final PageController pageController;
  final ssiv.SubsamplingScaleImageViewController controller;
  final bool isVisible;
  final BackgroundColor backgroundColor;
  final void Function(int index, bool failed) onFailedToLoadImage;
  final void Function(int index, double width, double height) onWidePage;
  final void Function(int index) onWideSinglePageLoaded;

  const ReaderPagedItem({
    super.key,
    required this.index,
    required this.page,
    required this.chapter,
    required this.readerMode,
    required this.pageController,
    required this.controller,
    required this.isVisible,
    required this.backgroundColor,
    required this.onFailedToLoadImage,
    required this.onWidePage,
    required this.onWideSinglePageLoaded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (page.isTransitionPage) {
      return TransitionViewPaged(data: page, readerMode: readerMode);
    }

    return ImageViewPaged(
      data: page,
      pageController: pageController,
      controller: controller,
      isVisible: isVisible,
      onImageLoaded: (width, height) {
        if (ref.read(splitWidePagesStateProvider) && width > height * 1.2) {
          onWidePage(index, width.toDouble(), height.toDouble());
        }
        if (width > height) {
          onWideSinglePageLoaded(index);
        }
      },
      loadStateChanged: (state) {
        if (state.loadState == ssiv.LoadState.loading) {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
              : 0;
          return Container(
            color:
                getBackgroundColor(backgroundColor) ??
                Theme.of(context).scaffoldBackgroundColor,
            height: context.height(0.8),
            child: CircularProgressIndicatorAnimateRotate(progress: progress),
          );
        }
        if (state.loadState == ssiv.LoadState.completed) {
          onFailedToLoadImage(index, false);
          return null; // Dessine l'image via SubsamplingScaleImageView
        }
        if (state.loadState == ssiv.LoadState.failed) {
          onFailedToLoadImage(index, true);
          final l10n = l10nLocalizations(context)!;
          return Container(
            color:
                getBackgroundColor(backgroundColor) ??
                Theme.of(context).scaffoldBackgroundColor,
            height: context.height(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.image_loading_error,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ReaderInteractiveRegion(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                      ),
                      onPressed: () {
                        state.reLoadImage();
                        onFailedToLoadImage(index, false);
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(l10n.retry),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      onLongPressData: (datas) => ImageActionsDialog.show(
        context: context,
        data: datas,
        manga: chapter.manga.value!,
        chapterName: chapter.name!,
      ),
    );
  }
}
